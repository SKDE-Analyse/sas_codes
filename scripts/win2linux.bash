#!/usr/bin/env bash

for i in $(find . -name '*.sas'); do

# Convert to utf-8
if [[ `file -i $i`  == *iso-8859* ]]; then
  echo "Konvertere fil $i til UTF-8"
  iconv -f WINDOWS-1252 -t UTF-8 $i > tmp
  mv tmp $i
  # Legg til BOM (for at EG skal skjønne at det er utf-8)
  sed -i '1s/^\(\xef\xbb\xbf\)\?/\xef\xbb\xbf/' $i
fi

if [[ `file -i $i`  == *unknown-8bit* ]]; then
  echo "Konvertere fil $i med ukjent encoding til UTF-8"
  iconv -f WINDOWS-1252 -t UTF-8 $i > tmp
  mv tmp $i
  sed -i '1s/^\(\xef\xbb\xbf\)\?/\xef\xbb\xbf/' $i
fi

done
