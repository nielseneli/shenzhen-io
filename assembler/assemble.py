import re
import numpy as np

from machine_codes import *

# Every command looks like:
# LABEL CONDITION INSTRUCTION ARGUMENTS COMMENT
# Regex objects for each potential component of an instruction
LABEL = re.compile(r"(\w*:)")
CONDITION = re.compile(r"(\+|\-)")
INSTRUCTION = re.compile('|'.join(list(functs)))
ARG_REG = re.compile('|'.join(list(registers)))
ARG_INT = re.compile(r" -?\d+")

REGEX_LIST = [LABEL, CONDITION, INSTRUCTION, ARG_REG, ARG_INT]

def parse_instr(instr):
    return [regex.findall(instr) for regex in REGEX_LIST]

def get_machine_code(regex_instr):
    try:
        cond = conditionals.get(regex_instr[1][0])
    except IndexError:
        cond = "00"
    funct = functs.get(regex_instr[2][0])
    regs = "".join([registers[reg] for reg in regex_instr[3]])
    imms = "".join([np.binary_repr(int(imm), width=11) for imm in regex_instr[4]])

    # Concatenate together appropriately based on number and type of arguments
    args_lens = (len(regex_instr[3]), len(regex_instr[4]))
    return {
        (0,0): "".join([cond, opcodes.get(""), funct, "0"*22]),             # _
        (1,0): "".join([cond, opcodes.get("r"), funct, regs, "0"*19]),      # r
        (2,0): "".join([cond, opcodes.get("rr"), funct, regs, "0"*16]),     # rr
        (0,1): "".join([cond, opcodes.get("i"), funct, "0"*11, imms]),      # i
        (0,2): "".join([cond, opcodes.get("ii"), funct, imms]),             # ii
        (1,1): "".join([cond, opcodes.get("ri"), funct, regs, "0"*8, imms]) # ri
    }.get(args_lens)

def get_instr_type(regex_instr):
    args_lens = (len(regex_instr[3]), len(regex_instr[4]))
    return {
        (0,0): "",
        (1,0): "r",
        (2,0): "rr",
        (0,1): "i",
        (0,2): "ii",
        (1,1): "ri"
    }.get(args_lens)

def assemble(instr):
    # print(get_instr_type(parse_instr(instr)))
    return get_machine_code(parse_instr(instr))

if __name__ == "__main__":
    instructions = [["mov 100 p1",
        "slp 3",
        "mov 0 p1",
        "slp 3"],
       ["  teq acc 0",
        "+ teq p0 100",
        "+ mov 1 x1",
        "- mov 0 x1",
        "  mov p0 acc",
        "  slp 1"],
       ["  slx x0",
        "  teq x0 1",
        "+ add 50",
        "  tgt acc 100",
        "+ mov 0 acc",
        "  mov acc p1"],
    ]

    for instruction in instructions[2]:
        print(parse_instr(instruction))
        print(assemble(instruction))
