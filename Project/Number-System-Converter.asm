.data
    # Input prompts
    promptCurrentSystem: .asciiz "Enter the current system: "
    promptNumber:       .asciiz "Enter the number: "
    promptNewSystem:    .asciiz "Enter the new system: "
    resultMsg:         .asciiz "The number in the new system: "
    errorMsg:          .asciiz "Error: Invalid input for the given number system!\n"
    newline:           .asciiz "\n"
    
    # Buffer for storing input number as string
    buffer: .space 100

.text
.globl main

main:
    # Get current system (base1)
    li $v0, 4
    la $a0, promptCurrentSystem
    syscall
    
    li $v0, 5           # Read integer
    syscall
    move $s0, $v0       # Store base1 in $s0
    
    # Get number as string (to handle hex input)
    li $v0, 4
    la $a0, promptNumber
    syscall
    
    li $v0, 8           # Read string
    la $a0, buffer
    li $a1, 100
    syscall
    
    # Get target system (base2)
    li $v0, 4
    la $a0, promptNewSystem
    syscall
    
    li $v0, 5           # Read integer
    syscall
    move $s1, $v0       # Store base2 in $s1
    
    # Prepare arguments and call OtherToDecimal
    la $a0, buffer      # Load address of input number
    move $a1, $s0       # Load source base
    jal OtherToDecimal
    
    # Check for error
    bltz $v0, inputError
    
    # Store result
    move $s2, $v0
    
    # Convert decimal to target base
    move $a0, $s2       # Load decimal number
    move $a1, $s1       # Load target base
    jal DecimalToOther
    
    # Print result
    li $v0, 4
    la $a0, resultMsg
    syscall
    
    # Print converted number (stored in $v0)
    move $a0, $v0
    li $v0, 1
    syscall
    
    # Print newline and exit
    li $v0, 4
    la $a0, newline
    syscall
    
    j exit

inputError:
    li $v0, 4
    la $a0, errorMsg
    syscall

exit:
    li $v0, 10
    syscall

# Function: OtherToDecimal
# Arguments: 
#   $a0: address of string containing number
#   $a1: source base
# Returns:
#   $v0: decimal value (-1 if error)
OtherToDecimal:
    # Save registers
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    li $s0, 0           # Initialize result
    li $s1, 0           # Initialize digit counter
    move $s2, $a1       # Store base
    
convertLoop:
    # Load current character
    lb $t0, ($a0)
    beqz $t0, endConvert    # Check for null terminator
    beq $t0, 10, endConvert # Check for newline
    
    # Convert character to value
    # If 0-9
    sub $t1, $t0, 48    # Convert ASCII to number
    blt $t1, 0, checkHex
    blt $t1, 10, validDigit
    
checkHex:
    # If A-F
    sub $t1, $t0, 65    # Convert ASCII to number (A=0)
    blt $t1, 0, inputError
    add $t1, $t1, 10    # A=10, B=11, etc.
    
validDigit:
    # Check if digit is valid for given base
    bge $t1, $s2, inputError
    
    # Multiply current result by base and add new digit
    mul $s0, $s0, $s2
    add $s0, $s0, $t1
    
    # Move to next character
    addi $a0, $a0, 1
    j convertLoop
    
endConvert:
    move $v0, $s0
    
    # Restore registers
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    
    jr $ra

# Function: DecimalToOther
# Arguments:
#   $a0: decimal number
#   $a1: target base
# Returns:
#   $v0: converted number
DecimalToOther:
    # Save registers
    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)
    
    move $s0, $a0       # Store number
    move $s1, $a1       # Store base
    li $s2, 0           # Initialize result
    li $s3, 1           # Initialize multiplier
    
convertToBase:
    beqz $s0, endBaseConvert
    
    # Get remainder
    div $s0, $s1
    mfhi $t0            # Remainder
    mflo $s0            # Quotient
    
    # Convert to proper digit
    mul $t1, $t0, $s3
    add $s2, $s2, $t1
    
    # Update multiplier
    mul $s3, $s3, 10
    
    j convertToBase
    
endBaseConvert:
    move $v0, $s2
    
    # Restore registers
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    
    jr $ra
