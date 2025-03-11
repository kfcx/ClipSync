.PHONY: all install clean

PREFIX ?= /var/jb/usr
BINDIR ?= $(PREFIX)/bin

CC     := xcrun --sdk iphoneos clang
CFLAGS ?= -O2 -arch arm64 -fobjc-arc -miphoneos-version-min=10.0
LIBS   := -framework Foundation -framework UIKit
SIGN   := ldid -Sent.plist

SRC  := $(wildcard **/*.m)
BINS := $(SRC:%.m=%)

all: $(BINS)

%: %.m
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)
	$(SIGN) $@

install:
	install -d $(DESTDIR)$(BINDIR)
	install -m755 $(BINS) $(DESTDIR)$(BINDIR)

clean:
	rm -rf $(BINS)