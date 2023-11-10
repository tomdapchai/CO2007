.data
	# Initialize two boards with all elements are 0
	board1:	.word 0:49
	board2:	.word 0:49
	
	welcome:	.asciiz "Welcome to BATTLESHIP game!\n"
	instruction:	.asciiz "To start, each player have to give the coordinate of 3 2x1 ships, 2 3x1 ships, 1 4x1 ships with format <row_bow> <column_bow> <row_stern> <column_stern> \nFor example: a 4x1 ship has the coordinate of bow is (0, 0) and stern is (0, 3) will be entered as 0 0 0 3.\n"
	inputP1:	.asciiz "Player 1 input: \n"
	inputP2:	.asciiz "Player 2 input: \n"
	boardP1:	.asciiz "Map of Player 1: \n"
	boardP2:	.asciiz "Map of Player 2: \n"
	
	smallInput:	.asciiz "2x1 ships input: \n"
	averageInput:	.asciiz "3x1 ships input: \n"
	bigInput:	.asciiz "4x1 ships input: \n"
	shipInput:	.asciiz "Enter the coordinate of the ship: \n"
	shipShow:	.asciiz "Ship "

	invalidRange:	.asciiz "Invalid input, value must be from 0 to 6.\n"
	invalidPos:	.asciiz "Invalid input, bow and stern must be on the same row or same column.\n"
	invalidLength:	.asciiz "Invalid input, required length is " #the length
	overlap:	.asciiz "There is already a ship here, please place elsewhere.\n"
	
	invalidTarget:	.asciiz "Invalid target, value must be from 0 to 6.\n"
	
	hit:	.asciiz "HIT!.\n"
	miss:	.asciiz "MISS!.\n"
	winP1:	.asciiz "Player 1 WIN!\n"
	winP2:	.asciiz "Player 2 WIN!\n"
	newline:	.asciiz "\n"
	
	check:	.asciiz "check\n"
	check1:	.asciiz "check1\n"
	arrCheck:	.asciiz "arrCheck\n"
.text
main:
	# Welcome prompt
	li $v0, 4
	la $a0, welcome
	syscall
	
	# Load two boards to $s0 and $s1 register
	la $s0, board1
	la $s1, board2
	
	
	
	# Show instruction
	li $v0, 4
	la $a0, instruction
	syscall
	
	# Start inputing
	# P1
	li $v0, 4
	la $a0, inputP1
	syscall			

dataInputP1:
	beq $t1, 0, bigP1
	beq $t1, 1, averageP1
	beq $t1, 2, smallP1
bigP1:
	li $v0, 4
	la $a0, bigInput
	syscall
	j executeP1
averageP1:
	li $v0, 4
	la $a0, averageInput
	syscall
	j executeP1
smallP1:
	li $v0, 4
	la $a0, smallInput
	syscall
executeP1:
	la $a0, board1
	addi $a1, $t1, 1	# input from big > average > small
	jal input
	
	addi $t1, $t1, 1
	beq $t1, 3, exitInputP1
	j dataInputP1
exitInputP1:	

	#printOut the board to confirm
	li $t1, 7 # number of rows
	li $t2, 7 # number of columns
	li $t3, 0 # row counter
	li $t4, 0 # column counter

print_boardP1:
    	bge $t3, $t1, exitP1 # if we've printed all rows, exit
    	li $t4, 0 # reset column counter for new row
print_rowP1:
        	bge $t4, $t2, print_newlineP1 # if we've printed all columns in this row, print newline
        	mul $t5, $t3, $t2 # calculate the linear index
        	add $t5, $t5, $t4
        	sll $t5, $t5, 2 # multiply by 4 because we're dealing with integers
        	add $t6, $s0, $t5 # calculate the address of the element
        	lw $a0, 0($t6) # load the integer to be printed
        	li $v0, 1 # system call code for print_int
        	syscall
        	addiu $t4, $t4, 1 # increment column counter
        	j print_rowP1
print_newlineP1:
        	li $v0, 4 # system call code for print_string
        	la $a0, newline # address of newline character
        	syscall
        	addiu $t3, $t3, 1 # increment row counter
        	j print_boardP1
exitP1:

	# P2
	li $v0, 4
	la $a0, inputP2
	syscall	

#	add $a0, $s1, 0
#dataInputP2:
#	beq $t1, 3, exitInputP2
#	add $a1, $t1, $zero
#	jal input
#	addi $t1, $t1, 1
#	j dataInputP2
#exitInputP2:

# Game start				
	# set hit counter for two players
#	li $s2, 0	# hit_counter_P1
#	li $s3, 0	# hit_counter_P2

#while:
#	# things goes here
#	beq $s2, 16, P1		# Player 1 WIN, goto P1
#	beq $s3, 16, P2		# Player 2 WIN, goto P2
	# things goes here
	
	
#P1:
#	li $v0, 4
#	la $a0, winP1
#	syscall
#	j end
#P2:
#	li $v0, 4
#	la $a0, winP2
#	syscall
#end:
	# stop the program
	li $v0, 10
	syscall

