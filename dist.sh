#!/bin/bash

# Package for Windows

set -eu

OUTDIR=ThetisSkinMaker
BINDIR=$OUTDIR/bin
LIBDIR=$OUTDIR/lib
SHAREDIR=$OUTDIR/share

# Get all the dependent libraries, needed both by the executable and
# the GdkPixbuf loaders.
files=$(cat <(ldd ./build/thetisskinmaker.exe) <(ldd /mingw64/lib/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-jpeg.dll) | grep mingw64 | uniq | awk '{print $3}')

echo -n "Making required folders... "
mkdir -p $OUTDIR
mkdir -p $BINDIR
mkdir -p $LIBDIR
mkdir -p $SHAREDIR
mkdir -p $SHAREDIR/icons
mkdir -p $SHAREDIR/glib-2.0/schemas
echo "done"

echo -n "Copying required files... "
cp ./ThetisSkinMaker.bat $OUTDIR
cp ./README.txt $OUTDIR
cp ./build/thetisskinmaker.exe $OUTDIR/bin

# Copy all dependent libraries
for file in $files; do
    cp $file $BINDIR
done

# Copy the gdbus binary, since it wants it so bad
cp $(which gdbus) $BINDIR

# We only need these two themes, I think
cp -r /mingw64/share/icons/hicolor $SHAREDIR/icons
cp -r /mingw64/share/icons/AdwaitaLegacy $SHAREDIR/icons
# otherwise we can't load any images
cp -r /mingw64/lib/gdk-pixbuf-2.0 $LIBDIR
cp /mingw64/share/glib-2.0/schemas/org.gtk.Settings* $SHAREDIR/glib-2.0/schemas

echo "done"

echo -n "Compiling gschema schema... "
glib-compile-schemas $SHAREDIR/glib-2.0/schemas
echo "done"

echo -n "Compressing into a zip archive... "
zip -r $OUTDIR.zip $OUTDIR > /dev/null
echo "done"
