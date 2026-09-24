# if CONFIG_X=y, X is enabled
include $(KCONFIG_CONFIG)

PACKAGE_ALL := $(patsubst package/%,%,$(shell find package -mindepth 1 -maxdepth 1 -type d))
PACKAGE_ENABLED := $(foreach pkg,$(PACKAGE_ALL),$(if $(filter y,$(CONFIG_$(call str_toupper,$(pkg)))),$(pkg),))
PACKAGE_TARGETS := $(addprefix package-,$(PACKAGE_ENABLED))

package: $(PACKAGE_TARGETS)

package-status:
	@echo "All packages: $(PACKAGE_ALL)"
	@echo "Enabled: $(PACKAGE_ENABLED)"
	@echo "Targets: $(PACKAGE_TARGETS)"

export PKG_CC := $(CROSS_COMPILE)cc
export PKG_CFLAGS := -I$(OUTPUT)

$(foreach t,$(PACKAGE_ENABLED), \
  $(eval package-$(t): ; $$(MAKE) -C package/$(t) \
))

.PHONY: package
.PHONY: package-status
.PHONY: $(PACKAGE_TARGETS)
