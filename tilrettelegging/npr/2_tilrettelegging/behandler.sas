/* Makro for å lage behandler (BEHSH, BEHHF, BEHRHF). */
/* Den bruker variabelen 'behandlingsstedkode2' (RHF datagrunnlag) som lages i tilretteleggingen for å definere behandler */
/* Alle linjer må ha gyldig orgnr/behandler - det fikses i tilrettelegging */

/* Det gjøres en kontroll etter innlasting av CSV for å sjekke at det ikke er duplikate verdier */
/* Hvis det er duplikate verdier slettes datasettet behandler og det kommer en melding om ABORT i SAS-logg */

%macro behandler(inndata=, beh=behandlingsstedkode2, utdata=);


/* Hente inn CSV-fil for å lage behandler */
data beh;
  infile "&filbane/formater/behandler.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format orgnr 10.;
  format org_navn $100.;
  format behsh 3.;
  format behsh_navn $60.;
  format behhf 3.;
  format behhf_navn $60.;
  format behhf_navnkort $60.;
  format behrhf 1.;
  format behrhf_navn $60.;
  format behrhf_navnkort $60.;
  format behrhf_navnkortest $10.;
  format kommentar $300.;

  input	
  orgnr
  org_navn $
	behsh 
	behsh_navn $
	behhf
	behhf_navn $
	behhf_navnkort $
	behrhf 
	behrhf_navn $
	behrhf_navnkort $
	behrhf_navnkortest $
	kommentar $
	;
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
data beh(keep=orgnr behsh behhf behrhf);
set beh;
run;

/*merge behandler med bruk av orgnr*/
proc sql;
	create table &utdata as
	select * from &inndata a left join beh b
	on a.&beh=b.orgnr;
quit;

proc freq data=&utdata;
  tables behsh behhf behrhf;
run;

%mend;