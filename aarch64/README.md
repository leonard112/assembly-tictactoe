# ARM (aarch64) Assembly Language Tic Tac Toe

This program should be able to run on any Linux system.

&nbsp;

## How to run this program
1. Clone this repository and run all the following commands from the `assembly-tictactoe/aarch64` folder.
2. If this program is being built on any architecture other than `aarch64`, install `binutils-aarch64-linux-gnu-dbg` which contains the assembler and link editor required to assemble and link `aarch64` programs.
```console
$ sudo apt-get update && sudo apt-get install binutils-aarch64-linux-gnu-dbg # debian/ubuntu
...
```
4. Run `make`:
> _`make` uses `as` or `aarch64-linux-gnu-as` to assemble all assembly source files into binary object files, and then uses `ld` or `aarch64-linux-gnu-ld` to link edit all of the binary object files into an executable binary file called `tictactoe`. The linker and assembler used depends on whether or not `tictactoe` is being built on `aarch64`._

> _If you see output that looks like the following, that indicates that the build was successful._
```console
$ make
mkdir -p object
aarch64-linux-gnu-as -g -o object/exit.o exit.s
aarch64-linux-gnu-as -g -o object/fill_space.o fill_space.s
aarch64-linux-gnu-as -g -o object/input_cpu.o input_cpu.s
aarch64-linux-gnu-as -g -o object/input.o input.s
aarch64-linux-gnu-as -g -o object/main.o main.s
aarch64-linux-gnu-as -g -o object/print.o print.s
aarch64-linux-gnu-as -g -o object/random.o random.s
aarch64-linux-gnu-as -g -o object/show_board.o show_board.s
aarch64-linux-gnu-ld   object/exit.o  object/fill_space.o  object/input_cpu.o  object/input.o  object/main.o  object/print.o  object/random.o  object/show_board.o -o tictactoe
```
5. Execute the `tictactoe` binary:
> _If `tictactoe` is not being run on `aarch64` architecture, install `qemu-user` to get the hardware emulation software to run `aarch64` programs._
> To run with `qemu`: `$ qemu-aarch64 ./tictactoe`
```console
$ ./tictactoe
Welcome to ARM (aarch64) assembler Tic Tac Toe!
| | | |
| | | |
| | | |
It's X's turn:
```
