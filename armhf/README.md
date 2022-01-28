# armhf (ARM32) Assembler Tic Tac Toe

This program should be able to run on any Linux system.

&nbsp;

## How to run this program
1. Clone this repository and run all the following commands from the `assembly-tictactoe/armhf` folder.
2. If this program is being built on any architecture other than `armhf`, install `arm-linux-gnueabihf` which contains the assembler and link editor required to assemble and link `armhf` programs.
```console
$ sudo apt-get update && sudo apt-get install arm-linux-gnueabihf # debian/ubuntu
...
```
4. Execute `build.sh`:
> _`build.sh` uses `as` or `arm-linux-gnueabihf-as` to assemble all assembly source files into binary object files, and then uses `ld` or `arm-linux-gnueabihf-ld` to link edit all of the binary object files into an executable binary file called `tictactoe`. The linker and assembler used depends on whether or not `tictactoe` is being built on `armhf`._

> _No output indicates that the build was sucessful._
```console
$ ./build.sh
$
```
5. Execute the `tictactoe` binary:
> _If `tictactoe` is not being run on `armhf` or `aarch64`, install `qemu-user` to get the hardware emulation software to run ARM programs._
> To run with `qemu`: `$ qemu-arm ./tictactoe`
```console
$ ./tictactoe
Welcome to armhf (ARM32) assembler Tic Tac Toe!
| | | |
| | | |
| | | |
It's X's turn:
```
