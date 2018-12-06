# shenzhen-io
Computer Architecture final project

## Installation and running

To get the python assembler working, run:
```bash
sudo apt-get install python3-numpy
```

To run the python assembler, run:
```bash
python3 assembler/assemble.py PathToAssemblyFile PathToMachineCodeFile loop
```
This will assemble the assembly file into machine code, with a line at the end that jumps to the beginning. If you don't want to have the line at the end that jumps to the beginning, write something else instead of `loop`.
