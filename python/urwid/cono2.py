import urwid

def exit_on_q(key):
    if key in ('q', 'Q'):
        raise urwid.ExitMainLoop()

palette = [ ('banner', 'black', 'light gray'),
            ('streak', 'black', 'dark red'),
            ('bg', 'black', 'dark blue'),
            ('bouton', 'yellow', 'dark blue') ]

txt = urwid.Text(('banner', u" Hello World "), align='center')
map1 = urwid.AttrMap(txt, 'streak')
fill = urwid.Filler(map1)
map2 = urwid.AttrMap(fill, 'bg')
reply = urwid.Text(u"Merdum")
button = urwid.Button(u'Hehe')
mapBouton = urwid.AttrMap(button, 'bouton')
empile = urwid.Pile([mapBouton, reply])
top = urwid.Filler(empile, valign='top')
loop = urwid.MainLoop(top, palette, unhandled_input=exit_on_q)
loop.run()
