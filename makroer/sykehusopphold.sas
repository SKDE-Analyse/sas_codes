/* This is a macro to replace the old Episode of Care */
/* It takes the aggrshoppID_Lnr from NPR as a starting point, 
   and adds on overføring to other sykehus within a specified time (defult 8 hours) */
   
%macro sykehusopphold(
  dsn=, 
  overforing_tid=28800 /*tid mellom opphold sammenslåing*/, 
  forste_hastegrad = 1, 
  behold_datotid=0,
  nulle_liggedogn = 0,
  minaar=0);
/*!

 ### Beskrivelse
Makro for å markere opphold som regnes som en sykehusepisode. 
Inndatasettet må inneholde pid, inndato, utdato, inntid, uttid, aar, alder, aggrshoppid_lnr, aktivitetskategori3, hastegrad, uttilstand, behsh

```
%sykehusopphold(dsn=, overforing_tid=28800, forste_hastegrad=1, behold_datotid=0, nulle_liggedogn=0, minaar=0);
```
### Parametre

### Input
- `dsn`: datasett man utfører analysen på 
- `overforing_tid` (=28800): tidskrav i sekunder (default 8 timer) for opphold med tidsdifferanse - må være et tall
- `forste_hastegrad` (=1): Hastegrad for første kontakt hvis ulik 0. Hvis 0: hastegrad for første døgnopphold
- `behold_datotid` (=0): Hvis ulik 0, så beholdes disse 
- `nulle_liggedogn` (=0): Hvis forskjellig fra null, så settes antall SHO_liggedogn til null hvis opphold er <8 timer
- `minaar` (=0): dersom man ønsker å bruke første opphold for å definere SHO_Aar
  
Episode of care omfatter da:
- Dersom inndatotid på nytt opphold er før utdatotid på forrige opphold
- Dersom nytt opphold er innen *x* sekunder fra utdatotid på forrige opphold


 
### Output
Makroen lager 12 (eventuelt 14) nye variabler:
1.  `SHO_nr_pid`: Nummererte SHO-opphold pr pid, dersom SHO består av flere opphold har disse samme nummer
2.  `SHO_id`: Unik ID per sykehusopphold (pid+SHO_nr_pid)
3.  `SHO_Intern_nr`: Nummerer oppholdene innenfor hver SHO for hver pid
4.  `SHO_Antall_i_SHO`: Antall opphold i SHO
5.  `SHO_inndato`: inndato på første opphold i SHO
6.  `SHO_utdato`: utdato på siste opphold i SHO
7.  [eventuelt] `SHO_inndatotid`: inntid (dato og tidspunkt) på første opphold i SHO (hvis behold_datotid ulik 0))
8.  [eventuelt] `SHO_utdatotid`: uttid (dato og tidspunkt) på siste opphold i SHO (hvis behold_datotid ulik 0))
9.  `SHO_aar`: år ved utskriving - alternativt minaar=1 (år ved første opphold)
10. `SHO_liggetid`: tidsdifferanse mellom inndatotid på det første oppholdet og utdatotid på det siste oppholdet i SHO
11. `SHO_aktivitetskategori3`: 1 hvis ett av oppholdene er døgn, eller 2 hvis ett av oppholdene er dag (og ingen døgn), eller 3 hvis oppholdene er kun poli
12. `SHO_hastegrad`: 1 hvis ett av oppholdene er akutt, 4 ellers
13. `SHO_forste_hastegrad`: Hastegrad for første avdelingsopphold. 1 for akutt, 4 for elektiv
14. `SHO_uttilstand`: max(uttilstand) for oppholdene i en SHO ("som død" hvis ett av oppholdene er "som død")


### Endringslogg
- 07.09.2021 Opprettet av Janice Shu
 */

/* 
Slette SHO-variabler som lages i denne makroen
*/
data &dsn;
set &dsn;
drop SHO:;
if aggrshoppID_Lnr=. then aggrshoppID_Lnr=1;
run;

 /* First check if required variables are on the dataset, if not exit the macro and print error message */
data _null_;
dset=open("&dsn");

call symput ('chk1',varnum(dset,'inndato'));
call symput ('chk2',varnum(dset,'utdato'));
call symput ('chk3',varnum(dset,'inntid'));
call symput ('chk4',varnum(dset,'uttid'));
call symput ('chk5',varnum(dset,'aar'));
call symput ('chk6',varnum(dset,'alder'));
call symput ('chk7',varnum(dset,'aggrshoppid_lnr'));
call symput ('chk8',varnum(dset,'aktivitetskategori3'));
call symput ('chk9',varnum(dset,'hastegrad'));
call symput ('chk10',varnum(dset,'uttilstand'));
call symput ('chk11',varnum(dset,'behsh'));
run;

%if &chk1=0 or &chk2=0  or &chk3=0  or &chk4=0  or &chk5=0  or &chk6=0  or &chk7=0  or 
    &chk8=0 or &chk9=0  or &chk10=0 or &chk11=0  %then %do;
    %put !!!WARNING!!! At least one of the required input variables is missing on the dataset.;
    %abort ;
%end;

