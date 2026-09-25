#include "hello.h"
#include <stdio.h>

#include <autoconf.h>

int
hello(void)
{
  printf("%s %d\n", CONFIG_HELLO_STRING, CONFIG_HELLO_INTEGER);
  return 0;
}
hdefine(hello);
