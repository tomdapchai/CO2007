.text
main:
	# Open file
	li $v0, 13
	la $a0, logFile
	li $a1, 1
	li $a2, 0
	syscall
	addi $s6, $v0, 0	# save the file descriptor
	
	li $v0, 4
	la $a0, hideBoard
	syscall
	
	la $a1, logStart
	jal writeFile
	# Welcome prompt
	li $v0, 4
	la $a0, welcome
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, ready
	syscall
	
	li $v0, 8
	la $a0, ip
	li $a1, 1000
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	# Reset all board to 0 in case players want to play again
	la $a0, board1
	jal resetBoard
	
	la $a0, board2
	jal resetBoard
	
	la $a0, check1
	jal resetCheck
	
	la $a0, check2
	jal resetCheck
	# Show instruction
	li $v0, 4
	la $a0, instruction
	syscall
	
	# Start inputing
	# P1
	li $v0, 4
	la $a0, inputP1
	syscall			
	
	la $a1, inputP1
	jal writeFile
	
	li $t1, 0		# reset $t1 to loop counter
dataInputP1:
	beq $t1, 0, bigP1
	beq $t1, 1, averageP1
	beq $t1, 2, smallP1
bigP1:
	li $v0, 4
	la $a0, bigInput
	syscall
	
	la $a1, bigInput
	jal writeFile
	
	j executeP1
averageP1:
	li $v0, 4
	la $a0, averageInput
	syscall
	
	la $a1, averageInput
	jal writeFile
	
	j executeP1
smallP1:
	li $v0, 4
	la $a0, smallInput
	syscall
	
	la $a1, smallInput
	jal writeFile
executeP1:
	la $a0, board1
	addi $a1, $t1, 1	# input from big > average > small
	jal input
	
	addi $t1, $t1, 1
	beq $t1, 3, exitInputP1
	j dataInputP1
exitInputP1:	
	li $v0, 4
	la $a0, line
	syscall
	#printOut the board to confirm
	li $v0, 4
	la $a0, boardP1
	syscall
	
	la $a2, board1
	jal printBoard
	
	li $v0, 4
	la $a0, line
	syscall
	# Option if player want to place the ships again, or end the game, or continue
	li $v0, 4
	la $a0, reThink
	syscall
	
	la $a1, reThink
	jal writeFile
selectP1:
	li $v0, 4
	la $a0, rePlace
	syscall
	
	li $v0, 8
	la $a0, ip
	li $a1, 1000
	syscall
	
	addi $a1, $a0, 0
	jal writeFile
	
	lb $t1, 0($a0)
	beq $t1, 49, continuePlayP1
	beq $t1, 50, rePlaceP1
	beq $t1, 51, end
	j selectP1
rePlaceP1:
	la $a0, board1
	jal resetBoard
	li $t1, 0
	j dataInputP1
	
continuePlayP1:
	# Hiding board
	li $v0, 4
	la $a0, hideBoard
	syscall
	# P2
	li $v0, 4
	la $a0, inputP2
	syscall
	
	la $a1, inputP2
	jal writeFile
	li $t1, 0		# reset $t1 to loop counter	

dataInputP2:
	beq $t1, 0, bigP2
	beq $t1, 1, averageP2
	beq $t1, 2, smallP2
bigP2:
	li $v0, 4
	la $a0, bigInput
	syscall
	
	la $a1, bigInput
	jal writeFile
	
	j executeP2
averageP2:
	li $v0, 4
	la $a0, averageInput
	syscall
	
	la $a1, averageInput
	jal writeFile
	
	j executeP2
smallP2:
	li $v0, 4
	la $a0, smallInput
	syscall
	
	la $a1, smallInput
	jal writeFile
executeP2:
	la $a0, board2
	addi $a1, $t1, 1	# input from big > average > small
	jal input
	
	addi $t1, $t1, 1
	beq $t1, 3, exitInputP2
	j dataInputP2
exitInputP2:	
	li $v0, 4
	la $a0, line
	syscall
	#printOut the board to confirm
	li $v0, 4
	la $a0, boardP2
	syscall

	la $a2, board2
	jal printBoard
	li $v0, 4
	la $a0, line
	syscall
	# Option if player want to place the ships again, or end the game, or continue
	li $v0, 4
	la $a0, reThink
	syscall
	
	la $a1, reThink
	jal writeFile
