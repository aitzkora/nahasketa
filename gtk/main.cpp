#include <iostream>
#include <gtk/gtk.h>
#include <gdk/gdkkeysyms.h>

#include <string>
#include <iostream>
#include <sstream>
#include <vector>

void changeColor(GtkWidget * widget, GdkColor foreground, GdkColor background)
{
    static GtkStyle * style;
    if (!style)
    {
        style = gtk_style_copy(gtk_widget_get_style(widget));
        style->bg[GTK_STATE_NORMAL] = foreground;
        style->fg[GTK_STATE_NORMAL] = background;
        gtk_widget_set_style(widget, style);
        gtk_style_ref(style);
    }
}



int main(int argc, char * argv[])
{
    gtk_init(&argc, &argv);

    GtkWidget *win = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_signal_connect(GTK_OBJECT(win), "destroy",
            GTK_SIGNAL_FUNC(gtk_main_quit), NULL);

    GtkWidget * text;
    gchar* textConvert = nullptr;
    textConvert = g_locale_to_utf8("proßt", -1, NULL, NULL, NULL);
    text = gtk_label_new(textConvert);
    g_free(textConvert);

    GdkColor beltza = (GdkColor){0, 0x0000, 0x0000, 0x0000};
    GdkColor arrosa = (GdkColor){0, 0xFFFF, 0x0000, 0xFFFF};
    GdkColor urdina = (GdkColor){0, 0x0000, 0x0000, 0xFFFF};
    changeColor(win, arrosa, beltza);
    gtk_container_add(GTK_CONTAINER(win), text);

    gtk_widget_show_all(win);
    gtk_main();
    return 0;
}
