#! /bin/bash

python3 assembler/assemble.py assembler/xbus_test0.asm assembler/xbus_test0.text
python3 assembler/assemble.py assembler/xbus_test1.asm assembler/xbus_test1.text

iverilog -Wall -o verilog/design.vvp verilog/design.t.v

./verilog/design.vvp +mem_text_fn1=assembler/xbus_test0.text +mem_text_fn2=assembler/xbus_test1.text +dump_fn=verilog/design.vcd
gtkwave verilog/design.vcd verilog/output.gtkw
