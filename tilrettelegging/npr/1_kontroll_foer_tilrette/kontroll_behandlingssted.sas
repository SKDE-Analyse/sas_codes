%macro kontroll_behandlingssted(inndata=, beh=); 
/*!
### Beskrivelse

Makro for å kontrollere om variabel 'behandlingsstedkode' eller 'behandlingssted2' i somatikk-data og 'institusjonid' i avtspes-data har en kjent verdi.
Kontrollen gjennomføres ved at mottatte verdier sjekkes mot CSV-filer som inneholder organisasjonsnummer for somatikk-data og reshid for avtalespesialist-data. 

Ugyldige/ukjente verdier printes ut kontrolleres mot brønnøysundregisteret eller reshid-registeret.
Hvis verdien i error_listen er et gyldig organisasjonsnummer eller reshid så skal CSV-fil oppdateres.
Hvis ugyldig verdi gjør evnt manuell korrigering før tilrettelegging kjøres, f.eks sette behandlingsstedkode til missing, da brukes institusjonid i tilretteleggingen.

Eksempel på bruk:
Somatikk:           %kontroll_behandlingssted(inndata=hnmot.SOM_2022_M22T1);
Avtalespesialist:   %kontroll_behandlingssted(inndata=HNMOT.ASPES_2022_M22T1, beh=institusjonid);


### Input 
- inndata: Filen med behandlingssted-variabel som skal kontrolleres, f.eks hnmot.m20t3_som_2020.
- beh: Organisasjonsnummer eller reshid som skal kontrolleres, default er 'behandlingsstedkode' for RHF-data. Hvis kontroll av SKDE-data endres det til 'behandlingssted2', eller ved kontroll av reshid i avtalespesialist-data endres det til 'institusjonid'.

### Output 
- printes i result viewer

### Endringslogg
- 2020 Opprettet av Janice og Tove
- September 2021, Tove, dokumentasjon markdown
- Mars 2023, Tove, endret output
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

%if &beh eq institusjonid %then %do; /*avtalespesialister*/
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
select distinct &beh as mottatt_id
from &inndata;
quit;

proc sql;
	create table flagg_ugyldig as 
	select 	a.mottatt_id, 
			b.orgnr as liste_orgnr,
			case when a.mottatt_id ne . and a.mottatt_id=b.orgnr then 1 end as gyldig,
			case when a.mottatt_id not in (select distinct orgnr from beh_liste) then 1 end as ukjent
	from mottatt_beh a
	left join beh_liste b
	on a.mottatt_id=b.orgnr;
quit;

title color= purple height=5 
    "6a: behandler-ID: antall rader med missing eller ukjent verdi. Hvis ukjente orgnr mottatt er gyldige (sjekk brreg.no) skal de legges til i CSV-fil behandler";
proc sql;
	select &beh.,
			count(case when &beh. eq . then 1 end) as mangler_orgnr, 
			count(case when &beh. in (select mottatt_id from flagg_ugyldig where ukjent eq 1 and mottatt_id ne .) then 1 end) as ukjent
			from &inndata.
	    group by &beh.
      having calculated mangler_orgnr or calculated ukjent;
quit;
title; 

%if &beh = behandlingsstedkode %then %do;
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
delete flagg_ugyldig tmp_data tmp_data2 orgnr beh_liste mottatt_beh;
run;
%mend kontroll_behandlingssted;
