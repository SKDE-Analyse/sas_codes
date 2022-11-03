
# Dokumentasjon for filen *rateprogram/ratefigur_aarsvar_eng.sas*

### Beskrivelse

Makro for Ã¥ lage ratefigur med Ã¥rsvariasjon.

```
kortversjon (kjÃ¸res med default-verdier for resten)
%ratefig_aarsvar(dsn=, yvariabel1=, yvariabel2=, start=, slutt=, figurnavn=);
```
### Input
- datasett/output fra rateprogram
- datasett mÃ¥ inneholde alle rate-variabelene og nrate

- fÃ¸lgende let-statement:
    - bildesti
-fÃ¸lgende include-statement
    anno

### Output
- bildefil med valgt format lagres pÃ¥ angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
