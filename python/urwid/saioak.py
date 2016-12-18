import urwid


class EneBotoia(urwid.Text):
    def __init__(self, label):
        w = self.__super.__init__(label)
        w = urwid.LineBox(w)
        w = urwid.Padding(w, 'center', len(label) + 2)
        w = urwid.Filler(w, 'middle', height = 1)
        self = w


def exit_on_q(key):
    if key in ('q', 'Q'):
        raise urwid.ExitMainLoop()


button1 = EneBotoia(u'Berriz')
button2 = EneBotoia(u'Erraza')
empile = urwid.Columns([button1, button2])
#top = urwid.Filler(empile, valign='top')
loop = urwid.MainLoop(empile, unhandled_input=exit_on_q)
loop.run()
