# assume we run make on x86_64 linux
toolchain-cc:
	mkdir -p $(TOOLCHAIN_DIR)
	for t in g++ ar as ld ranlib nm objcopy objdump strip readelf; do \
	  ln -sf "$$(command which $$t)" "$(CROSS_COMPILE)$$t"; \
	done
	if [[ "x$$CONFIG_TOOLCHAIN_EXTERNAL_COMPILER" != "x" ]]; then \
	  toolchain/wrap-cc.sh \
	    $(CONFIG_TOOLCHAIN_EXTERNAL_COMPILER)/$(CROSS_TRIPLET)-cc \
	    $(TOOLCHAIN_DIR)/cc.specs \
	    > $(CROSS_COMPILE)cc; \
	else \
	  toolchain/wrap-cc.sh \
	    $$(command which cc) \
	    $(TOOLCHAIN_DIR)/cc.specs \
	    > $(CROSS_COMPILE)cc; \
	fi
	chmod +x $(CROSS_COMPILE)cc 
	ln -sf "$(CROSS_COMPILE)cc" "$(CROSS_COMPILE)gcc"

toolchain-clean-cc:
	rm -rf $(TOOLCHAIN_DIR)

.PHONY: toolchain-cc
