SHELL = /bin/bash

prefix ?= /usr/local
bindir ?= $(prefix)/bin
srcdir = src

.DEFAULT_GOAL = commoditize

.PHONY: commoditize
commoditize: $(srcdir)/commoditize.bash
	@cp $< $@
	@chmod +x $@

.PHONY: check
check: commoditize
	@bash -n $<

.PHONY: install
install: commoditize
	@install -d "$(bindir)"
	@install commoditize "$(bindir)"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/commoditize"

.PHONY: clean
clean:
	@rm -f commoditize
