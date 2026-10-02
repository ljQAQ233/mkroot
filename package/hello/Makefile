include $(KCONFIG_CONFIG)
CC      = $(PKG_CC)
CFLAGS  = $(PKG_CFLAGS) -g
LDFLAGS = -static
LDLIBS  =
BUILD  := $(BUILD)/hello

CFLAGS  += -I$(STAGING)/include

all: $(BUILD)/hello

install:
	install -D -m 0755 $(BUILD)/hello $(SYSROOT)/bin/hello

objs  = $(BUILD)/main.o
objs += $(BUILD)/hello.o

ifeq (${CONFIG_HELLO_NCURSES},y)
  objs += $(BUILD)/ncurses.o
  LDFLAGS += -L$(STAGING)/lib
  LDLIBS  += -lformw_g -lmenuw_g -lncursesw_g -lpanelw_g
endif

$(BUILD)/hello: $(objs)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD)

stpclean: ;
distclean: ;

.PHONY: all install
