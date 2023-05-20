# PowerPC (ppc64) Assembly Language Tic Tac Toe

This program should be able to run on any Linux system.

&nbsp;

## How to run this program
1. Clone this repository and run all the following commands from the `assembly-tictactoe/ppc64` folder.
2. If this program is being built on any architecture other than `ppc64`, install `binutils-powerpc64-linux-gnu` which contains the assembler and link editor required to assemble and link `ppc64` programs.
```console
$ sudo apt-get update && sudo apt-get install binutils-s390x-linux-gnu # debian/ubuntu
...
```
4. Run `make`:
> _`make` uses `as` or `powerpc64-linux-gnu-as` to assemble all assembly source files into binary object files, and then uses `ld` or `powerpc64-linux-gnu-ld` to link edit all of the binary object files into an executable binary file called `tictactoe`. The linker and assembler used depends on whether or not `tictactoe` is being built on `ppc64`._

> _If you see output that looks like the following, that indicates that the build was successful._
```console
$ make
mkdir -p object
powerpc64-linux-gnu-as -g -o object/exit.o exit.s
powerpc64-linux-gnu-as -g -o object/fill_space.o fill_space.s
powerpc64-linux-gnu-as -g -o object/input_cpu.o input_cpu.s
powerpc64-linux-gnu-as -g -o object/input.o input.s
powerpc64-linux-gnu-as -g -o object/main.o main.s
powerpc64-linux-gnu-as -g -o object/print.o print.s
powerpc64-linux-gnu-as -g -o object/random.o random.s
powerpc64-linux-gnu-as -g -o object/show_board.o show_board.s
powerpc64-linux-gnu-ld   object/exit.o  object/fill_space.o  object/input_cpu.o  object/input.o  object/main.o  object/print.o  object/random.o  object/show_board.o -o tictactoe
```
5. Execute the `tictactoe` binary:
> _If `tictactoe` is not being run on `ppc64` architecture, install `qemu-user` to get the hardware emulation software to run `ppc64` programs._
> To run with `qemu`: `$ qemu-ppc64 ./tictactoe`
```console
$ ./tictactoe
Welcome to PowerPC (ppc64) assembly language Tic Tac Toe!
| | | |
| | | |
| | | |
It's X's turn: 
```