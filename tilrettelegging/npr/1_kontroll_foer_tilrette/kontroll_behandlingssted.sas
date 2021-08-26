%macro kontroll_behandlingssted(inndata=, aar= , beh=behandlingsstedkode, sektor=som); 
/* !
### Beskrivelse

Makro for å kontrollere om variabel 'behandlingsstedkode' i somatikk-data og 'institusjonid' i avtspes-data har en kjent verdi.
Kontrollen gjennomføres ved at mottatte verdier sjekkes mot CSV-filer som inneholder organisasjonsnummer for somatikk-data og reshid for avtalespesialist-data. 

Ukjente verdier (fra datasettet error_liste_'aar') kontrolleres mot brønnøysundregisteret eller reshid-registeret.
Hvis verdien i error_listen er et gyldig organisasjonsnummer eller reshid så skal CSV-fil oppdateres.
Hvis ikke korrigeres det i tilretteleggingen steg 2.

### Input 
- inndata: 
- aar: Brukes for å gi unike navn til output-errorfiler.
- beh: Organisasjonsnummer eller reshid som skal kontrolleres, default er 'behandlingsstedkode' for somatikkdata. Hvis kontroll av reshid i avtalespesialist-data endres det til 'institusjonid'.
- sektor: Default er 'som' som somatikk-data, det velges 'aspes' hvis avtalespesialist-data. 

### Output 
- seks datasett
 - orgnr: alle verdier fra CSV-fil(avtalespesialister.csv eller behandler.csv) brukt i kontrollen.
 - mottatt_beh: alle verdier fra variabel som kontrolleres.
 - error_liste_'aar': verdier fra kontrollert variabel som ikke gjenfinnes i CSV-filen. 
 - flagg_org: viser flagg med 'gyldig' eller 'ugyldig' for mottatte verdier.
 - tmp_data: datasett som brukes til å gjøre proc freq.
- resultat fra proc freq
 - viser andel av radene med gyldig og ugyldig verdi av kontrollert variabel.

### Endringslogg
- 2020 Opprettet av Janice og Tove
- August 2021, Tove, dokumentasjon markdown
*/

%if &sektor=som %then %do;
data orgnr;
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
%end;

%if &sektor=aspes or &sektor=avtspes %then %do;
data orgnr;
  infile "&filbane\formater\avtalespesialister.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format orgnr 10.;
  format org_navn $100.;
  format kommentar $300.;

  input	
  orgnr
  org_navn $
	kommentar $
	;
run;
%end;

/*til kontroll av orgnr i mottatte data trenger en kun kolonnen orgnr*/
data beh_liste(keep=orgnr);
set orgnr;
run;

/*hente ut behandlingssted/orgnr fra mottatt data*/
proc sql;
create table mottatt_beh as
select distinct &beh as orgnr
from &inndata;
quit;

/*sortere og flagge orgnr/behandler*/
proc sort data=beh_liste; by orgnr; run;
proc sort data=mottatt_beh; by orgnr; run;

data flagg_org;
merge mottatt_beh (in=a) beh_liste (in=b);
by orgnr;
if a and b then gyldig = 1;
if a and not b then ugyldig = 1;
run;

/*merge flagg til data som kontrolleres*/
%if &sektor=som %then %do;
proc sql;
	create table tmp_data as
	select a.&beh, a.institusjonid, a.hf, gyldig, ugyldig 
  from &inndata a left join flagg_org b
	on a.&beh=b.orgnr;
quit;
%end;

%if &sektor=aspes or &sektor=avtspes %then %do;
proc sql;
	create table tmp_data as
	select a.&beh, a.sektor, gyldig, ugyldig 
  from &inndata a left join flagg_org b
	on a.&beh=b.orgnr;
quit;
%end;

/*hvor mange linjer har gyldig/ugyldig orgnr*/
proc freq data=tmp_data; 
tables gyldig/missing; 
run;

/*printe ut fil med ugyldig behandler/orgnr*/
/*disse fikses i tilrettelegging*/
proc sort data=tmp_data nodupkey out=error_liste_&aar(keep=&beh);
by &beh; where ugyldig = 1; run;
%mend;