data &dsn;
  set &dsn;
  if inntid=. then inntid=0;
  if uttid=. then uttid=0;
  inndatotid=dhms(innDato,0,0,innTid);
  utdatotid=dhms(utDato,0,0,utTid);
  format inndatotid utdatotid datetime18.;
run;

proc sort data=&dsn out=&dsn;
  by pid inndatotid utdatotid;
run;

/* Lage oppholdsnummer*/

Data &dsn;
  set &dsn;
  by pid inndatotid utdatotid;
  If first.PID=1 then Oppholdsnr=0;
	Oppholdsnr+1;	
run;

proc sort data=&dsn;
  by aktivitetskategori3 pid inndatotid utdatotid;
run;

/*IDENTIFISERE OVERFØRINGER */
/* #### improvement for the future.  keep ony necessary variables when making the first tmp dataset */

data Overforinger;
set &dsn;
retain flag;
retain pasient_flag;

	Lag_PID=Lag(PID);
	Lag_UtDato=Lag(UtDato);
	Lag_UtDatotid=Lag(UtDatotid);
	Lag_BehSh=Lag(BehSh);

  lag_aktkat3=lag(aktivitetskategori3);
  lag_hastegrad=lag(hastegrad);

  /*overføring på døgnopphold*/
  if aktivitetskategori3=1 then do;

	if (PID=LAG_PID) then do;

		/* dager differansen */
		Dager_mellom=InnDato-LAG_UtDato;

		/* Beregne tidsdifferansen mellom opphold */
		Sek_mellom=inndatotid-lag_utdatotid; /* Tidsdifferanse (sekunder) mellom inndatotid på dette oppholdet og utdatotid på forrige opphold */

		/* increase flag value if there is a longer break between opphold */
    	if Dager_mellom>1 then do; 
	 	 flag+1;
     pasient_flag + 1;
    	end;
 
    end;

	else do; /* increase flag value for different pid */
	  flag+1;
    pasient_flag = 1;
	end;

	if BehSH ne LAG_BehSH and sek_mellom ne . and sek_mellom<=&overforing_tid then Overforing=flag;

  end;
run;

/* turn the file upside down so that we can flag the opphold that preceeds the overføring*/
/* look at only døgn  */

proc sort data=Overforinger;
  by aktivitetskategori3 pid descending Oppholdsnr;
run;

data Overforinger;
  set Overforinger;
  lag_overforing=lag(overforing);
  if lag_overforing > 0       then  overforing = lag_overforing; 
run; 

/*sort the file differently to flag akuttpol prior to døgn*/
proc sort DAta=Overforinger;
by pid descending Oppholdsnr;
run;

data Overforinger;
  set Overforinger;
  lag_dogn_etter_akuttpol=lag(dogn_etter_akuttpol);
  if lag_dogn_etter_akuttpol > 0 then  dogn_etter_akuttpol = lag_dogn_etter_akuttpol;
run;

/*sort chronologically*/
proc sort DAta=Overforinger;
by pid  Oppholdsnr;
run;

/*if test, then save intermediate datasets*/
%if %sysevalf(%superq(test)=,boolean) %then %let test = 0;
%if &test=1 %then %do;
data overforing_updown;
  set overforinger;
run;
%end;


/*all lines with same overforing flag get the same SHO_id*/
PROC SQL;
	CREATE TABLE Overforinger AS 
	SELECT *,(MAX(aggrshoppID_Lnr)) AS max_aggrshopp
	FROM Overforinger
	GROUP BY pid, Overforing;
QUIT;

data Overforinger;
  set Overforinger;

/*  assign SHO_id based on aggrshoppid_lnr and overføring*/
  if max_aggrshopp>1 then SHO_id=max_aggrshopp;
  else SHO_id=pid*1000 + pasient_flag;

/*  opphold that is not a part of overføring episode*/
  if overforing=. then SHO_id=aggrshoppID_Lnr;

  length SHO_id 8;
  format SHO_id 13.;
run;

/*all lines with same aggrshoppID_lnr get the same SHO_id*/

proc sort data=Overforinger(keep=pid aggrshoppID_lnr overforing SHO_id) nodupkey out=aggrshopp_newaggr;
  by pid aggrshoppID_lnr;
  where overforing > 0 and aggrshoppID_lnr ne 1;
run;

proc sort data=Overforinger;
  by pid aggrshoppID_lnr;
run;

data Overforinger;
  merge Overforinger (in=a rename=(SHO_id=old_aggr)) 
		aggrshopp_newaggr (in=b keep=pid aggrshoppID_lnr SHO_id rename=(SHO_id=new_aggr));
  by pid aggrshoppID_lnr;

  if b then SHO_id=new_aggr;
  else      SHO_id=old_aggr;

  if a;

  SHO_id_tmp=SHO_id;
  if SHO_id = 1 then SHO_id	= pid*1000+oppholdsnr;

  length SHO_id 8;
  format SHO_id 13.;
run;

/*make all lines with SHO_id in the format of pid*1000 + a number*/
/*give SHO_id that are same as aggrshoppID_lnr a new id in the same format as others*/

