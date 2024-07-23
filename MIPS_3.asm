.data
  M:     .space 400  		# int M[][] The matrix
  V:     .space 400  		# int V[]   The vector
  C:     .space 400  		# int C[] : The output vector
  m:     .word 10   		# m is an int whose value is at most 10
                     		# max value for rows and columns
  col_m: .word 5                # columns for matrix M: This should not be more than 10
  row_m: .word 5                # rows for matrix M:    This should not be more than 10
                                # (col_m * row_m) * 4 <= M
  col_v: .word 1                # colums for vector V. For a vector, the column is always one
  row_v: .word 5                # rows for vector V. This should not be more than 10
                                # (col_v * row_v) * 4 <= V

      # You may add more variables here if you need to

prompt1:  .asciiz "Enter elements for matrix: "

prompt2:  .asciiz "Enter elements for vector: "

prompt3:  .asciiz "Enter element "
equal:    .asciiz " = "
endl:     .asciiz "\n"

message1: .asciiz "NOT WORKABLE BECAUSE OF THE DIMENSIONS"

message2: .asciiz "NOT WORKABLE BECAUSE OF THE MEMORY"

bracket1: .asciiz "["
bracket2: .asciiz "]"
comma:    .asciiz ", "



.text

.globl main

main:

#------- INSERT YOUR CODE HERE for main -------


lw $s3, col_m
lw $s4, row_m
lw $s5, col_v
lw $s6, row_v
#la $s7, V
#la $s0, M

###########---Promts---#############


# define size of M matrix here = (col_m * row_m) ---> ($s1)

mul $s1, $s3, $s4


# define size of V vector here = (col_v * row_v) ---> ($s2)

mul $s2, $s5, $s6

#You need to check the compatibility of Matrix and Vector:

# If columns of the matrix are not equal to the rows of vector, your program should exit with the
# message1 “ NOT WORKABLE BECAUSE OF THE DIMENSIONS”


beq $s3, $s6, _endif1
    la $a0,endl # system call to print out a newline
    li $v0,4
    syscall
    la $a0, message1 # printing message 1
    li $v0, 4
    syscall
    j exit
_endif1:


# Cols x Rows <= Allocated memory. You need to have this checked as well

# If Cols x Rows > Allocated memory, your program should exit with the
# message2 “NOT WORKABLE BECAUSE OF THE MEMORY”.

move $t2, $s1

mul $t2, $t2, 4

lw $t1, m # to store m
mul $t1, $t1, $t1 # $t1 = m*m
mul $t1, $t1, 4 # $t1 = m*m*4 -- assume to be allocated memory

ble $t2, $t1, _endif2
    la $a0,endl # system call to print out a newline
    li $v0,4
    syscall
    la $a0, message2 #printing message 2
    li $v0, 4
    syscall
    j exit
_endif2:


# Ask the user to input mxn elements for matrix:

move $a1, $s1 # argument to the function -- number of elements to read

jal read_matrix

# get return mtrix from $v1 and store it in somewhere

move $s0, $v1 # store return matrix in $s0 register

# Ask the user to input n elements for vector:

move $a1, $s2 # argument to the function -- number of elements to read



jal read_vector

move $s7, $v1 # store return vector in $s7 register

move $a1, $s0  # pass matrix as argument

move $a2, $s7  # pass vector as argument

move $a0, $s4  # pass m as argument $a0

move $a3, $s3 # pass col_m as argument $a3

# call function  MVM <-- returns the result vector in $v1

jal MVM

# pass $v1 as argument to print vector

move $a0, $v1

# Pass num of elements in vector as argument $a1

move $a1, $s4 # <-- number of rows of M should be number of elements in the result vector

# call print_vector

jal print_vector


j exit

#----------------------------------------------
# Main():
# $s1 -- num of elements in matrix
# $s2 -- num of elements in vector
# $s3 -- col_m
# $s4 -- row_m
# $s5 -- col_v
# $s6 -- row_v
# $s7 -- V
# $s0 -- M
# $v1 -- return address of matrix
# $v0 -- for system calls
#----------------------------------------------

###########---Functions---#############

# Matrix-vector multiplication can be described by the following function:
#  int* MVM (int m, int A[m][n], int X[n]) { // m -- num of rows of M
#  int* V = new int[m]; // allocate an array of n ints int i,j;
#  for (i=0; i<m; i++) {
#      int sum = 0;
#      for (j=0; j<n; j++) {
#          sum = sum + A[i][j] * X[j];
#      }
#      V[i] = sum;
#  }
#  return V; // return a pointer to vector V }

