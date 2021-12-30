#!/bin/bash

# print commands and stop on error
set -xe

# directoru of musl install
MUSL="/usr/local/musl/bin"

# This builds an executable in release mode, statically linked with musl
# using clang and the `orc` garbage collector, and strips the symbols.
# `-march=native` makes clang optimize for the CPU its being built on
nimble build      \
	 -d:release   \
	 -d:danger    \
	 -d:strip     \
	 -d:static    \
	--silent      \
	--opt:speed   \
	--cc:clang    \
	--gc:orc      \
	--verbosity:1 \
	--clang.exe:$MUSL/musl-clang       \
	--clang.linkerexe:$MUSL/musl-clang \
	--parallelBuild:0                  \
	--passL:"-static"                  \
	--passC:"-march=native"
	

# compress the binary
upx --lzma ./compiler

# turn off logging
set +xe

# fun stats
echo "-- final binary stats --"
echo ""

# verify that its statically linked
file compiler

# used to test various linkers and C compilers
readelf -p .comment compiler

# print the final size in bytes
echo "size:" $(cat compiler | wc -c) "bytes"
