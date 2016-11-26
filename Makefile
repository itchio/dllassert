
# deadlines don't make for pretty Makefiles, do they?

CFLAGS:=-std=gnu99 -Wall -Os
LDFLAGS:=

DLLASSERT_CFLAGS?=-DDLLASSERT_VERSION=\"head\"

.PHONY: 32 64

all: 32 64

32: export PATH:=/mingw32/bin:$(PATH)
32:
	gcc ${CFLAGS} ${DLLASSERT_CFLAGS} src/dllassert.c -o dllassert32.exe
	strip dllassert32.exe

64: export PATH:=/mingw64/bin:$(PATH)
64:
	gcc ${CFLAGS} ${DLLASSERT_CFLAGS} src/dllassert.c -o dllassert64.exe
	strip dllassert64.exe