#----------------------------------------------
# MVM():
# $s0 -- num of elements of result vector -- m
# $s1 -- address of matrix
# $s2 -- address of vector
# $s3 -- address of result vector
# $s4 -- num of col_m -- n
# $v1 -- return address of result vector
# $t0 -- counter to iterate through matrix i
# $t1 -- counter to iterate through cols of matrix j
# $t2 -- to store addresses of matrix [i]
# $t3 -- to store addresses of vector [j]
# $t4 -- to store addresses of result vector C
# $t5 -- sum
# $t6 -- for A[i][j]
# $t7 -- intermediate result for A[i][j] * X[j]
# $a1 -- argument -- matrix
# $a2 -- argument -- vector
# $a0 -- argument -- number of rows/ elements for vector row_m
# $a3 -- argument -- number of cols of matrix col_m
#----------------------------------------------

MVM:

addi $sp, $sp, -20  # make space on stack to store 5 registers that this function overwrites
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
#---------body_of_function---------
move $s1, $a1 # <-- store matrix address in $s1 locally
move $s2, $a2 # <-- store vector address in $s2 locally
move $s0, $a0 # <-- store number of elements in result vector
move $s4, $a3 # <-- store number of columns of matrix
la $s3, C # <-- store address of result vector in $s3 locally
move $v1, $s3 # <-- put address of result vector to return value to be returned from this function

li $t0, 0 # <-- to iterate through matrix rows up to m elements < row_m        i
li $t2, 0 # t2 = 0 <-- to store addresses of matrix [i]
li $t3, 0 # t3 = 0 <-- to store addresses of vector [j]
li $t4, 0 # t4 = 0 <-- to store addresses of result vector C
li $t6, 0 # for A[i][j]


_loop5:
    beq $t0, $s0, _break5
    li $t5, 0 # sum = 0 <-- stores sum
    li $t1, 0 # <-- to iterate throguh matrix columns up to n elements < col_m     j = 0
    _loop6:
        beq $t1, $s4, _break6


        sll $t2, $t6, 2  # $t2 = i*4
        sll $t3, $t1, 2  # $t3 = j*4

        add $t2, $t2, $s1  # $t2 = addr of A[i][j]     A[i][j++]
        add $t3, $t3, $s2  # $t3 = addr of X[j]        X[j++]

        lw $t7, 0($t2)     # Load A[i][j] into $t7
        lw $t8, 0($t3)     # Load X[j] into $t8

        mul $t8, $t8, $t7
        add $t5, $t5, $t8  # intermediate result for A[i][j] * X[j]


        addi $t1, $t1, 1 # t1 = t1 + 1 # j++
        addi $t6, $t6, 1 # t6 = t6 + 1 # i, j++ for A[i][j]
        j _loop6
    _break6:

    sll $t4, $t0, 2
    add $t4, $t4, $s3 # $t4 = addr of V[i]

    sw $t5, 0($t4)     # Store sum into V[i]

    addi $t0, $t0, 1 # t0 = t0 + 1 # i++
    j _loop5

_break5:

#-----end_of_body_of_function------
lw $s4, 16($sp)
lw $s3, 12($sp)
lw $s2, 8($sp)
lw $s1, 4($sp)
lw $s0, 0($sp) # restore $s0 from stack
addi $sp, $sp, 20 # deallocate stack space
jr $ra # return to caller

########---Helper Functions---##########

#  int* read_vector (int n) {
#  // allocate a vector of n ints
#  // ask the user to input n ints and read them into allocated
#  vector // return address of vector
#  }

read_vector: # takes n <-- number of elements to read

addi $sp, $sp, -4  # make space on stack to store registers
sw $s0, 0($sp)

#---------body_of_function---------
la $s0, V
move $v1, $s0	# return value has address of vector
li $t0, 0 # t0 = 1  <-- to iterate through each element of vector  (i)
li $t3, 1 # to print indeces of vector
li $t1, 0 # t1 = 0 <-- to store addresses of V [i]

la $a0,endl # system call to print out a newline
li $v0,4
syscall

# "Enter elements for vector: "
la $a0, prompt2 # system call to print out a string
li $v0, 4
syscall

la $a0,endl # system call to print out a newline
li $v0,4
syscall

_loop2:
    beq $t0, $a1, _break2 # while ( t0 != $so )-- size of arrays -

    sll $t1, $t0, 2 # $t0 = i*4
    add $t1, $t1, $s0 # $t1 = addr of V [i]

    # ask to enter t0'th element
    la $a0, prompt3 # system call to print out a string
    li $v0, 4
    syscall

    move $a0, $t3 # get count
    li $v0, 1 # syscall 1 is print_integer
    syscall

    la $a0, equal # system call to print out a string " = "
    li $v0, 4
    syscall

    # store input in vector array:

    li $v0, 5 # syscall 5 is read an integer
    syscall
    #move $0, $v0
    sw $v0, 0($t1) # store input in v0 to the memory address in t1


    add $t0, $t0, 1 # t0 = t0 + 1 # i++
    add $t3, $t3, 1 # t0 ++

    j _loop2 # go up to loop
_break2:

