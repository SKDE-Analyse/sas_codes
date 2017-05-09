%macro Episode_of_care(dsn=, EoC_tid=28800, forste_hastegrad = 1, behold_datotid=0, debug = 0, nulle_liggedogn = 0);

/* 
Slette EoC-variabler som lages i denne makroen
*/
data &dsn;
set &dsn;
drop EoC:;
run;

/*
Nye tidsvariabler, både dato og tidspunkt på døgnet for ut og inn
*/
data &dsn;
set &dsn;
if inntid=. then inntid=0;
if uttid=. then uttid=0;
inndatotid=dhms(innDato,0,0,innTid);
utdatotid=dhms(utDato,0,0,utTid);
format inndatotid utdatotid datetime18.;
run;

proc sort data=&dsn;
by pid inndatotid utdatotid;
run;

data &dsn(drop = tmp_utdatotid);
set &dsn;
by pid;

retain tmp_utdatotid;

if first.pid then do;
	tmp_utdatotid = utdatotid;
end; 
	
lag_pid=lag(pid);
lag_utdatotid=lag(utdatotid);
if lag_pid=pid then do;
	if lag_utdatotid>inndatotid then EoC_overlapp=1;
	EoC_diff=inndatotid-tmp_utdatotid; /*Tidsdifferanse (timer) mellom inndatotid på dette oppholdet og utdatotid på forrige opphold */
	if EoC_diff>&EoC_Tid then do;
		tmp_utdatotid = utdatotid;
	end;
	else if utdatotid > tmp_utdatotid then do;
		tmp_utdatotid = utdatotid;
	end;
end;
format lag_utdatotid datetime18. EoC_diff time10.;
run;

proc sort data=&dsn;
by pid inndatotid utdatotid;
run;

data &dsn;
set &dsn;
if (pid=lag_pid and EoC_diff>=&EoC_tid) or (Pid ne lag_pid and EoC_diff=.) then EoC_brudd=1; 
run;

/*Nummerere EoC-oppholdene*/
proc sort data=&dsn;
by pid EoC_brudd inndatotid utdatotid;
run;

data &dsn;
set &dsn;
by pid EoC_brudd inndatotid utdatotid;
if EoC_brudd=1 then do;
	if first.pid=1 and EoC_brudd=1 then EoC_nr_pid=0; /*Nummererer EoC-oppholdene som har blitt merket med EoC_brudd*/
	EoC_nr_pid+1;
end;
if EoC_brudd=. then EoC_nr_pid=.;
run;

proc sort data=&dsn;
by pid inndatotid utdatotid EoC_overlapp;
*by pid inndatotid utdatotid;
run;

/*Fyller inn blanke, dvs fyller inn EoC_nr_pid på de som ikke er merket med blanke*/
data &dsn;
set &dsn;
retain tempvar 0;
if missing(EoC_nr_pid) = 1 then EoC_nr_pid = tempvar;
else tempvar = EoC_nr_pid;
drop tempvar;
run;

data &dsn;
set &dsn;
EoC_id = pid*1000 + EoC_nr_pid;
run;

proc sort data=&dsn;
by pid EoC_nr_pid inndatotid utdatotid;
run;

data &dsn;
set &dsn;
by pid EoC_nr_pid inndatotid utdatotid;
if first.EoC_nr_pid=1 then EoC_Intern_nr=0; /*Nummerer oppholdene innenfor hver EoC for hver pid*/
	EoC_Intern_nr+1;
run;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(EoC_Intern_nr) AS EoC_Antall_i_EoC, min(inndato) as EoC_inndato, max(utdato) as EoC_utdato, min(inndatotid) as EoC_inndatotid, max(utdatotid) as EoC_utdatotid, max(aar) as EoC_aar
	FROM &dsn
	GROUP BY PID,EoC_nr_pid;
QUIT;

data &dsn;
set &dsn;
	EoC_liggetid=EoC_utdato-EoC_inndato;
%if &nulle_liggedogn ne 0 %then %do; * Nulle ut liggetid hvis oppholdet er mindre enn åtte timer;
	if EoC_utdatotid - EoC_inndatotid < 28800 then EoC_liggetid = 0;
%end;
	drop EoC_brudd EoC_innen_t lag_utdatotid EoC_overlapp;
run;

/*
Hastegrad for første opphold, hvis forste_hastegrad = 1, eller første døgnopphold
*/
proc sort data=&dsn;
%if &forste_hastegrad ne 0 %then %do;
by EoC_id EoC_Intern_nr inndatotid utdatotid;
%end;
%else %do;
by EoC_id aktivitetskategori3 EoC_Intern_nr inndatotid utdatotid;
%end;
run;

/*
EoC_hastegrad regnes kun på innleggelser (AHS, 9. mai 2017)
*/
data &dsn;
set &dsn;
by EoC_id;
if first.EoC_id=1 then forste_hastegrad = hastegrad;
if aktivitetskategori3 = 1 then hastegrad_inn = hastegrad;
run;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *, min(aktivitetskategori3) as EoC_aktivitetskategori3, min(hastegrad_inn) as EoC_hastegrad, max(forste_hastegrad) as EoC_forste_hastegrad, max(uttilstand) as EoC_uttilstand, max(alder) as EoC_alder
	FROM &dsn
	GROUP BY EoC_id;
QUIT;

proc sort data=&dsn;
by pid EoC_nr_pid EoC_Intern_nr inndatotid utdatotid;
run;

data &dsn;
set &dsn;
%if &debug ne 0 %then %do;
drop lag_pid;
%end;
%else %if &debug eq 0 %then %do;
drop lag_pid EoC_diff inndatotid utdatotid forste_hastegrad;
%end;
format EoC_utdato EoC_inndato date10.;
format EoC_inndatotid EoC_utdatotid datetime18.;
format EoC_aktivitetskategori3 aktivitetskategori3f.;
format EoC_hastegrad EoC_forste_hastegrad hastegrad.;
%if &behold_datotid = 0 %then %do;
drop EoC_inndatotid EoC_utdatotid;
%end;

run;

%mend;
