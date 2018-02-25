.include "./common_macro.asm"
.data 
test_data: 1,3,8,7,5,2,20,10,42,53,62,12
size: .word 12
new_line: .asciiz "\n"
test_string: .asciiz "test"
comma: .asciiz ", "
.text
.globl main


#####################################################################
# Implement partition
# Argument:
# 	$a0: low 
#	$a1: hi
#       $t0 : Pivot $t1 : right $t3: index $t4,$t5,$t6: tmp
# Return:
#	$v0: pivot
#####################################################################
partition:
	#STORE
	addi $sp, $sp -24
	sw $fp, 24($sp)
	sw $ra, 20($sp)
	sw $a0, 16($sp)#LOW
	sw $a1, 12($sp)#HI 
	sw $a2, 8($sp)#XTRA VARIABLE
	addi $fp, $sp, 24 
	li $t0, 0
	li $t1, 0 
	li $t2, 0 
	li $t3, 0
	li $t4, 0
	li $t5, 0
	#CODE
	get($t0, test_data, $a1) #pivot = arr[high]
	move $t1, $a0 #RIGHT = LOW
	sub $t1,$t2, 1 #right = low - 1
	
	partition_traverse_loop: #i =0 i < high i++
	bge $t3, $a1, partition_traverse_end # INDEX >= HIGH? EXIT CONDITION
	get($t4, test_data, $t3) #GET A[INDEX]
	bge $t4, $t0, partition_continue #A[INDEX] >= PIVOT? CONTINUE
	
	addi $t1, $t1, 1 #RIGHT ++
	swap(test_data, $t3, $t1, $t4,$t5) #SWAP INDEX, RIGHT
	
	partition_continue:
	addi $t3,$t3, 1
	j partition_traverse_loop
	partition_traverse_end:
	addi $t1, $t1, 1
	swap(test_data, $t1,$a1, $t4,$t5)
	move $v0, $t1
	partition_restore:
	#RESTORE
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a2,  8($sp)
	addi	$sp, $sp, 24
	
	jr 	$ra
#####################################################################
# Implement partition
# Argument:
# 	$a0: low
#	$a1: hi
# Return: void
#####################################################################
quicksort:
	#STORE
	addi $sp, $sp -28
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	sw $a0, 20($sp)#LOW
	sw $a1, 16($sp)#HI 
	sw $s0, 12($sp)#PIVOT
	sw $s1, 8($sp)#HI TEMP
	addi $fp, $sp, 28

	bge $a0, $a1, quicksort_restore # IF LOW >= HIGH EXIT
	
	jal partition #PARTITION CALL
	move $s0, $v0
	move $s1, $a1
	move $a1, $s0
	subi $a1, $a1, 1
	jal quicksort
	move $a0, $s0
	addi $a0, $a0, 1
	move $a1, $s1
	jal quicksort
	quicksort_restore:
	#RESTORE
	lw	$fp, 28($sp)
	lw	$ra, 24($sp)
	lw	$a0, 20($sp)
	lw	$a1, 16($sp)
	lw	$s0,  12($sp)
	lw 	$s1,  8($sp)
	addi	$sp, $sp, 28
	jr 	$ra

main: 
li $a0, 0
lw $a1, size($zero)
lw $s1, size($zero)
sub $a1, $a1,1
#Before

li $s0, 0

before: 
bge $s0, $s1, before_end
get($t0, test_data,$s0)
print_reg_int($t0)
print_str(comma)
addi $s0,$s0,1
j before
before_end:

print_str(new_line)
li $a0, 0
lw $a1, size($zero)
sub $a1, $a1,1
jal quicksort

print_str(new_line)
li $s0, 0

after: 
bge $s0, $s1, after_end
get($t0, test_data,$s0)
print_reg_int($t0)
print_str(comma)
addi $s0,$s0,1
j after
after_end:

exit
