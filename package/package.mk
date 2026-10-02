PACKAGE_ALL := $(patsubst package/%,%,$(shell find package -mindepth 1 -maxdepth 1 -type d))
PACKAGE_ENABLED := $(foreach pkg,$(PACKAGE_ALL),$(if $(filter y,$(CONFIG_$(call str_toupper,$(pkg)))),$(pkg),))
PACKAGE_TARGETS := $(addprefix package-,$(PACKAGE_ENABLED))
PACKAGE_TARGETS_INSTALL := $(addprefix package-install-,$(PACKAGE_ENABLED))
PACKAGE_TARGETS_CLEAN := $(addprefix package-clean-,$(PACKAGE_ENABLED))
PACKAGE_TARGETS_STPCLEAN := $(addprefix package-stpclean-,$(PACKAGE_ENABLED))
PACKAGE_TARGETS_DISTCLEAN := $(addprefix package-distclean-,$(PACKAGE_ENABLED))

PACKAGE_TARGETS_DEPS := $(wildcard package/*/dep.mk)
include $(PACKAGE_TARGETS_DEPS)

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

$(foreach t,$(PACKAGE_ENABLED), \
  $(eval package-install-$(t): ; $$(MAKE) -C package/$(t) install \
))

$(foreach t,$(PACKAGE_ENABLED), \
  $(eval package-clean-$(t): ; $$(MAKE) -C package/$(t) clean \
))

$(foreach t,$(PACKAGE_ENABLED), \
  $(eval package-stpclean-$(t): ; $$(MAKE) -C package/$(t) stpclean \
))

$(foreach t,$(PACKAGE_ENABLED), \
  $(eval package-distclean-$(t): ; $$(MAKE) -C package/$(t) distclean \
))

package-install: $(PACKAGE_TARGETS_INSTALL)
package-clean: $(PACKAGE_TARGETS_CLEAN)
package-stpclean: $(PACKAGE_TARGETS_STPCLEAN)
package-distclean: $(PACKAGE_TARGETS_DISTCLEAN)

.PHONY: package
.PHONY: package-install
.PHONY: package-status
.PHONY: package-clean
.PHONY: $(PACKAGE_TARGETS)
.PHONY: $(PACKAGE_TARGETS_INSTALL)
.PHONY: $(PACKAGE_TARGETS_CLEAN)
.PHONY: $(PACKAGE_TARGETS_STPCLEAN)
.PHONY: $(PACKAGE_TARGETS_DISTCLEAN)
