# D34TH
A metamorphic ELF64 virus that demonstrates advanced infection techniques and anti-debugging capabilities.

⚠️ **WARNING**: This is a proof-of-concept virus. DO NOT use on production systems. For educational purposes only.

## Features

### Core Functionality
- Infects ELF64 binaries in specified directories (`/tmp/test` and `/tmp/test2`)
- Maintains original binary functionality after infection
- Metamorphic code generation - each infection is unique
- Anti-debugging protections
- Signature evolution with each infection

### Advanced Techniques
- Polymorphic code transformation
- Register shuffling
- Junk code insertion
- RC4 encryption
- Code section manipulation
- PT_NOTE to PT_LOAD conversion

### Anti-Debug Features
- Debugger detection
- Process tracing protection
- Code encryption
- Dynamic signature generation

## Technical Details

### Infection Method
1. Targets ELF64 binaries
2. Modifies program headers
3. Injects metamorphic payload
4. Updates entry points
5. Adds evolving signature

### Code Transformation
- Register reassignment
- Instruction substitution
- NOP sequence variation
- Control flow obfuscation

### Memory Layout
| HEADER |
| SEGMENTS |
| INFECTION CODE | | (Metamorphic) |
| SIGNATURE |
## Building

bash make # Standard build make debug # Debug build with logging
## Usage

bash ./Death # Standard execution
## Safety Notes

- Only run in isolated test environments
- Use virtual machines for testing
- Never deploy on production systems
- For educational purposes only

## Technical Requirements

- Linux x86_64 system
- NASM assembler
- GCC/Clang compiler
- Virtual machine for testing

## License

For educational purposes only. Use at your own risk.

## Disclaimer

This code is provided for educational purposes to demonstrate virus writing techniques. The authors take no responsibility for misuse or damage caused by this software.
