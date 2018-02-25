# ***** DO NOT MODIFY THIS FILE **** #
#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     # System call code for print_int
	li	$a0, $arg  # Integer to print
	syscall            # Print the integer
	.end_macro
	
	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
	# Macro: read_int
	# Usage: read_int(<reg>)
	.macro read_int($arg)
	li	$v0,5	# Read intger
	syscall
	move	$arg, $v0 # move the data to target reg
	.end_macro
	
	# Macro: print_reg_int
	# Usage: print_reg_int(<reg>)
	.macro print_reg_int ($arg)
	li	$v0, 1		# print_int call
	move	$a0, $arg 	# move the source reg value to $a0
	syscall
	.end_macro
	
	# Macro: lwi
	# Usage: lwi (<reg>, <upper imm>, <lower imm>)
	.macro lwi ($reg, $ui, $li)
	lui $reg, $ui
	ori $reg, $reg, $li
	.end_macro
	
	# Macro: push
	# Usage: push (<reg>)
	.macro push($reg)
	sw	$reg, 0x0($sp)	# M[$sp] = R[reg]
	addi    $sp, $sp, -4	# R[sp] = R[sp] - 4
	.end_macro
	
	# Macro: push
	# Usage: push (<reg>)
	.macro pop($reg)
	addi    $sp, $sp, +4	# R[sp] = R[sp] + 4
	lw	$reg, 0x0($sp)	# M[$sp] = R[reg]
	.end_macro
	
	.macro push_var_value($varName)
	lw	$t0, $varName
	push($t0)
	.end_macro
	
	.macro push_var_address($varName)
	la	$t0, $varName
	push($t0)
	.end_macro

	.macro call_printf($format)
	la	$a0, $format
	jal	printf
	.end_macro


	.macro swap($address, $arg, $arg2, $tmp, $tmp2)
	mul $arg, $arg, 4
	mul $arg2, $arg2, 4
	lw $tmp, $address($arg)
	lw $tmp2, $address($arg2)
	sw $tmp, $address($arg2) 
	sw $tmp2, $address($arg)
	div $arg, $arg, 4
	div $arg2, $arg2, 4
	.end_macro
	
	.macro get($target, $address, $index)
	mul $index,$index, 4
	lw $target, $address($index)
	div $index, $index , 4
	.end_macro
	
	.macro set($value, $address, $index)
	mul $index, $index, 4
	sw $value, $address($index)
	div $index, $index, 4
	.end_macro
	
	
	