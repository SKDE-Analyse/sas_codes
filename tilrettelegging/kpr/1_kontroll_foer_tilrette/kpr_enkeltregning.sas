/******************/
/*HVA KONTROLLERES*/
/******************/

/* 1) Unike enkeltregning_lnr på tvers av år*/
/* 2) Sjekk om enkeltregning_lnr fra hovedfil også gjenfinnes i satelitter*/

%macro kpr_enkeltregning;

/***************************************************************/
/* a) Finnes det duplikate enkeltregning_lnr på tvers av årene?*/
/***************************************************************/

data regninglnr;
set 
HNMOT.KPR_L_ENKELTREGNING_2019_M21T3(keep=enkeltregning_lnr)
HNMOT.KPR_L_ENKELTREGNING_2020_M21T3(keep=enkeltregning_lnr)
HNMOT.KPR_L_ENKELTREGNING_2021_M21T3(keep=enkeltregning_lnr)
HNMOT.KPR_L_ENKELTREGNING_2022_M22T3(keep=enkeltregning_lnr)
&inn(keep=enkeltregning_lnr)
;
run;
/* dup_regning skal være tom - DVS INGEN DUPLIKATER*/
proc sort data=regninglnr nodupkey out=unique dupout=dup_regning;
by enkeltregning_lnr;
run;

proc sql noprint;
  select count(*) into :ndup from dup_regning;
quit;

%put &ndup;

%if &ndup=0 %then %do;
title color=darkblue height=5 '2a: ingen duplicater av enkeltregning_lnr på tvers årene';
proc sql;
  create table m (note char(12));
  insert into m values ('All is good!');
  select *
  from m;
quit;
%end;
%else %do;
title color=red height=5 '2a: duplicater av enkeltregning_lnr - skal ikke være!!';
proc sql;
  select count(*) as ndup_enkeltregning_lnr from dup_regning;
quit;
%end;


/**************************************************************/
/* b) Gjenfinnes enkeltregning_lnr fra hovedfil i satelittene?*/
/**************************************************************/

proc sql;
	create table regninglnr_&aar. as
	select distinct enkeltregning_lnr, tjenestetype,
		case when enkeltregning_lnr in (select enkeltregning_lnr from &inn_diag ) then 1 end as ok_diag,
		case when enkeltregning_lnr in (select enkeltregning_lnr from &inn_takst ) then 1 end as ok_takst
	from &inn;
quit;

proc freq data=regninglnr_&aar.;
  tables ok_diag* ok_takst / norow nocol nopercent missing;
run;

proc sql noprint;
  select count(*) into :regning from regninglnr_&aar.;
quit;

/* ----------- */
/* DIAGNOSEFIL */
/* ----------- */
/*antall unike regninger i diagnosefil, burde være lik antall regninger i hovedfil*/
PROC SQL;
CREATE TABLE diag_&aar. AS
  SELECT  &aar as aar,
          count(distinct enkeltregning_lnr) 	as unik_regning_diag ,
		  &regning-calculated unik_regning_diag as diff_regning_diag ,
    	  min(aar) 					 			as minaar, 
          max(aar) 								as maxaar,
		  sum(missing(diagnosekode))			as miss_diag,
		  count(distinct diagnoseTabell)		as n_kodeverk
  FROM &inn_diag;
QUIT;


title color=darkblue height=5 '2b: Diagnosefilen: sjekk mot utleveringsinfo';
proc print data=diag_&aar;run;

proc sql noprint;
  select diff_regning_diag, miss_diag, n_kodeverk
    into :diff_diag, :miss_diag, :kodeverk
    from diag_&aar.;
quit;

%if &diff_diag ne 0 %then %do;
title color=red height=5 "2b: Mangler &diff_diag enkeltregning_lnr fra hovedfilen i diagnose-filen!!";
proc sql;
	select tjenestetype, count(*) as rad_diag
	from regninglnr_&aar.
	where ok_diag ne 1
	group by tjenestetype;
quit;
%end;
%else %do;
title color=darkblue height=5 '2b: All enkeltregning_lnr fra hovedfilen er i diagnose-filen :-)';
proc sql;
  create table m (note char(12));
  insert into m values ('All is good!');
  select *
  from m;
quit;
%end;

%if &miss_diag ne 0 %then %do;
title color=red height=5 "2b: Diagnosefilen: &miss_diag linjer uten diagnosekode";
proc sql;
  create table m (note char(25));
  insert into m values ('WARNING! MÅ SE NÆRMERE');
  select *
  from m;
quit;
%end;

%if &kodeverk ne 3 %then %do;
title color=red height=5 "2b: Diagnosefilen: kun &kodeverk kodeverk - skulle være 3 (ICD-10, ICPC-2, ICPC-2B)";
proc sql;
  select distinct diagnoseTabell
  from &inn_diag;
quit;
%end;





/* -------- */
/* TAKSTFIL */
/* -------- */
/* Finnes regningsnummer fra hovedfilen i takst filen? */
/*antall unike regninger i takstfil, burde være lik antall regninger i hovedfil*/
PROC SQL;
CREATE TABLE takst_&aar. AS
  SELECT  &aar as aar,
          count(distinct enkeltregning_lnr) 	as unik_regning_takst, 
		  &regning-calculated unik_regning_takst as diff_regning_takst,
		  min(aar) 					 			as minaar, 
          max(aar) 								as maxaar,
		  sum(missing(takstKode))				as miss_takst

  FROM &inn_takst;
QUIT;

title color=darkblue height=5 '2c: Takstfilen: sjekk mot utleveringsinfo';
proc print data=takst_&aar;run;

proc sql noprint;
  select diff_regning_takst, miss_takst
    into :diff_takst, :miss_takst
    from takst_&aar.;
quit;

%if &diff_takst ne 0 %then %do;
title color=red height=5 "2c: Mangler &diff_takst enkeltregning_lnr fra hovedfilen i takst-filen!!";
proc sql;
	select tjenestetype, count(*) as rad_takst
	from regninglnr_&aar.
	where ok_takst ne 1
	group by tjenestetype;
quit;
%end;
%else %do;
title color=darkblue height=5 '2c: All enkeltregning_lnr fra hovedfilen er ikke i takst-filen :-)';
proc sql;
  create table m (note char(12));
  insert into m values ('All is good!');
  select *
  from m;
quit;
%end;

%if &miss_takst ne 0 %then %do;
title color=red height=5 "2c: Takstfilen: &miss_takst linjer uten takstkode";
proc sql;
  create table m (note char(25));
  insert into m values ('WARNING! MÅ SE NÆRMERE');
  select *
  from m;
quit;
%end;



proc datasets nolist;
delete regninglnr regninglnr_&aar.  diag_&aar. takst_&aar. unique dup_regning;
run;

%mend kpr_enkeltregning;