# Function area
input:	
	# set index & counter
	addi $sp, $sp, -8
	sw $t1, 0($sp)
	sw $ra, 4($sp)
	li $t0, 0		# index
	li $t1, 0		# counter
	addi $s5, $a0, 0	# store the board to $s5
inputLoop:			# n times, n = 1, 2, 3
	
	li $t0, 0
	
	li $v0, 4
	la $a0, shipShow
	syscall
	
	li $v0, 1
	addi $a0, $t1, 0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	# input
	li $v0, 5
	syscall
	add $t2, $v0, $zero	#row_bow
	add $a2, $t2, $zero
	jal isValid
	beq $v0, $zero, errorRange	
	
	li $v0, 5
	syscall
	add $t3, $v0, $zero	#column_bow
	add $a2, $t3, $zero
	jal isValid
	beq $v0, $zero, errorRange	
	
	li $v0, 5
	syscall
	add $t4, $v0, $zero	#row_stern
	add $a2, $t4, $zero 
	jal isValid
	beq $v0, $zero, errorRange	
	
	li $v0, 5
	syscall
	add $t5, $v0, $zero	#column_stern
	add $a2, $t5, $zero
	jal isValid
	beq $v0, $zero, errorRange	
	
	# checkPos and checkSize
	addi $s4, $a1, -4	# required size (negative)
	sub $s4, $zero, $s4	# required size - 1 (abs(1 - 4) + 1 = 4)
	
	addi $s2, $t2, 0	# store row_bow
	addi $s3, $t3, 0	# store column_bow
	sub $t2, $t2, $t4	# $t2 = row_bow - row_stern
	sub $t3, $t3, $t5	# $t3 = column_bow - column_stern
	add $t4, $t2, $t3	# $t4 = row_bow - row_stern + column_bow - column_stern
	
	slti $t5, $t4, 0
	bne $t5, $zero, negative
	j checkSize
negative:
	sub $t4, $zero, $t4
checkSize:
	bne $t4, $s4, errorLength
	# Initialize ship in board, change from 0 to 1
	li $t4, 0
	addi $s4, $s4, 1
	# addi $s4, $s4, 1	# restore true required size
	beq $t2, $zero, byRow
	beq $t3, $zero, byColumn
	j errorPos
	#Perform checking overlap while assign 1 (very hard)
byRow:
	mul $t0, $s2, 7		# $t0 = row_idx * 7
	add $t0, $t0, $s3	# $t0 = row_idx * 7 + column_idx
	mul $t0, $t0, 4
	add $t0, $t0, $s5	# $t0 now is board_i[row_idx][column_idx]	
loopRow:
	# Check overlaping
	lw $t6, 0($t0)
	bne $t6, $zero, undoRow
	# No overlaping detected, assgin 0 to 1

	li $t6, 1
	sw $t6, 0($t0)
	
	beq $t5, $zero, backward	# stern on the left of bow
	addi $t0, $t0, 4
	j continueRow
backward:
	sub $t0, $t0, 4
continueRow:
	addi $t4, $t4, 1
	beq $t4, $s4, finish
	j loopRow

	#starting trace back and undo assigning 0 to 1	
undoRow:	
	beq $t4, $zero, endUndoRow
	beq $t5, $zero, undoBackwardRow
	sub $t0, $t0, 4
	j continueUndo
undoBackwardRow:
	addi $t0, $t0, 4
continueUndo:
	li $t6, 0
	sw $t6, 0($t0)
	sub $t4, $t4, 1
	j undoRow
endUndoRow:	
	j errorOverlap

byColumn:
	addi $t0, $s3, 0	# $t0 = column_idx
	mul $t6, $s2, 7		# $t6 = row_idx * 7
	add $t0, $t0, $t6	# $t0 = row_idx * 7 + column_idx
	mul $t0, $t0, 4		
	add $t0, $t0, $s5	# $t0 now is board_i[row_idx][column_idx]
loopColumn:	
	li $t6, 1
	sw $t6, 0($t0)
	
	beq $t5, $zero, upsidedown	# stern is above bow
	addi $t0, $t0, 28	# move row, length is 7 so 7 * 4 = 28
	j continueColumn
upsidedown:
	sub $t0, $t0, 28
continueColumn:	
	addi $t4, $t4, 1
	beq $t4, $s4, finish
	j loopColumn

finish:
	addi $t1, $t1, 1		# $t1++
	beq $t1, $a1, exitInput
	j keepInput
errorRange:
	li $v0, 4
	la $a0, invalidRange
	syscall
	j keepInput
errorPos:
	li $v0, 4
	la $a0, invalidPos
	syscall
	j keepInput
errorLength:
	li $v0, 4
	la $a0, invalidLength
	syscall
	
	li $v0, 1
	addi $a0, $4, 0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	j keepInput
errorOverlap:
	li $v0, 4
	la $a0, overlap
	syscall
keepInput:
	j inputLoop
exitInput:	
	lw $t1, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra


isValid:
	slti $v0, $a2, 7
	addi $t6, $zero, -1
	slt $t6, $t6, $a2
	and $v0, $v0, $t6
	jr $ra
