export str_toupper = $(shell echo "$(1)" | tr '[a-z]' '[A-Z]')
export str_tolower = $(shell echo "$(1)" | tr '[A-Z]' '[a-z]')

export kconf_get_str = $(patsubst "%",%,$(1))
