#!/usr/bin/env bash

for i in $(find . -name '*.sas'); do

# Convert to utf-8
if [[ `file -i $i`  == *iso-8859* ]]; then
  echo "Konvertere fil $i til UTF-8"
  iconv -f WINDOWS-1252 -t UTF-8 $i > tmp
  mv tmp $i
fi

done
