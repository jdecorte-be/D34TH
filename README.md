<h1 align="center">
  <a href="https://github.com/jdecorte-be/D34TH"><img src="assets/banner.png" alt="D34TH" ></a>
  D34TH
  <br>
</h1>

<p align="center">
  <a href="https://github.com/jdecorte-be/D34TH">
    <img src="https://shields.io/badge/D34TH-Security%20Research-critical?logoColor=white&labelColor=000000&color=8B0000"
         alt="D34TH Security Research">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH">
    <img src="https://shields.io/badge/Platform-Linux%20x86__64-blue?logo=linux&logoColor=white&labelColor=000000"
         alt="Linux x86_64 Platform">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH/stargazers">
    <img src="https://shields.io/github/stars/jdecorte-be/D34TH?logo=star&logoColor=white&labelColor=000000&color=yellow"
         alt="GitHub Stars">
  </a>
</p>

<p align="center">
  <a href="https://github.com/jdecorte-be/D34TH/issues">
    <img src="https://shields.io/github/issues/jdecorte-be/D34TH?logoColor=white&labelColor=000000&color=orange"
         alt="Open Issues">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH">
    <img src="https://shields.io/github/repo-size/jdecorte-be/D34TH?logo=database&logoColor=white&labelColor=000000&color=purple"
         alt="Repository Size">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH">
    <img src="https://shields.io/github/languages/top/jdecorte-be/D34TH?logo=code&logoColor=white&labelColor=000000&color=green"
         alt="Top Language">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH">
    <img src="https://shields.io/badge/⚠️-RESEARCH%20ONLY-critical?labelColor=000000&color=FF0000"
         alt="Research Only Warning">
  </a>
  <a href="https://github.com/jdecorte-be/D34TH">
    <img src="https://shields.io/badge/Encryptor-RC4-informational?logo=book&logoColor=white&labelColor=000000&color=blue"
         alt="Educational Use">
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

## 🚨 Critical Security Notice

> **⚠️ EDUCATIONAL MALWARE RESEARCH PROJECT ⚠️**
> 
> This repository contains a **proof-of-concept metamorphic virus** designed exclusively for:
> - 🎓 **Cybersecurity Education**
> - 🔬 **Academic Research**
> - 🛡️ **Defensive Security Development**
> 
> ### ❌ Prohibited Uses
> - Production systems or networks
> - Any malicious activities
> - Distribution outside educational contexts
> - Execution on non-isolated environments
> 
> ### ✅ Authorized Uses
> - Isolated virtual machine testing
> - Academic malware analysis courses
> - Security research and development
> - Cybersecurity training programs

---

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
- **[rc4.s](src/rc4.s)** - RC4 encryption implementation
- **[encrypt_start.s](src/encrypt_start.s)** - Encrypted payload section
- **[functions/](src/functions/)** - Modular infection and utility functions:
  - `infection.s` - Core binary infection logic
  - `prepare_infection.s` - Pre-infection validation and setup
  - `check_forbidden.s` - Process filtering and detection avoidance
  - `updata_signature.s` - Signature evolution mechanisms
  - `parse_dir.s` - Directory parsing utilities
- **[Makefile](Makefile)** - Build system with encryption integration

## License

**Educational and Research Use Only** - See project files for detailed terms.

**⚠️ DISCLAIMER**: The authors provide this code solely for educational purposes. Users are responsible for ensuring compliance with applicable laws. The authors disclaim all liability for misuse or damage.

---

<div align="center">

**🎯 The Answer to Everything: Knowledge, Responsibility, and Code**

> [42 School](https://42.fr) &nbsp;&middot;&nbsp;
> GitHub [@jdecorte-be](https://github.com/jdecorte-be) &nbsp;&middot;&nbsp;

</div>
