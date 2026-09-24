toolchain-newlib: INST_DIR:=$(TOOLCHAIN_DIR)/$(CROSS_TRIPLET)
toolchain-newlib: toolchain-cc
	@[[ -f toolchain/newlib/configure ]] || ( echo "missing newlib source code, clone github:ljQAQ233/newlib first" ; exit 1 )
	@mkdir -p $(BUILD)/toolchain/newlib
	cd $(BUILD)/toolchain/newlib && \
	  [[ -f Makefile ]] || \
	  $(TOPDIR)/toolchain/newlib/configure \
	  --target=$(CROSS_TRIPLET) \
	  --prefix=$(TOOLCHAIN_DIR)
	cd $(BUILD)/toolchain/newlib && make
	cd $(BUILD)/toolchain/newlib && make install
	cd toolchain/newlib && $(SHELL) \
	  newlib/libc/sys/textos/specs.sh \
	  $(INST_DIR)/include \
	  $(INST_DIR)/lib \
	  /dev/null \
	  > $(TOOLCHAIN_DIR)/cc.specs
	cd toolchain/newlib && $(SHELL) \
	  newlib/libc/sys/textos/stdarg.sh \
	  $(CROSS_COMPILE)cc \
	  > $(INST_DIR)/include/stdarg.h
	cd toolchain/newlib && $(SHELL) \
	  newlib/libc/sys/textos/stddef.sh \
	  $(CROSS_COMPILE)cc \
	  > $(INST_DIR)/include/stddef.h

.PHONY: toolchain-newlib
