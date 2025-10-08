/******************/
/*HVA KONTROLLERES*/
/******************/

/* 1) Sjekk om enkeltregning_lnr fra hovedfil også gjenfinnes i satelitter*/

%macro kpr_kobling_takst_diagnose(aar=);

/***********************************************************/
/* Gjenfinnes enkeltregning_lnr fra hovedfil i satelittene?*/
/***********************************************************/

data regninglnr_&aar.;
    if _N_ = 1 then do;
        declare hash h_diag(dataset:"&inn_diag(keep=enkeltregning_lnr)");
        h_diag.defineKey('enkeltregning_lnr');
        h_diag.defineDone();

        declare hash h_takst(dataset:"&inn_takst(keep=enkeltregning_lnr)");
        h_takst.defineKey('enkeltregning_lnr');
        h_takst.defineDone();
    end;
    set &inn(keep=enkeltregning_lnr tjenestetype);
    ok_diag = (h_diag.find() = 0);
    ok_takst = (h_takst.find() = 0);
run;

/* Count total regninger */
proc sql noprint;
  select count(distinct enkeltregning_lnr) into :regning from regninglnr_&aar.;
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

title color=darkblue height=5 '2a: Diagnosefilen: sjekk mot utleveringsinfo';
proc print data=diag_&aar;run;

proc sql noprint;
  select diff_regning_diag, miss_diag, n_kodeverk
    into :diff_diag, :miss_diag, :kodeverk
    from diag_&aar.;
quit;

%if &diff_diag ne 0 %then %do;
title color=red height=5 "2b: Finner ikke &diff_diag enkeltregning_lnr i diagnose-filen!!";
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
title color=red height=5 "2c: Diagnosefilen: &miss_diag linjer uten diagnosekode";
proc sql;
  create table m (note char(25));
  insert into m values ('WARNING! MÅ SE NÆRMERE');
  select *
  from m;
quit;
%end;

%if &kodeverk ne 3 %then %do;
title color=red height=5 "2d: Diagnosefilen: kun &kodeverk kodeverk - skulle være 3 (ICD-10, ICPC-2, ICPC-2B)";
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

title color=darkblue height=5 '3a: Takstfilen: sjekk mot utleveringsinfo';
proc print data=takst_&aar;run;

proc sql noprint;
  select diff_regning_takst, miss_takst
    into :diff_takst, :miss_takst
    from takst_&aar.;
quit;

%if &diff_takst ne 0 %then %do;
title color=red height=5 "3b: Finner ikke &diff_takst enkeltregning_lnr i takst-filen!!";
proc sql;
	select tjenestetype, count(*) as rad_takst
	from regninglnr_&aar.
	where ok_takst ne 1
	group by tjenestetype;
quit;
%end;
%else %do;
title color=darkblue height=5 '3c: All enkeltregning_lnr fra hovedfilen er ikke i takst-filen :-)';
proc sql;
  create table m (note char(12));
  insert into m values ('All is good!');
  select *
  from m;
quit;
%end;

%if &miss_takst ne 0 %then %do;
title color=red height=5 "3d: Takstfilen: &miss_takst linjer uten takstkode";
proc sql;
  create table m (note char(25));
  insert into m values ('WARNING! MÅ SE NÆRMERE');
  select *
  from m;
quit;
%end;

proc datasets nolist;
delete regninglnr_&aar.  diag_&aar. takst_&aar.;
run;

%mend;