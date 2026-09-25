#include "hello.h"
#include <stdio.h>
#include <string.h>

struct h* h;

void
reg(struct h* p)
{
  p->n = h;
  h = p;
}

int
main(int argc, char* argv[])
{
  char *s = argc <= 1 ? "hello" : argv[1];
  for (struct h* p = h; p; p = p->n) {
    if (strcmp(p->x, s) == 0) {
      return p->f();
    }
  }
  printf("not available\n");
  return 1;
}