PROC SQL;
	CREATE TABLE overforinger AS 
	SELECT *,(MIN(oppholdsnr)) AS min_oppholdsnr
	FROM overforinger
	GROUP BY pid, SHO_id;
QUIT;

data overforinger;
  set overforinger;
  SHO_id_tmp2=SHO_id;
  if SHO_id_tmp ne 1 then SHO_id = pid*1000+min_oppholdsnr;
  length SHO_id_tmp2 8;
  format SHO_id_tmp2 13.;

run;

/*sort file by chronological order*/
proc sort data=Overforinger;
  by pid inndatotid utdatotid;
run;

/*place variables in interest together for ease of reading and checking data*/
data Overforinger;
  retain pid inndato utdato aktivitetskategori3 behSh aggrshoppID_lnr overforing SHO_id;
  set Overforinger;
run;

/*merge new sho variables back to original dataset*/

proc sql;
  create table &dsn as
  select a.*, b.SHO_id, b.min_oppholdsnr as SHO_nr_pid
  from &dsn a, overforinger b
  where a.pid=b.pid
    and a.oppholdsnr=b.oppholdsnr
  order by a.pid, b.min_oppholdsnr, a.inndatotid, a.utdatotid;
quit;


/*create SHO_id level variables*/

data &dsn;
set &dsn;
by pid SHO_nr_pid inndatotid utdatotid;
if first.SHO_nr_pid=1 then SHO_Intern_nr=0; /*Nummerer oppholdene innenfor hver SHO for hver pid*/
	SHO_Intern_nr+1;
run;

%if &minaar ne 1 %then %do;
PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(SHO_Intern_nr) AS SHO_Antall_i_SHO, min(inndato) as SHO_inndato, max(utdato) as SHO_utdato, min(inndatotid) as SHO_inndatotid, max(utdatotid) as SHO_utdatotid, max(aar) as SHO_aar
	FROM &dsn
	GROUP BY PID,SHO_nr_pid;
QUIT;
%end;

%if &minaar = 1 %then %do;
PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(SHO_Intern_nr) AS SHO_Antall_i_SHO, min(inndato) as SHO_inndato, max(utdato) as SHO_utdato, min(inndatotid) as SHO_inndatotid, max(utdatotid) as SHO_utdatotid, min(aar) as SHO_aar
	FROM &dsn
	GROUP BY PID,SHO_nr_pid;
QUIT;
%end;


data &dsn;
set &dsn;
	SHO_liggetid=SHO_utdato-SHO_inndato;
%if &nulle_liggedogn ne 0 %then %do; /* Nulle ut liggetid hvis oppholdet er mindre enn åtte timer */
	if SHO_utdatotid - SHO_inndatotid < 28800 then SHO_liggetid = 0;
%end;
run;


/*
Hastegrad for første opphold, hvis forste_hastegrad = 1, eller første døgnopphold
*/
proc sort data=&dsn;
%if &forste_hastegrad ne 0 %then %do;
by SHO_id SHO_Intern_nr inndatotid utdatotid;
%end;
%else %do;
by SHO_id aktivitetskategori3 SHO_Intern_nr inndatotid utdatotid;
%end;
run;

data &dsn;
set &dsn;
by SHO_id;
/* To avoid setting SHO_hastegrad to missing, since "." is less than 0 */
tmp_hastegrad = hastegrad;
if hastegrad = . then tmp_hastegrad = 99;
if first.SHO_id=1 then forste_hastegrad = hastegrad;
aktkat = aktivitetskategori3;
if uttilstand > 1 then aktkat = 1;
run;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *, min(aktkat) as SHO_aktivitetskategori3, 
   min(tmp_hastegrad) as SHO_hastegrad, 
   max(forste_hastegrad) as SHO_forste_hastegrad, max(uttilstand) as SHO_uttilstand, max(alder) as SHO_alder
	FROM &dsn
	GROUP BY SHO_id;
QUIT;

proc sort data=&dsn;
by pid SHO_nr_pid SHO_Intern_nr inndatotid utdatotid;
run;

data &dsn;
set &dsn;
if SHO_hastegrad = 99 then SHO_hastegrad = .;
/* Nulle liggedøgn hvis poliklinisk kontakt */
if SHO_aktivitetskategori3 = 3 then SHO_liggetid = 0;
drop lag_pid SHO_diff inndatotid utdatotid forste_hastegrad aktkat tmp_poli;
format SHO_utdato SHO_inndato date10.;
format SHO_inndatotid SHO_utdatotid datetime18.;
format SHO_aktivitetskategori3 aktivitetskategori3f.;
format SHO_hastegrad SHO_forste_hastegrad hastegrad.;
%if &behold_datotid = 0 %then %do;
drop SHO_inndatotid SHO_utdatotid;
drop tmp_hastegrad;
%end;
run;

/*if not test, then delete intermediate datasets*/
%if %sysevalf(%superq(test)=,boolean) %then %let test = 0;
%if &test=0 %then %do;
  proc datasets nolist;
  	delete AGGRSHOPP_NEWAGGR OVERFORINGER;
  run;
%end;

%mend;