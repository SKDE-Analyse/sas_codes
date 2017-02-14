# Hvordan produsere filene

- Konvertere filene fra utf-8 til windows-format

```
for i in icd10_2015.sas; do iconv -f utf-8 -t cp1252 --unicode-subst="" $i > tmp; mv tmp $i; done
```

