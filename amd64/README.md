# x86 (amd64) Assembler Language Tic Tac Toe

This program should be able to run on any 64 bit x86 Linux system.

&nbsp;

## How to run this program
1. Clone this repository and run all the following commands from the `assembly-tictactoe/amd64` folder.
2. Ensure `nasm` is insalled on the system
> _`nasm` is used to assemble the assembly source files into binary object files._
```console
$ sudo apt-get update && sudo apt-get install nasm # debian/ubuntu
...
```
```console
$ sudo apk add nasm # alpine
...
```
```console
$ sudo yum install nasm # fedora/coreos
...
```
4. Run `make`:
> _`make` uses `nasm` to assemble all assembly source files into binary object files, and then uses `ld` to link edit all of the binary object files into an executable binary file called `tictactoe`._

> _If you see output that looks like the following, that indicates that the build was successful._
```console
$ make
mkdir -p object
nasm -f elf64 exit.asm -o object/exit.o
nasm -f elf64 fill_space.asm -o object/fill_space.o
nasm -f elf64 input.asm -o object/input.o
nasm -f elf64 input_cpu.asm -o object/input_cpu.o
nasm -f elf64 main.asm -o object/main.o
nasm -f elf64 print.asm -o object/print.o
nasm -f elf64 random.asm -o object/random.o
nasm -f elf64 show_board.asm -o object/show_board.o
ld   object/exit.o  object/fill_space.o  object/input.o  object/input_cpu.o  object/main.o  object/print.o  object/random.o  object/show_board.o -o tictactoe
```
5. Execute the `tictactoe` binary:
```console
$ ./tictactoe
Welcome to x86 (amd64) assembler Tic Tac Toe!
| | | |
| | | |
| | | |
It's X's turn:
```
