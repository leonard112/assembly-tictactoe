ASMEXT=asm
SRC := $(wildcard *.$(ASMEXT))
OBJDIR=object
OBJ := $(patsubst %.$(ASMEXT), $(OBJDIR)/%.o, $(SRC))
EXE=tictactoe

AS=nasm
ASARGS=-f elf64
LD=ld
LDARGS=

all: pre-build $(EXE)

pre-build:
	mkdir -p $(OBJDIR)

$(EXE): $(OBJ)
	$(LD) $(LDARGS) $(OBJ) -o $(EXE)

$(OBJDIR)/%.o : %.$(ASMEXT)
	$(AS) $(ASARGS) $< -o $@

clean:
	rm -rf $(OBJDIR) $(EXE)
	