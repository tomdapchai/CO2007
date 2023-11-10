.data
	# Initialize two boards with all elements are 0
	board1:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	board2:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	
	welcome:	.asciiz "Welcome to BATTLESHIP game!"
	instruction:	.asciiz "To start, each player have to give the coordinate of 3 2x1 ships, 2 3x1 ships, 1 4x1 ships with format <row_bow> <column_bow> <row_stern> <column_stern> \n For example: a 4x1 ship has the coordinate of bow is (0, 0) and stern is (0, 3) will be entered as 0 0 0 3"
	inputP1:	.asciiz "Player 1 input: "
	inputP2:	.asciiz "Player 2 input: "
	smallInput:	.asciiz "2x1 ships input: "
	averageInput:	.asciiz "3x1 ships input: "
	bigInput:	.asciiz "4x1 ships input: "
	shipInput:	.asciiz "Enter the coordinate of the ship: "
	shipShow:	.asciiz "Ship "

	invalidRange:	.asciiz "Invalid input, value must be from 0 to 6"
	invalidPos:	.asciiz "Invalid input, bow and stern must be on the same row or same column"
	invalidLength:	.asciiz "Invalid input, required length is " #the length
	
	invalidTarget:	.asciiz "Invalid target, value must be from 0 to 6"
	
	hit:	.asciiz "HIT!"
	miss:	.asciiz "MISS!"
	winP1:	.asciiz "Player 1 WIN!"
	winP2:	.asciiz "Player 2 WIN!"
	newline:	.asciiz "\n"
	
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
		
	li $v0, 4
	la $a0, smallInput
	syscall
	lw $a0, 0($s0)		

dataInputP1:
	addi $s7, $t1, 0
	beq $t1, 0, bigP1
	beq $t1, 1, averageP1
	beq $t2, 2, smallP1
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
	addi $a1, $t1, 1	# input from big > average > small
	jal input
	addi $t1, $s7, 0	# restore $t1
	addi $t1, $t1, 1
	beq $t1, 3, exitInputP1
	j dataInputP1
	
exitInputP1:	
	# P2
	li $v0, 4
	la $a0, inputP2
	syscall	

	lw $a0, 0($s1)
dataInputP2:
	beq $t1, 3, exitInputP2
	add $a1, $t1, $zero
	jal input
	addi $t1, $t1, 1
	j dataInputP2
exitInputP2:

# Game start				
	# set hit counter for two players
	li $s2, 0	# hit_counter_P1
	li $s3, 0	# hit_counter_P2

while:
	# things goes here
	beq $s2, 16, P1		# Player 1 WIN, goto P1
	beq $s3, 16, P2		# Player 2 WIN, goto P2
	# things goes here
	
	
P1:
	li $v0, 4
	la $a0, winP1
	syscall
	j end
P2:
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
	li $t0, 0		# index
	li $t1, 0		# counter
inputLoop:			# n times, n = 1, 2, 3
	li $v0, 4
	la $a0, shipShow
	syscall
	
	li $v0, 1
	addi $a0, $t1, 0
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
	sub $s4, $a1, 4		# required size (negative)
	sub $s4, $zero, $s4	# required size - 1 (abs(1 - 4) + 1 = 4)
	add $s2, $zero, $t2	# store row_bow
	add $s3, $zero, $t3	# store column_bow
	sub $t2, $t2, $t4	# $t2 = row_bow - row_stern
	sub $t3, $t3, $t5	# $t3 = column_bow - column_stern
	add $t4, $t2, $t3	# $t4 = row_bow - row_stern + column_bow - column_stern
	slt $t5, $t4, $zero
	bne $t5, $zero, negative
	j checkSize
negative:
	sub $t4, $zero, $t4
checkSize:
	bne $t4, $s4, errorLength
	
	#Initialize ship in board, change from 0 to 1
	li $t4, 0
	addi $s4, $s4, 1	# restore true required size
	beq $t2, $zero, byRow
	beq $t3, $zero, byColumn
	j errorPos
byRow:
	mul $t0, $s2, 7		# $t0 = row_idx * 7
loopRow:
	add $t0, $t0, $s3	# $t0 = row_idx * 7 + column_idx
	mul $t0, $t0, 4
	add $t0, $a0, $t0	# $t0 now is board_i[row_idx][column_idx]
	
	bne $t5, $zero, backward	# stern on the left of bow
	addi $s3, $s3, 1
	j continueRow
backward:
	sub $s3, $s3, 1
continueRow:
	li $t6, 1
	sw $t6, 0($t0)
	addi $t4, $t4, 1
	beq $t4, $s4, finish
	j loopRow

byColumn:
	addi $t0, $s3, 0	# $t0 = column_idx
loopColumn:
	mul $t6, $s2, 7
	add $t0, $t0, $t6
	mul $t0, $t0, 4
	add $t0, $a0, $t0
	
	beq $t5, $zero, upsidedown	# stern is above bow
	addi $s2, $s2, 1
	j continueColumn
upsidedown:
	sub $s2, $s2, 1
continueColumn:
	li $t6, 1
	sw $t6, 0($t0)
	addi $t4, $t4, 1
	beq $t4, $s4, finish
	j loopColumn

finish:
	add $t1, $t1, 1		# $t1++
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
keepInput:
	j inputLoop
exitInput:	
	jr $ra

isValid:
	slti $v0, $a2, 7
	slt $t6, $zero, $a2
	and $v0, $v0, $t6
	jr $ra
