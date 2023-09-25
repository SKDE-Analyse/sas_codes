
# Dokumentasjon for filen *rateprogram/proc_stdrate_komnr.sas*

### Beskrivelse

Makro for å beregne rater for kommuner pr hf.
Kjøres i en makro for å beregne alle hf samtidig.

```
kortversjon
%proc_stdrate_komnr(dsn=, rate_var=,figurnavn=, standardaar=, start=, slutt= , rmult=);
```
### Input
- datasett med variabel det skal beregnes rater på, 
	- kan være 0,1 variabel eller aggregert
- let-statement med bildesti for å skrive ut png fra rateprogrammet

### Output
- &utdata + evt. long_&utdata

### Endringslogg:
- september 2023 opprettet, Tove

## Makro `proc_stdrate_komnr`


## Makro `proc_stdrate_kommune`

