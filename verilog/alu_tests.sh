#! /bin/bash

iverilog -Wall -o alu.vvp alu.t.v
./alu.vvp

gtkwave alu.vcd alu.gtkw
