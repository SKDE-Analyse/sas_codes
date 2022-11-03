
# Dokumentasjon for filen *rateprogram/ratefigur_5aarsvar.sas*

### Beskrivelse

Makro for å lage ratefigur med årsvariasjon, tilpasset fem år. 
Symbolene er endret ifht opprinnelig makro %ratefigur_aarsvar.

```
kortversjon (kjøres med default verdier for resten)
%ratefig_5aarsvar(dsn=, start=, slutt=, figurnavn=);
```
### Input
- datasett/output fra rateprogram
- datasett må inneholde alle rate-variabelene og nrate

- følgende let-statement:
    - 

### Output
- bildefil med valgt format lagres på angitt bildesti

### Endringslogg:
- mai 2022 opprettet, Tove
