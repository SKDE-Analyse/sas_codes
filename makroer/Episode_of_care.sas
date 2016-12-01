%macro Episode_of_care(dsn=, EoC_tid=28800, forste_hastegrad = 1, debug = 0, behold_datotid=0);

%let debugnavn = debug;

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
inndatotid=dhms(innDato,0,0,innTid);
utdatotid=dhms(utDato,0,0,utTid);
format inndatotid utdatotid datetime18.;
run;

%if &debug %then %do;
data &debugnavn.1;
set &dsn;
run;
%end;

proc sort data=&dsn;
by pid inndatotid utdatotid;
run;

data &dsn;
set &dsn;
lag_pid=lag(pid);
lag_utdatotid=lag(utdatotid);
if lag_pid=pid then do;
	if lag_utdatotid>inndatotid then EoC_overlapp=1; /*Dersom inndatotid på dette oppholdet er før utdatotid på forrige opphold*/
	if 0<=inndatotid-lag_utdatotid<&EoC_Tid then EoC_innen_t=1; /*Nytt opphold innen 8 timer fra utdatotid på forrige opphold */
	EoC_diff=inndatotid-lag_utdatotid; /*Tidsdifferanse (timer) mellom inndatotid på dette oppholdet og utdatotid på forrige opphold */
end;
*if EoC_overlapp=1 or EoC_innen_t=1 then for_innen=1; /*Dersom nytt opphold enten er før forrige eller innen 8t etter forrige*/
format lag_utdatotid datetime18. EoC_diff time10.;
run;

%if &debug ne 0 %then %do;
data &debugnavn.2;
set &dsn;
run;
%end;

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

%if &debug ne 0 %then %do;
data &debugnavn.3;
set &dsn;
run;
%end;

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
run;

%if &debug ne 0 %then %do;
data &debugnavn.4;
set &dsn;
run;
%end;

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

%if &debug ne 0 %then %do;
data &debugnavn.5;
set &dsn;
run;
%end;

data &dsn;
set &dsn;
by pid EoC_nr_pid inndatotid utdatotid;
if first.EoC_nr_pid=1 then EoC_Intern_nr=0; /*Nummerer oppholdene innenfor hver EoC for hver pid*/
	EoC_Intern_nr+1;
run;

%if &debug ne 0 %then %do;
data &debugnavn.6;
set &dsn;
run;
%end;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(EoC_Intern_nr) AS EoC_Antall_i_EoC, min(inndato) as EoC_inndato, max(utdato) as EoC_utdato, min(inndatotid) as EoC_inndatotid, max(utdatotid) as EoC_utdatotid
	FROM &dsn
	GROUP BY PID,EoC_nr_pid;
QUIT;

%if &debug ne 0 %then %do;
data &debugnavn.7;
set &dsn;
run;
%end;

data &dsn;
set &dsn;
EoC_liggetid=EoC_utdato-EoC_inndato;
if EoC_utdatotid - EoC_inndatotid < 28800 then EoC_liggetid = 0;
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

data &dsn;
set &dsn;
by EoC_id;
if first.EoC_id=1 then forste_hastegrad = hastegrad;
run;

%if &debug ne 0 %then %do;
data &debugnavn.8;
set &dsn;
run;
%end;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *, min(aktivitetskategori3) as EoC_aktivitetskategori3, min(hastegrad) as EoC_hastegrad, max(forste_hastegrad) as EoC_forste_hastegrad
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
