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
	
	gameStart:	.asciiz "Let start the game!\n"
	turnP1:	.asciiz "Player 1 turn.\n"
	turnP2:	.asciiz "Player 2 turn. \n"
	inputTarget:	.asciiz "Enter the coordinate of the target: "
	invalidTarget:	.asciiz "Invalid target, value must be from 0 to 6.\n"
	
	hit:	.asciiz "HIT!\n"
	miss:	.asciiz "MISS!\n"
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
	
	li $t1, 0		# reset $t1 to loop counter
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
	li $v0, 4
	la $a0, boardP1
	syscall
	
	li $t1, 7 		# number of rows
	li $t2, 7 		# number of columns
	li $t3, 0 		# row counter
	li $t4, 0 		# column counter

print_boardP1:
    	bge $t3, $t1, exitP1 	# if we've printed all rows, exit
    	li $t4, 0 		# reset column counter for new row
print_rowP1:
        	bge $t4, $t2, print_newlineP1 	# if printed all columns in this row, print newline
        	mul $t5, $t3, $t2 	
        	add $t5, $t5, $t4
        	mul $t5, $t5, 4 	
        	add $t5, $s0, $t5 	# $t5 = board1[i]
        	lw $a0, 0($t5) 		
        	li $v0, 1 		
        	syscall
        	addi $t4, $t4, 1 	# increment column counter
        	j print_rowP1
print_newlineP1:
        	li $v0, 4 		
        	la $a0, newline 	
        	syscall
        	addi $t3, $t3, 1 	# row counter ++
        	j print_boardP1
exitP1:

	# P2
	li $v0, 4
	la $a0, inputP2
	syscall
	li $t1, 0		# reset $t1 to loop counter	

dataInputP2:
	beq $t1, 0, bigP2
	beq $t1, 1, averageP2
	beq $t1, 2, smallP2
bigP2:
	li $v0, 4
	la $a0, bigInput
	syscall
	j executeP2
averageP2:
	li $v0, 4
	la $a0, averageInput
	syscall
	j executeP2
smallP2:
	li $v0, 4
	la $a0, smallInput
	syscall
executeP2:
	la $a0, board2
	addi $a1, $t1, 1	# input from big > average > small
	jal input
	
	addi $t1, $t1, 1
	beq $t1, 3, exitInputP2
	j dataInputP2
exitInputP2:	

	#printOut the board to confirm
	li $v0, 4
	la $a0, boardP2
	syscall
	
	li $t1, 7 # number of rows
	li $t2, 7 # number of columns
	li $t3, 0 # row counter
	li $t4, 0 # column counter

print_boardP2:
    	bge $t3, $t1, exitP2 # if we've printed all rows, exit
    	li $t4, 0 # reset column counter for new row
print_rowP2:
        	bge $t4, $t2, print_newlineP2 # if we've printed all columns in this row, print newline
        	mul $t5, $t3, $t2 # calculate the linear index
        	add $t5, $t5, $t4
        	sll $t5, $t5, 2 # multiply by 4 because we're dealing with integers
        	add $t5, $s1, $t5 # calculate the address of the element
        	lw $a0, 0($t5) # load the integer to be printed
        	li $v0, 1 # system call code for print_int
        	syscall
        	addi $t4, $t4, 1 # increment column counter
        	j print_rowP2
print_newlineP2:
        	li $v0, 4 # system call code for print_string
        	la $a0, newline # address of newline character
        	syscall
        	addi $t3, $t3, 1 # increment row counter
        	j print_boardP2
exitP2:


# Game start				
	# set hit counter for two players
	li $s2, 0	# hit_counter_P1
	li $s3, 0	# hit_counter_P2

    	li $v0, 4
    	la $a0, gameStart
    	syscall

while:
	# things goes here, mechanism and everything
    	li $v0, 4
    	la $a0, turnP1
    	syscall
    	la $a1, board2          # store board2 to $a1
    	li $a2, 1               # mode 1, player 1
    	jal game                # turn works with two arguments $a1, $a2

    	li $v0, 4
    	la $a0, turnP2
    	syscall
    	la $a1, board1
    	li $a2, 2
    	jal game

	beq $s2, 16, P1win		# Player 1 WIN, goto P1
	beq $s3, 16, P2win		# Player 2 WIN, goto P2
    	j while
	
	
P1win:
	li $v0, 4
	la $a0, winP1
	syscall
	j end
P2win:
	li $v0, 4
	la $a0, winP2
	syscall
end:
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
	addi $a0, $t1, 1
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
	# perform assign 0 to 1, if overlap undo and return error
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
	beq $t5, $zero, undoBackward
	sub $t0, $t0, 4
	j continueUndoRow
undoBackward:
	addi $t0, $t0, 4
continueUndoRow:
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
	# Check overlaping
	lw $t6, 0($t0)
	bne $t6, $zero, undoColumn
	# No overlaping detected, assign 0 to 1
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
undoColumn:
	beq $t4, $zero, endUndoColumn
	beq $t5, $zero, undoUpsidedown
	sub $t0, $t0, 28
	j continueUndoColumn
undoUpsidedown:
	addi $t0, $t0, 28
continueUndoColumn:
	li $t6, 0
	sw $t6, 0($t0)
	sub $t4, $t4, 1
	j undoColumn
endUndoColumn:
	j errorOverlap

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

game:
        	# $a1 is board, $a2 is player
        	addi $sp, $sp, -4
        	sw $ra, 0($sp)
        	addi $t0, $a2, 0        # $t0 is player

targetLoop:
        	li $v0, 4
        	la $a0, inputTarget
        	syscall

        	li $v0, 5               # input x
        	syscall
        	addi $a2, $v0, 0
        	jal isValid
        	beq $v0, $zero, errorTarget
        	addi $t1, $a2, 0        # store x

        	li $v0, 5               # input y
        	syscall
        	addi $a2, $v0, 0
        	jal isValid
        	beq $v0, $zero, errorTarget
        	addi $t2, $a2, 0        # store y

        	mul $t3, $t1, 7         # t3 is index, $t3 = x * 7
        	add $t3, $t3, $t2       # t3 = x * 7 + y
        	mul $t3, $t3, 4
        	add $t3, $t3, $a1       # $t3 now at board_i[x][y]

        	lw $t4, 0($t3)          # load value at board_i[x][y] to $t4
        	beq $t4, $zero, targetMiss
        	li $v0, 4
        	la $a0, hit
        	syscall

        	li $t4, 0
        	sw $t4, 0($t3)          # reset 1 to 0

        	bne $t0, 1, hitP2
        	addi $s2, $s2, 1
        	j exitGame
hitP2:
        	addi $s3, $s3, 1
        	j exitGame

targetMiss:
        	li $v0, 4
        	la $a0, miss
        	syscall
        	j exitGame

errorTarget:
        	li $v0, 4
        	la $a0, invalidTarget
        	syscall
        	j targetLoop

exitGame:
        	lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	jr $ra

isValid:
        	slti $v0, $a2, 7
        	addi $t6, $zero, -1
        	slt $t6, $t6, $a2
        	and $v0, $v0, $t6
        	jr $ra

