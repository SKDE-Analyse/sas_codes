
Konvertere tekst fra norsk til engelsk
```
for i in fig*.sas; do dos2unix $i;  iconv.exe -f CP1252 -t UTF-8 $i > tmp; sed -e 's/Opptaksområde/Hospital\ referral\ area/g' tmp > tmp2; rm tmp; iconv -f UTF-8 -t CP1252 tmp2 > $i; rm tmp2; unix2dos $i; done
 
for i in fig*.sas; do dos2unix $i;  iconv.exe -f CP1252 -t UTF-8 $i > tmp; sed -e 's/Antall\ pr\.\ 1\ 000\ innbyggere/Number\ per\ 1\,000\ inhabitants/g' tmp > tmp2; rm tmp; iconv -f UTF-8 -t CP1252 tmp2 > $i; rm tmp2; unix2dos $i; done

for i in fig*.sas; do dos2unix $i;  iconv.exe -f CP1252 -t UTF-8 $i > tmp; sed -e 's/år/years\ old/g' tmp > tmp2; rm tmp; iconv -f UTF-8 -t CP1252 tmp2 > $i; rm tmp2; unix2dos $i; done
```
