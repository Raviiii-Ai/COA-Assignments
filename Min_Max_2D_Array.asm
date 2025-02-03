.data
    array:      .space 36          # Space for 3x3 matrix (9 integers)
    input_buf:  .space 100         # Input buffer for a string
    element:    .asciiz "Enter 9 elements separated by space: "
    max_msg:    .asciiz "\nMaximum value: "
    min_msg:    .asciiz "\nMinimum value: "

.text
    .globl main

main:
    # Prompt user to enter elements
    li $v0, 4
    la $a0, element
    syscall

    # Read user input as a string
    li $v0, 8
    la $a0, input_buf
    li $a1, 100         # Maximum buffer size
    syscall

    # Parse string and store integers in the array
    la $t0, array       # Base address of array
    la $t1, input_buf   # Start of the input buffer

parse_loop:
    lb $t2, 0($t1)      # Load a byte from the input buffer
    beqz $t2, find_max_min # If null terminator, exit loop
    li $t3, 0           # Initialize integer accumulator

    # Parse digits
digit_loop:
    li $t4, 32          # ASCII code for space
    beq $t2, $t4, store_value  # If space, store the value
    subi $t2, $t2, 48   # Convert ASCII to integer (subtract '0')
    mul $t3, $t3, 10    # Multiply accumulator by 10
    add $t3, $t3, $t2   # Add the current digit
    addi $t1, $t1, 1    # Move to next byte
    lb $t2, 0($t1)      # Load next byte
    b digit_loop        # Repeat digit parsing

store_value:
    sw $t3, 0($t0)      # Store the parsed integer in the array
    addi $t0, $t0, 4    # Move to next array position
    addi $t1, $t1, 1    # Skip the space
    j parse_loop        # Continue parsing

find_max_min:
    # Initialize min and max with the first element
    la $t0, array
    lw $t4, 0($t0)      # max = array[0]
    lw $t5, 0($t0)      # min = array[0]

    li $t3, 1           # Start from the second element

find_loop:
    lw $t6, 0($t0)      # Load the current element
    addi $t0, $t0, 4    # Move to the next element

    # Compare max
    ble $t6, $t4, check_min
    move $t4, $t6       # Update max

check_min:
    bge $t6, $t5, next_element
    move $t5, $t6       # Update min

next_element:
    addi $t3, $t3, 1
    bne $t3, 9, find_loop  # Loop until all elements are checked

    # Print the maximum value
    li $v0, 4
    la $a0, max_msg
    syscall

    li $v0, 1
    move $a0, $t4
    syscall

    # Print the minimum value
    li $v0, 4
    la $a0, min_msg
    syscall

    li $v0, 1
    move $a0, $t5
    syscall

    # Exit the program
    li $v0, 10
    syscall
