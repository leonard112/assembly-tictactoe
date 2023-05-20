# ------------------------------- Description --------------------------------
#
# Since the process of loading the address of a buffer into a register takes
# several instruction and is highly esoteric on ppc64 architecture, this
# macro is used as an abstraction to make loading the address of a buffer
# one macro instruction.
#
# example:
#     la	  %r4, my_buffer	  
#
# ----------------------------------------------------------------------------


.macro	la reg, buffer
    lis     \reg, \buffer@highest           # load buffer address bits 48-63 into register bits 16-31
    ori     \reg, \reg, \buffer@higher      # load buffer address bits 32-47 into register bits 0-15
    rldicr  \reg, \reg, 32, 31              # Shift the contents of register right 32 bits starting at bit 31
    oris    \reg, \reg, \buffer@h           # load buffer address bits 16-31 into register bits 16-31
    ori	    \reg, \reg, \buffer@l           # load buffer address bits 0-15 into register bits 0-15
.endm
