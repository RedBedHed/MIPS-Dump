#########################################################
# RANDMIPS - LINEAR CONGRUENCE GENERATOR 		#
# 	Generates uniformly distributed random numbers.	#
#########################################################
# - DATA - #
	.data
ws: 	.byte 32
intro:	.asciiz "Hello, friend. This is a positive random number sequence generator.\n"
ask:	.asciiz "Enter the upper bound, x, for number generation (0 <= S_n < x).\n>> "
# - PUBLIC TEXT - #
	.text
	.globl main
# - MAIN METHOD - #
main:	#########################
	# <\ GET UPPER BOUND /> #
	#########################
	la	$a0, intro	# Print intro string.
	addiu 	$v0, $0, 4	#
	syscall			#
	la	$a0, ask	# Print question string
	syscall			#
	addiu 	$v0, $0, 5	# Get Input
	syscall			#
	addiu 	$t1, $v0, 0	# $t1 = $v0
	addiu 	$v0, $0, 30	# Get least significant bytes of system time.
	syscall			# 
	srl 	$t3, $a0, 4	# $t3 = $a0 >>> 4
	addiu	$t0, $0, 1	# #t0 = 1
	lbu 	$s2, ws		# $s2 = whitespace
L0:	#################################
	# <\ DO MATHS AND PRINT LIST /> #
	#################################
	sll 	$t2, $t3, 3	# $t2 = $t3 << 3
	addu	$t2, $t2, $t0	# $t2 += $t0
	div 	$t2, $t1	# $t3 = $t2 % $t1
	mfhi 	$t3		#
	addiu 	$t0, $t0, 1	# $t0++
	addiu 	$a0, $t3, 0	# $a0 = $t3
	addiu 	$v0, $0, 1	# 
	syscall			# Print int
	addiu 	$a0, $s2, 0	# $a0 = $s2
	addiu 	$v0, $0, 11	# 
	syscall			# Print whitespace
	blt 	$t0, 50, L0	# do while($t0 < 50)
	###########################
	# <\ EXIT FROM PROGRAM /> #
	###########################
	jr 	$ra		# Return from main.