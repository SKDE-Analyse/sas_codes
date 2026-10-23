/* kontroll av de nye LAB_RAD_PAT data  
    - Opprettet mars 2026, Janice S
*/

%macro kontroll_labrad(inndata=, aar=);

title color=darkblue height=5 "&aar";
proc sql;
  select count(*)            as ant_linjer     format=nlnum12.0,
         count(distinct pid) as ant_pasienter  format=nlnum12.0
  from &inndata;
quit;

/* ----------------------------- */
/* 1 - antall pasienter og rader */
/* ----------------------------- */
/* %include "&filbane/tilrettelegging/npr/1_kontroll_foer_tilrette/antall_pasienter_rader.sas"; */
/* %antall_pasienter_rader(inndata=&inndata, lnr=pid); */

proc freq data=&inndata;
  tables fagomraade_kode*offpriv;
run;

title 'Off v.s. Priv';
proc sql;
  select count(          case when fagomraade_kode='PO' then pid end)  as ant_off_linjer,
         count(distinct (case when fagomraade_kode='PO' then pid end)) as ant_off_pas,
         count(          case when fagomraade_kode='LR' then pid end)  as ant_priv_linjer,
         count(distinct (case when fagomraade_kode='LR' then pid end)) as ant_priv_pas
  from &inndata;
quit;

title 'MR pasienter';
proc sql;
  select count(          case when modalitet in ('MR','MRA') then pid end)  as ant_MR_linjer,
         count(distinct (case when modalitet in ('MR','MRA') then pid end)) as ant_MR_pas
  from &inndata;
quit;

/* ---------------------- */
/* 2 - kjønn og fødselsår */
/* ---------------------- */
title 'Kjønn og Aldersgrupper';
proc freq data=&inndata;
  tables pasient_kjonn aldersgruppe / missing;
run;

/*Ulike kjønn;*/
data lnr;
  set &inndata(keep=pid pasient_kjonn);
run;

proc sort data=lnr; by pid; run;

proc sort data=lnr nodupkey out=lnr_dupkjonn;
  by pid pasient_kjonn; 
run;

data dupkjonn;
  set lnr_dupkjonn;
  by pid pasient_kjonn;
  if first.pid =0 or last.pid=0 then output;
run;

title color=darkblue height=5 "2a: &aar - antall pasienter med ulike kjønn";
proc sql;
  select count(distinct pid) as unikid
  from dupkjonn;
quit;

proc transpose data=dupkjonn out=dupkjonn2;
  by pid;
  var pasient_kjonn;
run;

proc sql;
  create table dupkjonn_data as
  select *
  from &inndata
  where pid in (select distinct pid from dupkjonn)
  order by pid;
quit;


/*Ulike alder*/
data lnr;
  set &inndata(keep=pid aldersgruppe);
run;

proc sort data=lnr; by pid; run;

proc sort data=lnr nodupkey out=lnr_dupalder;
  by pid aldersgruppe; 
run;

data dupalder;
  set lnr_dupalder;
  by pid aldersgruppe;
  if first.pid =0 or last.pid=0 then output;
run;

title color=darkblue height=5 "2a: &aar - antall pasienter med ulike alder";
proc sql;
  select count(distinct pid) as unikid
  from dupalder;
quit;

proc transpose data=dupalder out=dupalder2;
  by pid;
  var aldersgruppe;
run;

proc sql;
  create table dupalder_data as
  select *
  from &inndata
  where pid in (select distinct pid from dupalder);
quit;

/* -------- */
/* 4 - dato */
/* -------- */
title color=darkblue height=5 "4: &aar - min og maks dato";
proc sql;  
select 	min(dato) 				as mindato format yymmdd10., 
		    max(dato) 				as maxdato format yymmdd10.
from &inndata;
quit;
title;

/* --------------- */
/* Other variables */
/* --------------- */

proc freq data=&inndata;
  tables tknr pasient_kommune_nr
         BEHANDLER_ETTERNAVN PRAKSIS_NAVN 
         lokalisasjon*modalitet/missing nopercent nocol norow;
run;
%mend;