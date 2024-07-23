############################################
# Triangle(0) or Square(1) or Pyramid (2)?1
# Required size? 3
#
# ***
# ***
# ***
# -- program is finished running --
############################################

.data

prompt1:  .asciiz "Triangle(0) or Square(1) or Pyramid (2)? "
prompt2:  .asciiz "Required size? "
err_msg:  .asciiz "Make choice either 0/1 or 2!"
err_msg2: .asciiz "Invalid input!"
star:     .asciiz "*"
space:    .asciiz " "
endl:     .asciiz "\n"



.text
.globl main

main:

#----------------------------------------------
# Main():
# $a0 --> for promts and
# $s0 --> the figure choice read
# $s1 --> number of lines read
# $v0 --> is mainly used for system calls
# $t1 --> use for lines counter
# $t0 --> for switch choices
#----------------------------------------------

###########---Promts---#############

# ask the user for the figure they want:
# Triangle(0) or Square(1) or Pyramid (2)
    la $a0, prompt1 # load the prompt 1 address into argument register $a0
    li $v0, 4       # syscall 4 is print_string
    syscall         # printing the prompt

    li $v0, 5       # syscall 5 is read_int
    syscall
    move $s0, $v0   # $s0 = the figure

# ask the user for the size (number of lines)
# Required size?
    la $a0, prompt2 # load the prompt 2 address into argument register $a0
    li $v0, 4       # syscall 4 is print_string
    syscall         # printing the prompt

    li $v0, 5       # syscall 5 is read_int
    syscall
    move $s1, $v0   # $s1 = # of lines


    bge $s1, 1, _valid_input
        la $a0,endl
	li $v0,4
	syscall
        la $a0, err_msg2
        li $v0, 4   # print error message
        syscall
        li $v0, 10  # exit
	syscall
    _valid_input:


#-------------------------------------------

###########---Switch---#############

# switch cases to choose the figure

# Triangle (0)
    case0:
        li $t0, 0
        bne $s0, $t0, case1 # move to case 1 if not case 0

                            # call the function triangle and pass the argument -- number of line in it
        jal triangle

        j terminate         # jump to done

# Square (1)
    case1:
        li $t0, 1
        bne $s0, $t0, case2 # move to case 1 if not case 0

                            # call the function triangle and pass the argument -- number of line in it
                            # save all the registers that are used:
        jal square

        j terminate         # jump to done

# Pyramid (2)
    case2:
        li $t0, 2
        bne $s0, $t0, default # move to case 1 if not case 0

                            # call the function triangle and pass the argument -- number of line in it

        jal pyramid

        j terminate         # jump to done

    default:
                            # print an error message about invalid input
                            # exit the program
        la, $a0, endl
        li $v0, 4
        syscall
        li $v0, 4           # system call to print the message
	la $a0, err_msg     # prints the error message
	syscall
	la, $a0, endl
        li $v0, 4
        syscall
	j main              # go back to start of program

###########-----Output-----#############
    terminate: # end of program

                            #la $a0, end_program # load the end-of-program message address into argument register $a0
                            #li $v0, 4 # syscall 4 is print_string
                            #syscall # printing the message
                            # terminate program
	li $v0, 10
	syscall
###########---Functions---#############

#----------------------------------------------
# Square():
# $t1 -- holds the count of current line
# $s0 -- holds the figure choice
# $s1 -- holds num of lines user chose
# $a2 -- argument for print_star_line: bool 0 or 1 for either to print a space between stars or not ( 1 for pyramid )
# $a1 -- argument for print_star_line: number of stars to print on each line
#----------------------------------------------

    square: # (# of lines) <-- function for printing a square

        addi $sp, $sp, -12         # make space on stack to store two registers
        sw $s1, 8($sp)             # we need to store it
        sw $s0, 4($sp)             # save $s0 and $s1 on stack
        sw $ra, 0($sp)

         # Body of function -------------
            # $s1 ---> # of lines
            #int i = 1
            #while ( i != # of lines ) {
            #    print_stars($s1) <--- pass number of stars to print each line
            #    i ++
            #}
        li $t1, 1                 # int i = 0 <-- counter for lines
        move $s4, $s1             # for print_star_line argument
        add $s1, $s1, 1           # num of line to print ++ so the last line is also printed
        _loop:                    # while loop
            beq $t1, $s1, _break  # while ( i != num of lines)

                                  # call print_star_line function

            move $s0, $t1         # save $t1 registers value on $s0 before calling function

            move $a1, $s4         # argument to the function -- num of stars to print in each line

            li $a2, 0             # we dont need spaces between stars for

            jal print_star_line   # call funciton

            move $t1, $s0         # restore $t1 register from $s0

            add $t1, $t1, 1       # i ++
            j   _loop             # repeat loop

        _break:

        # end of function body -----------

                                  # move $v0, $s0
        lw $ra, 0($sp)
        lw $s0, 4($sp)            # restore $s0 from stack
        lw $s1, 8($sp)            # we need to restore it
        addi $sp, $sp, 12         # deallocate stack space

        jr $ra                    # return to caller
