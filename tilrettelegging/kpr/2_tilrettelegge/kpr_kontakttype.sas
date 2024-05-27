
%macro kpr_kontakttype (takst_fil= /* filen innholder takstkoder som skal brukes til å definere kontakttype */,
                        regning_fil= /* filen på enkeltregning_lnr nivå som kontakttype skal "limes" på */);
/*assign each takstkode to a kontakttype*/
/*<< kontakttypen defineres ut i fra den taksten på regningskortet som er ansett som den mest ressurskrevende taksten>>*/
/*rekkefølge: sykebesøk (4), tverrfaglig (5), konsultasjon (3), enkel kontakt (2), annet (1), ukjent (0)*/

/* Tove J 24.05.2024: lagt til takster brukt av primærhelseteam med driftstilskuddsmodell */

data takst;
  set &takst_fil;
  
/* helsedirektoratet.no/statistikk/om-data-statistikk-om-fastlegetjenesten#datakilde */

if lowcase(takstKode) in ('2ad','2ae','2ak','2aek','2ed','2fk','2af',
                      '074a','074ae','074b','074be','074d') then kontakttype=3; /*konsultasjon, beløp <100 - <1000*/

else if lowcase(takstKode) in ('11ad','11ak',
                      '086a','086b') then kontakttype=4;/*sykebesøk, beløp 500-3000*/

else if lowcase(takstKode) in ('1ad', '1ak', '1bd', '1be', '1bk', '1e', '1g', '1h', '1i', '701a', '612a', '612b', '618', 'v1'
                      '070','071a') then kontakttype=2;/*enkel kontakt, beløp <100-300*/

*else if lowcase(takstKode) in ('1bd','1bk','1be','1g') then kontakttype=2; /* telefonkontakt */

else if lowcase(takstKode) in ('1f','14','1j') then kontakttype=5; /*tverrfaglig, beløp 100-1000*/

else if upcase(substr(takstKode,1,1))='L' or lowcase(takstKode) in ('5','616','h1','2kd') then kontakttype=1;

else kontakttype=0; /*ukjent*/ 

run;

/*determine the kontakttype for the whole enkeltregning, based on the highest hierarki within the enkeltregning*/
proc sql;
  create table takst2 as
  select enkeltregning_lnr, max(kontakttype) as kontakttypeId
  from takst
  group by enkeltregning_lnr
  order by enkeltregning_lnr;
quit;

/*merge back to enkeltregning file*/
proc sql;
  create table &regning_fil as
  select a.*, b.kontakttypeId
  from &regning_fil a left join takst2 b
  on a.enkeltregning_lnr=b.enkeltregning_lnr;
quit;

proc datasets nolist;
  delete takst2;
run;

%mend kpr_kontakttype;