.PHONY: all clean install test ref

SHELL := /bin/bash
.SHELLFLAGS := -ec
.ONESHELL:

all: tdm_ghost.pk4

src/script/tdm_main.script: ~/darkmod/tdm_base01.pk4
	unzip -p $^ script/tdm_main.script >$@
	TDM_VERSION=$$(unzip -p $^ tdm_version.txt | grep "version=" | cut -d "=" -f2)
	# Add custom addon scripts hooks
	sed "/tdm_custom_scripts/a \\\n// kcghost: Add custom addon hook to $$TDM_VERSION tdm_main.script\n#include \"script/tdm_custom_addon_scripts.script\"" $@ -i
	sed "/Do any script setup here/a \\\tcustom_addon_script_init_hook();" $@ -i

tdm_ghost.pk4: src/README.txt src/script/tdm_ghost.script src/script/tdm_custom_addon_scripts.script src/script/tdm_main.script
	rm -f $@
	cd src
	zip -0 -r ../$(notdir $@) *

clean:
	rm -f src/script/tdm_main.script
	rm -f tdm_ghost.pk4

install: tdm_ghost.pk4
	cp tdm_ghost.pk4 ~/darkmod/

test: install
	~/darkmod/thedarkmod.x64

ref:
	rm -rf ref/
	mkdir -p ref
	find ~/darkmod/ -name "*.pk4" -exec unzip {} -d ref/ \;
