/* Kontrollere om variabel behandlingsstedkode har gyldig verdi (orgnr) */
/* Output fra proc freq gir andel med gyldig og ugyldig orgnr mottatt */
/* Output error-fil gir alle linjene fra mottatt data som har ugyldig orgnr - fikses i tilrettelegging */
/* NB: ugyldig orgnr kan v�re et nytt orgnr ikke registrert i listen v�r */

%macro kontroll_behandlingssted(aar= ,avd=, beh=behandlingsstedkode); /*behandlingsstedkode kan erstattes med annen variabel som inneholder orgnr hvis en �nsker � kontrollere for gyldige orgnr*/

data orgnr;
  infile "&databane\behandler.csv"
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

/*til kontroll av orgnr i mottatte data trenger en kun kolonnen orgnr*/
data beh_liste(keep=orgnr);
set orgnr;
run;

/*hente ut behandlingssted/orgnr fra mottatt data*/
proc sql;
create table mottatt_beh as
select distinct &beh as orgnr
from hnmot.m20_&avd._&aar;
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
proc sql;
	create table tmp_data as
	select a.&beh, a.institusjonid, a.hf, gyldig, ugyldig 
  from hnmot.m20_&avd._&aar a left join flagg_org b
	on a.&beh=b.orgnr;
quit;

/*hvor mange linjer har gyldig/ugyldig orgnr*/
proc freq data=tmp_data; 
tables gyldig/missing; 
run;


/*printe ut fil med ugyldig behandler/orgnr*/
/*disse fikses i tilrettelegging*/

proc sort data=tmp_data nodupkey out=error_liste_&aar(keep=&beh);
by &beh; where ugyldig = 1; run;


%mend;
