struct h
{
  char* x;
  int (*f)(void);
  struct h* n;
};

void
reg(struct h* nh);

#define hdefine(x)                                                             \
  static void __attribute__((constructor)) myinit()                            \
  {                                                                            \
    static struct h h = { #x, x, 0 };                                          \
    reg(&h);                                                                   \
  }
