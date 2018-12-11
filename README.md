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

## Next steps
