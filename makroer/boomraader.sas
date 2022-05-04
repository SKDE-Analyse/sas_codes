%macro boomraader(inndata=, indreOslo = 0, bydel = 1);
/*! 
### Beskrivelse

Makro for � lage bo-variablene: boshhn, bohf, borhf og fylke.
Bo-variablene defineres ved � bruke 'komnr' og 'bydel' fra inndata.

```
%boomraader(inndata=, indreOslo = 0, bydel = 1);
```

### Input 
- inndata: Datasett som skal f� koblet p� bo-variablene.
- indreOslo = 1: Sl�r sammen Diakonhjemmet og Lovisenberg, NB: m� ogs� ha argument 'bydel = 1', default er 'indreOslo=0'.
- bydel = 0: Uten bydel f�r hele kommune 301 Oslo bohf=30 (Oslo), ved bruk av 'bydel=1' deles kommune 301 Oslo til bohf: 15 (akershus), 17 (lovisenberg), 18 (diakonhjemmet) og 15 (ahus), default er 'bydel=1'. 

### Output 
- bo-variablene: boshhn, bohf, borhf og fylke.

### Endringslogg:
- 2020 Opprettet av Tove og Janice
- september 2021, Tove, fjernet argument 'utdata='
- januar 2022, Tove, fjerne argument 'barn=' og 'haraldsplass='
- februar 2022, Tove, ta ut radene som kun brukes til formater
 */

/*
*****************************************
1. Drop variablene BOHF, BORHF og BOSHHN
*****************************************
*/
/* Pga sql-merge i makroen m� datasettet en sender inn ikke ha variablene bohf, borhf eller boshhn med */
data &inndata;
set &inndata;
drop bohf borhf boshhn;
run;
/*
*********************************************
2. Importere CSV-fil med mapping av boomr�der
*********************************************
*/
data bo;
  infile "&filbane/formater/boomr.csv"
  delimiter=';'
  missover firstobs=3 DSD;

  format komnr 4.;
  format komnr_navn $60.;
  format bydel 6.;
  format bydel_navn $60.;
  format bohf 4.;
  format bohf_navn $60.;
  format boshhn 2.;
  format boshhn_navn $15.;
  format borhf 4.;
  format borhf_navn $60.;
  format kommentar $400.;
 
  input	
  komnr komnr_navn $ bydel bydel_navn $ bohf bohf_navn $ boshhn boshhn_navn $ borhf borhf_navn $ kommentar $ ;
  if komnr eq . then delete; /*ta vekk rader som kun brukes til � lage formater*/
  run;
/*
*********************************
3a. Bo - Opptaksomr�der med bydel
*********************************
*/
%if &bydel = 1 %then %do;
proc sql;
  create table &inndata as
  select a.*, b.bohf, b.boshhn, b.borhf
  from &inndata a left join bo b
  on a.komnr=b.komnr
  and a.bydel=b.bydel;
quit;

/* Slette datasett */
proc datasets nolist;
delete bo ;
run;
%end;
/*
**********************************
3b. Bo - Opptaksomr�der uten bydel
**********************************
*/
%if &bydel = 0 %then %do;
data bo_utenbydel;
set bo;
if bydel >0 then delete; /*fjerner linjene i bo-data som har bydel*/
run;

proc sql;
  create table &inndata as
  select a.*, b.bohf, b.boshhn, b.borhf 
  from &inndata a left join bo_utenbydel b
  on a.komnr=b.komnr;
quit;

/* Slette datasett */
proc datasets nolist;
delete bo_utenbydel bo ;
run;
%end;
/*
**********************************
4. IndreOslo
**********************************
*/
data &inndata;
set &inndata;
%if &indreoslo = 1 %then %do; /* Sl�r sammen Lovisenberg og Diakonhjemmet */
  if bohf in (17,18) then bohf=31;
%end;
/*
**********************************
5. Fylke
**********************************
*/
Fylke=.;
if bohf=24 then Fylke=24 ;/*24='Boomr utlandet/Svalbard' */
else if bohf=99 then Fylke=99; /*99='Ukjent/ugyldig kommunenr'*/
else Fylke=floor(komnr/100); /*Remove the last 2 digits from kommunenummer.  The remaining leading digits are fylke*/
run;
%mend;