    # -*- compile-command: "PYTHONPATH=../unittests python3 -m unittest unittests.TestReadMatrix -v"; -*-

    .globl read_matrix

    .text
    # ==========================================================================
    # FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
    #
    # FILE FORMAT:
    #   The first 8 bytes are two 4 byte ints representing the # of rows and columns
    #   in the matrix. Every 4 bytes afterwards is an element of the matrix in
    #   row-major order.
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    #   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    # Returns:
    #   a0 (int*)  is the pointer to the matrix in memory
    # Exceptions:
    # - If malloc returns an error,
    #   this function terminates the program with error code 88.
    # - If you receive an fopen error or eof, 
    #   this function terminates the program with error code 90.
    # - If you receive an fread error or eof,
    #   this function terminates the program with error code 91.
    # - If you receive an fclose error or eof,
    #   this function terminates the program with error code 92.
    # ==========================================================================

read_matrix:

    # Prologue
	addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # >>> fopen >>>
    mv a1, s0
    li a2, 0
    jal fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s3, a0
    # <<< fopen <<<
    
    # >>> read row and col >>>
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error

    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, fread_error
    # <<< read row and col <<<
    

    # >>> malloc >>>
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    li t2, -1
    beq a0, t2, malloc_error
    mv s4, a0
    # <<< malloc <<< 

    # >>> read matrix >>>
    mv a1, s3
    mv a2, s4
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a3, t0, t1
    slli a3, a3, 2
    jal fread
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t3, t0, t1
    slli t3, t3, 2
    bne a0, t3, fread_error
    # <<< read matrix <<<

    # >>> fclose >>>
    mv a1, s3
    jal fclose
    li t2, -1
    beq a0, t2, fclose_error
    # <<< fclose <<<

    mv a0, s4
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    ret

malloc_error:
    li a1, 88
    jal exit2

fopen_error:
    li a1, 90
    jal exit2

fread_error:
    li a1, 91
    jal exit2

fclose_error:
    li a1, 92
    jal exit2
