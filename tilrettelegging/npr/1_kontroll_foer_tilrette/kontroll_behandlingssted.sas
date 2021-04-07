/* Kontrollere om variabel behandlingsstedkode har gyldig verdi (orgnr) */
/* Output fra proc freq gir andel med gyldig og ugyldig orgnr mottatt */
/* Output error-fil gir alle linjene fra mottatt data som har ugyldig orgnr - fikses i tilrettelegging */
/* NB: ugyldig orgnr kan være et nytt orgnr ikke registrert i listen vår */

%macro kontroll_behandlingssted(inndata=, aar= , beh=behandlingsstedkode, sektor=som); 
/* beh=behandlingsstedkode kan erstattes med annen variabel som inneholder orgnr hvis en ønsker å kontrollere for gyldige orgnr*/
/* sektor could be set to som or aspes */

%if &sektor=som %then %do;
data orgnr;
  infile "&filbane\data\behandler.csv"
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
  infile "&filbane\data\avtalespesialister.csv"
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
