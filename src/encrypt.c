#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <elf.h>

#define RC4_KEY 0xdeadbeefcafebabe

void	rc4_init(uint8_t *s, const uint8_t *key, size_t key_len)
{
	int		i;
	int		j;
	uint8_t	temp;

	i = 0;
	while (i < 256)
	{
		s[i] = i;
		i++;
	}
	j = 0;
	i = 0;
	while (i < 256)
	{
		j = (j + s[i] + key[i % key_len]) % 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
		i++;
	}
}

void	rc4_encrypt(uint8_t *data, size_t size, uint64_t key)
{
	uint8_t	s[256];
	uint8_t	*k;
	int		i;
	int		j;
	uint8_t	temp;
	uint8_t	keystream;
	size_t	pos;

	k = (uint8_t *)&key;
	rc4_init(s, k, 8);
	i = 0;
	j = 0;
	pos = 0;
	while (pos < size)
	{
		i = (i + 1) % 256;
		j = (j + s[i]) % 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
		keystream = s[(s[i] + s[j]) % 256];
		data[pos] ^= keystream;
		pos++;
	}
}

static int	parse_symbols(FILE *fp, size_t *encrypted_start, size_t *stop_addr)
{
	char	line[256];
	char	*sym;

	while (fgets(line, sizeof(line), fp))
	{
		sym = strchr(line, ' ');
		if (!sym)
			continue ;
		sym += 3;
		if (strncmp(sym, "_encrypted_start\n", 17) == 0)
			sscanf(line, "%lx", encrypted_start);
		else if (strncmp(sym, "_stop\n", 6) == 0)
			sscanf(line, "%lx", stop_addr);
	}
	return (0);
}

int	get_encryption_range(const char *binary, size_t *start_out, size_t *end_out)
{
	FILE	*fp;
	char	cmd[512];
	size_t	encrypted_start;
	size_t	stop_addr;

	encrypted_start = 0;
	stop_addr = 0;
	snprintf(cmd, sizeof(cmd), "nm '%s' 2>/dev/null", binary);
	fp = popen(cmd, "r");
	if (!fp)
	{
		perror("popen");
		return (-1);
	}
	parse_symbols(fp, &encrypted_start, &stop_addr);
	pclose(fp);
	if (encrypted_start == 0 || stop_addr == 0)
	{
		fprintf(stderr, "❌ Could not find _encrypted_start or _stop in symbols\n");
		return (-1);
	}
	if (encrypted_start >= stop_addr)
	{
		fprintf(stderr, "❌ Invalid range: _encrypted_start (0x%lx) >= _stop (0x%lx)\n",
			encrypted_start, stop_addr);
		return (-1);
	}
	*start_out = encrypted_start;
	*end_out = stop_addr;
	printf("🛡️  Encryption range: _encrypted_start = 0x%lx, _stop = 0x%lx, size = %lu bytes\n",
		encrypted_start, stop_addr, stop_addr - encrypted_start);
	return (0);
}

static int	validate_elf(uint8_t *buf)
{
	Elf64_Ehdr	*eh;

	eh = (Elf64_Ehdr *)buf;
	if (memcmp(eh->e_ident, ELFMAG, SELFMAG) != 0
		|| eh->e_ident[EI_CLASS] != ELFCLASS64)
	{
		fprintf(stderr, "Invalid ELF64\n");
		return (-1);
	}
	return (0);
}

static int	encrypt_text_section(uint8_t *buf, Elf64_Ehdr *eh,
	size_t encrypted_start_vaddr, size_t stop_vaddr)
{
	Elf64_Shdr	*sh;
	const char	*shstrtab;
	int			i;
	size_t		text_vaddr;
	size_t		text_offset;
	size_t		text_size;
	size_t		encrypt_start_offset;
	size_t		encrypt_size;

	sh = (Elf64_Shdr *)(buf + eh->e_shoff);
	shstrtab = (char *)(buf + sh[eh->e_shstrndx].sh_offset);
	i = 0;
	while (i < eh->e_shnum)
	{
		if (strcmp(&shstrtab[sh[i].sh_name], ".text") == 0)
		{
			text_vaddr = sh[i].sh_addr;
			text_offset = sh[i].sh_offset;
			text_size = sh[i].sh_size;
			if (encrypted_start_vaddr < text_vaddr
				|| stop_vaddr > text_vaddr + text_size)
			{
				fprintf(stderr, "❌ Encryption range (0x%lx-0x%lx) is outside .text section (0x%lx-0x%lx)\n",
					encrypted_start_vaddr, stop_vaddr, text_vaddr, text_vaddr + text_size);
				return (-1);
			}
			encrypt_start_offset = text_offset + (encrypted_start_vaddr - text_vaddr);
			encrypt_size = stop_vaddr - encrypted_start_vaddr;
			printf("📍 Encrypting in file: offset = 0x%lx, size = %lu bytes\n",
				encrypt_start_offset, encrypt_size);
			rc4_encrypt(buf + encrypt_start_offset, encrypt_size, RC4_KEY);
			return (0);
		}
		i++;
	}
	fprintf(stderr, "No .text section found\n");
	return (-1);
}

static int	process_binary(const char *bin)
{
	FILE		*f;
	size_t		size;
	uint8_t		*buf;
	Elf64_Ehdr	*eh;
	size_t		encrypted_start_vaddr;
	size_t		stop_vaddr;

	f = fopen(bin, "rb+");
	if (!f)
	{
		perror("fopen");
		return (1);
	}
	fseek(f, 0, SEEK_END);
	size = ftell(f);
	rewind(f);
	buf = malloc(size);
	if (!buf)
	{
		perror("malloc");
		fclose(f);
		return (1);
	}
	fread(buf, 1, size, f);
	if (validate_elf(buf) != 0)
	{
		free(buf);
		fclose(f);
		return (1);
	}
	eh = (Elf64_Ehdr *)buf;
	if (get_encryption_range(bin, &encrypted_start_vaddr, &stop_vaddr) != 0)
	{
		free(buf);
		fclose(f);
		return (1);
	}
	if (encrypt_text_section(buf, eh, encrypted_start_vaddr, stop_vaddr) != 0)
	{
		free(buf);
		fclose(f);
		return (1);
	}
	rewind(f);
	fwrite(buf, 1, size, f);
	fclose(f);
	free(buf);
	printf("✅ Code encrypted with RC4 from _encrypted_start to _stop\n");
	return (0);
}

int	main(int argc, char **argv)
{
	if (argc != 2)
	{
		fprintf(stderr, "Usage: %s <binary>\n", argv[0]);
		return (1);
	}
	return (process_binary(argv[1]));
}