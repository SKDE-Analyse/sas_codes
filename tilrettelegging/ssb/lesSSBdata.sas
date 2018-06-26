%macro lesSSBdata(aar=, utdata = , bydel = 0);

/*!
Makro for å lese Excel-fil med innbyggertall fra SSB

Følgende må gjøres før denne makroen kjøres
1. Last ned data fra SSB som *Semikolonseparert med overskrift (csv)*.
2. Åpne csv-fil i Excel
  - Fjern i to øverste radene
  - Erstatt `kjønn` med `kjonn` og `Personer ÅÅÅÅ` med `Personer`
  - Sjekk at fanen heter `Personer`
  - Lagre som `xlxs`-fil med navnet `Innb20XX_bydel` eller `Innb20XX_kommune` i mappen `Analyse\Data\SAS\Tilrettelegging\Innbyggere`.

Makroen gjør følgende:
- Leser fanen `Personer` fra filen `Innb&aar._bydel` (hvis `bydel ne 0`) eller `Innb&aar._kommune` (hvis `bydel = 0`).
- Konverterer variablene fra *character* til *numeric*. 
- Lagrer et sas-datasett med navnet `&utdata`.
*/



%if &bydel = 0 %then %do;
%let fignavn = Innb&aar._kommune.xlsx;
%end;
%else %do;
%let fignavn = Innb&aar._bydel.xlsx;
%end;

/* Lese excel-fil */
%let filepath="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\ANALYSE\Data\SAS\Tilrettelegging\Innbyggere\&fignavn.";
%let sheet=Personer;
proc import 
    out =&utdata
    datafile = &filepath
    dbms = xlsx replace;
    sheet = "&sheet";
	getnames=yes;
quit;

data &utdata;
set &utdata;

/* Lage bydel som numerisk variabel */
%if &bydel ne 0 %then %do;

/* 
Ta ut totaltallene for disse kommunene 
*/
where substr(region,5,2) ne '00';

/* Lage bydelsvariabel og endre den til numerisk */
bydel_string=substr(region,1,6);
bydel=input(bydel_string,6.);

drop bydel_string;
%end;
%else %do;
/*
Ta ut Oslo, Bergen, Trondheim og Stavanger fra kommunefil 
'0301'=Oslo, '1103'=Stavanger, '1201'=Bergen, 
'1601'=Trondheim før 2018, '5001'=Trondheim fra 2018
*/
where not (substr(region,1,4) in ('0301', '1103', '1201', '1601', '5001'));

bydel = .;

%end;


/* Lage komnr-variabel og endre den til numerisk */
komnr_string=substr(region,1,4);
komnr=input(komnr_string,4.);

drop komnr_string;


/* Fjerne " år" i alder og endre den til numerisk */
alder_string = substr(alder, 1, length(alder)-3);
drop alder;

alder_num = input(alder_string, 4.);

rename alder_num = alder;

drop alder_string;

/* Definere `ErMann` fra `kjonn` */
if kjonn = "Menn" then ErMann = 1;
else if kjonn = "Kvinner" then ErMann = 0;

innbyggere = Personer;

drop kjonn region Personer;

/* 
Bruker antall innbyggere 1. januar for år X + 1 som innbyggertall for år X 
*/
aar = %eval(&aar - 1);

run;

%mend;

