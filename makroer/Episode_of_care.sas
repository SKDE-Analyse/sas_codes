%macro Episode_of_care(dsn=, EOC_tid=28800, ReInn_tid=30, 
	standard_where= and aktivitetskategori3=1 and hastegrad=1, 
	tilleggs_where= , debug = 0);


/*nye tidsvariabler, både dato og tidspunkt på døgnet for ut og inn*/
data &dsn;
set &dsn;
inndatotid=dhms(innDato,0,0,innTid);
utdatotid=dhms(utDato,0,0,utTid);
format inndatotid utdatotid datetime18.;
run;


proc sort data=&dsn;
by pid inndatotid utdatotid;
run;

data &dsn;
set &dsn;
overlapp=.;
lag_pid=lag(pid);
lag_utdatotid=lag(utdatotid);
if lag_pid=pid then do;
	if lag_utdatotid>inndatotid then overlapp=1; /*Dersom inndatotid på dette oppholdet er før utdatotid på forrige opphold*/
	if 0<=inndatotid-lag_utdatotid<&EOC_Tid then innen_t=1; /*Nytt opphold innen 8 timer fra utdatotid på forrige opphold */
	diff=inndatotid-lag_utdatotid; /*Tidsdifferanse (timer) mellom inndatotid på dette oppholdet og utdatotid på forrige opphold */
end;
if overlapp=1 or innen_t=1 then for_innen=1; /*Dersom nytt opphold enten er før forrige eller innen 8t etter forrige*/
format lag_utdatotid datetime18. diff time10.;
run;

proc sort data=&dsn;
by pid inndatotid utdatotid;
run;

DATA &dsn;
_N_ ++1;
If _N_ <= N then do;
Set &dsn point=_N_;
Lead_innen_t=innen_t;
lead_pid=pid;
lead_diff=diff;
end;
set &dsn nobs=n;
run;

data &dsn;
set &dsn;
if (pid=lag_pid and diff>=&EOC_tid) or (Pid ne lag_pid and diff=.) then brudd=1; 
*if innen_t=1 or Lead_innen_t=1 THEN eoc=1; /*hva tenker vi her?*/
format lead_diff time8.;
run;

/*Nummerere EOC-oppholdene*/
proc sort data=&dsn;
by pid brudd inndatotid utdatotid;
run;

data &dsn;
set &dsn;
by pid brudd inndatotid utdatotid;
if brudd=1 then do;
	if first.pid=1 and brudd=1 then EOC_nr_pid=0; /*Nummererer EOC-oppholdene som har blitt merket med brudd*/
	EOC_nr_pid+1;
end;
if brudd=. then EOC_nr_pid=.;
run;

/*
Må også sortere på 'overlapp'. Ellers blir det feil hvis inntid og uttid er lik på to opphold.
*/
proc sort data=&dsn;
by pid inndatotid utdatotid overlapp;
run;

/*Fyller inn blanke, dvs fyller inn EOC_nr_pid på de som ikke er merket med blanke*/
data &dsn;
set &dsn;
retain tempvar 0;
if missing(EOC_nr_pid) = 1 then EOC_nr_pid = tempvar;
else tempvar = EOC_nr_pid;
drop tempvar;
run;

data &dsn;
set &dsn;
EoC_id = pid*1000 + EOC_nr_pid;
run;

proc sort data=&dsn;
by pid EOC_nr_pid inndatotid utdatotid;
run;

data &dsn;
set &dsn;
by pid EOC_nr_pid inndatotid utdatotid;
if first.EOC_nr_pid=1 then EOC_Intern_nr=0; /*Nummerer oppholdene innenfor hver EOC for hver pid*/
	EOC_Intern_nr+1;
run;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(EOC_Intern_nr) AS EOC_Antall_i_EOC, min(inndato) as EOC_inndato, max(utdato) as EOC_utdato
	FROM &dsn
	GROUP BY PID,EOC_nr_pid;
QUIT;

data &dsn;
set &dsn;
EOC_liggetid=EOC_utdato-EOC_inndato;
drop brudd for_innen innen_t lag_utdatotid lead_diff Lead_innen_t lead_pid overlapp;
format EOC_utdato EOC_inndato date10.;
run;

proc sort data=&dsn;
by pid aktivitetskategori3 EOC_nr_pid EOC_Intern_nr inndatotid utdatotid;
run;

data &dsn;
set &dsn;
lag_EOC_utdato=lag(EOC_utdato);
lag_EOC_nr_pid=lag(EOC_nr_pid);
lag_EOC_liggetid=lag(EOC_liggetid);
if pid=lag_pid and lag_EOC_liggetid > 0 then do;
	if EOC_nr_pid ne lag_EOC_nr_pid &standard_where &tilleggs_where then do;
		if EOC_inndato-lag_EOC_utdato<&ReInn_Tid then ReInnleggelse=1;
	end;
end;
run;


proc sort data=&dsn;
by EOC_id;
run;


PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(ReInnleggelse) AS EoC_reinnleggelse, min(aktivitetskategori3) as EoC_aktivitetskategori3
	FROM &dsn
	GROUP BY EOC_id;
QUIT;

proc sort data=&dsn;
by pid EOC_nr_pid EOC_Intern_nr inndatotid utdatotid;
run;


data &dsn;
set &dsn;
%if &debug ne 0 %then %do;
drop lag_pid lag_EOC_utdato lag_EOC_nr_pid lag_EOC_liggetid;
%end;
%else %if &debug eq 0 %then %do;
drop lag_pid lag_EOC_utdato lag_EOC_nr_pid lag_EOC_liggetid ReInnleggelse;
%end;
run;

%mend;
