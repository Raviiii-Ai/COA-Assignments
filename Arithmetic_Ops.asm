.data
    num1: .asciiz "Enter first integer: "
    num2: .asciiz "Enter second integer: "
    result_add: .asciiz "Addition result: "
    result_sub: .asciiz "Subtraction result: "
    result_mul: .asciiz "Multiplication result: "
    result_div: .asciiz "Division result: "
    newline: .asciiz "\n"

.text
    .globl main

main:
    #first integer
    li $v0, 4                
    la $a0, num1
    syscall
    li $v0, 5                # syscall: read integer
    syscall
    move $t0, $v0            # store first integer in $t0

    #second integer
    li $v0, 4                
    la $a0, num2
    syscall
    li $v0, 5                # syscall: read integer
    syscall
    move $t1, $v0            # store second integer in $t1

    # Perform addition
    add $t2, $t0, $t1        
    
    # Display addition result
    li $v0, 4               
    la $a0, result_add
    syscall
    li $v0, 1               
    move $a0, $t2
    syscall
    li $v0, 4                
    la $a0, newline
    syscall

    # Perform subtraction
    sub $t3, $t0, $t1       
    
    # Display subtraction result
    li $v0, 4                
    la $a0, result_sub
    syscall
    li $v0, 1              
    move $a0, $t3
    syscall
    li $v0, 4              
    la $a0, newline
    syscall

    # Perform multiplication
    mul $t4, $t0, $t1        
    
    # Display multiplication result
    li $v0, 4                # syscall: print string
    la $a0, result_mul
    syscall
    li $v0, 1                
    move $a0, $t4
    syscall
    li $v0, 4                # syscall: print string
    la $a0, newline
    syscall

    # Perform division
    div $t0, $t1             
    mflo $t5  
                   
    # Display division result
    li $v0, 4              
    la $a0, result_div
    syscall
    li $v0, 1                
    move $a0, $t5
    syscall
    li $v0, 4                
    la $a0, newline
    syscall

    # Exit program
    li $v0, 10               
    syscall
