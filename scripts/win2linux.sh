#!/usr/bin/env bash

for i in **/*.sas; do

# Convert to unix line ending
if [[ `file -k $i`  == *CRLF* ]]; then
  dos2unix $i
fi

# Convert to utf-8
if [[ `file -i $i`  == *iso-8859-1* ]]; then
  echo "Konvertere fil $i til UTF-8"
  iconv -f WINDOWS-1252 -t UTF-8 $i > tmp
  mv tmp $i
fi

done