selectP2:
	li $v0, 4
	la $a0, rePlace
	syscall
	
	li $v0, 8
	la $a0, ip
	li $a1, 1000
	syscall
	
	addi $a1, $a0, 0
	jal writeFile
	
	lb $t1, 0($a0)
	beq $t1, 49, continuePlayP2
	beq $t1, 50, rePlaceP2
	beq $t1, 51, end
	j selectP1
rePlaceP2:
	la $a0, board2
	jal resetBoard
	li $t1, 0
	j dataInputP2
continuePlayP2:
	# Hiding board
	li $v0, 4
	la $a0, hideBoard
	syscall
	
# Game start	
	li $v0, 4
	la $a0, line
	syscall
	
	la $a1, line
	jal writeFile			
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
    	la $a1, turnP1
    	jal writeFile
    	
    	la $a1, board2          # store board2 to $a1
    	li $a2, 1               # mode 1, player 1
    	jal game                # turn works with two arguments $a1, $a2
	beq $s2, 16, P1win		# Player 1 WIN, goto P1
	
    	li $v0, 4
    	la $a0, turnP2
    	syscall
    	
    	la $a1, turnP2
    	jal writeFile
    	
    	la $a1, board1
    	li $a2, 2
    	jal game
	beq $s3, 16, P2win		# Player 2 WIN, goto P2
    	j while
	
P1win:
	li $v0, 4
	la $a0, winP1
	syscall
	
	la $a1, winP1
	jal writeFile
	j endGame
P2win:
	li $v0, 4
	la $a0, winP2
	syscall
	
	la $a1, winP2
	jal writeFile
endGame:
	li $v0, 4
	la $a0, replay
	syscall
	
	li $v0, 4
	la $a0, yes
	syscall
	
	li $v0, 4
	la $a0, no
	syscall
	
selectLoop:	
	li $v0, 4
	la $a0, selection
	syscall
	
	la $a1, selection
	jal writeFile
	li $v0, 8
	la $a0, ip
	li $a1, 1000
	syscall
	
	addi $a1, $a0, 0
	jal writeFile
	lb $t0, 0($a0)
	beq $t0, 49, main	# 1
	beq $t0, 50, end	# 2
	# invalid choice
	j selectLoop
end:
	# close the file
	li $v0, 16
	addi $a0, $s6, 0
	syscall
	# stop the program
	li $v0, 4
	la $a0, thanks
	syscall
	
	la $a1, logEnd
	jal writeFile
	
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
	
	addi $s2, $a1, 0	# store $a1 value
	
	li $v0, 4
	la $a0, shipShow
	syscall
	
	la $a1, logInput
	jal writeFile
	
	li $v0, 1
	addi $a0, $t1, 1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	# input
	
	li $v0, 8
	la $a0, ip
	li $a1, 1000
	syscall
	
	addi $a1, $a0, 0
	jal writeFile
	
	addi $a1, $s2, 0	# restore $a1 value, $s2 free
	addi $t6, $a0, 0	# t6 contains input string
	li $s2, 0
	lb $t8, 7($t6)
	bne $t8, '\n', errorFormat
checkInputLoop:
	lb $s3, 0($t6)
	div $t2, $s2, 2
	mfhi $t2
	
	bne $t2, $zero, ifOddInput
	li $t7, 55		# even, check if < 7
	bge $s3, $t7, errorFormat
	bgt $zero, $s3, errorFormat
	j noInputError
ifOddInput:
	li $t7, 32		# odd, check if space
	bne $s3, $t7, errorFormat
noInputError:
	addi $s2, $s2, 1
	addi $t6, $t6, 1
	bge $s2, 7, endCheckInput
	j checkInputLoop
endCheckInput:
	sub $t6, $t6, 7
	lb $t2, 0($t6)
	lb $t3, 2($t6)
	lb $t4, 4($t6)
	lb $t5, 6($t6)
	
	sub $t2, $t2, 48
	sub $t3, $t3, 48
	sub $t4, $t4, 48
	sub $t5, $t5, 48
	
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
	#errorPosCheck
	bne $t2, $zero, checkPos
	j doneCheckPos
