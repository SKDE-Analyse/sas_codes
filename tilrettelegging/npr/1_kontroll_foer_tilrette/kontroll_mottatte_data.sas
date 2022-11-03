%macro kontroll_mottatte_data(inndata=, aar=);

/* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
data _null_;
dset=open("&inndata");
call symput ('chk1',varnum(dset,'komnrhjem2'));
call symput ('chk2',varnum(dset,'bydel2'));
call symput ('chk3',varnum(dset,'behandlingsstedkode'));
call symput ('chk4',varnum(dset,'institusjonid'));
call symput ('chk5',varnum(dset,'sektor'));
call symput ('chk6',varnum(dset,'lopenr'));
call symput ('chk7',varnum(dset,'aar'));
call symput ('chk8',varnum(dset,'inndato'));
call symput ('chk9',varnum(dset,'utdato'));
call symput ('chk10',varnum(dset,'lnr'));
call symput ('chk11',varnum(dset,'kjonn'));
call symput ('chk12',varnum(dset,'fodselsar'));
run;

/* verdi på sektor brukes til å skille mellom avtspes og somatikk */
%if &chk5 ne 0 %then %do;
proc sql noprint;
	select max(sektor) into: max_sektor
	from &inndata;
quit;
%end;

/* ----------------------------- */
/* 1 - antall pasienter og rader */
/* ----------------------------- */

/* RHF-data har LOPENR, mens SKDE-data har LNR */
%if (&chk6 /*lopenr*/ ne 0 or &chk10 /*lnr*/ ne 0)  and &chk11 /*kjonn*/ ne 0 and &chk12 /*fodselsar*/ ne 0  %then %do;
	%if &chk6 ne 0 %then %do;
		%let pasid=lopenr;
	%end;
	%else %if &chk10 ne 0 %then %do;
		%let pasid=lnr;
	%end;
%include "&filbane1/antall_pasienter_rader.sas";
%antall_pasienter_rader(inndata=&inndata., pasid=&pasid.);

/* -------------------------------------- */
/* 2 - min og maks-verdier for år og dato */
/* -------------------------------------- */

%if &chk7 /*aar*/ ne 0 and &chk8 /*inndato*/ ne 0 and &chk9 /*utdato*/ ne 0  %then %do;
%include "&filbane1/min_maks_dato.sas";
%min_maks_dato(inndata=&inndata.);
%end;

/* ---------------------- */
/* 3 - kjønn og fødselsår */
/* ---------------------- */
%include "&filbane1/kjonn_fodselsar.sas";
%kjonn_fodselsar(inndata=&inndata., pasid=&pasid.);
%end;

/* ---------------------------------------------------------------- */
/* 4 - Har mottatte variabler lik type og lengde som referanse satt */
/* ---------------------------------------------------------------- */
%include "&filbane1/kontroll_type_lengde.sas";
%kontroll_type_lengde(inndata=&inndata);

/* -------------------------- */
/* 5 - kommunenummer og bydel */
/* -------------------------- */
%if &chk1 ne 0 and &chk2 ne 0 %then %do;
%include "&filbane1/1_kontroll_komnr_bydel.sas";
%kontroll_komnr_bydel(inndata= &inndata., komnr=komnrhjem2, bydel=bydel2, aar=&aar);
%end;

/* ---------------- */
/* 6 - behandler-id */
/* ---------------- */
/* må bruke variabel sektor i kombinasjon med behandlingsstedkode (somatikkdata) og institusjonid (avtspesdata) for å skille mellom somatikk og avtspes */
%if (&chk3 /*behandlingsstedkode*/ ne 0 or &chk4 /*institusjonid*/ ne 0) and &chk5 /*sektor*/ ne 0 %then %do;
	%if &chk3 ne 0 and &max_sektor eq 4 %then %do;
		%let beh=behandlingsstedkode;
	%end;
	%if &chk4 ne 0 and (&max_sektor eq SOM or &max_sektor eq PHV) %then %do;
		%let beh=institusjonid;
	%end;
%include "&filbane1/kontroll_behandlingssted.sas";
%include "&filbane/formater/beh.sas";
%kontroll_behandlingssted(inndata=&inndata., aar=&aar , beh=&beh.);
%end;
%mend kontroll_mottatte_data;