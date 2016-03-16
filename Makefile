INSTALL_PATH?=/usr/local
BIN_DIR=$(INSTALL_PATH)/bin
SHARE_DIR=$(INSTALL_PATH)/share
KCOV_DIR=/tmp/kcov
KCOV_BIN=$(KCOV_DIR)/src/kcov

info:
	@echo ======================================
	@echo This is a Makefile for figconv tool.
	@echo You can use the following:
	@echo ======================================
	@echo - make test
	@echo - sudo make install
	@echo - sudo make uninstall
	@echo - INSTALL_PATH=mybuild make install
	@echo - INSTALL_PATH=mybuild make uninstall
	@echo ======================================

test:
	tests/run-tests.sh

install: $(BIN_DIR)/figconv $(SHARE_DIR)/figconv-plugins

uninstall:
	rm $(BIN_DIR)/figconv
	rm -r $(SHARE_DIR)/figconv-plugins

$(SHARE_DIR):
	mkdir -p $(SHARE_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/figconv: $(BIN_DIR)
	cp -r bin/figconv $(BIN_DIR)/figconv

$(SHARE_DIR)/figconv-plugins: $(SHARE_DIR)
	cp -r share/figconv-plugins $(SHARE_DIR)/figconv-plugins

# TODO: coverage reports using kcov not working at the moment
test-kcov: $(KCOV_BIN)
	$(KCOV_BIN) kcov-output/ tests/run-tests.sh

$(KCOV_BIN): $(KCOV_DIR)
	cd $(KCOV_DIR);cmake ./;make

$(KCOV_DIR):
	git clone --depth=1 https://github.com/SimonKagstrom/kcov $(KCOV_DIR)