checkPos:
	bne $t3, $zero, errorPos
doneCheckPos:
	bne $t4, $s4, errorLength
	# Initialize ship in board, change from 0 to 1
	li $t4, 0
	addi $s4, $s4, 1
	# addi $s4, $s4, 1	# restore true required size
	beq $t2, $zero, byRow
	beq $t3, $zero, byColumn
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
	li $v0, 4
	la $a0, currentBoard
	syscall
	
	addi $a2, $s5, 0
	jal printBoard
	addi $t1, $t1, 1		# $t1++
	beq $t1, $a1, exitInput
	j keepInput
errorFormat:
	li $v0, 4
	la $a0, invalidFormat
	syscall
	
	addi $s2, $a1, 0
	
	la $a1, invalidFormat
	jal writeFile
	
	addi $a1, $s2, 0
	j keepInput
errorRange:
	li $v0, 4
	la $a0, invalidRange
	syscall
	
	addi $s2, $a1, 0
	la $a1, invalidRange
	jal writeFile
	addi $a1, $s2, 0
	j keepInput
errorPos:
	li $v0, 4
	la $a0, invalidPos
	syscall
	
	addi $s2, $a1, 0
	la $a1, invalidPos
	jal writeFile
	addi $a1, $s2, 0
	j keepInput
errorLength:
	li $v0, 4
	la $a0, invalidLength
	syscall
	
	li $v0, 1
	addi $a0, $s4, 1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $s2, $a1, 0
	la $a1, logLength
	jal writeFile
	
	la $a1, newline
	jal writeFile
	addi $a1, $s2, 0
	
	j keepInput
errorOverlap:
	li $v0, 4
	la $a0, overlap
	syscall
	
	la $a1, overlap
	jal writeFile
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
	# Shows opponent board
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, currentMap
	syscall
	
	beq $t0, 2, mapP1
	la $a2, check2
	jal printBoard
	
	j inputBegin
mapP1:
	la $a2, check1
	jal printBoard

inputBegin:
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, mapGuide
	syscall
	
	li $v0, 4
	la $a0, smallLine
	syscall
	# input coordinate
        	li $v0, 4
        	la $a0, inputTarget
        	syscall
	
	addi $t1, $a1, 0 	# store $a1
	
	la $a1, inputTarget
	jal writeFile
	
	li $v0, 8
	la $a0, ip
	li $a1, 1000
	syscall
	
	addi $a1, $a0, 0
	jal writeFile
	
	addi $t2, $a0, 0	# $t2 contains input string
	addi $a1, $t1, 0	# restore $a1, $t1 have th
	
	lb $t8, 3($t2)
	bne $t8, '\n', errorFormatTarget
	li $t1, 0		# counter
checkGameInput:
	lb $t3, 0($t2) 
	div $t4, $t1, 2
	mfhi $t4
	bne $t4, $zero, ifOddGame
	li $t5, 55
	bge $t3, $t5, errorTarget
	bgt $zero, $t3, errorTarget
	j keepCheckGame	
ifOddGame:
	li $t5, 32
	bne $t3, $t5, errorTarget
keepCheckGame:
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	bge $t1, 3, endCheckGame
	j checkGameInput
endCheckGame:
	sub $t2, $t2, 3
	lb $t1, 0($t2)		# x + 48
	lb $t2, 2($t2)		# y + 48
		
	sub $t1, $t1, 48	# x
	sub $t2, $t2, 48	# y

        	mul $t3, $t1, 7         # t3 is index, $t3 = x * 7
        	add $t3, $t3, $t2       # t3 = x * 7 + y
        	mul $t3, $t3, 4
        	addi $t5, $t3, 0
        	add $t3, $t3, $a1       # $t3 now at board_i[x][y]

        	lw $t4, 0($t3)          # load value at board_i[x][y] to $t4
        	beq $t4, $zero, targetMiss
        	li $v0, 4
        	la $a0, hit
        	syscall
        	
        	addi $t7, $a1, 0
        	la $a1, hit
        	jal writeFile
        	addi $a1, $t7, 0
        	
        	li $v0, 4
        	la $a0, line
        	syscall
        	
        	sw $zero, 0($t3)          # reset 1 to 0
	li $t7, 1
        	beq $t0, 2, hitP2
        	addi $s2, $s2, 1	# counter of P1
        	# Mark in check
        	la $a0, check2
        	add $a0, $a0, $t5
        	sw $t7, 0($a0)
     
        	j exitGame
