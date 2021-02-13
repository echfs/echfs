CC=cc
OBJCOPY=objcopy
PREFIX=/usr/local
CFLAGS=-O3 -Wall -Wextra -pipe

.PHONY: all clean install

all: echfs-utils echfs-fuse mkfs.echfs

boot.bin: boot.asm
	nasm -fbin -o boot.bin boot.asm

boot.o: boot.bin
	$(OBJCOPY) -B i8086 -I binary -O default boot.bin boot.o

echfs-utils: echfs-utils.c part.c part.h
	$(CC) $(CFLAGS) part.c echfs-utils.c -luuid -o echfs-utils

echfs-fuse: echfs-fuse.c part.c part.h
	$(CC) $(CFLAGS) part.c echfs-fuse.c $(shell pkg-config fuse --cflags --libs) -o echfs-fuse

mkfs.echfs: boot.o mkfs.echfs.c
	$(CC) $(CFLAGS) boot.o mkfs.echfs.c -o mkfs.echfs

clean:
	rm -f echfs-utils
	rm -f echfs-fuse
	rm -f mkfs.echfs

install:
	install -d $(PREFIX)/bin
	install -s echfs-utils $(PREFIX)/bin
	install -s echfs-fuse $(PREFIX)/bin
	ln -s $(PREFIX)/bin/echfs-fuse $(PREFIX)/sbin/mount.echfs-fuse
	ln -s $(PREFIX)/bin/echfs-fuse $(PREFIX)/sbin/mount.echfs
	install -s mkfs.echfs $(PREFIX)/bin
