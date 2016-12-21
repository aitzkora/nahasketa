import urwid


class Botoia(urwid.Text):
    """
    Create a button with a frame around
    """
    def __init__(self, label):
        self.__super.__init__(label)
        w = urwid.LineBox(self)
        w = urwid.Padding(w, 'center', len(label) + 2)
        self.view = w


def exit_on_q(key):
    if key in ('q', 'Q'):
        raise urwid.ExitMainLoop()


berriz = Botoia(u'Berriz')
zaila = Botoia(u'Zaila')
ona = Botoia(u'Ona')
erraza = Botoia(u'Erraza')
empile = urwid.Columns([berriz.view, zaila.view, ona.view, erraza.view])
top = urwid.Filler(empile, valign='bottom')
loop = urwid.MainLoop(top, unhandled_input=exit_on_q)
loop.run()
