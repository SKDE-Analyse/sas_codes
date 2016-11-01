%macro Episode_of_care(dsn=,tidskrav=);

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
	if 0<=inndatotid-lag_utdatotid<&tidskrav then innen_t=1; /*Nytt opphold innen 8 timer fra utdatotid på forrige opphold */
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
if (pid=lag_pid and diff>=&tidskrav) or (Pid ne lag_pid and diff=.) then brudd=1; 
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

proc sort data=&dsn;
by pid inndatotid utdatotid;
run;

/*Fyller inn blanke, dvs fyller inn EOC_nr_pid på de som ikke er merket med blanke*/
data &dsn;
set &dsn;
retain tempvar 0;
if missing(EOC_nr_pid) = 1 then EOC_nr_pid = tempvar;
else tempvar = EOC_nr_pid;
drop tempvar;
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
	SELECT *,MAX(EOC_Intern_nr) AS EOC_Antall_i_EOC, min(inndato) as EOC_startdato, max(utdato) as EOC_sluttdato
	FROM &dsn
	GROUP BY PID,EOC_nr_pid;
QUIT;

data &dsn;
set &dsn;
EOC_liggetid=EOC_sluttdato-EOC_startdato;
drop brudd for_innen innen_t lag_pid lag_utdatotid lead_diff Lead_innen_t lead_pid overlapp;
format EOC_sluttdato EOC_startdato date10.;
run;

proc sort data=&dsn;
by pid inndatotid utdatotid;
run;
%mend Episode_of_care(dsn=,tidskrav=);