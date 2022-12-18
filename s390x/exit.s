# ------------------------------- Description --------------------------------
#
# Terminate the program with an exit status code specified by the caller.
#
# -------------------------------- Parameters --------------------------------
#
# %r2    	Exit status code of the program
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


.globl exit

exit:
	lghi 	%r1, 1				# specify exit syscall
	svc 	0					# execute syscall
