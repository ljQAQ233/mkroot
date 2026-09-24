TOPDIR   := $(CURDIR)
OUTPUT   := $(TOPDIR)/output
BUILD    := $(OUTPUT)/build
TARGET   := $(OUTPUT)/target
AUTOCONF := $(OUTPUT)/autoconf.h

ARCH := x86_64

include globmks/const.mk

include toolchain/$(ARCH)-cc.mk
include toolchain/$(ARCH)-newlib.mk

toolchain: toolchain-cc
toolchain: toolchain-newlib

