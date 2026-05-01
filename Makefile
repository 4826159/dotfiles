.PHONY: all install

all: install

install:
	stow --target="$(HOME)" .
