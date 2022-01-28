#!/bin/bash

as -g -o object/main.o main.asm
as -g -o object/print.o print.asm
as -g -o object/input.o input.asm
as -g -o object/exit.o exit.asm
as -g -o object/show_board.o show_board.asm
as -g -o object/fill_space.o fill_space.asm
ld -g -o tictactoe \
   object/main.o \
   object/print.o \
   object/input.o \
   object/exit.o \
   object/show_board.o \
   object/fill_space.o
