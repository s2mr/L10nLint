SWIFT_BUILD_FLAGS := -c release --disable-sandbox --arch arm64 --arch x86_64
TOOL_NAME := l10nlint

TOOL_BIN_DIR := $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)
TOOL_BIN := $(TOOL_BIN_DIR)/$(TOOL_NAME)

.PHONY: $(MAKECMDGOALS)

build-cp-zsh: build
	sudo rm -f /usr/local/bin/$(TOOL_NAME)
	sudo cp $(TOOL_BIN) /usr/local/bin/$(TOOL_NAME)
	make install-completion-zsh

install-completion-zsh:
	mkdir -p ~/.zsh/competion
	$(TOOL_NAME) --generate-completion-script zsh > ~/.zsh/completion/_$(TOOL_NAME)

build:
	swift build $(SWIFT_BUILD_FLAGS)
	@echo $(TOOL_BIN)

zip: build
	rm -f $(TOOL_NAME).zip
	zip -j $(TOOL_NAME).zip $(TOOL_BIN)

change-version:
	@[ -n "$(TAG)" ] || (echo "\nERROR: Make sure setting environment variable 'TAG'." && exit 1)
	./Scripts/change-version.sh $(TAG)
	git add Sources/l10nlint/Generated/Version.swift
	git commit -m "Bump version to $(TAG)"
	git tag $(TAG)
	git push $(TAG)

release: change-version zip
	@[ -n "$(TAG)" ] || (echo "\nERROR: Make sure setting environment variable 'TAG'." && exit 1)
	gh release create "$(TAG)" --generate-notes
	gh release upload $(TAG) $(TOOL_NAME).zip

upload-zip: zip
	@[ -n "$(TAG)" ] || (echo "\nERROR: Make sure setting environment variable 'TAG'." && exit 1)
	gh release upload $(TAG) $(TOOL_NAME).zip

delete-zip:
	@[ -n "$(TAG)" ] || (echo "\nERROR: Make sure setting environment variable 'TAG'." && exit 1)
	gh release delete-asset $(TAG) $(TOOL_NAME).zip

sha256-zip:
	shasum -a 256 $(TOOL_NAME).zip