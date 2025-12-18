    # -*- compile-command: "PYTHONPATH=../unittests python3 -m unittest unittests.TestMain -v"; -*-

    .globl classify

    .text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, argc_error

    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    li a0, 24
    jal malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s3, a0

    # Load pretrained m0
    lw a0, 4(s1)
    addi a1, s3, 0
    addi a2, s3, 4
    jal read_matrix
    mv s4, a0

    # Load pretrained m1
    lw a0, 8(s1)
    addi a1, s3, 8
    addi a2, s3, 12
    jal read_matrix
    mv s5, a0

    # Load input matrix
    lw a0, 12(s1)
    addi a1, s3, 16
    addi a2, s3, 20
    jal read_matrix
    mv s6, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # === malloc layer ===
    lw t0, 0(s3)
    lw t1, 20(s3)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s7, a0

    # === cal m0 * input ===
    mv a0, s4
    lw a1, 0(s3)
    lw a2, 4(s3)
    mv a3, s6
    lw a4, 16(s3)
    lw a5, 20(s3)
    mv a6, s7
    jal matmul

    # === do relu ===
    mv a0, s7
    lw t0, 0(s3)
    lw t1, 20(s3)
    mul a1, t0, t1
    jal relu

    # === malloc ouput ===
    lw t0, 8(s3)
    lw t1, 20(s3)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s8, a0    

    # === cal relu(m0*input) * m1 ===
    mv a0, s5
    lw a1, 8(s3)
    lw a2, 12(s3)
    mv a3, s7
    lw a4, 0(s3)
    lw a5, 20(s3)
    mv a6, s8
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s1)
    mv a1, s8
    lw a2, 8(s3)
    lw a3, 20(s3)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s8
    lw t0, 8(s3)
    lw t1, 20(s3)
    mul a1, t0, t1
    jal argmax
    mv s9, a0
    

    # Print classification
    bne s2, zero, done
    mv a1, s9
    jal print_int

    # Print newline afterwards for clarity
    li a1 10
    jal print_char
    
done:
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free

    mv a0, s9
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 44

    ret

malloc_error:
    li a1, 88
    jal exit2

argc_error:
    li a1, 89
    jal exit2
