/* Makro for � lage behandlersykehus, hf og rhf. */
/* Alle linjer m� ha gyldig orgnr/behandler - fikses i tilrettelegging */
/* Dvs 2_tilrettelegging\fix_behandlingssted m� kj�res f�rst */
/* Opprinnelig variabel i mottatt data 'behandlingsstedkode' beholdes uendret, det lages en 'beh_tmp' som brukes til � definere behsh, behhf og behrhf. */

%macro ny_behandler(inndata=, beh=behandlingsstedkode, utdata=);

%let csvbane= \\tos-sas-skde-01\SKDE_SAS\felleskoder\boomr\data; /*m� endres til \master\data etter merge*/


/* Hente inn CSV-fil for � lage behandler */
data beh;
  infile "&csvbane\behandler.csv"
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

/*ta med de variablene som trengs til � lage behandler*/
data beh(keep=orgnr behsh behhf behrhf);
set beh;
run;

/*merge behandler med bruk av orgnr*/
proc sql;
	create table &utdata as
	select * from &inndata a left join beh b
	on a.behandlingsstedkode2=b.orgnr;
quit;

%mend;