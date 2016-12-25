import urwid


class Botoia(urwid.Text):
    """
    Create a button with a frame around
    """
    def __init__(self, label, palette):
        self.__super.__init__(label)
        w = urwid.LineBox(self)
        w = urwid.Padding(w, 'center', len(label) + 2)
        self.view = w
        self.palette = palette

    """
    Simulates that button is pushed
    """
    def push(self, timePush):
        from time import sleep
        txt, attr = self.get_label()
        self.set_text(urwid.AttrMap(txt, 'inverse'))
        sleep(timePush)
        self.set_label((txt, attr))


def exit_on_q(key):
    if key in ('q', 'Q'):
        raise urwid.ExitMainLoop()


palette = [('normal', 'black', 'white'),
           ('inverse', 'white', 'black')]

berriz = Botoia(u'Berriz', palette)
zaila = Botoia(u'Zaila', palette)
ona = Botoia(u'Ona', palette)
erraza = Botoia(u'Erraza', palette)
empile = urwid.Columns([berriz.view, zaila.view, ona.view, erraza.view])
top = urwid.Filler(empile, valign='bottom')
loop = urwid.MainLoop(top, palette, unhandled_input=exit_on_q)
berriz.push(2)
loop.run()
