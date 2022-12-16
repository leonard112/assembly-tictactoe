# IBMZ (s390x) Assembly Language Tic Tac Toe

This program should be able to run on any Linux system.

&nbsp;

## How to run this program
1. Clone this repository and run all the following commands from the `assembly-tictactoe/s390x` folder.
2. If this program is being built on any architecture other than `s390x`, install `binutils-s390x-linux-gnu` which contains the assembler and link editor required to assemble and link `s390x` programs.
```console
$ sudo apt-get update && sudo apt-get install binutils-s390x-linux-gnu # debian/ubuntu
...
```
4. Execute `build.sh`:
> _`build.sh` uses `as` or `s390x-linux-gnu-as` to assemble all assembly source files into binary object files, and then uses `ld` or `s390x-linux-gnu-ld` to link edit all of the binary object files into an executable binary file called `tictactoe`. The linker and assembler used depends on whether or not `tictactoe` is being built on `s390x`._

> _No output indicates that the build was sucessful._
```console
$ ./build.sh
$
```
5. Execute the `tictactoe` binary:
> _If `tictactoe` is not being run on `s390x` architecture, install `qemu-user` to get the hardware emulation software to run `s390x` programs._
> To run with `qemu`: `$ qemu-s390x ./tictactoe`
```console
$ ./tictactoe
Welcome to IBMZ (s390x) assembler Tic Tac Toe!
| | | |
| | | |
| | | |
It's X's turn:
```