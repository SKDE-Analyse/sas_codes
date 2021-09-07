
# Dokumentasjon for filen *makroer/forny_komnr.sas*


## Makro `forny_komnr`

### Beskrivelse

Makro for å fornye gamle kommunenummer til kommunenummer i bruk pr 1.1.2021 .

```
%forny_komnr(inndata=, kommune_nr=komnrhjem2)
```

### Input 
- Inndata:
- kommune_nr:  Kommunenummer som skal fornyes, default er 'KomNrHjem2' - variabel utlevert fra NPR 

### Output 
- KomNr: Fornyet kommunenummer
- komnr_inn: Input kommunenummer beholdes i utdata for evnt kontroll

OBS: bydeler blir ikke oppdatert når denne makroen kjøres. 
Hvis det er bydeler i datasettet må de fornyes etter at denne makroen er kjørt. 
Se makro 'bydel': 
- \\&filbane\tilrettelegging\npr\2_tilrettelegging\bydel.sas

### Endringslogg:
- 2020 Opprettet av Tove og Janice
- august 2021, Tove
  - tatt bort 'utdata='
  - skrive melding til SAS-logg
  - dokumentasjon markdown

