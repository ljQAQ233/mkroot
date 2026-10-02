$(OUTPUT)/osimage/root.tar.gz:
	@mkdir -p $(@D)
	curl -o $@ -L $(GITHUB_URL)/ljQAQ233/textos-dev/releases/$(CONFIG_OSIMAGE_REMOTE_TAG)/download/root.tar.gz

$(OUTPUT)/osimage/root: $(OUTPUT)/osimage/root.tar.gz
	@mkdir -p $(@D)
	tar xzvf $< -C $(abspath $@/..)
	touch $@

ifeq (${CONFIG_OSIMAGE_APPLY_BUNDLE},y)
image.item: $(OUTPUT)/osimage/root
endif

image.item:
	echo -n > image.item
	for d in $^; do \
	  prt=$${d%/*}; \
	  name=$${d##*/}; \
	  pushd $$prt >/dev/null; \
	  find $$name -type f >> $(abspath image.item); \
	  popd >/dev/null; \
	done

image.img:
	dd if=/dev/zero of=$@ bs=1M count=128
	echo ',36M,c' | sfdisk $@
	echo ',  ,81' | sfdisk $@ --append
	loop=$$(sudo losetup --partscan --show --find "$@"); \
	  echo $${loop}; \
	  sudo mkfs.fat -F 32 -s 1 $${loop}p1; \
	  sudo mkfs.minix -3 $${loop}p2; \
	sudo losetup --detach $${loop}

mkimage diskmu diskdrop: L:=$(shell sudo losetup -f)
mkimage diskmu diskdrop: B:=$(OUTPUT)/osimage/.boot/
mkimage diskmu diskdrop: R:=$(OUTPUT)/osimage/.root/
mkimage: image.img
	sudo losetup --partscan $(L) image.img
	mkdir -p $(B) $(R)
	sudo mount $(L)p1 $(B)
	sudo mount $(L)p2 $(R)
	cd $(OUTPUT)/osimage; \
	  cat $(abspath image.item) | while read -r file; do \
	    case "$$file" in \
		  root-made/*) p=$${file#root-made/} ;; \
		  root/*) p=$${file#root/} ;; \
		esac; \
		p=$(R)$${p}; \
		sudo mkdir -p $$(dirname $${p}); \
	    sudo cp $$file $${p}; \
	    echo "Copy $$file"; \
	  done
	sudo cp -r $(R)boot/* $(B)
	sudo rm -rf $(R)boot/*
	sudo sync
	sudo umount $(R) $(B)
	sudo losetup --detach $(L)

attached_loops:=$(shell sudo losetup -j image.img | awk -F ':' '{print $$1}')

diskdrop:
	-while sudo umount $(B); do true ; done
	-while sudo umount $(R); do true ; done
	-for i in $(attached_loops); do sudo losetup --detach $$i; done

ifeq (${attached_loops},)

diskmu:
	sudo losetup --partscan $(L) image.img
	sudo mount $(L)p1 $(B)
	sudo mount $(L)p2 $(R)

else
diskmu: diskdrop
endif

preimage: image.item

.PHONY: diskdrop diskmu preimage

image-kernel: $(CONFIG_OSIMAGE_KERNEL_PATH)
	sudo cp $< $(B)

image-efiboot: $(CONFIG_OSIMAGE_EFIBOOT_PATH)
	@sudo mkdir -p $(B)/EFI/BOOT
	sudo cp $< $(B)/EFI/BOOT/BOOTX64.EFI

image-ldso: $(CONFIG_OSIMAGE_LDSO_PATH)
	@sudo mkdir -p $(R)/lib
	sudo cp $< $(R)/lib

.PHONY: image-kernel image-efiboot image-ldso

ifneq (${CONFIG_OSIMAGE_KERNEL_PATH},)
install: image-kernel
endif

ifneq (${CONFIG_OSIMAGE_EFIBOOT_PATH},)
install: image-efiboot
endif

ifneq (${CONFIG_OSIMAGE_LDSO_PATH},)
install: image-ldso
endif
