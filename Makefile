CC=cc
OBJCOPY=objcopy
PREFIX=/usr/local
CFLAGS=-O3 -Wall -Wextra -pipe

.PHONY: all utils fuse clean install

all: utils fuse

utils: echfs-utils mkfs.echfs

fuse: echfs-fuse

boot.bin: boot.asm
	nasm -fbin -o boot.bin boot.asm
	@test $$(stat -c%s boot.bin) -eq 512 || \
		(echo Error: boot.asm must assemble to exactly 512 bytes. && rm boot.bin && exit 1)

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
	rm -f boot.bin boot.o

install-utils: utils
	install -d $(PREFIX)/bin
	install -s mkfs.echfs $(PREFIX)/bin
	install -s echfs-utils $(PREFIX)/bin

install-fuse: fuse
	install -d $(PREFIX)/bin
	install -s echfs-fuse $(PREFIX)/bin
	ln -sf $(PREFIX)/bin/echfs-fuse $(PREFIX)/sbin/mount.echfs-fuse
	ln -sf $(PREFIX)/bin/echfs-fuse $(PREFIX)/sbin/mount.echfs

install: install-utils install-fuse
