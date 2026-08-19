# Multiplies two 2x2 matrices:
#
#   A = | 1  2 |     B = | 5  6 |
#       | 3  4 |         | 7  8 |
#
#   C = A x B = | 1*5+2*7   1*6+2*8 |   =  | 19  22 |
#               | 3*5+4*7   3*6+4*8 |      | 43  50 |
#
#
# Memory layout (word addresses, each word is 4 bytes):
#   mem[0]  = A[0][0]      mem[4]  = B[0][0]      mem[8]  = C[0][0]
#   mem[1]  = A[0][1]      mem[5]  = B[0][1]      mem[9]  = C[0][1]
#   mem[2]  = A[1][0]      mem[6]  = B[1][0]      mem[10] = C[1][0]
#   mem[3]  = A[1][1]      mem[7]  = B[1][1]      mem[11] = C[1][1]
#
# Register:
#   x1-x4   = A[0][0], A[0][1], A[1][0], A[1][1]
#   x5-x8   = B[0][0], B[0][1], B[1][0], B[1][1]
#   x11-x18 = the 8 individual products
#   x20     = multiply accumulator 
#   x21     = multiply loop counter 
#   x19,x20,x21,x22 = C[0][0], C[0][1], C[1][0], C[1][1]


# matrix values into memory 
addi x1, x0, 1
sw   x1, 0(x0)      # A[0][0] = 1
addi x1, x0, 2
sw   x1, 4(x0)      # A[0][1] = 2
addi x1, x0, 3
sw   x1, 8(x0)      # A[1][0] = 3
addi x1, x0, 4
sw   x1, 12(x0)     # A[1][1] = 4
addi x1, x0, 5
sw   x1, 16(x0)     # B[0][0] = 5
addi x1, x0, 6
sw   x1, 20(x0)     # B[0][1] = 6
addi x1, x0, 7
sw   x1, 24(x0)     # B[1][0] = 7
addi x1, x0, 8
sw   x1, 28(x0)     # B[1][1] = 8

# matrix values into registers
lw x1, 0(x0)         # x1 = A[0][0]
lw x2, 4(x0)          # x2 = A[0][1]
lw x3, 8(x0)          # x3 = A[1][0]
lw x4, 12(x0)         # x4 = A[1][1]
lw x5, 16(x0)         # x5 = B[0][0]
lw x6, 20(x0)         # x6 = B[0][1]
lw x7, 24(x0)         # x7 = B[1][0]
lw x8, 28(x0)         # x8 = B[1][1]

# A[0][0] * B[0][0] -> x11 
addi x20, x0, 0
addi x21, x5, 0
mul1_loop:
beq  x21, x0, mul1_done
add  x20, x20, x1
addi x21, x21, -1
beq  x0, x0, mul1_loop
mul1_done:
addi x11, x20, 0

# A[0][1] * B[1][0] -> x12 
addi x20, x0, 0
addi x21, x7, 0
mul2_loop:
beq  x21, x0, mul2_done
add  x20, x20, x2
addi x21, x21, -1
beq  x0, x0, mul2_loop
mul2_done:
addi x12, x20, 0

# A[0][0] * B[0][1] -> x13
addi x20, x0, 0
addi x21, x6, 0
mul3_loop:
beq  x21, x0, mul3_done
add  x20, x20, x1
addi x21, x21, -1
beq  x0, x0, mul3_loop
mul3_done:
addi x13, x20, 0

# A[0][1] * B[1][1] -> x14 
addi x20, x0, 0
addi x21, x8, 0
mul4_loop:
beq  x21, x0, mul4_done
add  x20, x20, x2
addi x21, x21, -1
beq  x0, x0, mul4_loop
mul4_done:
addi x14, x20, 0

# A[1][0] * B[0][0] -> x15 
addi x20, x0, 0
addi x21, x5, 0
mul5_loop:
beq  x21, x0, mul5_done
add  x20, x20, x3
addi x21, x21, -1
beq  x0, x0, mul5_loop
mul5_done:
addi x15, x20, 0

# A[1][1] * B[1][0] -> x16 
addi x20, x0, 0
addi x21, x7, 0
mul6_loop:
beq  x21, x0, mul6_done
add  x20, x20, x4
addi x21, x21, -1
beq  x0, x0, mul6_loop
mul6_done:
addi x16, x20, 0

# A[1][0] * B[0][1] -> x17 
addi x20, x0, 0
addi x21, x6, 0
mul7_loop:
beq  x21, x0, mul7_done
add  x20, x20, x3
addi x21, x21, -1
beq  x0, x0, mul7_loop
mul7_done:
addi x17, x20, 0

# A[1][1] * B[1][1] -> x18 
addi x20, x0, 0
addi x21, x8, 0
mul8_loop:
beq  x21, x0, mul8_done
add  x20, x20, x4
addi x21, x21, -1
beq  x0, x0, mul8_loop
mul8_done:
addi x18, x20, 0

# Add products
add x19, x11, x12    # C[0][0] = product1 + product2
sw  x19, 32(x0)

add x20, x13, x14    # C[0][1] = product3 + product4
sw  x20, 36(x0)

add x21, x15, x16    # C[1][0] = product5 + product6
sw  x21, 40(x0)

add x22, x17, x18    # C[1][1] = product7 + product8
sw  x22, 44(x0)


halt:
beq x0, x0, halt
