
# Dokumentasjon for filen *rateprogram/proc_stdrate.sas*


## Makro `proc_stdrate`

### Beskrivelse

Makro for Ã¥ beregne rater

```
kortversjon (kjÃ¸res med default verdier for resten)
%proc_stdrate(dsn=, rate_var=, standardaar=, start=, slutt=, utdata=);
```
### Input
- datasett med variabel det skal beregnes rater pÃ¥, 
	- kan vÃ¦re 0,1 variabel eller aggregert
	- mÃ¥ innheolde bo-nivÃ¥et det skal kjÃ¸res rater pÃ¥

### Output
- &utdata + evt. long_&utdata

### Endringslogg:
- februar 2022 opprettet, Frank
