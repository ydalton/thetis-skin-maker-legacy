project(
    'ThetisSkinMaker',
    ['vala', 'c'],
    version: '0.1.0'
)

gnome = import('gnome')

vala = meson.get_compiler('vala')

if host_machine.system() == 'windows'
    add_project_arguments('-D', '_WIN32', language: 'vala')
else
    error('Compiling on non-Windows platforms is not supported.')
endif



tsm_src = files()
subdir('src')

tsm_dep = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    dependency('gdk-pixbuf-2.0')
]

tsm_exe = executable(
    meson.project_name(),
    tsm_src,
    c_args: [
        '-Wno-unused-variable',
        '-Wno-discarded-qualifiers',
    ],
    win_subsystem: 'windows,6.0',
    dependencies: tsm_dep,
)