NAME         = Death
ENCRYPTOR    = encrypt

ASM          = nasm
ASM64FLAGS   = -f elf64 -i src

CC           = gcc
CFLAGS       = #-Wall -Wextra

LD           = ld
LDFLAGS      = -T link.ld

SRCDIR       = ./src/
OBJDIR       = ./obj/

SRC          = Death.s
OBJ          = $(addprefix $(OBJDIR), $(SRC:.s=.o))

C_SRC        = encrypt.c
C_OBJ        = $(addprefix $(OBJDIR), $(C_SRC:.c=.o))


# ===== Targets =====

all: $(NAME) $(ENCRYPTOR)

$(NAME): $(ENCRYPTOR) $(OBJDIR) $(OBJ)
	$(LD) $(LDFLAGS) -o $(NAME) $(OBJ)
	chmod +x $(ENCRYPTOR)
	./$(ENCRYPTOR) $(NAME)

$(ENCRYPTOR): $(C_OBJ)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJDIR):
	@mkdir -p $(OBJDIR)

$(OBJDIR)%.o: $(SRCDIR)%.s
	$(ASM) $(ASM64FLAGS) $< -o $@

$(OBJDIR)%.o: $(SRCDIR)%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(NAME) $(ENCRYPTOR)

fclean: clean
	rm -rf $(OBJDIR)

re: fclean all

.PHONY: all clean fclean re
