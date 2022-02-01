
# Dokumentasjon for filen *rateprogram/ratefig_aarsvar.sas*


## Makro `ratefig_aarsvar`

### Beskrivelse

Makro for å lage ratefigur med årsvariasjon.

```
kortversjon (kjøres med default verdier for resten)
%ratefig_aarsvar(dsn=, start=, slutt=, figurnavn=);
```
### Input
- datasett/output fra rateprogram
- datasett må inneholde alle rate-variabelene og nrate
- eventuelt, hente inn data fra annet datasett til y-axis table
- følgende let-statement:
    - 

### Output
- bildefil med valgt format lagres på angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
