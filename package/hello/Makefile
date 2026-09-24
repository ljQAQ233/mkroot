CC     = $(PKG_CC)
CFLAGS = $(PKG_CFLAGS)

all: $(BUILD)/hello/hello

$(BUILD)/hello/hello: hello.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -static $< -o $@

.PHONY: all install
