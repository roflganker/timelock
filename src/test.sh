#!/bin/sh

getcat() {
  echo "Tracy";
}

echo "$getcat";
echo "${getcat}";
echo "$(getcat)";

