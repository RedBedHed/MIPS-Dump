#################################
# A Faster Fibonacci Calculator #
#	Author: Ellie Moore	#
#	Version: 01.22.2021	#
#################################

#DATA
	.data
input: 	.asciiz "fib("
table: 	.align 2 
	.space 5000

#PROGRAM
	.text
	.globl 	main
	.globl 	fib

main:	la	$s1, table	# Save the address of dynamic table.
	addiu 	$s0, $ra, 0	# Save the return address.
	la 	$a0, input	# Print the prompt string.
	li 	$v0, 4
	syscall 
	li 	$v0, 5		# Get an int from the user.
	syscall
	sll 	$a0, $v0, 2
	jal 	fib		# Call fib($a0).
	addiu 	$a0, $v0, 0	# Print the result.
	li 	$v0, 1
	syscall
	jr 	$s0		# Return from main.
	
fib:	beq 	$a0, 0, base0	# If $a0 == 0, branch to base0.
	beq 	$a0, 4, base1	# If $a0 == 1, branch to base1.
	addiu 	$sp, $sp, -16 	# Push function onto the stack.
	sw 	$ra, 0($sp)	# Save the return address on the stack.
	addiu 	$a0, $a0, -4	# Decrement the argument.
	sw 	$a0, 4($sp)	# Save the argument on the stack.
	jal 	fib		# Recurse.
	lw 	$a0, 4($sp)	# Retrieve the argument from the stack.
	addu	$t0, $a0, $s1	# Calculate address of the visited node in dynamic table.
	sw	$v0, 0($t0)	# Store the result of the visited node in dynamic table.
	sw 	$v0, 8($sp)	# Save the result on the stack.
	addiu	$t0, $t0, -4	# Calculate the address for the next node in dynamic table.
	lw	$t1, 0($t0)	# Load pre-calculated node (if any) into $t1.
	bne	$t1, 0, skip	# If $t1 != 0, skip recursion.
	addiu 	$a0, $a0, -4	# Decrement the argument.
	jal 	fib		# Recurse.
	b 	cont
	
skip:  	addiu 	$v0, $t1, 0 

cont:	lw 	$t0, 8($sp)	# Retrieve the result of the first call from the stack.
	addu 	$v0, $v0, $t0	# Add the result of the first call to that of the second.
	b 	exit		# $v0 = fib($a0 - 1) + fib($a0 - 2).
	
base0:  li 	$v0, 0		# Return 0.
	jr 	$ra			

base1:	li 	$v0, 1		# Return 1.
	jr 	$ra
	
exit:	lw 	$ra, 0($sp)	# Retrieve the return address from the stack.
	addiu 	$sp, $sp, 16	# Pop function off of the stack.
	jr 	$ra		# Return $v0.
