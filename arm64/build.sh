#!/bin/bash

as -o object/main.o main.asm
as -o object/print.o print.asm
as -o object/input.o input.asm
as -o object/exit.o exit.asm
as -o object/show_board.o show_board.asm
as -o object/fill_space.o fill_space.asm
ld -o tictactoe \
   object/main.o \
   object/print.o \
   object/input.o \
   object/exit.o \
   object/show_board.o \
   object/fill_space.o
