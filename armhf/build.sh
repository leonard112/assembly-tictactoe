#!/bin/bash

architecture=$(lscpu | grep Architecture: | awk '{print $NF}' | tr -d '\n')
assembler="as"
link_editor="ld"

if [ "$architecture" != "armhf" ]; then
    assembler="arm-linux-gnueabihf-as"
    link_editor="arm-linux-gnueabihf-ld"
    echo "'tictactoe' is not being built on ARM32. tictactoe is being cross compiled." \
    "If you do not plan to run 'tictactoe' on ARM32 or ARM64, use 'qemu-arm' to run the program."
fi

$assembler -g -o object/main.o main.asm
$assembler -g -o object/print.o print.asm
$assembler -g -o object/input.o input.asm
$assembler -g -o object/exit.o exit.asm
$assembler -g -o object/show_board.o show_board.asm
$assembler -g -o object/fill_space.o fill_space.asm
$link_editor -o tictactoe object/main.o object/print.o \
                  object/input.o object/exit.o \
              object/show_board.o object/fill_space.o
