
# Dokumentasjon for filen *rateprogram/sas/ekskluderingstabeller.sas*


## Makro `ekskluderingstabeller`

Makro for å lage tabeller over antall kontakter i det originale datasettet som blir ekskludert
i rateprogrammet.

Følgende ekskluderinger vises:
- `komnr=. or komnr not in (0:2031, 5000:5100)`
- `alder not &aldersspenn`
- `ermann not in &kjonn`
- `aar not in (&startår:&sluttår)`

Følgende variabler, som er definert tidligere, brukes:
- `&aldersspenn`
- `&kjonn`
- `&startår`
- `&sluttår`

