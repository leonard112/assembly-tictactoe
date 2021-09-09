# x86 (i386) Assembler Tic Tac Toe

This program should be able to run on any 32 bit or 64 bit x86 Linux system.

&nbsp;

## How to run this program
1. Clone this repository and run all the following commands from the `assembly-tictactoe/x86-i386` folder.
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
4. Execute `build.sh`:
> _`build.sh` uses `nasm` to assemble all assembly source files into binary object files, and then uses `ld` to link edit all of the binary object files into an executable binary file called `tictactoe`._

> _No output indicates that the build was sucessful._
```console
$ ./build.sh
$
```
5. Execute the `tictactoe` binary:
```console
$ ./tictactoe
Welcome to x86 (i386) assembler Tic Tac Toe!
| | | |
| | | |
| | | |
It's X's turn:
```