#----------------------------------------------
# Triangle():
# $t1 -- holds the count of current line
# $s0 -- holds the figure choice
# $s1 -- holds num of lines user chose
# $a2 -- argument for print_star_line: bool 0 or 1 for either to print a space between stars or not ( change to 1 for spaces between stars)
# $a1 -- argument for print_star_line: number of stars to print on each line
#----------------------------------------------

    triangle: # (# of lines) <-- function for printing a triangle

        addi $sp, $sp, -12  # make space on stack to store two registers
        sw $s1, 8($sp)      # we need to store it
        sw $s0, 4($sp)      # save $s0 and $s1 on stack
        sw $ra, 0($sp)
            # Body of function -------------
                            # $s1 ---> # of lines
                            # int i = 0 # num of lines counter
                            # int j = 0 # num of stars
                            # while ( i != # of lines ) {
                            # print_stars(j) <--- pass number of stars to print each line
                            # i++
                            # j++
                            #}
        li $t1, 1           # int i = 0 <-- counter for lines
        add $s1, $s1, 1     # num of lines to print ++ so the last line is also printed
        _loop3:             # while loop
            beq $t1, $s1, _break3 # while ( i != num of lines)
                            # call print_star_line function
            move $s0, $t1   # save $t1 registers value on $s0 before calling function
            move $a1, $t1   # argument to the function -- num of stars to print in each line
            li $a2, 0       # we dont need spaces between stars => 0
            jal print_star_line # call funciton
            move $t1, $s0   # restore $t1 register from $s0
            add $t1, $t1, 1 # i ++
            j   _loop3      #repeat loop
        _break3:
            # end of body of function ------
        lw $ra, 0($sp)
        lw $s0, 4($sp)     # restore $s0 from stack
        lw $s1, 8($sp)     # yes we need to restorre it
        addi $sp, $sp, 12  # deallocate stack space

        jr $ra             # return to caller

