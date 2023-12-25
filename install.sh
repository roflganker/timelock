#!/bin/sh

if [ "$(id -u)" != "0" ]; then
  echo "Please run this script as root user" >&2
  which sudo > /dev/null && echo "Example: sudo $0" >&2

  return 1
fi

executable="tl"
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

scriptdir=$(dirname $(readlink -f $0))
srcdir="$scriptdir/src"
mainscript="tl.sh"
entrypoint="$srcdir/$mainscript"
dist="/usr/src/timelock"
[ -d $dist ] && rm -rf $dist

mkdir $dist 
cp -r $srcdir/* $dist
chmod -R 755 $dist
ln -fs $dist/$mainscript /usr/local/bin/$executable

if which $executable > /dev/null; then
  echo "Installation complete!" >&2
else
  echo "Installation failed :(" >&2
  return 1
fi

