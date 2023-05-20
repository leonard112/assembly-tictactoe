# ------------------------------- Description --------------------------------
#
# This subroutine reads user input from stdin and stores it in the input
# buffer provided by the caller.
#
# ------------------------------- Parameters ---------------------------------
#
# %r4       Size of the buffer that user input will be read to
# %r5       Address of buffer that user input will be read to
#
# ------------------------------ Register Usage ------------------------------
#
# %r0      Used to store the syscall number
# %r3      Used to store the file descriptor
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


.global input

input:
    li	%r0, 3			# specify stdin syscall
    li	%r3, 1			# specify stdin file descriptor
    sc				    # execute syscall
    blr
    