#include <stdio.h>

#include <autoconf.h>

int main() {
  printf("%s %d\n", CONFIG_HELLO_STRING, CONFIG_HELLO_INTEGER);
  return 0;
}
