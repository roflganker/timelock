#!/bin/sh

if [ "$(id -u)" != "0" ]; then
  echo "Please run this script as root user" >&2
  which sudo > /dev/null && echo "Example: sudo $0" >&2

  return 1
fi

executable="tt"
found="$(which $executable)"
if [ -n "$found" ] && [ -f "$found" ] && [ -x "$found" ]; then
  answer=""
  while [ -z "$answer" ]; do
    echo -n "Already installed at $found. Reinstall? Y/N "
    read answer
    if [ "$answer" = "N" ] || [ "$answer" = "n" ]; then
      echo "Ok. Aborting" >&2
      return 1
    fi
  done
fi

srcdir="./src"
entrypoint="$srcdir/tt.sh"
if [ ! -d $srcdir ] || [ ! -f $entrypoint ] || [ ! -s $entrypoint ]; then
  echo "Please run $0 from project root" >&2
  return 1
fi
 
destination="/usr/src/timetrack.sh"
[ -d $destination ] && rm -rf $destination

mkdir $destination
cp -r $srcdir/* $destination
chmod -R 755 $destination

installdir="/usr/local/bin"
linkname="$installdir/$executable"
linktarget="$destination/tt.sh"
ln -fs $linktarget $linkname

if which $executable > /dev/null; then
  echo "Installation complete!" >&2
else
  echo "Installation failed :(" >&2
  return 1
fi

