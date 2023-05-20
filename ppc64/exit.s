# ------------------------------- Description --------------------------------
#
# Terminate the program with an exit status code specified by the caller.
#
# -------------------------------- Parameters --------------------------------
#
# %r3    	Exit status code of the program
#
# ------------------------------ Register Usage ------------------------------
#
# %r1		Used to store the syscall number
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


.global exit

exit:
    li	%r0, 1			# specify exit syscall
    sc                  # execute syscall
