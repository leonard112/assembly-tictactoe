# ARM (armhf) Assembly Language Tic Tac Toe

This program should be able to run on any Linux system.

&nbsp;

## How to run this program
1. Clone this repository and run all the following commands from the `assembly-tictactoe/armhf` folder.
2. If this program is being built on any architecture other than `armhf`, install `binutils-arm-linux-gnueabihf-dbg` which contains the assembler and link editor required to assemble and link `armhf` programs.
```console
$ sudo apt-get update && sudo apt-get install binutils-arm-linux-gnueabihf-dbg # debian/ubuntu
...
```
4. Run `make`:
> _`make` uses `as` or `arm-linux-gnueabihf-as` to assemble all assembly source files into binary object files, and then uses `ld` or `arm-linux-gnueabihf-ld` to link edit all of the binary object files into an executable binary file called `tictactoe`. The linker and assembler used depends on whether or not `tictactoe` is being built on `armhf`._

> _If you see output that looks like the following, that indicates that the build was successful._
```console
$ make
mkdir -p object
arm-linux-gnueabihf-as -g -o object/exit.o exit.s
arm-linux-gnueabihf-as -g -o object/fill_space.o fill_space.s
arm-linux-gnueabihf-as -g -o object/input_cpu.o input_cpu.s
arm-linux-gnueabihf-as -g -o object/input.o input.s
arm-linux-gnueabihf-as -g -o object/main.o main.s
arm-linux-gnueabihf-as -g -o object/print.o print.s
arm-linux-gnueabihf-as -g -o object/random.o random.s
random.s: Assembler messages:
random.s:43: Rd and Rm should be different in mul
arm-linux-gnueabihf-as -g -o object/show_board.o show_board.s
arm-linux-gnueabihf-ld   object/exit.o  object/fill_space.o  object/input_cpu.o  object/input.o  object/main.o  object/print.o  object/random.o  object/show_board.o -o tictactoe
```
5. Execute the `tictactoe` binary:
> _If `tictactoe` is not being run on `armhf` or `aarch64` architecture, install `qemu-user` to get the hardware emulation software to run `armhf` programs._
> To run with `qemu`: `$ qemu-arm ./tictactoe`
```console
$ ./tictactoe
Welcome to ARM (armhf) assembler Tic Tac Toe!
| | | |
| | | |
| | | |
It's X's turn:
```
