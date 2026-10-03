QEMU_FLAGS := \
  -cpu qemu64,+x2apic \
  -smp 2 -m 64M \
  -no-reboot \
  -debugcon file:output/qemu.log \
  -device isa-debug-exit \
  -netdev tap,id=net0,ifname=tap0,script=no,downscript=no \
  -device e1000,netdev=net0,mac=52:54:00:12:34:56 \
  -drive file=image.img,if=ide,index=0,media=disk

qemu-efi: toolchain-ovmf
	qemu-system-x86_64 \
	  -drive if=pflash,format=raw,file=$(TOOLCHAIN_DIR)/OVMF_$(EFI_ARCH)_RELEASE/OVMF_CODE.fd \
	  -drive if=pflash,format=raw,file=$(TOOLCHAIN_DIR)/OVMF_$(EFI_ARCH)_RELEASE/OVMF_VARS.fd \
	  $(QEMU_FLAGS)

qemu-emu:
	qemu-system-x86_64 \
	  -kernel $(OUTPUT)/osimage/root/boot/kernel.elf \
	  $(QEMU_FLAGS)

qemu-efi qemu-emu: qemu-net

.PHONY: qemu-efi qemu-emu
