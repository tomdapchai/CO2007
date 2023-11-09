.data
	board1:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	board2:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	welcome:	.asciiz "Welcome to BATTLESHIP game!"
	#This part may or may not be included in the program
	requireInput:	.asciiz "Please type your name."
	nameInputP1:	.asciiz "Player 1 name: "
	nameInputP2:	.asciiz "Player 2 name: "
	nameP1:	.space 100
	nameP2:	.space 100
	#end
	dataInputP1:	.asciiz "Player 1 input: "
	dataInputP2:	.asciiz "Player 2 input: "
	rBowInput:	.asciiz "Bow row: "
	cBowInput:	.asciiz "Bow column: "
	rSternInput:	.asciiz "Stern row: "
	cSternInput:	.asciiz "Stern column: "
	invalidRange:	.asciiz "Invalid input, value must be from 0 to 6"
	invalidPos:	.asciiz "Invalid input, bow and stern must be on the same row or same column"
	invaldLength:	.asciiz "Invalid input, required length is " #the length
	
	invalidTarget:	.asciiz "Invalid target, value must be from 0 to 6"
	
	hit:	.asciiz "HIT!"
	miss:	.asciiz "MISS!"
	winP1:	.asciiz "Player 1 WIN!"
	winP2:	.asciiz "Player 2 WIN!"
	
.text
	#Welcome prompt
	li $v0, 4
	la $a0, welcome
	syscall
	
	#Load two boards to $s0 and $s1 register
	la $s0, board1
	la $s1, board2
	
	
	add $t0, $zero, $zero	#hit_counter_P1
	add $t1, $zero, $zero	#hit_counter_P2

while
	#things goes here
	beq $t0, 16, P1		#Player 1 WIN, goto P1
	beq $t1, 16, P2		#Player 2 WIN, goto P2
	#things goes here
	j loop
	
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
	#stop the program
	li $v0, 10
	syscall