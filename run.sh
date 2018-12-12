#! /bin/bash

module_type=$1
shift
INDEX=1
mem_vars=""
for i in $@
do
  python3 assembler/assemble.py assembler/$i.asm assembler/$i.text
  mem_vars="$mem_vars +mem_text_fn$INDEX=assembler/$i.text"
  echo $mem_vars
  let INDEX=${INDEX}+1
done

iverilog -Wall -o verilog/design.vvp verilog/design$module_type.t.v

# ./verilog/design.vvp +mem_text_fn1=assembler/xbus_test0.text +mem_text_fn2=assembler/xbus_test1.text +dump_fn=verilog/design.vcd
./verilog/design.vvp $mem_vars +dump_fn=verilog/design.vcd
gtkwave verilog/design.vcd
