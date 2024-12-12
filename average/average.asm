.data
    array1: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    array2: .word 7, 2, 5, 11, 4, 6, 1, 1, 8, 3
    newline: .asciiz "\n"

.text
.globl main

average:
    # a0 = array address
    # a1 = size
    li $t0, 0       # sum = 0
    li $t1, 0       # i = 0
    
loop:
    bge $t1, $a1, end_loop
    sll $t2, $t1, 2         # t2 = i * 4
    add $t2, $t2, $a0       # t2 = base + (i * 4)
    lw $t3, ($t2)          # t3 = arr[i]
    add $t0, $t0, $t3      # sum += arr[i]
    addi $t1, $t1, 1       # i++
    j loop

end_loop:
    mtc1 $t0, $f0          # Move sum to float register
    cvt.s.w $f0, $f0       # Convert sum to float
    mtc1 $a1, $f2          # Move n to float register
    cvt.s.w $f2, $f2       # Convert n to float
    div.s $f0, $f0, $f2    # Calculate average
    jr $ra

main:
    # First array
    la $a0, array1
    li $a1, 10
    jal average
    mov.s $f12, $f0
    li $v0, 2
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Second array
    la $a0, array2
    li $a1, 10
    jal average
    mov.s $f12, $f0
    li $v0, 2
    syscall
    
    # Exit
    li $v0, 10
    syscall
