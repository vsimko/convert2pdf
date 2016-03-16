INSTALL_PATH?=/usr/local
BIN_DIR=$(INSTALL_PATH)/bin
SHARE_DIR=$(INSTALL_PATH)/share

install: $(BIN_DIR)/figconv $(SHARE_DIR)/figconv-plugins

uninstall:
	rm $(BIN_DIR)/figconv
	rm -r $(SHARE_DIR)/figconv-plugins

test:
	tests/run-tests.sh

$(SHARE_DIR):
	mkdir -p $(SHARE_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/figconv: $(BIN_DIR)
	cp -r bin/figconv $(BIN_DIR)/figconv

$(SHARE_DIR)/figconv-plugins: $(SHARE_DIR)
	cp -r share/figconv-plugins $(SHARE_DIR)/figconv-plugins

