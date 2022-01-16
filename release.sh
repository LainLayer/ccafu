#!/bin/bash

# print commands and stop on error
set -xe

# directory of musl install
MUSL="/usr/local/musl/bin"

# This builds an executable in release mode, statically linked with musl
# using clang and the `arc` garbage collector, and strips the symbols.
# `-march=native` makes clang optimize for the CPU its being built on.
nimble build      \
	 -d:release   \
	 -d:danger    \
	 -d:strip     \
	 -d:static    \
	--opt:speed   \
	--cc:clang    \
	--gc:arc      \
	--panics:on   \
	--verbosity:1 \
	--hint[Performance]:on             \
	--warning[GcMem]:off               \
	--clang.exe:$MUSL/musl-clang       \
	--clang.linkerexe:$MUSL/musl-clang \
	--parallelBuild:0                  \
	--passC:"-march=native"            \
	--passC:"-ffast-math"              \
	--passL:"-static"                  \
	--passL:"--for-linker=-N"
	# -N possibly makes it slower

# turn off logging
set +xe

# fun stats
echo "-- final binary stats --"
echo ""

# verify that its statically linked
file compiler
ldd compiler

# used to test various linkers and C compilers
readelf -p .comment compiler

# print the final size in bytes
echo "size:" $(cat compiler | wc -c) "bytes"
