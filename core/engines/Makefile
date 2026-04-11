CC = gcc
CXX = g++
CFLAGS = -Wall -Wextra -O2 -std=c99
CXXFLAGS = -Wall -Wextra -O2 -std=c++17
LDFLAGS = -lm

SRC_DIR = src
BIN_DIR = bin
BUILD_DIR = build

# C sources
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
C_OBJECTS = $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SOURCES))
C_TARGETS = $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(C_SOURCES))

# C++ sources
CXX_SOURCES = $(wildcard $(SRC_DIR)/*.cpp)
CXX_OBJECTS = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(CXX_SOURCES))
CXX_TARGETS = $(patsubst $(SRC_DIR)/%.cpp,$(BIN_DIR)/%,$(CXX_SOURCES))

ALL_TARGETS = $(C_TARGETS) $(CXX_TARGETS)

.PHONY: all clean directories

all: directories $(ALL_TARGETS)

directories:
	@mkdir -p $(BIN_DIR) $(BUILD_DIR)

$(BIN_DIR)/%: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(BIN_DIR)/%: $(SRC_DIR)/%.cpp
	@mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS)

clean:
	@rm -rf $(BUILD_DIR) $(BIN_DIR)
	@echo "✓ Build artifacts cleaned"

install: all
	@mkdir -p /usr/local/bin
	@cp $(BIN_DIR)/* /usr/local/bin/
	@echo "✓ Binaries installed to /usr/local/bin"

uninstall:
	@for binary in $(notdir $(ALL_TARGETS)); do \
		rm -f /usr/local/bin/$$binary; \
	done
	@echo "✓ Binaries uninstalled"

.PHONY: install uninstall
