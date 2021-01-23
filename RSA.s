######################################
# - A Tiny RSA Encryptor/Decryptor - #
#	Author:	Ellie Moore	     #
#	Version: 01.22.2021	     #	
######################################
	
# DATA #
	.data
readin: .align 	0
	.space 	5000
cmd:	.align 	0
	.space 	500
mod:	.align 	2
	.word 	10403
lcm: 	.word 	5100
pkey:	.word 	31
key:	.word 	4771
space:	.asciiz " "
ask:	.asciiz "Hello, friend. Encrypt or decrypt? (enc/dec)\n>> "
prompt: .asciiz "Enter your data.\n>> "
error:	.asciiz "You meant to type \"enc\".\nRestarting program...\n\n"

# DEF #
	.text
	.globl 	main
	
# PROGRAM #
main:				#
	addiu 	$s4, $ra, 0	# Save return address.
	lw	$s0, pkey	# Public Key !
	lw 	$s1, mod	# The MOD !
	lw	$s3, key	# Private Key ! (Not so private, eh? lol)
BEG:
	la 	$a0, ask	# Ask the user what they want to do.
	addiu 	$v0, $0, 4	#
	syscall			#
	la 	$a0, cmd	# Get the command from the user.
	addiu 	$a1, $0, 500	# (Buffer of 500 bytes)
	addiu	$v0, $0, 8	#
	syscall			#
	lbu 	$t6, 0($a0) 	# load the first character of the command.
	beq	$t6, 101, P0	# do while($t6 != 'e' && $t6 != 'd')
	bne	$t6, 100, BEG	#
P0:				#
	la 	$a0, prompt	# Ask the user to enter data.
	addiu 	$v0, $0, 4	#
	syscall			#
	la 	$a0, readin	# Get the data from the user.
	addiu	$a1, $0, 5000	#
	addiu	$v0, $0, 8	#
	syscall			#
	addiu 	$t5, $a0, 0	# Move address of data to $t5.
	beq	$t6, 100, L1	# If $t6 = 'd', branch to L1
L0:				#
	lbu 	$a0, 0($t5)	# Load the next byte into first arg.
	addiu 	$t6, $a0, 0 	# Save the byte to $t6.
	addiu 	$a1, $s0, 0	# Move public key into second arg.
	addiu 	$a2, $s1, 0	# Move mod into third arg.
	jal 	FASTME		# Perform Fast Modular Exponentiation on the byte.
	addiu 	$a0, $v0, 0	# Print the result.
	addiu	$v0, $0, 1	#
	syscall			#
	la 	$a0, space	# Print a space.
	addiu	$v0, $0, 4	#
	syscall			#
	addiu 	$t5, $t5, 1	# increment the address to load next byte.
	bne 	$t6, 0, L0	# Loop L0 if $t6 != '\0'
	jr 	$s4		# Return from main.
L1:				#
	addiu 	$t7, $0, 0 		# Zero out $t7 to use as the counter.
L1A:				#
	lbu 	$t6, 0($t5)	# Load the current byte at $t5 into $t6.
	beq	$t6, 32, L1A0	# If the byte represents '\s', break.
	beq	$t6, 10, L1A0	# If the byte represents '\n', break.
	beqz	$t6, RET	# If the byte represents '\0', break.
	bgt	$t6, 57, EXIT	# If the byte is not a digit...
	blt	$t6, 48, EXIT	# restart from main.
	andi	$t6, $t6, 0xF	# Convert ASCII digit to int and store in $t6.
	sll	$t9, $t7, 1	# Multiply the counter by ten
	sll	$t7, $t7, 3	# 	($t7 << 1) + ($t7 << 3) =
	addu 	$t7, $t7, $t9	# 	2($t7) + 8($t7) = 10($t7)
	addu   	$t7, $t7, $t6	# Add $t6 to the counter.
	addiu	$t5, $t5, 1	# increment the address.
	j	L1A		# Loop.
L1A0:				#
	addiu 	$a0, $t7, 0 	# Move the counter to first arg.
	addiu 	$a1, $s3, 0	# Move the private key to second arg.
	addiu 	$a2, $s1, 0	# Move the mod to third arg
	jal 	FASTME		# Perform Fast Modular Exponentiation on the counter.
	addiu 	$a0, $v0, 0	# Print the result as an ascii character.
	addiu 	$v0, $0, 11	#
	syscall			#
	addiu	$t5, $t5, 1	# Increment address for next byte sequence.
	j 	L1		# Loop L1
RET:				#
	jr 	$s4		# Return from main.
FASTME:				#
	addiu 	$t0, $0, 1	# Load $t0 with 1.
	ble 	$a1, 0, S0	# If $a1 <= 0, branch to S0
L2:				#
	andi 	$t1, $a1, 1	# $t1 = $a1 mod 2
	beq 	$t1, 0, L2B2	# if $t1 == 0, branch to L2B2
L2B1:				#
	mul 	$t0, $t0, $a0	# $t0 *= $a0
	div 	$t0, $a2	# $t0 %= $a2
	mfhi 	$t0		#
L2B2:				#
	mul 	$a0, $a0, $a0	# $a0 *= $a0
	div 	$a0, $a2	# $a0 %= $a2
	mfhi 	$a0		#
	srl 	$a1, $a1, 1	# $a1 >>>= 1
	bgt 	$a1, 0, L2	# if $a1 > 0, branch to L2
S0:				#
	addiu 	$v0, $t0, 0	# Move $t0 to $v0.
	jr 	$ra		# Return from FASTME.
EXIT:				#
	la 	$a0, error	# Print error message.
	addiu	$v0, $0, 4	#
	syscall			#
	j 	BEG		# Loop main.
	
