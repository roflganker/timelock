#!/bin/sh

if [ "$(id -u)" != "0" ]; then
  echo "Please run this script as root user" >&2
  which sudo >/dev/null && echo "Example: sudo $0" >&2

  return 1
fi

abort() {
  echo "$@" >&2
  exit 1
}

forceinstall="n"
executable="tl"

while getopts ':x:f' opt; do
  case "$opt" in
    f) forceinstall="y" ;;
    x) executable="$OPTARG" ;;
    ?) abort "Invalid option: -${OPTARG}" ;;
  esac
done

found="$(which "$executable")"
if [ -n "$found" ] && [ -f "$found" ] && [ -x "$found" ]; then
  while [ "$forceinstall" != "y" ]; do
    printf "Already installed at %s. Reinstall? y/n " "$found"
    read -r forceinstall
    [ "$forceinstall" = "n" ] && abort "Ok. Aborting"
  done
fi

scriptdir="$(dirname "$(readlink -f "$0")")"
srcdir="$scriptdir/src"
dist="/usr/src/timelock"
[ -d "$dist" ] && rm -rf "$dist"

mkdir "$dist"
cp -r $srcdir/* "$dist"
entrypoint="$dist/main.sh"
chmod +x "$entrypoint"
linkname="/usr/local/bin/$executable"
ln -fs "$entrypoint" "$linkname"
echo "Done. Linked to $linkname" >&2
