import curses
class menu: 
    def __init__(self, pos_y, pos_x, names):
        self.names = names 
        self.pos_x = pos_x
        self.pos_y = pos_y
        self._compute_dims()
        self.win = curses.newwin(self.size_y, self.size_x, self.pos_y, self.pos_x)
        self.win.box()
    def _compute_dims(self):
        self.size_x = max(map(len,self.names))+2
        self.size_y = len(self.names) +2 
        
    def refresh(self):
        self.win.box()
        for i,c  in enumerate(self.names):
            self.win.addstr(i +1, 1, c)
        self.win.refresh()
