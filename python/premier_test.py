#!/usr/bin/env python2.7
import curses, time
#hasteko
stdscr = curses.initscr()
curses.noecho()
curses.cbreak()
# avoid the fucking blank cursor!
curses.curs_set(0)
stdscr.nodelay(1)
stdscr.keypad(1)

#pad berri erantsi
begin_x = 3
begin_y = 3 
height = 10
width = 40
win = curses.newwin(height, width, begin_y, begin_x)
dx = 1
dy = 1
y = height/2
x = width/2
cond = True
while cond: 
    x += dx
    y += dy
    win.addch(y, x, ord("o"))
    win.addch(y-dy, x-dx, ord(" "))
    win.refresh()
    win.box()
    if x >= width - 2:
        dx = -dx
        x = width-2
    if y >= height - 2:
        dy = -dy
        y = height -2 
    if y <= 1:
        dy = -dy
        y = 1
    if x <= 1:
        dx = -dx
        x = 1
    time.sleep(0.1)
    key_press = stdscr.getch()
    if (key_press != -1) and (key_press == ord("q")):
        cond = False

## bukatzeko
curses.nocbreak()
stdscr.nodelay(0)
stdscr.keypad(0)
curses.echo()
curses.endwin()
