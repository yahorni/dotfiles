SHELL=/bin/bash
IDE_DIR=$(CURDIR)/.nvim
USER=$(shell whoami)

# targets with args
# ifneq (,$(filter $(firstword $(MAKECMDGOALS)),<target1> <target2>...))
#   RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#   $(eval $(RUN_ARGS):;@:)
# endif

### INTERNAL ###
.PHONY: help edit todo vim root notes
.DEFAULT_GOAL := help

help:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null |\
		awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' |\
		sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

edit:
	@$(EDITOR) $(IDE_DIR)/Makefile

todo:
	@$(EDITOR) $(IDE_DIR)/TODO.md

vim:
	@$(EDITOR) $(IDE_DIR)/init.vim

root:
	@if [[ $${EUID} -ne 0 ]]; then\
		echo "FAIL: Run target as root" ;\
		exit 1 ;\
	fi

notes:
	# empty project

################

bu:
	@echo 'cmake -S . -B build && cmake --build build -- -j'
