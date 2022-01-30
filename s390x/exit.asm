# Parameters:
# %r2 (Return value of the program)

.globl exit

exit:
	la %r1, 1			# specify exit syscall
	svc 0				# execute syscall
