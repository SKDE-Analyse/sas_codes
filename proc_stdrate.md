
# Dokumentasjon for filen *rateprogram/proc_stdrate.sas*


## Makro `proc_stdrate`

### Beskrivelse

Makro for å beregne rater

```
kortversjon (kjøres med default verdier for resten)
%proc_stdrate(dsn=, rate_var=, standardaar=, start=, slutt=, utdata=);
```
### Input
- datasett med variabel det skal beregnes rater på, 
	- kan være 0,1 variabel eller aggregert
	- må innheolde bo-nivået det skal kjøres rater på

### Output
- &utdata + evt. long_&utdata

### Endringslogg:
- februar 2022 opprettet, Frank
