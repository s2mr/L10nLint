SWIFT_BUILD_FLAGS := -c release --disable-sandbox --arch arm64 --arch x86_64
TOOL_NAME := l10n-lint

TOOL_BIN_DIR := $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)
TOOL_BIN := $(TOOL_BIN_DIR)/$(TOOL_NAME)

.PHONY: $(MAKECMDGOALS)

build-cp-zsh: build
	sudo rm -f /usr/local/bin/l10n-lint
	sudo cp $(TOOL_BIN) /usr/local/bin/l10n-lint
	make install-completion-zsh

install-completion-zsh:
	mkdir -p ~/.zsh/competion
	l10n-lint --generate-completion-script zsh > ~/.zsh/completion/_l10n-lint

build:
	swift build $(SWIFT_BUILD_FLAGS)
	@echo $(TOOL_BIN)

zip: build
	rm -f $(TOOL_NAME).zip
	zip -j $(TOOL_NAME).zip $(TOOL_BIN)

upload-zip: zip
	@[ -n "$(TAG)" ] || (echo "\nERROR: Make sure setting environment variable 'TAG'." && exit 1)
	gh release upload $(TAG) $(TOOL_NAME).zip

delete-zip:
	@[ -n "$(TAG)" ] || (echo "\nERROR: Make sure setting environment variable 'TAG'." && exit 1)
	gh release delete-asset $(TAG) $(TOOL_NAME).zip

sha256-zip:
	shasum -a 256 $(TOOL_NAME).zip