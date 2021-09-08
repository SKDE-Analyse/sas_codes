%macro behandler(inndata=, beh=behandlingssted2);
/*!
### Beskrivelse

```
%behandler(inndata=, beh=behandlingsstedkode2, utdata=);
```
Makro for � lage behandler-variablene behsh, behhf og behrhf. 
Dt gj�res ved bruk av csv-filen \&filbane\formater\behandler.csv.

Makroen bruker variabelen 'behandlingssted2' fra inndata for � lage behandler-variablene.
F�r makroen kj�res m� alle radene i inndata ha gyldig behandlingssted (organisasjonsnummer), det gj�res i tilretteleggingen med makroen:
- \\&filbane\tilrettelegging\npr\2_tilrettelegging\fix_behandlingssted.sas

Det gj�res en kontroll av CSV-filen etter innlasting for � sjekke etter duplikate verdier.
Hvis det er duplikate verdier slettes datasettet og det kommer en melding om ABORT i SAS-loggen.
Hvis det skjer m� CSV-filen sjekket og duplikate f�ringer m� slettes.

### Input 
- inndata: Datasett hvor behandler-variabler skal lages, f.eks hnmot.m20t3_som_2020.
- beh: Behandlingssted-variabel som brukes til � definere behandler-variablene, default er 'behandlingssted2' som brukes i b�de RHF- og SKDE-data.

### Output 
- tre variabler
  - BEHSH
  - BEHHF
  - BEHRHF

### Endringslogg
- 2020 Opprettet av Janice og Tove
*/

/* Hente inn CSV-fil for � lage behandler */
data beh;
  infile "&filbane\formater\behandler.csv"
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
/* Sortere etter organisasjonsnummer f�rst */
proc sort data=beh;
by orgnr;
run;

/* Hvis duplikat blir makro-variabel duplikat = 1 */
/* SAS gj�r i tillegg en ABORT */
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

/*ta med de variablene som trengs til � lage behandler*/
data beh(keep=orgnr behsh behhf behrhf);
set beh;
run;

/* drop evnt behrhf, behhf og behsh hvis de allerede er i inndata */
data &inndata;
set &inndata;
drop behsh behhf behrhf;
run;

/*merge behandler med bruk av orgnr*/
proc sql undo_policy=none;
	create table &inndata as
	select a.*, b.behsh, b.behhf, b.behrhf 
  from &inndata a left join beh b
	on a.&beh=b.orgnr;
quit;

proc datasets nolist;
delete beh;
run;
%mend;