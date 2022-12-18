CURRENT_ARCH := $(shell lscpu | grep Architecture: | awk '{print $$NF}' | tr -d '\n')
TARGET_ARCH=armhf
CROSS_BUILDER=arm-linux-gnueabihf

ASMEXT=s
SRC := $(wildcard *.$(ASMEXT))
OBJDIR=object
OBJ := $(patsubst %.$(ASMEXT), $(OBJDIR)/%.o, $(SRC))
EXE=tictactoe

AS=as
ASARGS=-g
LD=ld
LDARGS=

ifneq ($(CURRENT_ARCH), $(TARGET_ARCH))
	AS=$(CROSS_BUILDER)-as
	LD=$(CROSS_BUILDER)-ld
endif

all: pre-build $(EXE)

pre-build:
	mkdir -p $(OBJDIR)

$(EXE): $(OBJ)
	$(LD) $(LDARGS) $(OBJ) -o $(EXE)

$(OBJDIR)/%.o : %.$(ASMEXT)
	$(AS) $(ASARGS) -o $@ $<

clean:
	rm -rf $(OBJDIR) $(EXE)
