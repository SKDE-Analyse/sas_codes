%macro aktivitet_komnr_bydel(inndata=, komnr_navn=, bydel_navn=, bydel=1 /*default = 1*/, forny_komnr=1 /*default = 1*/);

/*! 
### Beskrivelse

Makro for å kontrollere at mottatte data inneholder data for alle kommuner og bydeler.
Kan også brukes for data uten bydeler.

```
%aktivitet_komnr_bydel(inndata= ,komnr_navn=, bydel_navn=);
```

### Input 
      - Inndata: 
      - komnr_navn:  Navn på kommunenummer-variabel
      - bydel_navn:  Navn på bydels-variabel, la være blank hvis ingen bydel i aktuelt datasett 
	  - bydel: 		 Angi om det er bydel i data som kontrolleres, default: bydel =1
	  - forny_komnr: Angi om makro forny_komnr skal kjøres, aktuelt for data levert med eldre kommunenummer, default: forny_komnr = 1

### Output 
      - Melding i resultatvindu i SAS EG angir om det er data for alle kommuner og bydeler, hvis ikke printes en liste med hvilke som mangler data.

### Endringslogg:
    - Tove: Opprettet desember 2022
	- Tove: tilpasset til bruk i makro for kontroll av mottatte data
 */

/*--------------------------------------------*/
/* les inn CSV-fil med gyldige komnr og bydel */
/*--------------------------------------------*/

data boomr;
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
  	komnr
  	komnr_navn $
	bydel 
	bydel_navn $
	bohf
	bohf_navn $
    boshhn
	boshhn_navn $
    borhf
	borhf_navn $
	kommentar $;
  run;

/*------------------------------------------*/
/* Gyldige kommuner og bydeler fra BOOMR.CSV*/
/*------------------------------------------*/

%if &bydel ne 0 %then %do;
/*tar kun med kommuner for bohf (1:23) - ekskluderer verdier for utland*/
proc sql;
	create table boomr as
	select komnr, bydel
	from boomr(keep=komnr bydel bohf)
	where komnr ne . and bohf in (1:23);
quit;

/*ta ut overflødige rader for bydelskommuner (brukes vanligvis til formater)*/
data boomr;
set boomr;
if komnr in (1103,4601,5001) and bydel eq . then delete;
ID_bo = bydel;
if bydel eq . then ID_bo = komnr;
drop komnr bydel;
run;
%end;

/*-----------------------------------*/
/* Hvis kontroll kjøres uten bydeler */
/*-----------------------------------*/

%if &bydel eq 0 %then %do;
/*tar kun med kommuner for bohf (1:23) - ekskluderer verdier for utland*/
proc sql;
	create table boomr as
	select distinct komnr as ID_bo
	from boomr(keep=komnr bohf)
	where komnr ne . and bohf in (1:23);
quit;
%end;

/*---------------*/
/* Mottatte data */
/*---------------*/

data tmp_data;
set &inndata(keep=&komnr_navn &bydel_navn);
/*hvis forny komnr ikke kjøres -> rename innsendt komnr-variabel til 'komnr'*/
%if &forny_komnr eq 0 %then %do;
komnr = &komnr_navn.;
%end;
run;

/*hvis komnr skal fornyes (default valg)*/
%if &forny_komnr ne 0 %then %do;
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=tmp_data, kommune_nr=&komnr_navn.);
%end;

data tmp_data;
set tmp_data;
where komnr not in (9000:9999); /*trenger ikke ta med rader med komnr utland*/

/*hvis bydel i data som kontrolleres - må lages etter forny komnr er gjort*/
%if &bydel ne 0 %then %do; 
if komnr = 5001 and &bydel_navn. not in (01:04) then &bydel_navn. = 0;
if komnr = 4601 and &bydel_navn. not in (01:08) then &bydel_navn. = 0;
if komnr = 1103 and &bydel_navn. not in (01:09) then &bydel_navn. = 0;
if komnr = 301  and &bydel_navn. not in (01:17) then &bydel_navn. = 0;

  if komnr in (301,4601,5001,1103) then do;
  	if &bydel_navn. <= 0 then bydel = komnr*100+99;
    else bydel = komnr*100+&bydel_navn.;
  end;
/* lage variabel ID som brukes til å sammenligne med boomr-csv */
ID = bydel;
if bydel eq . then ID = komnr;
%end;

%if &bydel eq 0 %then %do;
ID = komnr;
%end;
run;

/*slå sammen format for komnr og bydel*/
data fmtfil_komnr_bydel;
length fmtname $15.;
set HNREF.FMTFIL_KOMNR
	HNREF.FMTFIL_BYDEL;
fmtname= "komnr_bydel_fmt";
format start best6.;
run;
proc format cntlin = fmtfil_komnr_bydel; run;

/*aggregere opp antall rader per ID (kommune/bydel) etter fornying av komnr og bydel er gjort*/
proc sql;
	create table akt_komnr_bydel as
	select ID format komnr_bydel_fmt., count(*) as ant_rader
	from tmp_data
	group by ID;
quit;
/* left join antall rader per ID med liste av gyldige komnr-verdier */
proc sql;
	create table akt_komnr_bydel2 as
	select a.ID_bo format komnr_bydel_fmt., b.ant_rader
	from boomr a
	left join akt_komnr_bydel b
	on a.ID_bo=b.ID ;
quit;
/*datasett hvor det er ID (kommuner/bydeler) uten data*/
proc sql;
	create table komnr_uten_data as 
	select ID_bo as komnr_bydel format komnr_bydel_fmt., ant_rader
	from akt_komnr_bydel2
	where ant_rader lt 1;
quit;
/* sjekk om det er data i tabell 'komnr_uten_data' - output i resultvindu */
%let dsid2=%sysfunc(open(komnr_uten_data));
%let nobs_komnr=%sysfunc(attrn(&dsid2,any));
%let dsid2=%sysfunc(close(&dsid2)); 

%if &nobs_komnr eq 1 %then %do;
title color= red height=5 "5c: Kommuner/bydeler uten rapportert data ";
proc sql;
	select komnr_bydel, ant_rader
	from komnr_uten_data; 
quit;
title;
%end;

%if &nobs_komnr eq 0 %then %do;
title color= darkblue height=5  "5c: Alle kommuner/bydeler har rapporterte data";
proc sql;
   create table m
       (note char(12));
   insert into m
      values('All is good!');
   select * 
	from m;
quit;
%end;
title;

proc datasets nolist;
delete m komnr_uten_data tmp_data akt_komnr_bydel akt_komnr_bydel2 boomr ;
run;
%mend aktivitet_komnr_bydel;