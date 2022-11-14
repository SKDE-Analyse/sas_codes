%macro kontroll_mottatte_data(inndata=, mottatt_aar=);

/* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
data _null_;
dset=open("&inndata");
call symput ('komnrhjem2',varnum(dset,'komnrhjem2'));
call symput ('bydel2',varnum(dset,'bydel2'));
call symput ('behandlingsstedkode',varnum(dset,'behandlingsstedkode'));
call symput ('institusjonid',varnum(dset,'institusjonid'));
call symput ('sektor',varnum(dset,'sektor'));
call symput ('lopenr',varnum(dset,'lopenr'));
call symput ('aar',varnum(dset,'aar'));
call symput ('inndato',varnum(dset,'inndato'));
call symput ('utdato',varnum(dset,'utdato'));
call symput ('kjonn',varnum(dset,'kjonn'));
call symput ('fodselsar',varnum(dset,'fodselsar'));
run;

/* verdi på sektor brukes til å skille mellom avtspes og somatikk */
%if &sektor ne 0 %then %do;
proc sql noprint;
	select max(sektor) into: max_sektor
	from &inndata;
quit;
%end;

/* ----------------------------- */
/* 1 - antall pasienter og rader */
/* ----------------------------- */
%if &lopenr ne 0 and &kjonn ne 0 and &fodselsar ne 0  %then %do;
%include "&filbane1/antall_pasienter_rader.sas";
%antall_pasienter_rader(inndata=&inndata);

/* ---------------------- */
/* 2 - kjønn og fødselsår */
/* ---------------------- */
%include "&filbane1/kjonn_fodselsar.sas";
%kjonn_fodselsar(inndata=&inndata);
%end;

/* -------------------------------------- */
/* 3 - min og maks-verdier for år og dato */
/* -------------------------------------- */
%if &aar ne 0 and &inndato ne 0 and &utdato ne 0  %then %do;
%include "&filbane1/min_maks_dato.sas";
%min_maks_dato(inndata=&inndata);
%end;

/* ---------------------------------------------------------------- */
/* 4 - Har mottatte variabler lik type og lengde som referanse satt */
/* ---------------------------------------------------------------- */
%include "&filbane1/kontroll_type_lengde.sas";
%kontroll_type_lengde(inndata=&inndata);

/* -------------------------- */
/* 5 - kommunenummer og bydel */
/* -------------------------- */
%if &komnrhjem2 ne 0 and &bydel2 ne 0 %then %do;
%include "&filbane1/1_kontroll_komnr_bydel.sas";
%kontroll_komnr_bydel(inndata= &inndata., komnr=komnrhjem2, bydel=bydel2, aar=&mottatt_aar);
%end;

/* ---------------- */
/* 6 - behandler-id */
/* ---------------- */
/* må bruke variabel sektor i kombinasjon med behandlingsstedkode og institusjonid for å skille mellom somatikk, rehab og avtspes */
%if (&behandlingsstedkode ne 0 or &institusjonid ne 0) and &sektor ne 0 %then %do;
	%if &behandlingsstedkode ne 0 and (&max_sektor eq 4 /*somatikk*/ or &max_sektor eq 5 /*rehab*/) %then %do;
		%let beh=behandlingsstedkode;
	%end;
	%if &institusjonid ne 0 and (&max_sektor eq SOM or &max_sektor eq PHV) %then %do;
		%let beh=institusjonid;
	%end;
%include "&filbane1/kontroll_behandlingssted.sas";
%include "&filbane/formater/beh.sas";
%kontroll_behandlingssted(inndata=&inndata., aar=&mottatt_aar , beh=&beh.);
%end;
%mend kontroll_mottatte_data;