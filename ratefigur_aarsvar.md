
# Dokumentasjon for filen *rateprogram/ratefigur_aarsvar.sas*

### Beskrivelse

Makro for å lage ratefigur med årsvariasjon.

```
kortversjon (kjøres med default verdier for resten)
%ratefig_aarsvar(dsn=, start=, slutt=, figurnavn=);
```
### Input
- datasett/output fra rateprogram
- datasett må inneholde alle rate-variabelene og nrate

- følgende let-statement:
    - 

### Output
- bildefil med valgt format lagres på angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
- mai 2022 endret farge og størrelse på symboler årsvariasjon, Tove
