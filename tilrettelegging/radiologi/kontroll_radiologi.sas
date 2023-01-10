/* kontroll av radiologi-data bruker noen av de samme makroene fra kontroll av NPR-data */

%macro kontroll_radiologi(inndata=, mottatt_aar=);

/* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
data _null_;
dset=open("&inndata");
call symput ('pasientlopenummer',varnum(dset,'pasientlopenummer'));
call symput ('pasient_kjonn',varnum(dset,'pasient_kjonn'));
call symput ('fodt',varnum(dset,'født'));
call symput ('dato',varnum(dset,'dato'));
call symput ('pasient_alder',varnum(dset,'pasient_alder'));
run;

/* ----------------------------- */
/* 1 - antall pasienter og rader */
/* ----------------------------- */
%if &pasientlopenummer ne 0 %then %do;
%include "&filbane/tilrettelegging/npr/1_kontroll_foer_tilrette/antall_pasienter_rader.sas";
%antall_pasienter_rader(inndata=&inndata, lnr=pasientlopenummer);
%end;

/* ---------------------- */
/* 2 - kjønn og fødselsår */
/* ---------------------- */
%if &pasientlopenummer ne 0 and &pasient_kjonn ne 0 and &fodt ne 0  %then %do;
%include "&filbane/tilrettelegging/npr/1_kontroll_foer_tilrette/kjonn_fodselsar.sas";
%kjonn_fodselsar(inndata=&inndata, lnr=pasientlopenummer, kjonn=pasient_kjonn, fodselsar=født);
%end;

/* NCRP-data har ikke variabel "født" */
%if &pasientlopenummer ne 0 and &pasient_kjonn ne 0 and &fodt eq 0  %then %do;
data lnr;
  set &inndata(keep=pasientlopenummer pasient_kjonn);
run;

proc sort data=lnr; by pasientlopenummer; run;

proc sort data=lnr nodupkey out=lnr_dupkjonn;
  by pasientlopenummer pasient_kjonn; 
run;

data dupkjonn;
  set lnr_dupkjonn;
  by pasientlopenummer pasient_kjonn;
  if first.pasientlopenummer =0 or last.pasientlopenummer=0 then output;
run;

title color=darkblue height=5 "2a: antall pasienter med ulike kjønn";
proc sql;
  select count(distinct pasientlopenummer) as unikid
  from dupkjonn;
quit;

proc transpose data=dupkjonn out=dupkjonn2;
  by pasientlopenummer;
  var pasient_kjonn;
run;
%end;

/* --------- */
/* 3 - alder */
/* --------- */
%if &pasient_alder ne 0  %then %do;
title color=darkblue height=5 "3: &mottatt_aar - min og maks alder";
proc sql;  
select 	min(pasient_alder) 				as minalder, 
		max(pasient_alder) 				as maxalder 
from &inndata;
quit;
title;
%end;

/* -------- */
/* 4 - dato */
/* -------- */
title color=darkblue height=5 "4: &mottatt_aar - min og maks dato";
proc sql;  
select 	min(dato) 				as mindato format yymmdd10., 
		max(dato) 				as maxdato format yymmdd10.
from &inndata;
quit;
title;
%mend kontroll_radiologi;