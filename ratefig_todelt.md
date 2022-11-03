
# Dokumentasjon for filen *rateprogram/ratefig_todelt.sas*

### Beskrivelse

Makro for Ã¥ lage trodelt sÃ¸ylefigur.

```
Kortversjon (kjÃ¸res med default verdier for resten):
%ratefig_todelt(del1=, del2=, label_1=, label_2=, labeltab=, figurnavn=, xlabel= )
```
### Input
- T0 datasett/output fra rateprogram (del1 og del2)
- Ett let-statement for Ã¥ angi &bildesti (%let bildesti = &filbane/Analyse/prosjekter/eksempelmappe/figurer;)
- Ett include-statement for Ã¥ angi &anno 

### Output
- bildefil med valgt format lagres pÃ¥ angitt bildesti
- datasettet som lages i makroen

### Endringslogg:
- februar 2022 opprettet, Frank
