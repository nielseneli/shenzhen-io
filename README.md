# shenzhen-io
Computer Architecture final project

A simulation of Zachtronics' [Shenzhen I/O](http://www.zachtronics.com/shenzhen-io/). Microcontrollers are simulated in Verilog and run code assembled with Python. You can view the resulting waveforms in GTKWave. We tried to match the game pretty well; how our simulation differs from [this manual](http://shenzhen-io.wikia.com/wiki/File:SHENZHEN_IO_Manual.pdf) is detailed in our design decisions, and documentation for our ISA and CPUs is available below.

We needed a final project for our Computer Architecture class and this seemed fun and challenging, especially exploring communication protocols.

## Required software

Our project uses the following software (downloadable at the links):

- [python3](https://www.python.org/)
  - numpy
- [Icarus Verilog](http://iverilog.icarus.com/)
- [GTKWave](http://gtkwave.sourceforge.net/)

## How to run

From inside the `verilog` folder:

```bash
python3 ../assembler/assemble.py PathToAssemblyFile PathToMachineCodeFile
iverilog -o -Wall design.vvp design.t.v
./design.vvp
gtkwave PathToVCDFile
```

After running the third command, you will receive prompts for what arguments are necessary.

## Architecture
### ISA
We have an ISA for the assembly language used by the MC3999 chip, available [here](ISA.pdf). It defines the operations in the assembly language as well as how they're translated into machine code. It also specifies many of the unique operations of the MC3999 chip. Details of our python code are available [here](python).

### Components
![Block Diagram](images/blockdiagram.jpg)
This is the highest level block diagram of one of our MC3999 microcontrollers. At its heart, the MC3999 is a single cycle CPU, with some nontraditional conditional execution, I/O registers, and sleeping behavior. The vast majority of our components are behavioral, so we don't have block diagrams for them, but descriptions of how they behave follow:

- **slp**: This module handles the microcontroller's sleeping behavior. When a sleep command is executed, the slp module's interior sleep counter is set to the input value. The microntroller ceases operation (i.e. the program counter doesn't increment, and the fetched command is made into a noop) until the specified number of long clock cycles have passed.
- **LUT**: A fairly straigforward lookup table, that takes in our machine code command and outputs all of the requisite control signals for the rest of the cycle. The definition of the table is available [here](https://docs.google.com/spreadsheets/d/1rYDHNdSZZgFAvp9TGcSAbn49Tsm6109KkL4NYZ0mMM4/edit?usp=sharing).
- **regfile**: The MC3999's collection of registers. There are three flavors of registers contained in this module:
  - Internal storage (acc): A standard internal storage register. The MC3999 only has one.
  - Simple I/O (p0, p1): Simple I/O ports, as defined in the ISA. Can handle values from 0-127. When a value is output to a simple I/O port, that value stays on that line until the corresponding input port is read from. The ports are bidirectional, so output values can exist on both sides simultaneously.
  - XBus I/O (x0, x1): XBus I/O ports, as defined in the ISA. Used primarily for inter-chip communication. Can handle values from -1024-1023. These are blocking I/O ports; when a chip tries to read or write from/to one of these ports, that chip's execution halts until the other chip can either write/read the data with a corresponding XBus command. Once written/read, values do not persist on the XBus lines.
 - **ALU**: This is a completely behavioral ALU. It can add/subtract/multiply its two input values, and it also outputs the result of ==, >, or < operations on its two input values, based on the funct input it receives.

## Next steps
