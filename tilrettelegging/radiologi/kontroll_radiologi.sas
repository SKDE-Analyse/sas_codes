/* kontroll av radiologi-data bruker noen av de samme makroene fra kontroll av NPR-data */

%macro kontroll_radiologi(inndata=, mottatt_aar=);

/* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
data _null_;
dset=open("&inndata");
call symput ('pasientlopenummer',varnum(dset,'pasientlopenummer'));
call symput ('pasient_kjonn',varnum(dset,'pasient_kjonn'));
call symput ('fodt',varnum(dset,'født'));
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

%mend kontroll_radiologi;