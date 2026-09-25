TOPDIR   := $(CURDIR)
OUTPUT   := $(TOPDIR)/output
BUILD    := $(OUTPUT)/build
TARGET   := $(OUTPUT)/target

ARCH := x86_64

export TOPDIR
export OUTPUT
export BUILD
export TARGET
export ARCH

menuconfig:
	menuconfig $(KCONFIG)

genconfig: $(KCONFIG_CONFIG)
	genconfig $(KCONFIG) \
	  --header-path $(KCONFIG_AUTOHEADER)

include globmks/const.mk
include globmks/kconf.mk
include globmks/utils.mk

include toolchain/$(ARCH)-cc.mk
include toolchain/$(ARCH)-newlib.mk

package: genconfig

include package/package.mk

toolchain: toolchain-cc
toolchain: toolchain-newlib
toolchain-clean: toolchain-clean-cc toolchain-clean-newlib

clean: package-clean toolchain-clean
	rm -rf $(BUILD)

stpclean: package-stpclean

distclean: clean stpclean package-distclean
	rm -f $(KCONFIG_CONFIG)
	rm -rf $(OUTPUT)

