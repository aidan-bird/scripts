#!/bin/sh

# Aidan Bird 2021
# 
# compile and setup a debugging environment for a c source file
# subsequent invocations of make will be aware of any updates to the source file
# TODO unfinished script

exit 1

rm -rf /run/user/$(id -u)/$(basename $0)*
envroot=$(mktemp -dt "$(basename $0).XXXXXXXX" --tmpdir=/run/user/$(id -u))
binname='prog.out'
lastwd=$(pwd)
if [ -d "$1" ]
then
    realpath $1 | xargs -I{} ln -s {} $envroot/src
echo "CC = gcc
CC_FLAGS = -O0 -ggdb -lm
OBJS = $envroot/src/*
OBJ_NAME = $binname
all :
	\$(CC) \$(OBJS) \$(CC_FLAGS) -o \$(OBJ_NAME)" >> $envroot/makefile
else
    realpath $1 | xargs -I{} ln -s {} $envroot/main.c
echo "CC = gcc
CC_FLAGS = -O0 -ggdb -lm
OBJS = $envroot/main.c
OBJ_NAME = $binname
all :
	\$(CC) \$(OBJS) \$(CC_FLAGS) -o \$(OBJ_NAME)" >> $envroot/makefile
fi
#make $envroot/makefile
make -C $envroot -s
cd $envroot
SHELL=/bin/sh gdb -q $binname
cd $lastwd
exit 0

