.data
    array1: .word 10, 31, 5, 7, 11, 3, 8, 40, 12, 4
    array2: .word 11, 2, 3, 7, 5, 10, 9, 22, 6, 1
    newline: .asciiz "\n"

.text
.globl main

min:
    # a0 = array address
    # a1 = size
    lw $t0, ($a0)          # min = arr[0]
    li $t1, 1              # i = 1
    
loop:
    bge $t1, $a1, end_loop
    sll $t2, $t1, 2         # t2 = i * 4
    add $t2, $t2, $a0       # t2 = base + (i * 4)
    lw $t3, ($t2)          # t3 = arr[i]
    bge $t3, $t0, skip     # if arr[i] >= min, skip
    move $t0, $t3          # min = arr[i]
skip:
    addi $t1, $t1, 1       # i++
    j loop

end_loop:
    move $v0, $t0          # Return min
    jr $ra

main:
    # First array
    la $a0, array1
    li $a1, 10
    jal min
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
    jal min
    move $a0, $v0
    li $v0, 1
    syscall
    
    # Exit
    li $v0, 10
    syscall