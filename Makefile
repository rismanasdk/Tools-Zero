.PHONY: all build clean install uninstall dev help

CORE_DIR = core/engines

help:
	@echo "Tools-Zero Build System"
	@echo "======================"
	@echo "Targets:"
	@echo "  make build       - Compile all C/C++ tools"
	@echo "  make install     - Install compiled binaries"
	@echo "  make uninstall   - Uninstall binaries"
	@echo "  make clean       - Clean build artifacts"
	@echo "  make dev         - Run development environment"

all: build

build:
	@echo "Building C/C++ tools..."
	@$(MAKE) -C $(CORE_DIR)
	@echo "✓ Build complete"

install: build
	@$(MAKE) -C $(CORE_DIR) install

uninstall:
	@$(MAKE) -C $(CORE_DIR) uninstall

clean:
	@$(MAKE) -C $(CORE_DIR) clean
	@echo "✓ Project cleaned"

dev:
	@python3 main.py