hitP2:
        	addi $s3, $s3, 1
        	la $a0, check1
        	add $a0, $a0, $t5
        	sw $t7, 0($a0)
        	j exitGame

targetMiss:
        	li $v0, 4
        	la $a0, miss
        	syscall
        	
        	addi $t7, $a1, 0
        	la $a1, miss
        	jal writeFile
        	addi $a1, $t7, 0
        	
        	li $v0, 4
        	la $a0, line
        	syscall
        	
        	li $t7, 2
        	
        	beq $t0, 2, missP2
        	la $a0, check2
        	add $a0, $a0, $t5
        	lw $t6, 0($a0)
        	bne $t6, $zero, exitGame
        	sw $t7, 0($a0)

        	j exitGame
missP2:
	la $a0, check1
        	add $a0, $a0, $t5
        	lw $t6, 0($a0)
        	bne $t6, $zero, exitGame
        	sw $t7, 0($a0)

        	j exitGame
errorFormatTarget:
	li $v0, 4
	la $a0, formatTarget
	syscall
	
	addi $t7, $a1, 0
        	la $a1, formatTarget
        	jal writeFile
        	addi $a1, $t7, 0
        	
	j targetLoop
errorTarget:
        	li $v0, 4
        	la $a0, invalidTarget
        	syscall
        	
        	addi $t7, $a1, 0
        	la $a1, invalidTarget
        	jal writeFile
        	addi $a1, $t7, 0
        	
        	j targetLoop

exitGame:
        	lw $ra, 0($sp)
        	addi $sp, $sp, 4
        	jr $ra
        	
printBoard:
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	li $t1, 7 		# number of rows
	li $t2, 7 		# number of columns
	li $t3, 0 		# row counter
	li $t4, 0 		# column counter
startPrint:
	# function to shows the board after each ship placement
    	bge $t3, $t1, exitBoard 	# if we've printed all rows, exit
    	li $t4, 0 		# reset column counter for new row
printRow:
        	bge $t4, $t2, printNewline 	# if printed all columns in this row, print newline
        	mul $t5, $t3, $t2 	
        	add $t5, $t5, $t4
        	mul $t5, $t5, 4 	
        	add $t5, $a2, $t5 	# $t5 = board1[i]
        	lb $a0, 0($t5) 		
        	li $v0, 1 		
        	syscall
        	
        	la $a0, space
        	li $v0, 4
        	syscall
        	
        	addi $t4, $t4, 1 	# increment column counter
        	j printRow
printNewline:
        	li $v0, 4 		
        	la $a0, newline 	
        	syscall
        	addi $t3, $t3, 1 	# row counter ++
        	j startPrint
exitBoard:
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
resetBoard:
    	li $t0, 0
loopReset:
   	mul $t2, $t0, 4       
    	add $t3, $t2, $a0     

    	sw $zero, 0($t3)       

    	addi $t0, $t0, 1 
    	bne $t0, 49, loopReset
	
    	jr $ra

resetCheck:
    	li $t0, 0
loopCheck:
   	mul $t2, $t0, 4       
    	add $t3, $t2, $a0     
	
	li $t1, 0
    	sw $t1, 0($t3)       

    	addi $t0, $t0, 1 
    	bne $t0, 49, loopCheck
	
    	jr $ra
	
	# Write input to log.txt
writeFile:
	# a1 have the input string
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a2, 4($sp)
	sw $s7, 8($sp)
	sw $a1, 12($sp)
	li $v0, 15
	addi $a0, $s6, 0	# load file descriptor
	li $a2, 0
	
	# count the length of $a1 for $a2
lengthCount:
	lb $s7, 0($a1)
	beq $s7, $zero, endLengthCount
	addi $a2, $a2, 1
	addi $a1, $a1, 1
	j lengthCount
