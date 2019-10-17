ifneq ($(PREFIX),)
DUNE_PREFIX=--prefix=$(PREFIX)
endif

all: lib

lib:
	dune build @install

install: lib
	dune install $(DUNE_PREFIX)

clean:
	rm -rf _build

mrproper: clean
	# Nothing to remove.

.PHONY: lib install clean mrproper
