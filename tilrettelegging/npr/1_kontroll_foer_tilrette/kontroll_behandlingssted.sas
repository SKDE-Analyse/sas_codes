%macro kontroll_behandlingssted(inndata=, aar= , beh=); 
/*!
### Beskrivelse

Makro for å kontrollere om variabel 'behandlingsstedkode' eller 'behandlingssted2' i somatikk-data og 'institusjonid' i avtspes-data har en kjent verdi.
Kontrollen gjennomføres ved at mottatte verdier sjekkes mot CSV-filer som inneholder organisasjonsnummer for somatikk-data og reshid for avtalespesialist-data. 

Ukjente verdier (fra datasettet error_liste_'aar') kontrolleres mot brønnøysundregisteret eller reshid-registeret.
Hvis verdien i error_listen er et gyldig organisasjonsnummer eller reshid så skal CSV-fil oppdateres.
Hvis ikke korrigeres ugyldig verdi i tilretteleggingen steg 2.

Eksempel på bruk:
Somatikk:           %kontroll_behandlingssted(inndata=hnmot.SOM_2022_M22T1, aar=2022);
Avtalespesialist:   %kontroll_behandlingssted(inndata=HNMOT.ASPES_2022_M22T1, aar=2022,beh=institusjonid , sektor=avtspes);


### Input 
- inndata: Filen med behandlingssted-variabel som skal kontrolleres, f.eks hnmot.m20t3_som_2020.
- aar: Brukes for å gi unike navn til output-errorfiler.
- beh: Organisasjonsnummer eller reshid som skal kontrolleres, default er 'behandlingsstedkode' for RHF-data. Hvis kontroll av SKDE-data endres det til 'behandlingssted2', eller ved kontroll av reshid i avtalespesialist-data endres det til 'institusjonid'.
- sektor: Default er 'som' for somatikk-data, det velges 'aspes' hvis avtalespesialist-data. 

### Output 
- ett datasett
 - error_liste_'aar': mottatte verdier fra kontrollert variabel som ikke gjenfinnes i CSV-filen. 
- resultat fra proc freq
 - viser andel av radene med gyldig og ugyldig verdi av kontrollert variabel.

### Endringslogg
- 2020 Opprettet av Janice og Tove
- September 2021, Tove, dokumentasjon markdown
*/

%if &beh eq behandlingsstedkode %then %do;

data orgnr;
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
%end;

%if &beh eq institusjonid %then %do;
data orgnr;
  infile "&filbane/formater/avtalespesialister.csv"
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

proc sql;
	create table tmp_data as
	select a.&beh, a.sektor, gyldig, ugyldig 
  from &inndata a left join flagg_org b
	on a.&beh=b.orgnr;
quit;

/*hvor mange linjer har gyldig/ugyldig orgnr*/
title color= purple height=5 
    "6a: behandler-ID: antall og andel rader med gyldig/ugyldig verdi. Se i output-fil 'error_behandler_&aar' for hvilke verdier det gjelder.";
proc freq data=tmp_data; 
tables gyldig/missing; 
run;
title;
/*printe ut fil med ugyldig behandler/orgnr*/
/*disse fikses i tilrettelegging*/
proc sort data=tmp_data nodupkey out=error_behandler_&aar(keep=&beh);
by &beh; where ugyldig = 1; run;

%if &beh = behandlingsstedkode /*and &institusjonid ne 0 */ %then %do;
/*data som har missing behandlingssted*/
data tmp_data2;
set &inndata(keep=behandlingsstedkode institusjonid);
where &beh = .;
format institusjonid org_fmt.;
run;
title color= purple height=5 "6b: Hvis missing &beh. så brukes institusjonid som erstatning i tilretteleggingen, har alle radene med missing &beh. oppgitt InstitusjonId? ";
proc freq data=tmp_data2;
tables institusjonid  /nocol nopercent norow;
run;
%end;

proc datasets nolist;
delete flagg_org tmp_data tmp_data2 orgnr beh_liste mottatt_beh;
run;
%mend kontroll_behandlingssted;
