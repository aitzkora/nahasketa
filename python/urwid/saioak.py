import urwid


class EneBotoia(urwid.Text):
    def __init__(self, label):
        self.__super.__init__(label)
        w = urwid.LineBox(self)
        w = urwid.Padding(w, 'center', len(label) + 2)
        #w = urwid.Filler(w, 'middle', height=1)
        self.view = w


def exit_on_q(key):
    if key in ('q', 'Q'):
        raise urwid.ExitMainLoop()


button1 = EneBotoia(u'Berriz')
button2 = EneBotoia(u'Erraza')
empile = urwid.Columns([button1.view, button2.view])
top = urwid.Filler(empile, valign='middle')
loop = urwid.MainLoop(top, unhandled_input=exit_on_q)
loop.run()
