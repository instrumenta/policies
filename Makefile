SUBDIRS := $(wildcard */.)

default: test

test: $(SUBDIRS)
$(SUBDIRS):
	@conftest verify -p $@

test-%:
	@conftest verify -p $$(echo $@ | cut -d "-" -f 2-)


.PHONY: default test test-% $(SUBDIRS)

