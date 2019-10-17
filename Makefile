# Name: Makefile
# Author: Andres Lopez
# Copyright: NA
# License: NA

# This is a prototype Makefile. Modify it according to your needs.
# You should at least check the settings for
# DEVICE ....... The AVR device you compile for
# CLOCK ........ Target AVR clock rate in Hertz
# OBJECTS ...... The object files created from your source files. This list is
#                usually the same as the list of source files with suffix ".o".
# PROGRAMMER ... Options to avrdude which define the hardware you use for
#                uploading to the AVR and the interface where this hardware
#                is connected. We recommend that you leave it undefined and
#                add settings like this to your ~/.avrduderc file:
#                   default_programmer = "stk500v2"
#                   default_serial = "avrdoper"
# FUSES ........ Parameters for avrdude to flash the fuses appropriately.

DEVICE 		= attiny85
CLOCK 		= 8000000
PROGRAMMER 	= -c usbasp -p t85
SRC_DIR 	= ./src
BUILD_DIR 	= ./build
OBJECTS 	= $(BUILD_DIR)/main.o
FUSES 		= -U lfuse:w:0x62:m -U hfuse:w:0xdf:m -U efuse:w:0xff:m

# DEFAULT FUSE as listed http://www.engbedded.com/fusecalc


# Tune the lines below only if you know what you are doing:

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE)
COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

# symbolic targets:
all:	main.hex

$(BUILD_DIR)/main.o:
	$(COMPILE) -c $(SRC_DIR)/main.c -o $@

flash:	all
	$(AVRDUDE) -U flash:w:$(BUILD_DIR)/main.hex:i

fuse:
	$(AVRDUDE) $(FUSES)

# if you use a bootloader, change the command below appropriately:
load: all
	bootloadHID $(BUILD_DIR)/main.hex

clean:
	rm -f $(BUILD_DIR)/main.hex $(BUILD_DIR)/main.elf $(OBJECTS)

# file targets:
main.elf: $(OBJECTS)
	$(COMPILE) -o $(BUILD_DIR)/main.elf $(OBJECTS)

main.hex: main.elf
	rm -f $(BUILD_DIR)/main.hex
	avr-objcopy -j .text -j .data -O ihex $(BUILD_DIR)/main.elf $(BUILD_DIR)/main.hex
	avr-size --format=avr --mcu=$(DEVICE) $(BUILD_DIR)/main.elf
# If you have an EEPROM section, you must also create a hex file for the
# EEPROM and add it to the "flash" target.

# Targets for code debugging and analysis:
disasm:	main.elf
	avr-objdump -d $(BUILD_DIR)/main.elf