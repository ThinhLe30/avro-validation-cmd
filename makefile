# Variables
YQ_BIN = /usr/local/bin/yq
AVROSV_BIN = $(GOPATH)/bin/avrosv
SCRIPT_PATH = ./avrovl.sh
INSTALL_PATH = /usr/local/bin/avrovl
YQ_URL = https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
GOINSTALL_CMD = go install github.com/hamba/avro/v2/cmd/avrosv@latest

.PHONY: all check_yq check_avrosv install_yq install_avrosv install_cmd clean

# Default target: install yq, avrosv, and the shell script
all: check_yq check_avrosv install_cmd

# Check if yq is installed
check_yq:
	@if ! command -v yq &> /dev/null; then \
		echo "yq not found. Installing yq..."; \
		$(MAKE) install_yq; \
	else \
		echo "yq is already installed."; \
	fi

# Check if avrosv is installed
check_avrosv:
	@if ! command -v avrosv &> /dev/null; then \
		echo "avrosv not found. Installing avrosv..."; \
		$(MAKE) install_avrosv; \
	else \
		echo "avrosv is already installed."; \
	fi

# Install yq to /usr/local/bin/yq
install_yq:
	@echo "Downloading yq..."
	@sudo wget -q $(YQ_URL) -O $(YQ_BIN)
	@sudo chmod +x $(YQ_BIN)
	@echo "yq installed successfully at $(YQ_BIN)."

# Install avrosv using go install
install_avrosv:
	@echo "Installing avrosv..."
	@$(GOINSTALL_CMD)
	@echo "avrosv installed successfully at $(AVROSV_BIN)."

# Install the shell script to /usr/local/bin/
install_cmd:
	@if [ -f $(SCRIPT_PATH) ]; then \
		echo "Installing avrovl.sh to /usr/local/bin/avrovl..."; \
		sudo cp $(SCRIPT_PATH) $(INSTALL_PATH); \
		sudo chmod +x $(INSTALL_PATH); \
		echo "Shell script installed successfully at $(INSTALL_PATH)."; \
	else \
		echo "Shell script $(SCRIPT_PATH) not found!"; \
		exit 1; \
	fi

# Clean up by removing installed test_avro script
clean:
	@echo "Cleaning up..."
	@sudo rm -f $(INSTALL_PATH)
	@echo "Removed $(INSTALL_PATH)."
