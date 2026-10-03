$(TOOLCHAIN_DIR)/OVMF_$(EFI_ARCH)_RELEASE.tar.gz:
	@mkdir -p $(@D)
	cd $(TOOLCHAIN_DIR) && curl -o $@ -L \
	  $(GITHUB_URL)/ljQAQ233/ovmf-prebuilt/releases/latest/download/OVMF_$(EFI_ARCH)_RELEASE.tar.gz

$(TOOLCHAIN_DIR)/OVMF_$(EFI_ARCH)_RELEASE: $(TOOLCHAIN_DIR)/OVMF_$(EFI_ARCH)_RELEASE.tar.gz
	cd $(TOOLCHAIN_DIR) && tar xzvf $<
	touch $@

toolchain-ovmf: $(TOOLCHAIN_DIR)/OVMF_$(EFI_ARCH)_RELEASE

.PHONY: toolchain-ovmf
