/* Kontrollere om variabel behandlingsstedkode har gyldig verdi (orgnr) */
/* Output fra proc freq gir andel med gyldig og ugyldig orgnr mottatt */
/* Output error-fil gir alle linjene fra mottatt data som har ugyldig orgnr - fikses i tilrettelegging */

%macro kontroll_orgnr(inndata= , beh=, aar=);

	%macro read_csv;
		%let datamappe = \\tos-sas-skde-01\SKDE_SAS\felleskoder\boomr\data;  /*boomr må endres til master når branchen tas inn i  master*/
		proc import datafile = "&datamappe.\&datafil"
		DBMS = csv OUT = &utdata replace;
		getnames=YES;
		run;
	%mend;

	%let datafil=behandler.csv;
	%let sheetnavn=ark1;
	%let utdata = behandler;
	%read_csv


/*til kontroll av orgnr i mottatte data trenger en kun kolonnen orgnr*/
data beh_liste(keep=orgnr2);
set behandler;
orgnr2=input(orgnr,best12.); /*endre til numerisk*/
run;


/*hente ut behandlingssted/orgnr fra mottatt data*/
proc sql;
create table mottatt_beh as
select distinct &beh as orgnr2
from &inndata;
quit;


/*sortere og flagge orgnr/behandler*/
proc sort data=beh_liste; by orgnr2; run;
proc sort data=mottatt_beh; by orgnr2; run;

data flagg_org;
merge mottatt_beh (in=a) beh_liste (in=b);
by orgnr2;
if a and b then gyldig = 1;
if a and not b then ugyldig = 1;
run;

/*merge flagg til data som kontrolleres*/
proc sql;
	create table kontroll as
	select * from &inndata a left join flagg_org b
	on a.&beh=b.orgnr2;
quit;

/*hvor mange linjer har gyldig/ugyldig orgnr*/
proc freq data=kontroll; 
tables gyldig/missing; 
run;


/*printe ut fil med ugyldig behandler/orgnr*/
/*disse fikses i tilrettelegging*/
data error_orgnr_&aar;
set kontroll;
where ugyldig = 1;
run;

%mend;
