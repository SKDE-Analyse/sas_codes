%macro boomraader2(inndata=);
/*! 
### Beskrivelse

Makro for å lage bo-variablene: boshhn, bohf, borhf og fylke.
Bo-variablene defineres ved å bruke 'komnr' og 'bydel' fra inndata.

```
%boomraader2(inndata=);
```

### Input 
- inndata: Datasett som skal få koblet på bohf2-variablene.

### Output 
- bo-variabel: bohf2

### Endringslogg:
- 2022 opprettet Tove
 */

/*
*****************************************
1. Drop variabel BOHF2
*****************************************
*/
/* Pga sql-merge i makroen må datasettet en sender inn ikke ha variablene bohf, borhf eller boshhn med */
data &inndata;
set &inndata;
drop bohf;
run;
/*
*********************************************
2. Importere CSV-fil med mapping av boområder
*********************************************
*/
data bo;
  infile "&filbane\formater\boomr2.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format borhf_navn $60.;
  format bohf $60.;
  format bohf2 4.;
  format bohf2_navn $60.;
  format komnr 4.;
  format komnr_navn $60.;
  format bydel 6.;
  format bydel_navn $60.;
  format innb best9.;

  input	
  	borhf_navn $ bohf $ bohf2 bohf2_navn $ komnr komnr_navn $ bydel bydel_navn $ innb ;
  run;
/*
*********************************
3a. Bo - Opptaksområder med bydel
*********************************
*/
proc sql;
  create table &inndata as
  select a.*, b.bohf2 as bohf
  from &inndata a left join bo b
  on a.komnr=b.komnr
  and a.bydel=b.bydel;
quit;

/* Slette datasett */
proc datasets nolist;
delete bo ;
run;

run;
%mend;