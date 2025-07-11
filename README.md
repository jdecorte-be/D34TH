<h1 align="center">
  <br>
  <a href="http://www.amitmerchant.com/electron-markdownify"><img src="assets/banner.png" alt="Markdownify" ></a>
  <br>
  D34TH
  <br>
</h1>

<h4 align="center">A metamorphic ELF64 virus demonstrating advanced infection techniques built with <a href="https://www.nasm.us/" target="_blank">NASM</a>.</h4>

<p align="center">
  <a href="https://github.com/jdecorte-be/D34TH/releases">
    <img src="https://img.shields.io/github/v/release/jdecorte-be/D34TH?style=flat-square&color=white&labelColor=black"
         alt="Release">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-Educational-red?style=flat-square&labelColor=black" alt="License">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH/commits/main">
    <img src="https://img.shields.io/github/last-commit/jdecorte-be/D34TH?style=flat-square&color=white&labelColor=black" alt="Last Commit">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH">
    <img src="https://img.shields.io/badge/platform-Linux%20x86__64-blue?style=flat-square&labelColor=black" alt="Platform">
  </a>
</p>

<p align="center">
  <a href="#warning">⚠️ Warning</a> •
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#technical-details">Technical Details</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#educational-purpose">Educational Purpose</a> •
  <a href="#license">License</a>
</p>

<div align="center">
  
</div>

## ⚠️ Warning

> **🚨 CRITICAL NOTICE 🚨**
> 
> This is a **proof-of-concept virus** for educational and research purposes **ONLY**.
> 
> - ❌ **DO NOT** use on production systems
> - ❌ **DO NOT** deploy outside isolated environments  
> - ❌ **DO NOT** use for malicious purposes
> - ✅ **ONLY** use in virtual machines
> - ✅ **ONLY** for cybersecurity education

## Key Features

* **Metamorphic Engine** - Each infection generates unique code variants
  - Dynamic register reassignment and instruction substitution
* **Anti-Debugging Protection** - Multiple evasion techniques
  - Process tracing detection and debugger presence checks
* **ELF64 Binary Infection** - Advanced binary manipulation
  - PT_NOTE to PT_LOAD conversion and header modification
* **RC4 Encryption** - Encrypted payload components
* **Signature Evolution** - Dynamic signature mutation with each infection
* **Process Filtering** - Intelligent target selection and process avoidance
* **Memory Layout Manipulation** - Direct ELF structure modification
* **Polymorphic Transformation** - Register shuffling and junk code insertion
* **Educational Framework** - Comprehensive demonstration of virus techniques
* **Cross-platform Assembly** - Pure x86_64 assembly implementation

## How To Use

To compile and run this educational virus, you'll need [NASM](https://www.nasm.us/) and [GCC](https://gcc.gnu.org/) installed on a Linux x86_64 system. **IMPORTANT: Only run in isolated virtual machines.**

```bash
# Clone this repository
$ git clone https://github.com/jdecorte-be/D34TH

# Go into the repository
$ cd D34TH

# Build the virus
$ make

# Run in isolated environment ONLY
$ ./Death
```

> **Note**
> Always use virtual machines for testing. The virus targets `/tmp/test` and `/tmp/test2` directories.

## Technical Details

### Infection Process
1. **Target Discovery**: Scans specified directories for ELF64 binaries
2. **Binary Analysis**: Parses ELF headers and validates infection targets
3. **Code Generation**: Creates unique metamorphic payload variants
4. **Header Modification**: Updates program headers and entry points
5. **Payload Injection**: Inserts encrypted virus code into target binary
6. **Signature Evolution**: Appends mutated infection signature

### Anti-Analysis Techniques
- **Debugger Detection**: Multiple ptrace-based detection methods
- **Process Name Filtering**: Avoids security tools and analyzers
- **Code Encryption**: RC4 encryption of sensitive payload sections
- **Control Flow Obfuscation**: Dynamic jump target modification
- **Junk Code Insertion**: Random NOP sequence generation

### Memory Architecture

```
ELF64 Binary Structure:
┌─────────────────┐
│ ELF Header      │ ← Modified e_entry
├─────────────────┤
│ Program Headers │ ← PT_NOTE → PT_LOAD
├─────────────────┤
│ Original Code   │
├─────────────────┤
│ Metamorphic     │ ← Unique per infection
│ Virus Payload   │
├─────────────────┤
│ Encrypted Data  │ ← RC4 encrypted
├─────────────────┤
│ Evolution       │ ← Mutated signature
│ Signature       │
└─────────────────┘
```

## Architecture

The virus consists of several key components:

- **[Death.s](src/Death.s)** - Main virus entry point and control logic
- **[Death.inc](src/Death.inc)** - System call definitions and data structures  
- **[Deathf.s](src/Deathf.s)** - File system traversal and infection routines
- **[functions/](src/functions/)** - Modular infection and utility functions
- **[Makefile](Makefile)** - Build system with encryption integration

## Educational Purpose

This project demonstrates advanced malware techniques for cybersecurity education:

### Learning Objectives
- Understanding ELF binary format manipulation
- Assembly language virus construction principles
- Anti-analysis and evasion technique implementation
- Metamorphic code generation algorithms
- System-level programming in x86_64 assembly

### Research Applications
- Malware analysis methodology development
- Defensive security tool testing
- Cybersecurity curriculum enhancement
- Academic virus research

## Credits

This educational virus uses the following techniques and concepts:

- **Assembly Language**: x86_64 NASM implementation
- **ELF Format**: Linux binary manipulation
- **Cryptography**: RC4 encryption algorithm
- **Anti-Debug**: ptrace-based detection methods
- **Metamorphism**: Code variation algorithms

## Related

[🔬 Virus Analysis Tools](https://github.com/search?q=malware+analysis) - Tools for analyzing malware samples

## Educational Use Only

This software is intended for:
- 🎓 Cybersecurity education and training
- 🔬 Academic malware research
- 🛡️ Defensive security development
- 📚 Assembly language instruction

## You may also like...

- [Assembly Language Learning Resources](https://github.com/topics/assembly) - Assembly programming tutorials
- [ELF Binary Analysis Tools](https://github.com/topics/elf-analysis) - Binary analysis utilities
- [Cybersecurity Education](https://github.com/topics/cybersecurity-education) - Educational security projects

## License

**Educational and Research Use Only** - See project files for detailed terms.

**⚠️ DISCLAIMER**: The authors provide this code solely for educational purposes. Users are responsible for ensuring compliance with applicable laws. The authors disclaim all liability for misuse or damage.

---

<div align="center">

**🎯 The Answer to Everything: Knowledge, Responsibility, and Code**

> [42 School](https://42.fr) &nbsp;&middot;&nbsp;
> GitHub [@jdecorte-be](https://github.com/jdecorte-be) &nbsp;&middot;&nbsp;
> Project [D34TH](https://github.com/jdecorte-be/D34TH)

</div>
