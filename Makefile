PACKAGE=collections
LIB=collections

# Include configuration variables.
include Makefile.config

INCLUDES=-I src -I +threads

DFLAGS=$(INCLUDES)
CFLAGS=$(INCLUDES)
XFLAGS=$(INCLUDES)
LFLAGS=
OFLAGS=$(INCLUDES)

ML=$(shell $(OCAMLDEP) $(DFLAGS) -sort $(wildcard src/*.ml))
MLI=$(shell $(OCAMLDEP) $(DFLAGS) -sort $(wildcard src/*.mli))
CMO=$(ML:.ml=.cmo)
CMI=$(MLI:.mli=.cmi)
DEP=.dep

TARGETS=$(LIB).cmi $(LIB).cma $(LIB).cmxa $(LIB).cmxs

# Includes the dependencies to build in the right order
-include $(DEP)

ifdef DEBUG
	CFLAGS += -g
	LFLAGS += -g
endif

all: byte native

byte: $(LIB).cmi $(LIB).cma

native: $(LIB).cmi $(LIB).cmxa $(LIB).cmxs

dep: $(DEP)

$(DEP): $(ML) $(MLI)
	$(OCAMLDEP) $(DFLAGS) $^ > $@

$(CMI):%.cmi:%.mli
	$(OCAMLC) $(CFLAGS) -c -o $@ $<

$(CMO):%.cmo:%.ml %.cmi
	$(OCAMLC) $(CFLAGS) -c -o $@ $<

$(CMX):%.cmx:%.ml %.cmi
	$(OCAMLOPT) $(XFLAGS) -c -o $@ $<

$(LIB).cmo $(LIB).cmi: %: $(CMO)
	$(OCAMLC) -pack -o $@ $^

$(LIB).cmx: %: $(CMX)
	$(OCAMLOPT) -pack -o $@ $^

$(LIB).cma: $(LIB).cmo
	$(OCAMLC) $(LFLAGS) -a -o $@ $<

$(LIB).cmxa: $(LIB).cmx
	$(OCAMLOPT) $(LFLAGS) -a -o $@ $<

$(LIB).cmxs: $(LIB).cmx
	$(OCAMLOPT) $(LFLAGS) -shared -o $@ $<

doc: $(ML) $(MLI)
	@mkdir -p doc/html
	ocamldoc -html -d doc/html $(OFLAGS) $^

install: $(TARGET) $(LIB).cmi
	@echo "installing to $(PREFIX)/lib/$(PACKAGE)/"
	@mkdir -p $(PREFIX)/lib/$(PACKAGE)
	@cat META | sed "s/%LIBRARY%/$(LIB)/g" | sed "s/%VERSION%/$(shell cat VERSION)/g" > $(PREFIX)/lib/$(PACKAGE)/META
	@cp $(PACKAGE).opam $(PREFIX)/lib/$(PACKAGE)/
	@cp $(TARGETS) $(PREFIX)/lib/$(PACKAGE)/
	@echo "done."

# Clean the repo.
clean:
	rm -rf $(CMO) $(CMI) $(LIB).a $(LIB).o $(LIB).cmo $(LIB).cmx $(DEP)

# Clean and remove binairies.
mrproper: clean
	rm -rf $(TARGETS)

# Non-file targets.
.PHONY: all dep doc clean mrproper