#-----end_of_body_of_function------
lw $s0, 0($sp) # restore $s0 from stack
addi $sp, $sp, 4 # deallocate stack space
jr $ra # return to caller


#  int* read_matrix (int n) {
#  // allocate a matrix of n*n ints
#  // ask the user to input n*n ints and read them into allocated
#  matrix // return address of matrix
#  }


#----------------------------------------------
# Read_matrix():
# $s1 -- num of elements in matrix
# $s0 -- address of matrix
# $v1 -- return address of matrix
# $t0 -- counter to iterate through matrix
# $t3 -- to print indeces of matrix elements
# $t1 -- counter for addresses of elements of matrix
# $a1 -- argument -- number of elements to read
#----------------------------------------------
read_matrix: # <-- takes number of elements to read
addi $sp, $sp, -4  # make space on stack to store two registers
sw $s0, 0($sp)

#---------body_of_function---------
la $s0, M  # get matrix address
move $v1, $s0	# return value has address of matrix
li $t0, 0 # t0 = 1  <-- to iterate through each element of matrix  (i)
li $t3, 1 # to print indeces of matrix
li $t1, 0 # t1 = 0 <-- to store addresses of M [i]

la $a0,endl # system call to print out a newline
li $v0,4
syscall

# "Enter elements for matrix: "
la $a0, prompt1 # system call to print out a string
li $v0, 4
syscall

la $a0,endl # system call to print out a newline
li $v0,4
syscall


_loop1:
    beq $t0, $s1, _break1 # while ( t0 != $so )-- size of arrays -

    sll $t1, $t0, 2 # $t0 = i*4
    add $t1, $t1, $s0 # $t1 = addr of M [i]

    # ask to enter t0'th element
    la $a0, prompt3 # system call to print out a string
    li $v0, 4
    syscall

    move $a0, $t3 # get count
    li $v0, 1 # syscall 1 is print_integer
    syscall

    la $a0, equal # system call to print out a string " = "
    li $v0, 4
    syscall

    # store input in matrix array:

    li $v0, 5 # syscall 5 is read an integer
    syscall
    #move $0, $v0
    sw $v0, 0($t1) # store input in v0 to the memory address in t1


    add $t0, $t0, 1 # t0 = t0 + 1 # i++
    add $t3, $t3, 1 # t0 ++

    j _loop1 # go up to loop
_break1:

#-----end_of_body_of_function------
lw $s0, 0($sp) # restore $s0 from stack
addi $sp, $sp, 4 # deallocate stack space
jr $ra # return to caller



#  void print_vector (int n, int V[n]) {
#  // Display the n elements of vector V
#  }

#----------------------------------------------
# Print_vector():
# $s2 -- num of elements in vector
# $s0 -- address of matrix
# $v1 -- return address of matrix
# $t0 -- counter to iterate through matrix
# $t3 -- to print indeces of matrix elements
# $t1 -- counter for addresses of elements of matrix
# $a0 -- argument -- address of vector to print
# $a1 -- argument -- number of elements of vector
#----------------------------------------------

print_vector: # takes number of elements and vector to print


addi $sp, $sp, -4  # make space on stack to store two registers
sw $s0, 0($sp)

#---------body_of_function---------
move $s0, $a0  # move address of vector to print into $s0

li $t0, 0 # t0 = 1 <-- to iterate through each element of vector  (i)
li $t1, 0 # t1 = 0 <-- to store addresses of V [i]

la $a0,endl # system call to print out a newline
li $v0,4
syscall

# "Enter elements for vector: "
la $a0, bracket1 # system call to print out a bracket [
li $v0, 4
syscall

addi $a1, $a1, -1

_loop4:
    beq $t0, $a1, _break4 # while ( t0 != $so )-- size of arrays -

    sll $t1, $t0, 2 # $t0 = i*4
    add $t1, $t1, $s0 # $t1 = addr of V [i]

    lw $a0, 0($t1) # print V [i]
    li $v0, 1
    syscall


    la $a0, comma # system call to print out a string ,
    li $v0, 4
    syscall


    add $t0, $t0, 1 # t0 = t0 + 1 # i++

    j _loop4 # go up to loop

_break4:

sll $t1, $t0, 2 # $t0 = i*4
add $t1, $t1, $s0 # $t1 = addr of V [i]
lw $a0, 0($t1) # print V [i]
li $v0, 1
syscall

la $a0, bracket2
li $v0, 4
syscall

la $a0,endl # system call to print out a newline
li $v0,4
syscall

#-----end_of_body_of_function------
lw $s0, 0($sp) # restore $s0 from stack
addi $sp, $sp, 4 # deallocate stack space
jr $ra # return to caller


##############-----Output-----################

exit:                     # This is code to terminate the program
addi $v0, $0, 10      	# system call code 10 for exit
syscall               	# exit the program

###########-----END PROGRAM-----#############
