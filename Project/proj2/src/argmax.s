    .globl argmax

    .text
    # =================================================================
    # FUNCTION: Given a int vector, return the index of the largest
    #	element. If there are multiple, return the one
    #	with the smallest index.
    # Arguments:
    # 	a0 (int*) is the pointer to the start of the vector
    #	a1 (int)  is the # of elements in the vector
    # Returns:
    #	a0 (int)  is the first index of the largest element
    # Exceptions:
    # - If the length of the vector is less than 1,
    #   this function terminates the program with error code 77.
    # =================================================================

argmax:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    # Prologue

    li t0, 1
    blt a1, t0, invalid_length
    
    mv s0, a0
    mv s1, a1
    add t0, zero, s0
    add t1, zero, zero
    lw t2, 0(sp)
    add t3, zero, zero
loop_start:
    beq t1, s1, loop_end
    lw t4, 0(t0)
    bge t4, t2, loop_continue
    add t2, zero, t4
    add t3, zero, t1

loop_continue:
    addi t1, t1, 1
    addi t0, t0, 4
    j loop_start
    
loop_end:
    mv a0, t3

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi, sp, sp, 8

    ret

invalid_length:
    li a1, 77
    jal exit2
