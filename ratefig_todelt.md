
# Dokumentasjon for filen *rateprogram/ratefig_todelt.sas*


## Makro `ratefig_todelt`

### Beskrivelse

Makro for å lage trodelt søylefigur.

```
Kortversjon (kjøres med default verdier for resten):
%ratefig_todelt(del1=, del2=, label_1=, label_2=, labeltab=, figurnavn=, xlabel= )
```
### Input
- T0 datasett/output fra rateprogram (del1 og del2)
- Ett let-statement for å angi &bildesti (%let bildesti = \\&filbane\Analyse\prosjekter\eksempelmappe\figurer;)
- Ett include-statement for å angi &anno 

### Output
- bildefil med valgt format lagres på angitt bildesti
- datasettet som lages i makroen

### Endringslogg:
- februar 2022 opprettet, Frank
