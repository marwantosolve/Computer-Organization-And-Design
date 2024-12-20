.data
    array1: .word 10, 31, 5, 7, 11, 3, 8, 40, 12, 4
    array2: .word 19, 2, 3, 7, 5, 10, 9, 0, 6, 1
    newline: .asciiz "\n"

.text
.globl main

countEven:
    # a0 = array address
    # a1 = size
    li $t0, 0       # count = 0
    li $t1, 0       # i = 0
    
loop:
    bge $t1, $a1, end_loop
    sll $t2, $t1, 2         # t2 = i * 4
    add $t2, $t2, $a0       # t2 = base + (i * 4)
    lw $t3, ($t2)          # t3 = arr[i]
    andi $t4, $t3, 1       # Check if even
    bnez $t4, skip         # If odd, skip increment
    addi $t0, $t0, 1       # count++
skip:
    addi $t1, $t1, 1       # i++
    j loop

end_loop:
    move $v0, $t0          # Return count
    jr $ra

main:
    # First array
    la $a0, array1
    li $a1, 10
    jal countEven
    move $a0, $v0
    li $v0, 1
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Second array
    la $a0, array2
    li $a1, 10
    jal countEven
    move $a0, $v0
    li $v0, 1
    syscall
    
    # Exit
    li $v0, 10
    syscall