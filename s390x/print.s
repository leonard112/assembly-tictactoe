# ------------------------------- Description --------------------------------
#
# Print the contents of a buffer to stdout.
#
# -------------------------------- Parameters --------------------------------
#
# %r3       Address of buffer containing message to be printed
# %r4       Size of buffer to be printed
#
# ------------------------------ Register Usage ------------------------------
#
# %r1       Used to store the syscall number
# %r2       Used to store the file descriptor
#
# --------------------------- Memory Manipulation ----------------------------
#
# None
#
# ------------------------------ Return Values -------------------------------
#
# None
#
# ----------------------------------------------------------------------------


.globl print

print:
    lghi    %r1, 4			    # specify write syscall	
    lghi    %r2, 1			    # specify stdout file descriptor
    svc     0				    # execute syscall
    br      %r14	
