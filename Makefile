INSTALL_PATH?=/usr/local
BIN_DIR=$(INSTALL_PATH)/bin
SHARE_DIR=$(INSTALL_PATH)/share
KCOV_DIR=/tmp/kcov
KCOV_BIN=$(KCOV_DIR)/src/kcov
DEB_PKG=deb/figconv_4.2
DEB_PKG_DOC=$(DEB_PKG)/usr/share/doc/figconv

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

# this target actually replaces the old version (reinstall)
install: uninstall install-only

# this target does not replace the old version
install-only: $(BIN_DIR)/figconv $(SHARE_DIR)/figconv-plugins
	@git log -n1 --date=short --format='commit %h on %ad' > $(SHARE_DIR)/figconv.version
	@echo -n "Installed figconv to your install path $(INSTALL_PATH) version: "
	@cat $(SHARE_DIR)/figconv.version

clean:
	rm tests/*.pdf

deb-clean:
	rm -r deb/

deb:
	mkdir -p $(DEB_PKG)/DEBIAN
	cp deb-control $(DEB_PKG)/DEBIAN/control
	mkdir -p $(DEB_PKG)/usr/
	cp -r bin/ $(DEB_PKG)/usr/
	cp -r share/ $(DEB_PKG)/usr/
	mkdir -p $(DEB_PKG_DOC)
	cp deb-changelog $(DEB_PKG_DOC)/changelog
	gzip -n -9 $(DEB_PKG_DOC)/changelog
	cp LICENSE $(DEB_PKG_DOC)/copyright
	fakeroot dpkg-deb --build $(DEB_PKG)
	lintian $(DEB_PKG).deb

uninstall:
	@if [ -f $(SHARE_DIR)/figconv.version ]; then echo -n "Trying to uninstall version: "; cat $(SHARE_DIR)/figconv.version; rm $(SHARE_DIR)/figconv.version; fi
	@if [ -f $(BIN_DIR)/figconv ]; then rm $(BIN_DIR)/figconv; echo "figconv uninstalled"; fi
	@if [ -d $(SHARE_DIR)/figconv-plugins ]; then rm -r $(SHARE_DIR)/figconv-plugins; echo "figconv-plugins uninstalled"; fi

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
