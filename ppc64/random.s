# ------------------------------- Description --------------------------------
#
# Generate a random number between 0 and 3.
#
# -------------------------------- Parameters --------------------------------
#
# None
#
# ------------------------------ Register Usage ------------------------------
#
# %r0       Used to store syscall number
# %r3       Used to get syscall return value
#           Used for deriving random number between 0 and 3 from seed
# %r4       Used for deriving random number between 0 and 3 from seed
# %r5       Used for deriving random number between 0 and 3 from seed
#
# --------------------------- Memory Manipulation ----------------------------
#
# None
#
# ------------------------------ Return Values -------------------------------
#
# %r3       A random number between 0 and 3
#
# ----------------------------------------------------------------------------


.global random

random:
    # get sys_time as seed for random number generation
    # result of syscall gets stored in %r3
    li      %r0, 13
    li      %r3, 0
    sc

    li      %r5, 3

    # divide %r3 (sys_time) by %r5 (3) and store quotient in %r4
    # multiply the %r4 (quotient) by %r5 (3) and store the product in %r4
    # subtract %r4 (product) from %r3 (sys_time) and store the difference in %r3
    divd    %r4, %r3, %r5
    mulld   %r4, %r4, %r5
    subf    %r3, %r4, %r3
    
    blr
    