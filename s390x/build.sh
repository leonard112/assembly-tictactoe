#!/bin/bash

set -e

mkdir object &> /dev/null || true

architecture=$(lscpu | grep Architecture: | awk '{print $NF}' | tr -d '\n')
assembler="as"
link_editor="ld"

if [ "$architecture" != "s390x" ]; then
    assembler="s390x-linux-gnu-as"
    link_editor="s390x-linux-gnu-ld"
    echo "'tictactoe' is not being built on 's390x' architecture. 'tictactoe' is being cross compiled." \
    "If you do not plan to run 'tictactoe' on 's390x' architecture, use 'qemu-s390x' to run the program."
fi

$assembler -g -o object/exit.o exit.asm
$assembler -g -o object/fill_space.o fill_space.asm
$assembler -g -o object/input_cpu.o input_cpu.asm
$assembler -g -o object/input.o input.asm
$assembler -g -o object/main.o main.asm
$assembler -g -o object/print.o print.asm
$assembler -g -o object/random.o random.asm
$assembler -g -o object/show_board.o show_board.asm
$link_editor object/exit.o \
             object/fill_space.o \
             object/input_cpu.o \
             object/input.o \
             object/main.o \
             object/print.o \
             object/random.o \
             object/show_board.o \
             -o tictactoe