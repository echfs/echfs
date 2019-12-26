CC=cc
PREFIX=/usr/local
CFLAGS=-O3 -Wall -Wextra -pipe

.PHONY: all clean install

all: echfs-utils

echfs-utils:
	$(CC) $(CFLAGS) echfs-utils.c -o echfs-utils

echfs-fuse:
	$(CC) $(CFLAGS) echfs-fuse.c $(shell pkg-config fuse --cflags --libs) -o echfs-fuse

clean:
	rm -f echfs-utils
	rm -f echfs-fuse

install:
	install -d $(PREFIX)/bin
	install -s echfs-utils $(PREFIX)/bin

install-fuse:
	install -d $(PREFIX)/bin
	install -s echfs-fuse $(PREFIX)/bin
