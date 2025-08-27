# golang-asm-v2

**Enhanced Go Assembler Library with Go 1.25 Support and Extended RISC-V Instructions**

golang-asm-v2 is an updated version of [golang-asm](https://github.com/twitchyliquid64/golang-asm) that integrates the latest Go 1.25 assembler code, providing significantly enhanced RISC-V instruction support and modern assembler features.

## Key Improvements

### 🚀 **Massive RISC-V Instruction Set Expansion**
- **671 RISC-V instructions** (vs 250 in original golang-asm)
- **168% increase** in RISC-V instruction support
- **Vector Extension (V)**: ~400 new vector instructions for high-performance computing
- **Bit Manipulation Extension (B)**: ~40 new bit operation instructions
- **Modern RISC-V Configurations**: Support for rva20u64, rva22u64, rva23u64

### 🔧 **Go 1.25 Integration**
- Updated from Go 1.15 (5 years old) to Go 1.25 (latest)
- Enhanced build configuration system with `internal/buildcfg`
- Modern assembler architecture and optimizations
- Updated API compatibility with backward compatibility layer

### 🛠 **API Compatibility Layer**
- `ProgHelper` class for handling Go 1.25 API changes
- Seamless transition from `[]Addr` to `[]AddrPos` in `Prog.RestArgs`
- Maintains backward compatibility while providing access to new features

## Installation

```bash
go get github.com/alicemare/golang-asm-v1.25
```

## Quick Start

### Basic x86-64 Assembly
```go
package main

import (
    golangasm "github.com/alicemare/golang-asm-v1.25"
    "github.com/alicemare/golang-asm-v1.25/obj"
    "github.com/alicemare/golang-asm-v1.25/obj/x86"
)

func main() {
    // Create builder for x86-64
    builder, err := golangasm.NewBuilder("amd64", 64)
    if err != nil {
        panic(err)
    }

    // MOV $42, AX
    movInstr := builder.NewProg()
    movInstr.As = x86.AMOVQ
    movInstr.From.Type = obj.TYPE_CONST
    movInstr.From.Offset = 42
    movInstr.To.Type = obj.TYPE_REG
    movInstr.To.Reg = x86.REG_AX
    builder.AddInstruction(movInstr)

    // Generate machine code
    machineCode := builder.Assemble()
    fmt.Printf("Generated: %x\n", machineCode)
}
```

### Enhanced RISC-V Assembly
```go
package main

import (
    golangasm "github.com/alicemare/golang-asm-v1.25"
    "github.com/alicemare/golang-asm-v1.25/obj"
    "github.com/alicemare/golang-asm-v1.25/obj/riscv"
)

func main() {
    // Create builder for RISC-V 64-bit
    builder, err := golangasm.NewBuilder("riscv64", 64)
    if err != nil {
        panic(err)
    }

    // ADDI x1, x0, 42  (load immediate 42 into x1)
    addiInstr := builder.NewProg()
    addiInstr.As = riscv.AADDI
    addiInstr.From.Type = obj.TYPE_CONST
    addiInstr.From.Offset = 42
    addiInstr.Reg = riscv.REG_ZERO
    addiInstr.To.Type = obj.TYPE_REG
    addiInstr.To.Reg = riscv.REG_X1
    builder.AddInstruction(addiInstr)

    // Generate machine code
    machineCode := builder.Assemble()
    fmt.Printf("Generated RISC-V: %x\n", machineCode)
}
```

### API Compatibility Layer
```go
// Handle Go 1.25 API changes seamlessly
prog := builder.NewProg()
helper := golangasm.NewProgHelper(prog)

// Set rest arguments (handles []Addr to []AddrPos conversion)
arg := obj.Addr{Type: obj.TYPE_REG, Reg: 1}
helper.SetRestArg(0, arg)
retrieved := helper.GetRestArg(0)
```

## Supported Architectures

- **amd64** (x86-64)
- **arm64** (AArch64)
- **riscv64** (RISC-V 64-bit) - **Significantly Enhanced**
- **386** (x86)
- **arm** (ARM)
- **mips/mips64**
- **ppc64**
- **s390x**
- **wasm**

## RISC-V Enhancements

### New Instruction Extensions

#### Vector Extension (V)
- Vector configuration instructions
- Vector memory access instructions  
- Vector arithmetic and logical operations
- Vector floating-point operations
- Vector reduction operations

#### Bit Manipulation Extension (B)
- Address generation instructions
- Logical operations with immediate
- Bit counting and manipulation
- Rotation operations

#### Modern RISC-V Profiles
- **rva20u64**: RISC-V Application Profile for 64-bit systems
- **rva22u64**: Enhanced profile with additional extensions
- **rva23u64**: Latest profile with cutting-edge features

## Examples

See the `examples/` directory for comprehensive usage examples:

```bash
cd examples
go run example_usage.go
```

This will demonstrate:
1. x86-64 assembly generation
2. Enhanced RISC-V instruction usage
3. API compatibility layer features

## Building from Source

```bash
# Clone the repository
git clone https://github.com/alicemare/golang-asm-v1.25
cd golang-asm-v2

# Build the library
go build .

# Run tests
cd test
go run minimal_demo.go
```

## Migration from golang-asm

golang-asm-v2 maintains API compatibility with the original golang-asm while providing enhanced features:

1. **Drop-in replacement**: Change import path from `golang-asm` to `golang-asm-v2`
2. **Enhanced RISC-V**: Access to 671 RISC-V instructions vs 250 in original
3. **Modern Go support**: Built on Go 1.25 vs Go 1.15
4. **API compatibility**: Use `ProgHelper` for Go 1.25 API changes

## Technical Details

### Architecture
- **Modular Design**: Clean separation of architecture-specific code
- **Unified Interface**: Consistent API across all supported architectures
- **Extensible**: Easy to add new instruction sets and extensions

### Build System
- **gen.sh**: Automated extraction from Go 1.25 source
- **Constant Replacement**: Smart handling of build-time constants
- **Import Rewriting**: Automatic path rewriting for standalone usage

### API Changes Handled
- `LSym.Func` → `LSym.Extra` with `FuncInfo`
- `arch.Set(string)` → `arch.Set(string, bool)`
- `Prog.RestArgs []Addr` → `Prog.RestArgs []AddrPos`

## Performance

golang-asm-v2 provides the same high-performance assembly generation as the Go compiler's internal assembler, with the added benefit of:

- **Modern optimizations** from Go 1.25
- **Enhanced instruction scheduling** for RISC-V
- **Improved code generation** for vector operations

## Contributing

We welcome contributions! Please see the original [golang-asm](https://github.com/twitchyliquid64/golang-asm) project for contribution guidelines.

## License

This project maintains the same license as the original golang-asm and Go source code.

## Acknowledgments

- Original [golang-asm](https://github.com/twitchyliquid64/golang-asm) by twitchyliquid64
- Go team for the excellent assembler architecture
- RISC-V International for the instruction set specifications

---

**golang-asm-v2** - Bringing modern Go assembler capabilities to your projects with enhanced RISC-V support! 🚀