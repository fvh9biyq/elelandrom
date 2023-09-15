TARGET ?= elelandrom

Z80=zma
CXX=g++
CXXFLAGS=-Wall -O3 -std=c++17

INCLUDES=
LDFLAGS ?=
STRIP=strip

SRC_DIRS ?= src
BUILD_DIR ?= build

TOOL_DIR ?= tool

INC_FILES := $(shell find $(SRC_DIRS) -name *.inc)
MAP_FILES := $(shell find $(SRC_DIRS) -name *.map)
MAPTBL_FILES := $(MAP_FILES:%.map=$(BUILD_DIR)/%.map.tbl)
MAPDATA_FILES := $(MAP_FILES:%.map=$(BUILD_DIR)/%.map.data)

DEPS_SRCS := $(shell find $(SRC_DIRS) -name '*.asm' -or -name '*.map' -or -name '*.inc')
DEPS := $(DEPS_SRCS:%=$(BUILD_DIR)/%.d)

.PHONY: clean all mapzip msxcolor tool

all: rom bin dsk tool $(MAPTBL_FILES) $(MAPDATA_FILES)

rom: $(BUILD_DIR)/$(TARGET).rom
$(BUILD_DIR)/%.rom: $(SRC_DIRS)/%.asm $(BUILD_DIR)/mapzip $(MAPTBL_FILES) $(MAPDATA_FILES) $(INC_FILES)
	$(MKDIR_P) $(dir $@)
	$(Z80) $< $@
	grep '^_' zma.sym

bin: $(BUILD_DIR)/eleland.bin
$(BUILD_DIR)/eleland.bin: $(SRC_DIRS)/bload.asm $(BUILD_DIR)/mapzip $(MAPTBL_FILES) $(MAPDATA_FILES) $(INC_FILES)
	$(MKDIR_P) $(dir $@)
	$(Z80) $< $@
	grep '^_' zma.sym

dsk: $(BUILD_DIR)/eleland.dsk
$(BUILD_DIR)/eleland.dsk: $(SRC_DIRS)/diskboot.asm $(SRC_DIRS)/diskmain.asm $(BUILD_DIR)/mapzip $(MAPTBL_FILES) $(MAPDATA_FILES) $(INC_FILES)
	$(MKDIR_P) $(dir $@)
	$(Z80) $(SRC_DIRS)/diskboot.asm $(BUILD_DIR)/diskboot.bin
	$(Z80) $(SRC_DIRS)/diskmain.asm $(BUILD_DIR)/diskmain.bin
	cat $(BUILD_DIR)/diskboot.bin $(BUILD_DIR)/diskmain.bin > $(BUILD_DIR)/eleland.dsk
	truncate -s 737280 $(BUILD_DIR)/eleland.dsk
	grep '^_' zma.sym


# map to map.tbl
$(BUILD_DIR)/%.map.tbl: %.map $(BUILD_DIR)/mapzip
	$(MKDIR_P) $(dir $@)
	$(BUILD_DIR)/mapzip $< $(BUILD_DIR)/$<.tbl $(BUILD_DIR)/$<.data run-length2

# map to map.data
$(BUILD_DIR)/%.map.data: %.map $(BUILD_DIR)/mapzip
	$(MKDIR_P) $(dir $@)
	$(BUILD_DIR)/mapzip $< $(BUILD_DIR)/$<.tbl $(BUILD_DIR)/$<.data run-length2

mapzip: $(BUILD_DIR)/mapzip
$(BUILD_DIR)/mapzip: tool/mapzip.cpp
	$(MKDIR_P) $(BUILD_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(TOOL_DIR)/mapzip.cpp -o $(BUILD_DIR)/mapzip

msxcolor: $(BUILD_DIR)/msxcolor
$(BUILD_DIR)/msxcolor: tool/msxcolor.cpp
	$(MKDIR_P) $(BUILD_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(TOOL_DIR)/msxcolor.cpp -o $(BUILD_DIR)/msxcolor

tool: mapzip msxcolor

# clean project
#
clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) zma.log zma.sym

-include $(DEPS)

MKDIR_P ?= mkdir -p
