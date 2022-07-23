# - - - - - - - - - - - - - #
#    Variables to change    #
# - - - - - - - - - - - - - #

# CA65 executable locations
CA65 = ../../cc65/bin/ca65.exe

# LD65 executable locations
LD65 = ../../cc65/bin/ld65.exe

# Emulator executable location
EMULATOR = ../../emu/Mesen/Mesen.exe

# Hexdump executable location
HEXDUMP = ..\..\hexdump.exe

# Game name
GAME_NAME = MMC5_Demo

# Bin folder for binary output
BIN = bin

# Folder with assembler sources files
ASM = asm

# Change this to 0 if you don't want FamiStudio
FAMISTUDIO = 0

# Change this to 1 if you want the MMC5 mapper
MMC5 = 1


# ! - - - - - - - - - - - - - - - - ! #
#  DO NOT CHANGE ANYTHING AFTER THIS  #
# ! - - - - - - - - - - - - - - - - ! #


# make the nes game from assembler files
all:
	make clean_all
	make asm

# make the nes game from assembler files
asm: $(GAME_NAME)_a.nes
	make clean


# create the nes file from assembler sources
$(GAME_NAME)_a.nes:
# create folder if it does not exist
	@-if not exist "$(BIN)" ( mkdir "$(BIN)" )
# assemble main file
	.\$(CA65) asm/crt0.asm -o $(BIN)/$(GAME_NAME).o --debug-info -DFAMISTUDIO=$(FAMISTUDIO) -DMMC5=$(MMC5)
# link files
ifeq ($(MMC5),1)
	.\$(LD65) $(BIN)/$(GAME_NAME).o -C $(GAME_NAME)_mmc5.cfg -o $(GAME_NAME)_a.nes --dbgfile $(GAME_NAME)_a.DBG
else
	.\$(LD65) $(BIN)/$(GAME_NAME).o -C $(GAME_NAME).cfg -o $(GAME_NAME)_a.nes --dbgfile $(GAME_NAME)_a.DBG
endif


# clean object files
clean:
	@-if exist "$(BIN)" ( rmdir /Q /S "$(BIN)" )


# clean all generated files
clean_all:
	make clean
	del $(GAME_NAME)_a.nes
	del $(GAME_NAME)_a.DBG
	del dump_$(GAME_NAME)_a.txt

# run the nes game generated with assembler sources
run_a:
	$(EMULATOR) $(GAME_NAME)_a.nes
run:
	$(EMULATOR) $(GAME_NAME)_a.nes


# dump the nes files binary into hexa text
hex:
	$(HEXDUMP) $(GAME_NAME)_a.nes > dump_$(GAME_NAME)_a.txt