SHELL=/bin/bash
USER=$(shell whoami)
IDE_DIR:=$(CURDIR)/${IDE_DIR}
BACKUP_DIR=$(HOME)/backup

IDE_DIR:=${IDE_DIR}
ifeq ($(IDE_DIR), )
	IDE_DIR:=.ide
endif
IDE_DIR_PATH:=$(CURDIR)/$(IDE_DIR)

EDITOR:=${EDITOR}
ifeq ($(EDITOR), )
	EDITOR:=vim
endif

# targets with args
# ifneq (,$(filter $(firstword $(MAKECMDGOALS)),<target1> <target2>...))
#   RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#   $(eval $(RUN_ARGS):;@:)
# endif

### INTERNAL ###
.PHONY: help edit todo vim plug debug root noroot backup notes
default: help

help:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null |\
		awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' |\
		sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

edit:
	@$(EDITOR) $(IDE_DIR)/Makefile

todo:
	@$(EDITOR) $(IDE_DIR)/TODO.md

vim:
	@$(EDITOR) $(IDE_DIR)/options.vim

plug:
	@$(EDITOR) $(IDE_DIR)/plugins.vim

debug:
	@if [ -f "$(IDE_DIR)/.vimspector.json" ]; then\
		$(EDITOR) $(IDE_DIR)/.vimspector.json ;\
	else\
		echo "FAIL: No debug configuration" ;\
	fi

root:
	@if [[ $${EUID} -ne 0 ]]; then\
		echo "FAIL: Run target as root" ;\
		exit 1 ;\
	fi

noroot:
	@if [[ $${EUID} -eq 0 ]]; then\
		echo "FAIL: Do not run the target as root" ;\
		exit 1 ;\
	fi

backup:
	zip -r backup.zip $(IDE_DIR)/{Makefile,TODO.md,*.vim,*.sh}
	mkdir -p $(BACKUP_DIR)
	cp $(IDE_DIR)/{Makefile,TODO.md,*.vim,*.sh} backup.zip $(BACKUP_DIR)
	rm backup.zip

notes:
	# empty

################

.PHONY: build

build:
	@echo 'cmake -S . -B build && cmake --build build -- -j'
