#include <stdio.h>
#include <sys/ioctl.h>

int sixel_write(char *data, int size, void *priv)
{
    return fwrite(data, 1, size, (FILE *)priv);
}

int get_win_height(void)
{
    struct winsize sz;
    ioctl(0, TIOCGWINSZ, &sz);
    return sz.ws_row;
}
