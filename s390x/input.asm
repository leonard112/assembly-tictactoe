# %r3 address for buffer
# %r4 size of buffer

.globl input

input:
    la %r1, 3           # specify read syscall 
    la %r2, 0           # specify stdin file descriptor
    svc 0               # execute syscall
    br %r14
