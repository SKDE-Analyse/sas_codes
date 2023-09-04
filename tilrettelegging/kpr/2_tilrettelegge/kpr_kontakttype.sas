
%macro kpr_kontakttype (takst_fil= /* filen innholder takstkoder som skal brukes til � definere kontakttype */,
                        regning_fil= /* filen p� enkeltregning_lnr niv� som kontakttype skal "limes" p� */);
/*assign each takstkode to a kontakttype*/
/*<< kontakttypen defineres ut i fra den taksten p� regningskortet som er ansett som den mest ressurskrevende taksten>>*/
/*rekkef�lge: sykebes�k (5), tverrfaglig (4), konsultasjon (3), enkelt kontakt (2), annet (1), ukjent (0)*/

data takst;
  set &takst_fil;
  
/* helsedirektoratet.no/statistikk/om-data-statistikk-om-fastlegetjenesten#datakilde */

if lowcase(takstKode) in ('2ad','2ae','2ak','2aek','2ed','2fk','2af') then kontakttype=3; /*konsultasjon, bel�p <100 - <1000*/

else if lowcase(takstKode) in ('11ad','11ak') then kontakttype=4;/*sykebes�k, bel�p 500-3000*/

else if lowcase(takstKode) in ('1ad', '1ak', '1bd', '1be', '1bk', '1e', '1g', '1h', '1i', '701a', '612a', '612b', '618', 'v1') then kontakttype=2;/*enkel kontakt, bel�p <100-300*/

*else if lowcase(takstKode) in ('1bd','1bk','1be','1g') then kontakttype=2; /* telefonkontakt */

else if lowcase(takstKode) in ('1f','14','1j') then kontakttype=5; /*tverrfaglig, bel�p 100-1000*/

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

