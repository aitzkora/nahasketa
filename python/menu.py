class menu: 
    def __init__(self, father, pos_y, pos_x, names):
        _names = names 
        _pos_x = pos_x
        _pos_y = pos_y
        _father = father
        _compute_dims()
        _win = father.win(_size_y, _size_x, _pos_y, _pos_x)
        _win.box()
    def _compute_dims(self):
        _size_x = max(map(len,_names))+2
        _size_y = len(_names) +2 
        
    def refresh(self):
        _win.box()
        for i,c  in enumerate(_names):
            _win.addstr(i, 1, c)
        _win.refresh()
