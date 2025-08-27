package golangasm

import (
	"fmt"

	"github.com/alicemare/golang-asm-v1.25/asm/arch"
	"github.com/alicemare/golang-asm-v1.25/obj"
	"github.com/alicemare/golang-asm-v1.25/objabi"
)

// Builder allows you to assemble a series of instructions.
type Builder struct {
	ctxt *obj.Link
	arch *arch.Arch

	first *obj.Prog
	last  *obj.Prog

	// bulk allocator.
	block *[]obj.Prog
	used  int
}

// Root returns the first instruction.
func (b *Builder) Root() *obj.Prog {
	return b.first
}

// NewProg returns a new instruction structure.
func (b *Builder) NewProg() *obj.Prog {
	return b.progAlloc()
}

func (b *Builder) progAlloc() *obj.Prog {
	var p *obj.Prog

	if b.used >= len(*b.block) {
		p = b.ctxt.NewProg()
	} else {
		p = &(*b.block)[b.used]
		b.used++
	}

	p.Ctxt = b.ctxt
	return p
}

// AddInstruction adds an instruction to the list of instructions
// to be assembled.
func (b *Builder) AddInstruction(p *obj.Prog) {
	if b.first == nil {
		b.first = p
		b.last = p
	} else {
		b.last.Link = p
		b.last = p
	}
}

// Assemble generates the machine code from the given instructions.
func (b *Builder) Assemble() []byte {
	s := &obj.LSym{}
	funcInfo := s.NewFuncInfo()
	funcInfo.Text = b.first
	b.arch.Assemble(b.ctxt, s, b.progAlloc)
	return s.P
}

// NewBuilder constructs an assembler for the given architecture.
func NewBuilder(archStr string, cacheSize int) (*Builder, error) {
	a := arch.Set(archStr, false)
	ctxt := obj.Linknew(a.LinkArch)
	ctxt.Headtype = objabi.Hlinux
	ctxt.DiagFunc = func(in string, args ...interface{}) {
		fmt.Printf(in+"\n", args...)
	}
	a.Init(ctxt)

	block := make([]obj.Prog, cacheSize)

	return &Builder{
		ctxt:  ctxt,
		arch:  a,
		block: &block,
	}, nil
}

// ProgHelper provides helper methods for working with obj.Prog to maintain
// compatibility with the new Go 1.25 API changes, particularly the RestArgs
// field change from []Addr to []AddrPos.
type ProgHelper struct {
	prog *obj.Prog
}

// NewProgHelper creates a helper for the given prog.
func NewProgHelper(prog *obj.Prog) *ProgHelper {
	return &ProgHelper{prog: prog}
}

// SetRestArg sets a rest argument at the given index with backward compatibility.
// This handles the API change from []Addr to []AddrPos in Go 1.25.
func (ph *ProgHelper) SetRestArg(index int, addr obj.Addr) {
	if ph.prog.RestArgs == nil {
		ph.prog.RestArgs = make([]obj.AddrPos, index+1)
	}
	if index >= len(ph.prog.RestArgs) {
		newArgs := make([]obj.AddrPos, index+1)
		copy(newArgs, ph.prog.RestArgs)
		ph.prog.RestArgs = newArgs
	}
	ph.prog.RestArgs[index] = obj.AddrPos{Addr: addr, Pos: 0}
}

// GetRestArg gets a rest argument at the given index with backward compatibility.
func (ph *ProgHelper) GetRestArg(index int) obj.Addr {
	if index < len(ph.prog.RestArgs) {
		return ph.prog.RestArgs[index].Addr
	}
	return obj.Addr{}
}

// SetRestArgs sets all rest arguments at once.
func (ph *ProgHelper) SetRestArgs(addrs []obj.Addr) {
	ph.prog.RestArgs = make([]obj.AddrPos, len(addrs))
	for i, addr := range addrs {
		ph.prog.RestArgs[i] = obj.AddrPos{Addr: addr, Pos: 0}
	}
}

// GetRestArgs gets all rest arguments as a slice of Addr.
func (ph *ProgHelper) GetRestArgs() []obj.Addr {
	addrs := make([]obj.Addr, len(ph.prog.RestArgs))
	for i, addrPos := range ph.prog.RestArgs {
		addrs[i] = addrPos.Addr
	}
	return addrs
}
