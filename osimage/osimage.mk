$(OUTPUT)/osimage/root.tar.gz:
	@mkdir -p $(@D)
	curl -o $@ -L $(GITHUB_URL)/ljQAQ233/textos-dev/releases/$(CONFIG_OSIMAGE_REMOTE_TAG)/download/root.tar.gz

$(OUTPUT)/osimage/root/boot/kernel.elf: $(call kconf_get_str,$(CONFIG_OSIMAGE_KERNEL_PATH))
	[[ -f "$<" ]] && install -D $< $@

$(OUTPUT)/osimage/root/boot/EFI/BOOT/BOOTX64.EFI: $(call kconf_get_str,$(CONFIG_OSIMAGE_EFIBOOT_PATH))
	[[ -f "$<" ]] && install -D $< $@

$(OUTPUT)/osimage/root/lib/ld-textos.so: $(call kconf_get_str,$(CONFIG_OSIMAGE_LDSO_PATH))
	[[ -f "$<" ]] && install -D $< $@

$(OUTPUT)/osimage/root.extract: $(OUTPUT)/osimage/root.tar.gz
	@mkdir -p $(@D)
	tar -xzvf $< -C $(abspath $@/..)
	touch $@

$(OUTPUT)/osimage/root: \
	$(OUTPUT)/osimage/root.extract \
	$(OUTPUT)/osimage/root/lib/ld-textos.so \
	$(OUTPUT)/osimage/root/boot/kernel.elf \
	$(OUTPUT)/osimage/root/boot/EFI/BOOT/BOOTX64.EFI
	touch $@

ifeq (${CONFIG_OSIMAGE_APPLY_BUNDLE},y)
image.item: $(OUTPUT)/osimage/root
endif

$(SYSROOT): install
image.item: $(SYSROOT)

image.item:
	echo -n > image.item
	for d in $^; do \
	  prt=$${d%/*}; \
	  name=$${d##*/}; \
	  pushd $$prt >/dev/null; \
	  find $$name -type f >> $(abspath image.item); \
	  popd >/dev/null; \
	done

.PHONY: image.item

image.img:
	dd if=/dev/zero of=$@ bs=1M count=128
	echo ',36M,c' | sfdisk $@
	echo ',  ,81' | sfdisk $@ --append
	loop=$$(sudo losetup --partscan --show --find "$@"); \
	  echo $${loop}; \
	  sudo mkfs.fat -F 32 -s 1 $${loop}p1; \
	  sudo mkfs.minix -3 $${loop}p2; \
	sudo losetup --detach $${loop}

diskdrop diskmu: attached_loops=$(shell sudo losetup -j image.img | awk -F ':' '{print $$1}')
mkimage diskdrop diskpick: L=$(if $(_lazy_L),$(_lazy_L),$(eval _lazy_L:=$(shell sudo losetup -f))$(_lazy_L))
mkimage diskdrop diskpick: B:=$(OUTPUT)/osimage/.boot/
mkimage diskdrop diskpick: R:=$(OUTPUT)/osimage/.root/
mkimage: image.img
	sudo losetup --partscan $(L) image.img
	mkdir -p $(B) $(R)
	sudo mount $(L)p1 $(B)
	sudo mount $(L)p2 $(R)
	cd $(OUTPUT)/osimage; \
	  cat $(abspath image.item) | while read -r file; do \
	    case "$$file" in \
		  packs/*) p=$${file#packs/} ;; \
		  root/*) p=$${file#root/} ;; \
		esac; \
		p=$(R)$${p}; \
		[[ -d $$(dirname $${p}) ]] || sudo mkdir -p $$(dirname $${p}); \
	    sudo cp $$file $${p}; \
	    echo "Copy $$file"; \
	  done
	sudo mkdir -p $(R)/home/{local,guest}
	sudo chown -R 1000:1000 $(R)/home/local
	sudo chown -R 1001:1001 $(R)/home/guest
	sudo cp -r $(R)boot/* $(B)
	sudo rm -rf $(R)boot/*
	sudo sync
	sudo umount $(R) $(B)
	sudo losetup --detach $(L)

diskdrop:
	-while sudo umount $(B); do true ; done
	-while sudo umount $(R); do true ; done
	-for i in $(attached_loops); do sudo losetup --detach $$i; done

diskpick:
	sudo losetup --partscan $(L) image.img
	sudo mount $(L)p1 $(B)
	sudo mount $(L)p2 $(R)

diskmu:
	@if [[ "x$(attached_loops)" != "x" ]]; then \
	  env -i PATH=$(PATH) make diskdrop; \
	else \
	  env -i PATH=$(PATH) make diskpick; \
	fi

preimage: image.item

.PHONY: diskdrop diskpick diskmu preimage

osimage-clean:
	rm -f image.img
	rm -f image.item
