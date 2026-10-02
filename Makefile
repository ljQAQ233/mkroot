TOPDIR   := $(CURDIR)
OUTPUT   := $(TOPDIR)/output
BUILD    := $(OUTPUT)/build
STAGING  := $(OUTPUT)/staging
TARGET   := $(OUTPUT)/target

ARCH := x86_64

# GITHUB_PROXY := https://gh-proxy.com/
GITHUB_URL := $(GITHUB_PROXY)https://github.com

export TOPDIR
export OUTPUT
export BUILD
export TARGET
export STAGING
export ARCH

menuconfig:
	menuconfig $(KCONFIG)

genconfig: $(KCONFIG_CONFIG)
	genconfig $(KCONFIG) \
	  --header-path $(KCONFIG_AUTOHEADER)

include globmks/const.mk
include globmks/kconf.mk
include globmks/utils.mk

# if CONFIG_X=y, X is enabled
-include $(KCONFIG_CONFIG)

include toolchain/$(ARCH)-cc.mk
include toolchain/$(ARCH)-newlib.mk

toolchain: toolchain-cc
toolchain: toolchain-newlib
toolchain-clean: toolchain-clean-cc toolchain-clean-newlib

package: genconfig

include package/package.mk

include osimage/osimage.mk

clean: package-clean toolchain-clean
	rm -rf $(BUILD)

stpclean: package-stpclean

distclean: clean stpclean package-distclean
	rm -f $(KCONFIG_CONFIG)
	rm -rf $(OUTPUT)

