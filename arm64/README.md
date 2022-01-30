# arm64 (ARM64) Assembly Language Tic Tac Toe

This program should be able to run on any Linux system.

&nbsp;

## How to run this program
1. Clone this repository and run all the following commands from the `assembly-tictactoe/arm64` folder.
2. Execute `build.sh`:
> _`build.sh` uses `as` to assemble all assembly source files into binary object files, and then uses `ld` to link edit all of the binary object files into an executable binary file called `tictactoe`._

> _No output indicates that the build was sucessful._
```console
$ ./build.sh
$
```
3. Execute the `tictactoe` binary:
```console
$ ./tictactoe
Welcome to arm64 (ARM64) assembler Tic Tac Toe!
| | | |
| | | |
| | | |
It's X's turn:
```