#----------------------------------------------
# Pyramid():
# $t1 -- holds the count of current line
# $t2 -- holds the count of spaces to print before line of stars
# $s0 -- holds the figure choice
# $s1 -- holds num of lines user chose
# $a2 -- argument for print_star_line: bool 0 or 1 for either to print a space between stars or not ( 1 for pyramid )
# $a1 -- argument for print_star_line: number of stars to print on each line
# $a3 -- argument to print_line_
#----------------------------------------------

    pyramid:  # (# of lines) <-- function for printing a pyramid

        addi $sp, $sp, -12        # make space on stack to store two registers
        sw $s1, 8($sp)            # we need to store it
        sw $s0, 4($sp)            # save $s0 and $s1 on stack
        sw $ra, 0($sp)

            # Body of function -------------

            #int i = 0 #num of lines counter
            #int j = 1 #num of stars in line to print
            #num_of_spaces_space = $s1 - 1
            #while ( i != # of lines ) {
            #    print_spaces(num_of_spaces)
            #    print_star_line_pyramid(j) <--- pass number of stars to print each line
            #    i++
            #    j++
            #    num_of_spaces--
            #}
            # ex. if number of lines is 5:
            #|    *
            #|   * *
            #|  * * *
            #| * * * *
            #|* * * * *

        li $t1, 1                 # int i = 0 <-- counter for lines
        move $t2, $s1             # <-- counter for spaces to print
        add $t2, $t2, -1          # in the begining is equal to # of lines - 1
        add $s1, $s1, 1           # num of lines to print ++ so the last line is also printed
        _loop5:                   # while loop
            beq $t1, $s1, _break5 # while ( i != num of lines)

                                  # call print_space_line function

            move $s0, $t1         # save $t1 registers value on $s0 before calling function
            #move $s2, $t2        # save $t2 registers value on $s2 before calling function
            move $a3, $t2         # argument for the function -- num of spaces to print on each lin
            #li $a2, 1            # we do need spaces between stars => 1

            jal print_space_line  # call funciton

            move $t1, $s0         # restore $t1 register from $s0
                                  # move $t2, $s2 # restore $t2 from $s2
                                  # call print_star_line function
            move $s0, $t1         # save $t1 registers value on $s0 before calling function
                                  # move $s2, $t2  # save $t2 registers value on $s2 before calling function

            move $a1, $t1         # argument to the function -- num of stars to print in each line
            li $a2, 1             # we do need spaces between stars => 1

            jal print_star_line   # call function

            move $t1, $s0         # restore $t1 register from $s0
                                  # move $t2, $s2 # restore $t2 from $s2

            add $t1, $t1, 1       # i ++
            add $t2, $t2, -1      # decrement # of spaces to print before stars

            j   _loop5            # repeat loop

        _break5:
            # end of body of function ------
       lw $ra, 0($sp)
        lw $s0, 4($sp)            # restore $s0 from stack
        lw $s1, 8($sp)
        addi $sp, $sp, 12         # deallocate stack space

        jr $ra # return to caller

 #----------------------------------------------
 # Print_space_line():
 # $a3 -- number of spaces to print on each line
 # $a0 -- used for system calls
 # $a2 -- bool 0 or 1 for either to print a space between stars or not ( 1 for pyramid )
 # $t1 -- count for current number of spaces
 #----------------------------------------------

    print_space_line:             # (# of spaces) <-- function for printing a line of spaces
        addi $sp, $sp, -8         # make space on stack to store two registers
        sw $s0, 4($sp)            # save $s0 and $s1 on stack
        sw $s1, 0($sp)

        # Body of function -------------
            # int i = 0
            # while ( i< # of spaces) {
               # print (space)
            # }
        li $t1, 0                 # int i = 0 <-- counter for spaces printing
        _loop4:
            beq $t1, $a3, _break4
            la $a0, space         # system call to print
      	    li $v0, 4	          # out a space
      	    syscall

	    add $t1, $t1, 1       # i ++
	    j   _loop4            #repeat loop
        _break4:
        # end of body of function ------
        lw $s1, 0($sp)
        lw $s0, 4($sp)            # restore $s0 from stack
        addi $sp, $sp, 8          # deallocate stack space

        jr $ra                    # return to caller
 #----------------------------------------------
 # Print_star_line():
 # $a1 -- number of stars to print on each line
 # $a0, $v -- used for system calls
 # $a2 -- bool 0 or 1 for either to print a space between stars or not ( 1 for pyramid )
 # $t1 -- count for current number of stars
 #----------------------------------------------
    print_star_line:              # (# of stars) <-- funciton for printing a line of stars '*'
        addi $sp, $sp, -8         # make space on stack to store two registers
        sw $s0, 4($sp)            # save $s0 and $s1 on stack
        sw $s1, 0($sp)
            # Body of function -------------
            # int i = 0
            # while ( i< # of stars) {
               # print (star)
               # if( $a1 == 1)
               #    print(space)
            # }
            # print( endl)
        li $t1, 0                 # int i = 0 <-- counter for stars printing
        _loop2:
            beq $t1, $a1, _break2
            la $a0, star          # system call to print
      	    li $v0, 4	          # out a star
      	    syscall
      	    bne $a2, 1, _endif    # if $a2 != 1 (we don't neeed to print spaces after stars) => skip
      	        la $a0, space     # system call to print out a space
      	        li $v0, 4
      	        syscall
      	    _endif:

	    add $t1, $t1, 1       # i ++
	    j   _loop2            # repeat loop

        _break2:
        la $a0,endl               # system call to print out a newline
	li $v0,4
	syscall


        # end of body of function ------
        lw $s1, 0($sp)
        lw $s0, 4($sp)            # restore $s0 from stack
        addi $sp, $sp, 8          # deallocate stack space

        jr $ra                    # return to caller
