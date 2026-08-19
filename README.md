# RISC-V CPU 

This is the RISC-V implementation CPU that implements the architecture provided below

<img width="1270" height="952" alt="image" src="https://github.com/user-attachments/assets/90e6d8ba-4f71-4703-9692-374b44eb8d5d" />

The instruction set that it supports is given below

add rd, rs1, rs2

sub rd, rs1, rs2

addi rd, rs1, imm

lw rd, imm(rs1)

sw rs2, imm(rs1)

beq rs1, rs2, label

bne rs1, rs2, label

blt rs1, rs2, label

rd = rs1 + rs2

rd = rs1 - rs2

rd = rs1 + imm

rd = memory[rs1 + imm]

memory[rs1 + imm] = rs2

jump to label if rs1 == rs2

jump to label if rs1 != rs2

jump to label if rs1 < rs2

## What happens in a single cycle 

Fetch: read the instruction from instruction memory

Decode: split it into opcode/registers/immediate fields and send it to CU

Execute: the ALU adds or subtracts or compares two registers

Memory: read or write data memory

Writeback: the result is written back into a register

Next PC: either pc + 4, or pc + immediate if a branch was taken 

## What program does it run

The code is written in ASM as well as hexadecimal 

It multiplies: 
A = ((1,2),(3,4)) B = ((5,6),(7,8))

to get: 
C = A x B = ((19,22),(43,50))

