.data
enter_a:      .asciiz "Enter coefficient a : " #a is non zero
enter_b:      .asciiz "Enter coefficient b: "
enter_c:      .asciiz "Enter coefficient c: "
root:         .asciiz "Root: "
real_part:    .asciiz "Real Part: "
img_part:     .asciiz "Imaginary Part: "
find_complex: .asciiz "Complex roots detected.\n"
newline:      .asciiz "\n"
invalid_a:    .asciiz "Error: Coefficient a cannot be zero.\n"

val_zero:     .double 0.0
val_two:      .double 2.0
val_four:     .double 4.0

.text
.globl main

main:
    # Read coefficient a
    li $v0, 4                  
    la $a0, enter_a           
    syscall

    li $v0, 7                  # Read double input
    syscall
    mov.d $f12, $f0            # Store a in $f12   ,64bit in double

    li.d $f2, val_zero          # Load 0.0
    c.eq.d $f12, $f2           # Check if a == 0   ,(compare equal double precision)
    bc1t exit_invalid_a        # If a == 0, exit

    # Read coefficient b
    li $v0, 4                  # Print string
    la $a0, enter_b            
    syscall

    li $v0, 7                  # Read double input
    syscall
    mov.d $f14, $f0            # Store b in $f14

    # Read coefficient c
    li $v0, 4                  # Print string
    la $a0, enter_c            
    syscall

    li $v0, 7                  # Read double input
    syscall
    mov.d $f16, $f0            # Store c in $f16

    # Calculate the discriminant: b^2 - 4*a*c
    mul.d $f4, $f14, $f14      # b^2
    mul.d $f6, $f12, $f16      # a * c
    li.d $f8, val_four          # Load 4.0
    mul.d $f6, $f6, $f8        # 4 * a * c
    sub.d $f18, $f4, $f6       # b^2 - 4*a*c

    # Check discriminant
    c.lt.d $f18, $f2           # Check if d< 0
    bc1t handle_complex         # d< 0,handle complex roots ,branch on condition less than

    # Calculate real roots
    sqrt.d $f20, $f18          # sqrt(d)
    neg.d $f22, $f14           # -b
    sub.d $f24, $f22, $f20     # -b - sqrt(discriminant)
    add.d $f26, $f22, $f20     # -b + sqrt(discriminant)
    li.d $f28, val_two          # Load 2.0
    div.d $f24, $f24, $f28     # root1 = (-b - sqrt(discriminant)) / 2a
    div.d $f26, $f26, $f28     # root2 = (-b + sqrt(discriminant)) / 2a

    # Display real roots
    li $v0, 4                  # Print string
    la $a0, root
    syscall
    li $v0, 3                  # Print double
    mov.d $f12, $f24           # root1
    syscall

    li $v0, 4                  # Print newline
    la $a0, newline
    syscall

    li $v0, 4                  # Print string
    la $a0, root
    syscall
    li $v0, 3                  # Print double
    mov.d $f12, $f26           # root2
    syscall

    j exit                     # Exit program

handle_complex:
    neg.d $f20, $f14           # Real part = -b / (2a)
    div.d $f20, $f20, $f28

    abs.d $f18, $f18           # abs(discriminant)
    sqrt.d $f22, $f18          # sqrt(abs(discriminant))
    div.d $f22, $f22, $f28     # Imaginary part = sqrt(|d|) / (2a)

    # Display complex roots as real and imaginary part.
    li $v0, 4                  # Print string
    la $a0, find_complex
    syscall

    li $v0, 4                  # Print string
    la $a0, real_part
    syscall
    li $v0, 3                  # Print double
    mov.d $f12, $f20           # Real part
    syscall

    li $v0, 4                  # Print string
    la $a0, img_part
    syscall
    li $v0, 3                  # Print double
    mov.d $f12, $f22           # Imaginary part
    syscall

    j exit                     # Exit program

exit_invalid_a:
    li $v0, 4                  # Print error
    la $a0, invalid_a
    syscall
    j exit                     # Exit program

exit:
    li $v0, 10                 # Exit syscall
    syscall
