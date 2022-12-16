# %r3 address for string to print
# %r4 length of string to print

.globl print

print:
    lghi %r1, 4			# specify write syscall	
    lghi %r2, 1			# specify stdout file descriptor
    svc 0				# execute syscall
    br %r14	
