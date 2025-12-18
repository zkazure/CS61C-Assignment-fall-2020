    # -*- compile-command: "PYTHONPATH=../unittests python3 -m unittest unittests.TestMatmul -v"; -*-
    
    .globl matmul

    .text
    # =======================================================
    # FUNCTION: Matrix Multiplication of 2 integer matrices
    # 	d = matmul(m0, m1)
    # Arguments:
    # 	a0 (int*)  is the pointer to the start of m0 
    #	a1 (int)   is the # of rows (height) of m0
    #	a2 (int)   is the # of columns (width) of m0
    #	a3 (int*)  is the pointer to the start of m1
    # 	a4 (int)   is the # of rows (height) of m1
    #	a5 (int)   is the # of columns (width) of m1
    #	a6 (int*)  is the pointer to the the start of d
    # Returns:
    #	None (void), sets d = matmul(m0, m1)
    # Exceptions:
    #   Make sure to check in top to bottom order!
    #   - If the dimensions of m0 do not make sense,
    #     this function terminates the program with exit code 72.
    #   - If the dimensions of m1 do not make sense,
    #     this function terminates the program with exit code 73.
    #   - If the dimensions of m0 and m1 don't match,
    #     this function terminates the program with exit code 74.
    # =======================================================

matmul:
    # Error checks
    bge zero, a1, m0_invalid_dimensions 
    bge zero, a2, m0_invalid_dimensions 
    bge zero, a4, m1_invalid_dimensions
    bge zero, a5, m1_invalid_dimensions
    bne a2, a4, unmatched_dimensions

    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    mv s0, a0
    mv s1, a3
    mv s2, a6
    mv s3, a1
    mv s4, a2
    mv s5, a5

    li t0, 0
outer_loop_start:
    bge t0, s3, outer_loop_end
    mul t3, t0, s4
    slli t3, t3, 2
    add t2, s0, t3

    li t1, 0
inner_loop_start:
    bge t1, s5, inner_loop_end

    slli t4, t1, 2
    add t3, s1, t4
    
    mv a0, t2
    mv a1, t3
    mv a2, s4
    li a3, 1
    mv a4, s5
    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    jal ra, dot
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    addi sp, sp, 16

    mul t5, t0, s5
    slli t5, t5, 2
    add t4, t5, s2
    slli t5, t1, 2
    add t4, t4, t5
    sw a0, 0(t4)

    addi t1, t1, 1
    j inner_loop_start
inner_loop_end:
    addi t0, t0, 1

    j outer_loop_start
outer_loop_end:

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
    
    ret

m0_invalid_dimensions:
    li a1, 72
    jal exit2

m1_invalid_dimensions:
    li a1, 73
    jal exit2

unmatched_dimensions:
    li a1, 74
    jal exit2
