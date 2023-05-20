# ------------------------------- Description --------------------------------
#
# Print the contents of a buffer to stdout.
#
# -------------------------------- Parameters --------------------------------
#
# %r4       Address of buffer containing message to be printed
# %r5       Size of buffer to be printed
#
# ------------------------------ Register Usage ------------------------------
#
# %r0       Used to store the syscall number
# %r3       Used to store the file descriptor
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


.global print

print:
    li	%r0, 4			# specify write syscall
    li	%r3, 1			# specify stdout file descriptor
    sc                  # specify execute syscall
    blr