endLengthCount:
	sub $a1, $a1, $a2	# restore $a1
	syscall
	
	lw $a0, 0($sp)
	lw $a2, 4($sp)
	lw $s7, 8($sp)
	lw $a1, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
	
# Data field
.data
	# Initialize two boards with all elements are 0
	board1:	.word 0:49
	board2:	.word 0:49
	check1:	.space 196
	check2:	.space 196 
	# Create input field
	ip:	.space 1000
	
	welcome:	.asciiz "Welcome to BATTLESHIP game!\n"
	ready:	.asciiz "Ready to destroy all your opponent's ship?\nPress any key to start the game!"
	smallLine:	.asciiz "----------------------------------------------------------\n"
	line:	.asciiz "==========================================================\n"
	replay:	.asciiz "Want to play again?\n"
	reThink:	.asciiz "Do you want to place the ships again, or end the game, or continue?\n"
	rePlace:	.asciiz "Plese type 1 to continue, 2 to place the ship again and 3 for exit the game.\n"
	yes:	.asciiz "1. Play again.\n"
	no:	.asciiz "2. Exit.\n"
	
	selection:	.asciiz "Please type 1 for Play again, 2 for Exit.\n"
	instruction:	.asciiz "To start, each player have to give the coordinate of 3 2x1 ships, 2 3x1 ships, 1 4x1 ships with format <row_bow> <column_bow> <row_stern> <column_stern> \nFor example: a 4x1 ship has the coordinate of bow is (0, 0) and stern is (0, 3) will be entered as 0 0 0 3.\n"
	inputP1:	.asciiz "Player 1 input: \n"
	inputP2:	.asciiz "Player 2 input: \n"
	currentBoard:	.asciiz "Current map: \n"
	boardP1:	.asciiz "Map of Player 1: \n"
	boardP2:	.asciiz "Map of Player 2: \n"
	
	smallInput:	.asciiz "2x1 ships input: \n"
	averageInput:	.asciiz "3x1 ships input: \n"
	bigInput:	.asciiz "4x1 ships input: \n"
	shipInput:	.asciiz "Enter the coordinate of the ship: \n"
	shipShow:	.asciiz "Ship "

	invalidFormat:	.asciiz "Invalid input, you must type in 4 numbers from 0 to 6 for the coordinate of bow and stern with only ONE space between each number, no space at the begin or the end of input!\n"
	invalidRange:	.asciiz "Invalid input, value must be from 0 to 6!\n"
	invalidPos:	.asciiz "Invalid input, bow and stern must be on the same row or same column!\n"
	invalidLength:	.asciiz "Invalid input, required length is " #the length
	overlap:	.asciiz "There is already a ship here, please place elsewhere!\n"
	
	gameStart:	.asciiz "Let start the game!\n"
	turnP1:	.asciiz "Player 1 turn\n"
	turnP2:	.asciiz "Player 2 turn\n"
	inputTarget:	.asciiz "Enter the coordinate of the target: "
	formatTarget:	.asciiz "Invalid target, you must type in 2 numbers from 0 to 6 for the coordinate of the target and there is only ONE space between them, no space at the begin or the end of input!\n"
	invalidTarget:	.asciiz "Invalid target, value of two coordinates must be from 0 to 6!\n"
	
	currentMap:	.asciiz "Your opponent's current map: \n"
	mapGuide:	.asciiz "0 is unrevealed position.\n1 is revealed position and there's a ship's part.\n2 is revealed position and there isn't anything.\n"
	hit:	.asciiz "HIT!\n"
	miss:	.asciiz "MISS!\n"
	winP1:	.asciiz "Player 1 WIN!\n"
	winP2:	.asciiz "Player 2 WIN!\n"
	
	thanks:	.asciiz "Thanks for playing, hope you enjoy the game!"
	newline:	.asciiz "\n"
	hideBoard:	.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	space:	.asciiz " "
	mark:	.asciiz "*"
	
	# log things
	logStart:	.asciiz "=============START============="
	logEnd:	.asciiz "==============END=============="
	logInput:	.asciiz "Input: "
	logLength:	.asciiz "Wrong length\n"
	logFile:	.asciiz "log.txt"
