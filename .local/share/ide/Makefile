SHELL=/bin/bash
USER=$(shell whoami)
ARCH=$(shell uname -m)

IDE_DIR:=${IDE_DIR}
ifeq ($(IDE_DIR), )
	IDE_DIR=.ide
endif
IDE_DIR_PATH=$(CURDIR)/$(IDE_DIR)
IDE_MAKE=make -f $(IDE_DIR)/Makefile

EDITOR:=${EDITOR}
ifeq ($(EDITOR), )
	ifneq (,$(shell command -v nvim))
		EDITOR:=nvim
	else ifneq (,$(shell command -v vim))
		EDITOR:=vim
	endif
endif

# targets with args
# ifneq (,$(filter $(firstword $(MAKECMDGOALS)),<target1> <target2>...))
#   RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#   $(eval $(RUN_ARGS):;@:)
# endif

# backup setup
BACKUP_DIR=$(HOME)/dox/uebernotes
IDE_FILES=$(IDE_DIR)/{Makefile,TODO.md,options.vim,plugins.vim,.vimspector.json}

# git state
GIT_COMMIT_LONG=$(shell git rev-parse HEAD)
GIT_COMMIT_SHORT=$(shell git rev-parse --short HEAD)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

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
	zip -r backup.zip $(IDE_FILES)
	mkdir -p $(BACKUP_DIR)
	cp $(IDE_FILES) backup.zip $(BACKUP_DIR)
	rm backup.zip

notes:
	# to print some notes for project

update:
	# to update some ide files for project

################

.PHONY: build

build:
	@echo 'cmake -S . -B build && cmake --build build -- -j'
