
# Dokumentasjon for filen *rateprogram/ratefig_tredelt_andelkolonne.sas*


## Makro `ratefig_tredelt_andelkolonne`

### Beskrivelse

Makro for å lage tredelt søylefigur.

```
Kortversjon (kjøres med default verdier for resten):
%ratefig_tredelt_andelkolonne(del1=, del2=, del3=, label_1=, label_2=, label_3=, fignavn=, xlabel= )
```
### Input
- Tre datasett/output fra rateprogram (del1, del2 og del3)
- Ett let-statement for å angi &bildesti
- Ett include-statement for å angi &anno 

### Output
- bildefil med valgt format lagres på angitt bildesti
- datasettet som lages i makroen

### Endringslogg:
- februar 2022 opprettet, Tove
