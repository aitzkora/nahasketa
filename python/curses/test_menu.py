import curses, time
from menu import *
def main(sc):
  sc.nodelay(1)
  curses.curs_set(0)
  while True:
      men1 = menu(3,3, ["Fitxategia", "Belle la France", "Aux Chiottes"])
      sc.refresh()
      men1.refresh()
      if sc.getch() == ord('q'):
         break
      time.sleep(1)

if __name__=='__main__': curses.wrapper(main)
