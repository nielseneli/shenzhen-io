# shenzhen-io
Computer Architecture final project

Description

Motivation

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
