.data
# You can use the following for the pretty printing the
# input and output as described in the homework document
A:		.asciiz "A["
B:		.asciiz "B["
C:		.asciiz "]="
spacechar:	.asciiz " "
bar:	.asciiz "|"
endl: .asciiz "\n"


.align 2
pinA: .space	400   # We will not change this
pinB: .space	400   # We will not change this
num: .word n        # We can change this                       # of elemens in array
                    # n x 4 <= 400 This is the constraint


.text
.globl main



main:


lw $s0, num # SIZE_OF _ARRAYS
la $s1, pinA # ARRAY_A base address
la $s2, pinB # ARRAY_B base address

#########---Populate_arrays---###########

#----------------------------------------------
# $t0 -- to iterate through arrays
# $t1 -- to store effective addresses of arrayA [i]
# $t2 -- to store effective addresses of arrayB [i]
# $s1 -- arrayA base address
# $s2 -- arrayB base address
# $s0 -- size of arrays
# $t3 -- holds temp for swaps
#----------------------------------------------


# start loop

li $t3, 1 # to print indeces of arrays
li $t0, 0 # t0 = 1  <-- to iterate through each element of erray  (i)
li $t1, 0 # t1 = 0 <-- to store addresses of arrayA [i]
li $t2, 0 # t2 = 0 <-- to store addresses of arrayB [i]

_loop:

    beq $t0, $s0, _break # while ( t0 != $so )-- size of arrays -

    sll $t1, $t0, 2      # $t0 = i*4
    sll $t2, $t0, 2      # $t0 = i*4

    add $t1, $t1, $s1    # $t1 = addr of arrayA [i]
    add $t2, $t2, $s2    # $t1 = addr of arrayB [i]


# print A

    la $a0, A            # system call to print out a string
    li $v0,4
    syscall


# print t3

    move $a0, $t3        # get count
    li $v0, 1            # syscall 1 is print_integer
    syscall

# print C

    la $a0, C            # system call to print out a string
    li $v0,4
    syscall


# store input in array A:

    li $v0, 5            # syscall 5 is read an integer
    syscall
    sw $v0, 0($t1)       # store input in v0 to the memory address in t1

# print B

    la $a0, B            # system call to print out a string
    li $v0,4
    syscall

# print t3

    move $a0, $t3        # get count
    li $v0, 1            # syscall 1 is print_integer
    syscall

# print C

    la $a0, C            # system call to print out a string
    li $v0,4
    syscall

# store input in array B:

    li $v0, 5            # syscall 5 is read an integer
    syscall
    sw $v0, 0($t2)       # store input in v0 to the memory address in t2


add $t0, $t0, 1          # t0 = t0 + 1 # i++
add $t3, $t3, 1          # t0 ++

j _loop                  # go up to loop


_break:

#########---Swap_values_of_arrays---#########

li $t0, 0                # t0 = 1  <-- to iterate through each element of erray  (i)
li $t1, 0                # t1 = 0 <-- to store addresses of arrayA [i]
li $t2, 0                # t2 = 0 <-- to store addresses of arrayB [i]
li $t3, 0                # temp to store arrayA [i] for swap
li $t4, 0                # to store arraB[i] for swap

# loop until Size_of_array in (s0 + 1) is reached

_loop2:
    beq $t0, $s0, _break2

    sll $t1, $t0, 2      # $t0 = i*4
    sll $t2, $t0, 2      # $t0 = i*4

    add $t1, $t1, $s1    # $t1 = addr of arrayA [i]
    add $t2, $t2, $s2    # $t1 = addr of arrayB [i]


    lw $t3, 0($t1)       # temp = array A [t0]

    lw $t4, 0($t2)       # array B [t0]
    sw $t4, 0($t1)       # array A [t0] = array B [t0]

    sw $t3, 0($t2)       # array B [t0] = temp




    add $t0, $t0, 1      # t0 ++

    j _loop2             # go up to the loop begining


_break2:

#########---Print_values_of_arrays---#########

la $a0,endl              # system call to print out a newline
li $v0,4
syscall

li $t0, 0                # t0 = 1  <-- to iterate through each element of erray  (i)
li $t1, 0                # t1 = 0 <-- to store addresses of arrayA [i]
li $t2, 0                # t2 = 0 <-- to store addresses of arrayB [i]

_loop3:
    beq $t0, $s0, _break3 # loop until t0 == s0

    sll $t1, $t0, 2       # $t0 = i*4
    sll $t2, $t0, 2       # $t0 = i*4

    add $t1, $t1, $s1     # $t1 = addr of arrayA [i]
    add $t2, $t2, $s2     # $t1 = addr of arrayB [i]


# print arrayA [t0]

    lw $a0, 0($t1)        # get arraA[i]

    li $v0, 1             # syscall 1 is print an integer
    syscall

# print spacechar
    la $a0, spacechar     # system call to print out a string
    li $v0,4
    syscall

# print arrayB [t0]
    lw $a0, 0($t2)	      # get arraB[i]
    li $v0, 1             # syscall 1 is print an integer
    syscall

# print '|'
    la $a0, bar           # system call to print out a string
    li $v0,4
    syscall

    add $t0, $t0, 1       # t0 ++

    j _loop3              # go up to the loop begining


_break3:


# terminate program
li $v0, 10
syscall
