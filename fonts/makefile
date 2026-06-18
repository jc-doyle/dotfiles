ROOT_DIR    := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
IOSEVKA_DIR := $(ROOT_DIR)/Iosevka
PATCHED_DIR := $(IOSEVKA_DIR)/iosevka-custom
BUILD_PLAN  := build.toml
FONT_DIR    := ~/.local/share/fonts

build:
	if [ ! -d $(IOSEVKA_DIR) ]; then git clone --depth 1 https://github.com/be5invis/Iosevka.git; fi
	cp -f $(BUILD_PLAN) $(IOSEVKA_DIR)/private-build-plans.toml
	cd $(IOSEVKA_DIR); \
	npm install; \
	npm run build -- contents::iosevka-custom

patch:
	sudo rm -rf $(PATCHED_DIR)
	sudo docker run --rm -v $(IOSEVKA_DIR)/dist/iosevka-custom/TTF:/in:Z -v $(PATCHED_DIR):/out:Z -e "PN=5" nerdfonts/patcher -s --mdi --makegroups -1

install:
	mkdir -p $(FONT_DIR)
	cp -rf $(PATCHED_DIR) $(FONT_DIR)
	fc-cache
