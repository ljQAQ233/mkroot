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
	cd toolchain/newlib; \
	export cmdcc=$(CROSS_COMPILE)cc; \
	for i in stddef.h stdbool.h stdarg.h float.h iso646.h; do \
	  newlib/libc/sys/textos/stdcomp.sh $$i \
	  > $(INST_DIR)/include/$$i; \
	done

toolchain-clean-newlib:
	rm -rf $(BUILD)/toolchain/newlib

.PHONY: toolchain-newlib
