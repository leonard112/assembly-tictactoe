.globl random

.text
random:
    # get sys_times/compat_sys_times as seed for random number generation
    # result of syscall gets stored in %r0
    lghi %r1, 43
    lghi %r2, 0
    svc 0

    lghi %r1, 3
    lr %r3, %r2
    lghi %r2, 0

    # divide combination of %r2 and %r3 by %r1.
    # store result in %r3
    # store the remainder in %r2 (i.e 1823/3=607 rem 2)
    dr %r2, %r1
    
    lr %r0, %r2 # move remainder into %r0

	br %r14
