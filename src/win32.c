#include <windows.h>
#include <glib.h>

#define MSGBOX_WRAPPER(name, flags) \
    int show_ ## name ## _box(const gchar* title, const gchar *text) \
    { \
        return MessageBoxA(NULL, text, title, (flags)); \
    }

MSGBOX_WRAPPER(info, MB_OK | MB_ICONINFORMATION)
MSGBOX_WRAPPER(warning, MB_OK | MB_ICONWARNING)
MSGBOX_WRAPPER(error, MB_OK | MB_ICONERROR)
MSGBOX_WRAPPER(yes_no, MB_YESNOCANCEL | MB_ICONWARNING)