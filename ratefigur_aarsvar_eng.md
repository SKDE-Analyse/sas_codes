
# Dokumentasjon for filen *rateprogram/ratefigur_aarsvar_eng.sas*


## Makro `ratefigur_aarsvar_eng`

### Beskrivelse

Makro for å lage ratefigur med årsvariasjon.

```
kortversjon (kjøres med default-verdier for resten)
%ratefig_aarsvar(dsn=, yvariabel1=, yvariabel2=, start=, slutt=, figurnavn=);
```
### Input
- datasett/output fra rateprogram
- datasett må inneholde alle rate-variabelene og nrate

- følgende let-statement:
    - bildesti
-følgende include-statement
    anno

### Output
- bildefil med valgt format lagres på angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
