
# Dokumentasjon for filen *rateprogram/ratefigur_tredelt.sas*

### Beskrivelse

Makro for Ã¥ lage tredelt sÃ¸ylefigur.

```
Kortversjon (kjÃ¸res med default verdier for resten):
%ratefigur_tredelt(dsn= ,var1= ,var2= ,var3= ,
    label1= ,label2= ,label3= ,
    tabvar1= ,tabvar2= ,
    tablabel1= ,tablabel2= ,
    fmt_tabvar1= ,fmt_tabvar2= ,
    figurnavn= ,xlabel= )
    
```
### Input
- Ett tilpasset datasett fra rateprogram
- Ett let-statement for Ã¥ angi &bildesti (%let bildesti = &filbane/Analyse/prosjekter/eksempelmappe/figurer;)
- Ett include-statement for angi &anno
- Ett include-statement for Ã¥ angi sti til makro (%include "&filbane/rateprogram/ratefigur_tredelt.sas";)

### Output
- bildefil med valgt format lagres pÃ¥ angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
