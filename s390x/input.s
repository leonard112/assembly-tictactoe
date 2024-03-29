# ------------------------------- Description --------------------------------
#
# This subroutine reads user input from stdin and stores it in the input
# buffer provided by the caller.
#
# ------------------------------- Parameters ---------------------------------
#
# %r3       Size of the buffer that user input will be read to
# %r4       Address of buffer that user input will be read to
#
# ------------------------------ Register Usage ------------------------------
#
# %r1       Used to store the syscall number
# %r2       Used to store the file descriptor
#
# --------------------------- Memory Manipulation ----------------------------
#
# The input buffer should be the only memory that is manipulated by this 
# subroutine.
#
# ------------------------------ Return Values -------------------------------
#
# None
#
# ----------------------------------------------------------------------------


.globl input

input:
    lghi    %r1, 3          # specify read syscall 
    lghi    %r2, 0          # specify stdin file descriptor
    svc     0               # execute syscall
    br      %r14
