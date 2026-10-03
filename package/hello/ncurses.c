#include "hello.h"
#include <ncurses.h>
#include <string.h>
#include <time.h>

#include <autoconf.h>

#define WIDTH 40
#define HEIGHT 12

typedef struct
{
  int x, y, dx, dy;
  const char* label;
} ball_t;

int
ncurses(void)
{
  curses_trace((1 << (TRACE_SHIFT + 1)) - 1);
  initscr();
  noecho();
  cbreak();
  curs_set(0);
  keypad(stdscr, TRUE);
  nodelay(stdscr, TRUE);

  if (has_colors()) {
    start_color();
    use_default_colors();
    init_pair(1, COLOR_GREEN, -1);
    init_pair(2, COLOR_CYAN, -1);
    init_pair(3, COLOR_YELLOW, -1);
    init_pair(4, COLOR_MAGENTA, -1);
  }

  int rows, cols;
  getmaxyx(stdscr, rows, cols);

  int bx = cols / 2 - WIDTH / 2;
  int by = rows / 2 - HEIGHT / 2;
  if (bx < 1)
    bx = 1;
  if (by < 1)
    by = 1;

  ball_t balls[] = {
    { 2, 2, 1, 1, "o" },
    { WIDTH - 3, HEIGHT - 3, -1, 1, "@" },
    { WIDTH / 2, 2, 1, -1, "*" },
    { 2, HEIGHT - 3, -1, -1, "+" },
  };
  int nballs = sizeof(balls) / sizeof(balls[0]);

  int tick = 0;
  int running = 1;
  while (running) {
    int ch = getch();
    if (ch == 'q' || ch == 'Q') {
      running = 0;
    } else if (ch == KEY_RESIZE) {
      getmaxyx(stdscr, rows, cols);
      bx = (cols - WIDTH - 2) / 2;
      by = (rows - HEIGHT - 2) / 2;
      if (bx < 1)
        bx = 1;
      if (by < 1)
        by = 1;
    }

    for (int i = 0; i < nballs; i++) {
      balls[i].x += balls[i].dx;
      balls[i].y += balls[i].dy;
      if (balls[i].x <= 0 || balls[i].x >= WIDTH - 1)
        balls[i].dx *= -1;
      if (balls[i].y <= 0 || balls[i].y >= HEIGHT - 1)
        balls[i].dy *= -1;
      balls[i].x += balls[i].dx;
      balls[i].y += balls[i].dy;
    }

    erase();
    attron(A_BOLD);
    mvprintw(0, (cols - (int)strlen("NCURSES DEMO")) / 2, "NCURSES DEMO");
    attroff(A_BOLD);

    attron(COLOR_PAIR(2));
    mvaddch(by, bx, ACS_ULCORNER);
    mvhline(by, bx + 1, ACS_HLINE, WIDTH);
    mvaddch(by, bx + WIDTH + 1, ACS_URCORNER);
    mvvline(by + 1, bx, ACS_VLINE, HEIGHT);
    mvvline(by + 1, bx + WIDTH + 1, ACS_VLINE, HEIGHT);
    mvaddch(by + HEIGHT + 1, bx, ACS_LLCORNER);
    mvhline(by + HEIGHT + 1, bx + 1, ACS_HLINE, WIDTH);
    mvaddch(by + HEIGHT + 1, bx + WIDTH + 1, ACS_LRCORNER);
    attroff(COLOR_PAIR(2));

    for (int i = 0; i < nballs; i++) {
      attron(COLOR_PAIR(3 + (i % 2)) | A_BOLD);
      mvprintw(by + 1 + balls[i].y, bx + 1 + balls[i].x, "%s", balls[i].label);
      attroff(COLOR_PAIR(3 + (i % 2)) | A_BOLD);
    }

    attron(COLOR_PAIR(1));
    mvprintw(rows - 2, 2, "Press 'q' to quit  |  resize to test KEY_RESIZE");
    attroff(COLOR_PAIR(1));
    refresh();

    napms(50);
    tick++;
  }

  endwin();
  return 0;
}
hdefine(ncurses);
