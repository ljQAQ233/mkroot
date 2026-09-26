include $(KCONFIG_CONFIG)
version = 6.6
url = https://mirrors.aliyun.com/gnu/ncurses/ncurses-${version}.tar.gz
sha256 = 355b4cbbed880b0381a04c46617b7656e362585d52e9cf84a67e2009b749ff11

BUILD  := $(BUILD)/ncurses
SRCDIR := $(CURDIR)/.source/${version}/ncurses-$(version)

ifeq (${CONFIG_NCURSES_DEBUG},y)
  extra_flags += --with-debug
  extra_env = CFLAGS=-O0
else
  extra_flags += --without-debug
endif

all: .prepare .configure .build

.build:
	@mkdir -p $(BUILD)
	cd $(BUILD) && make -j$$(nproc)
	cd $(BUILD) && make install

.configure: flag_debug=$(if $($(CONFIG_NCURSES_DEBUG)),"--with-debug")
.configure:
	@mkdir -p $(BUILD)
	cd $(BUILD) && unset TERMINFO && \
	  CC=$(PKG_CC) $(extra_env) $(SRCDIR)/configure --prefix=$(TARGET) --host=x86_64-linux \
	  --without-ada --without-cxx-binding --without-manpages --without-tests $(extra_flags) \
	  --with-terminfo-dirs=/etc/terminfo:/usr/shared/terminfo --with-default-terminfo-dir=/etc/terminfo
	touch $@

.prepare:
	$(TOPDIR)/scripts/prepare.sh $(version) $(url) $(sha256)
	touch $@

include ../../globmks/clean.mk
