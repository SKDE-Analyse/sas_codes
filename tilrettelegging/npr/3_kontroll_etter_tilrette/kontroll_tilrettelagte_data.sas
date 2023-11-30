%macro kontroll_tilrettelagte_data(inndata=, aar=, tertial=);

/* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
data _null_;
dset=open("&inndata");
call symput ('komnrhjem2',varnum(dset,'komnrhjem2'));
call symput ('bydel2',varnum(dset,'bydel2'));
call symput ('behandlingsstedkode',varnum(dset,'behandlingsstedkode'));
call symput ('institusjonid',varnum(dset,'institusjonid'));
call symput ('sektor',varnum(dset,'sektor'));
call symput ('lopenr',varnum(dset,'lopenr'));
call symput ('aar',varnum(dset,'aar'));
call symput ('inndato',varnum(dset,'inndato'));
call symput ('utdato',varnum(dset,'utdato'));
call symput ('kjonn',varnum(dset,'kjonn'));
call symput ('fodselsar',varnum(dset,'fodselsar'));
call symput ('tilstand_1_1',varnum(dset,'tilstand_1_1'));
call symput ('ncmp_1',varnum(dset,'ncmp_1'));
call symput ('ncsp_1',varnum(dset,'ncsp_1'));
call symput ('ncrp_1',varnum(dset,'ncrp_1'));
call symput ('liggetid',varnum(dset,'liggetid'));
run;

/* verdi på sektor brukes til å skille mellom avtspes og somatikk */
%if &sektor ne 0 %then %do;
proc sql noprint;
	select max(sektor) into: max_sektor
	from &inndata;
quit;
%end;

/* ----------------------------- */
/* 1 - antall pasienter og rader */
/* ----------------------------- */
%if &lopenr ne 0 and &kjonn ne 0 and &fodselsar ne 0  %then %do;
%include "&filbane/tilrettelegging/npr/1_kontroll_foer_tilrette/antall_pasienter_rader.sas";
%antall_pasienter_rader(inndata=&inndata, lnr=lopenr);




/* ---------------------------------- */
/* ---------------------------------- */
proc sql;
  create table tertial_summary as
  select
  from &inndata
  group by
  order by;
quit;


%mend;