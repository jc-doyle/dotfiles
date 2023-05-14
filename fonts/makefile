ROOT_DIR    := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
IOSEVKA_DIR := $(ROOT_DIR)/Iosevka
PATCHED_DIR := $(ROOT_DIR)/iosevka-nerd
BUILD_PLANS := private-build-plans.toml
FONT_DIR    := ~/.local/share/fonts
PATCH_URL   := https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip
PATCH_ZIP   := patcher.zip

build:
	if [ ! -d $(IOSEVKA_DIR) ]; then git clone --depth 1 https://github.com/be5invis/Iosevka.git; fi
	cp -f $(BUILD_PLANS) $(IOSEVKA_DIR)/$(BUILD_PLANS)
	cd $(IOSEVKA_DIR); \
	npm install; \
	npm run build -- contents::iosevka-custom

patch:
	curl -L $(PATCH_URL) > $(PATCH_ZIP)
	unzip $(PATCH_ZIP) -d patcher
	rm $(PATCH_ZIP)
	./patcher/font-patcher $(IOSEVKA_DIR)/dist/iosevka-custom/ttf/iosevka-custom-regular.ttf -s -c -out $(PATCHED_DIR) --makegroups 6
	rm -rf ./patcher

install:
	mkdir -p $(FONT_DIR)
	cp -rf $(IOSEVKA_DIR)/dist/* $(FONT_DIR)
	cp -rf $(PATCHED_DIR) $(FONT_DIR)
	rm -rf $(PATCHED_DIR)
	fc-cache
