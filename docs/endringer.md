# Potensielle forbedringer og endringer av rateprogrammet

[Ta meg tilbake.](./)

Forslag til endringer legges inn som en *issue* [her](https://github.com/SKDE-Analyse/rateprogram/issues) (`New issue`).

## Overordnet

- Definere variabler, slik at bruker slipper å definere alt før hen kjører rateprogrammet
   - kjonn=(0,1)
   - innbyggerfil=Innbygg.innb_2004_2015_bydel_allebyer
   - ...
- Kunne kjøre uten at det produseres output (til testing).
- Gjøre variablene lokale (`%locale <variabelnavn>`)
   
## utvalgX-makro

- Flytte produksjon av ekskluderingstabeller til egen makro?
   - Bedre forklaring i tabellene? Kan være litt vanskelig å tolke slik som de printes nå

## rateberegning-makro

- Mange variabler defineres både her og i uvalgX-makroen. Definer dem kun en gang?
   - Dette må skje på nivået over begge makroene, siden makro-variabler er lokale.
- Skriv om if-looper, vis_tabeller (mye kode som går igjen)
- Bruke samme kode for tallformat = NLnum og Excel (kun tallformatet som er forskjellig)

## omraade-makro

- Slå sammen med omraadeHN?
