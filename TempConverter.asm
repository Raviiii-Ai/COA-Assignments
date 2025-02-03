.data
temp: .asciiz "Enter temperature in Fahrenheit: "  
result_msg: .asciiz "Temperature in Celsius: "         
newline: .asciiz "\n"                                  
const32: .float 32.0                                   
const5: .float 5.0                                     
const9: .float 9.0                                     

.text
.globl main

main:
    # Prompt user to enter Fahrenheit temperature
    li $v0, 4                   # print string
    la $a0, temp                # Load address
    syscall                     # Print

    # Read Fahrenheit input
    li $v0, 6                   #reading float
    syscall                     #input (Fahrenheit)
    mov.s $f0, $f0              # Store input in $f0

    # Perform conversion: Celsius = (Fahrenheit - 32) * (5/9)
    l.s $f1, const32            # Load 32.0
    sub.s $f2, $f0, $f1         # Fahrenheit - 32
    l.s $f3, const5             # Load 5.0
    l.s $f4, const9             # Load 9.0
    div.s $f5, $f3, $f4         # 5 / 9
    mul.s $f6, $f2, $f5         # (Fahrenheit - 32) * (5 / 9)

    # Display result message
    li $v0, 4                   # print string
    la $a0, result_msg          # result message
    syscall                     # Print the message

    # Print Celsius result
    li $v0, 2                   # print float
    mov.s $f12, $f6             # Move result to $f12 for syscall
    syscall                     # Print Celsius temperature

    # Print newline for formatting
    li $v0, 4                   # System call for print string
    la $a0, newline             # Load address of newline string
    syscall                     # Print newline

    # Exit program
    li $v0, 10                  # System call for exit
    syscall
