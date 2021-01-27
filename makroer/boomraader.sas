

/* Makroen 'forny_komnr_loop' m� v�re kj�rt f�r makroen boomraader kj�res */
/* Det for � sikre at datasettet har kommunenummer som er gyldige pr 01.01.2020 */

%macro Boomraader(dsn=, haraldsplass = 1, indreOslo = 0, bydel = 1, barn=0);

/* Hvis `haraldsplass = 1`: Deler Bergen i Haraldsplass og Haukeland */
/* Hvis `indreOslo = 1`: Sl�r sammen Diakonhjemmet og Lovisenberg */
/* Hvis `bydel = 0`: Vi mangler bydel og m� bruke gammel boomr.-struktur (bydel 030110, 030111, 030112 g�r ikke til Ahus men til Oslo) */
/* Hvis `barn = 1` : Helgeland legges under Nordland */


/*
*****************************************
1. Drop variablene BOHF, BORHF og BOSHHN
*****************************************
*/
/* Pga sql-merge m� datasettet en sender inn, &dsn, ikke ha variablene bohf, borhf eller boshhn med */
/* Hvis datasettes allerede har bohf, borhf eller boshhn s� vil de ikke overskrives i proc sql-merge */
data &dsn;
set &dsn;
drop bohf borhf boshhn;
run;


/*
*********************************************
2. Importere CSV-fil med mapping av boomr�der
*********************************************
*/
data bo;
  infile "&databane\boomr_2020.csv"
  delimiter=';'
  missover firstobs=2 DSD;

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
  run;

/*
*********************************
3a. Bo - Opptaksomr�der med bydel
*********************************
*/
%if &bydel = 1 %then %do;

/* Lager bydel=99 hvis det mangler i datasettet */
data &dsn;
set &dsn;
  if komnr in (301,4601,5001,1103) and bydel = . then bydel = komnr*100+99; /*hvis f�lgende komnr mangler bydel lage bydel udef, feks 30199*/
run;

proc sql;
  create table &dsn as
  select a.*, b.bohf, b.boshhn, b.borhf
  from &dsn a left join bo b
  on a.komnr=b.komnr
  and a.bydel=b.bydel;
quit;
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
  create table &dsn as
  select a.*, b.bohf, b.boshhn, b.borhf 
  from &dsn a left join bo_utenbydel b
  on a.komnr=b.komnr;
quit;
%end;

/*
**********************************
4. Haraldsplass, IndreOslo og Barn
**********************************
*/

data &dsn;
  set &dsn;

%if &haraldsplass = 0 %then %do; /* Bergen splittes ikke i Haukeland og Haraldsplass*/
  if bohf=9 then bohf=11;
%end;

%if &indreoslo = 1 %then %do; /* Sl�r sammen Lovisenberg og Diakonhjemmet */
  if bohf in (17,18) then bohf=31;
%end;

%if &barn = 1 %then %do;
  if boshhn in (9,10,11) then bohf = 3; /* Helgeland (Rana, Mosj�en og Sandnessj�en) legges under Nordland hvis vi ser p� barn*/
%end;

/*
******************************************************
5. Fylke
******************************************************
*/

Fylke=.;
if bohf=24 then Fylke=24 ;/*24='Boomr utlandet/Svalbard' */
else if bohf=99 then Fylke=99; /*99='Ukjent/ugyldig kommunenr'*/
else Fylke=floor(komnr/100); /*Remove the last 2 digits from kommunenummer.  The remaining leading digits are fylke*/
run;
%mend;

