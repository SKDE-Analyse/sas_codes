/* Makro for å lage behandler (BEHSH, BEHHF, BEHRHF). */
/* Den bruker variabelen 'behandlingsstedkode2' (RHF datagrunnlag) som lages i tilretteleggingen for å definere behandler */
/* Alle linjer må ha gyldig orgnr/behandler - det fikses i tilrettelegging */

/* Det gjøres en kontroll etter innlasting av CSV for å sjekke at det ikke er duplikate verdier */
/* Hvis det er duplikate verdier slettes datasettet behandler og det kommer en melding om ABORT i SAS-logg */

%macro behandler_psyk(inndata=, beh=);

/* Hente inn ref-fil for å lage behandler */
data beh;
  set hnref.ref_behandler_midlertidig2;
run;

/* --------------------------------------------------------------- */
/*  Kontroll at det ikke er duplikate organisasjonsnummer i filen  */  
/* --------------------------------------------------------------- */
/* Sortere etter organisasjonsnummer først */
proc sort data=beh;
by orgnr;
run;

/* Hvis duplikat blir makro-variabel duplikat = 1 */
/* SAS gjør i tillegg en ABORT */
data beh;
set beh;
by orgnr;
if first.orgnr = 0 or last.orgnr = 0 then do;
 CALL SYMPUTX('duplikat', 1);
abort;
end;
else CALL SYMPUTX('duplikat',0);
run;

/* Hvis det er duplikate orgnr slettes filen */
%if &duplikat = 1 %then %do;
proc delete data=beh;
run;
%end;

/*ta med de variablene som trengs til å lage behandler*/
data beh(keep=orgnr behsh behhf behhf_navn behrhf behrhf_navn org_navn);
set beh;
run;

/* hvis behandlingsstedkode mangler i datasettet så brukes institusjonid */
data &inndata;
set &inndata;
if &beh = . then &beh = institusjonid;
run;

/*merge behandler med bruk av orgnr*/
proc sql;
	create table &inndata as
	select a.*, b.behhf, b.behhf_navn, b.behrhf, b.behrhf_navn, b.org_navn
  from &inndata a 
  left join beh b
	on a.&beh=b.orgnr;
quit;
title height=5 "Oversikt behsh, behhf og behrhf i data. NB: ingen skal ha missing!";
proc freq data=&inndata;
  tables behhf behrhf / nocum;
run;
title;
proc datasets nolist;
delete beh;
run;
%mend;