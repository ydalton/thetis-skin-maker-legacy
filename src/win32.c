#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <shellapi.h>
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

int copy_folder(const gchar *src, const gchar *dest)
{
    SHFILEOPSTRUCT s = {0};
    s.wFunc = FO_COPY;
    s.fFlags = FOF_SILENT;
    s.pFrom = src;
    s.pTo = dest;

    return SHFileOperation(&s);
}