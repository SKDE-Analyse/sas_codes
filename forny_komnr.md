
# Dokumentasjon for filen *makroer/forny_komnr.sas*


## Makro `forny_komnr`

### Beskrivelse

Makro for Ã¥ fornye gamle kommunenummer til kommunenummer i bruk pr 1.1.2021 .

```
%forny_komnr(inndata=, kommune_nr=komnrhjem2)
```

### Input 
- Inndata:
- kommune_nr:  Kommunenummer som skal fornyes, default er 'KomNrHjem2' - variabel utlevert fra NPR 

### Output 
- KomNr: Fornyet kommunenummer
- komnr_inn: Input kommunenummer beholdes i utdata for evnt kontroll

OBS: bydeler blir ikke oppdatert nÃ¥r denne makroen kjÃ¸res. 
Hvis det er bydeler i datasettet mÃ¥ de fornyes etter at denne makroen er kjÃ¸rt. 
Se makro 'bydel': 
- \\&filbane\tilrettelegging\npr\2_tilrettelegging\bydel.sas

### Endringslogg:

- 2020 Opprettet av Tove og Janice
- august 2021, Tove
  - tatt bort 'utdata='
  - skrive melding til SAS-logg
  - dokumentasjon markdown
- september 2021, Janice
  - instead of renaming &kommune_nr to komnr_inn, add 0 to make it numeric in case it is not already

