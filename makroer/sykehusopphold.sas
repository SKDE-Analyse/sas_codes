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
- juni 2022, fikset bug som ga duplikate sho_id (den slo sammen rader som ikke hørte sammen, og ga dermed feil i sho-variablene)
 */

/* Slette SHO-variabler og andre variabler som lages i denne makroen */
data &dsn;
set &dsn;
drop SHO: oppholdsnr utdatotid inndatotid;
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
  /*hvis ikke aggrshoppid_lnr -> settes til lik 1*/
  if aggrshoppID_Lnr=. then aggrshoppID_Lnr=1;
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

/*sortere på aktivitetskategori, døgn kommer først*/
proc sort data=&dsn;
  by aktivitetskategori3 pid inndatotid utdatotid;
run;

/*IDENTIFISERE OVERFØRINGER */
data Overforinger;
set &dsn(keep=pid aar uttilstand alder aggrshoppid_lnr utdato inndato 
    inndatotid utdatotid behsh aktivitetskategori3 hastegrad oppholdsnr);
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
      pasient_flag + 1;
    	end;
    end;

	else do; /* sett til variabel pasient_flag til null når pid skifter */
    pasient_flag = 1;
	end;

	if BehSH ne LAG_BehSH and sek_mellom ne . and sek_mellom<=&overforing_tid then Overforing=pasient_flag;
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
  if lag_overforing > 0 then  overforing = lag_overforing; 
run; 

/*if test, then save intermediate datasets*/
%if %sysevalf(%superq(test)=,boolean) %then %let test = 0;
%if &test=1 %then %do;
data overforing_updown;
  set overforinger;
run;
%end;

/* 1) først la radene med overforing få samme aggrshopp*/
PROC SQL;
	CREATE TABLE Overforinger AS 
	SELECT *, MAX(aggrshoppID_Lnr) AS max_aggrshopp 
	FROM Overforinger
	GROUP BY pid, Overforing;
QUIT;


/* 2) alle aggrshoppid_lnr som inngår i overforing gis lik aggrshopp */
proc sort data=overforinger nodupkey out=overforinger_out(rename=(max_aggrshopp=ny_aggrshopp) keep=aggrshoppid_lnr max_aggrshopp);
by aggrshoppID_Lnr ; where overforing ne . and aggrshoppid_lnr ne 1; run;
proc sort data=overforinger;by aggrshoppid_lnr;run;

data overforinger2;
merge overforinger (in=a) overforinger_out(in=b);
by aggrshoppid_lnr;
run;

/*3) til sist fikse slik at alle rader med overforing har samme aggrshopp*/
proc sort data=overforinger2 nodupkey out=overforinger2_out(rename=(ny_aggrshopp=ny_aggrshopp2)keep=pid ny_aggrshopp overforing);
by pid overforing  ; where overforing ne . and ny_aggrshopp ne .; run;
proc sort data=overforinger2;by pid overforing ;run;

data overforinger3;
merge overforinger2 (in=a) overforinger2_out(in=b);
by pid overforing;
run;

/*fikse final_aggrshopp for overføringer med flere isf-opphold(aggrshopper)*/
data overforinger3;
set overforinger3;
if ny_aggrshopp ne . then final_aggrshopp = ny_aggrshopp;
else if ny_aggrshopp2 ne . then final_aggrshopp = ny_aggrshopp2;
run;

/*lager en temp_id, gi lik id- til alle rader, både isf-opphold og overføringer vi har identifisert*/
data overforinger4;
set overforinger3;
if aggrshoppid_lnr eq 1 and overforing eq . then temp_id = 1; 
else if aggrshoppid_lnr eq 1 and overforing ne . then do;
	if final_aggrshopp ne . then temp_id = final_aggrshopp;
	else if final_aggrshopp eq . then temp_id = 1;
	end;
else if aggrshoppid_lnr gt 1 then do;
	if final_aggrshopp ne . then temp_id = final_aggrshopp;
	else if final_aggrshopp eq . then temp_id = aggrshoppid_lnr;
	end;
run;

/*aggregere oppholdsnr på overforing og temp_id*/
PROC SQL;
	CREATE TABLE overforinger4 AS 
	SELECT *, MIN(oppholdsnr) as min_opphold
	FROM overforinger4
	GROUP BY pid, overforing;
QUIT;
PROC SQL;
	CREATE TABLE overforinger4 AS 
	SELECT *, MIN(oppholdsnr) as min_opphold2
	FROM overforinger4
	GROUP BY pid, temp_id;
QUIT;

/* lage SHO_id */
data Overforinger4;
  set Overforinger4;

  length SHO_id 8;
  format SHO_id 13.;
/*overføringer som inngår i isf-opphold*/
if overforing ne . and temp_id > 1 			then sho_id = pid*1000 + min_opphold2;
/*overføringer som ikke inngår i isf-opphold*/
else if overforing ne . and temp_id eq 1 	then sho_id = pid*1000 + min_opphold;
/*ikke overføring, men sho etter isf-definisjon (aggrshoppid_lnr har verdi) */
else if overforing eq . and temp_id ne 1 	then sho_id = pid*1000 + min_opphold2;
/*ikke overføring, ikke sho etter isf-definisjon (aggrshoppid_lnr lik 1) */
else if overforing eq . and temp_id eq 1 	then sho_id = pid*1000 + oppholdsnr;
run;

/*lage antall sho pr pid (sho_nr_pid)  */
proc sort data=overforinger4;
by pid sho_id;
run;

data overforinger4;
set overforinger4;
by pid sho_id;
if first.pid then sho_nr_pid = 0;
	if first.sho_id then sho_nr_pid +1;
run;

proc sort data=overforinger4;
by pid sho_nr_pid inndatotid utdatotid;
run;
/*create SHO_id level variables*/
data overforinger4;
set overforinger4;
by pid SHO_nr_pid inndatotid utdatotid;
if first.SHO_nr_pid=1 then SHO_Intern_nr=0; 
	SHO_Intern_nr+1;
run;

%if &minaar ne 1 %then %do;
PROC SQL;
	CREATE TABLE overforinger4 AS 
	SELECT *, MAX(SHO_Intern_nr) AS SHO_Antall_i_SHO, 
				min(inndato) as SHO_inndato, 
				max(utdato) as SHO_utdato, 
				min(inndatotid) as SHO_inndatotid, 
				max(utdatotid) as SHO_utdatotid, 
				max(aar) as SHO_aar
	FROM overforinger4
	GROUP BY PID,SHO_nr_pid;
QUIT;
%end;

%if &minaar = 1 %then %do;
PROC SQL;
	CREATE TABLE overforinger4 AS 
	SELECT *,	MAX(SHO_Intern_nr) AS SHO_Antall_i_SHO, 
				min(inndato) as SHO_inndato, 
				max(utdato) as SHO_utdato, 
				min(inndatotid) as SHO_inndatotid, 
				max(utdatotid) as SHO_utdatotid, 
				min(aar) as SHO_aar
	FROM overforinger4
	GROUP BY PID,SHO_nr_pid;
QUIT;
%end;

data overforinger4;
set overforinger4;
	SHO_liggetid=SHO_utdato-SHO_inndato;
%if &nulle_liggedogn ne 0 %then %do; /* Nulle ut liggetid hvis oppholdet er mindre enn åtte timer */
	if SHO_utdatotid - SHO_inndatotid < 28800 then SHO_liggetid = 0;
%end;
run;

/*Hastegrad for første opphold, hvis forste_hastegrad = 1, eller første døgnopphold*/
proc sort data=overforinger4;
%if &forste_hastegrad ne 0 %then %do;
by SHO_id SHO_Intern_nr inndatotid utdatotid;
%end;
%else %do;
by SHO_id aktivitetskategori3 SHO_Intern_nr inndatotid utdatotid;
%end;
run;

data overforinger4;
set overforinger4;
by SHO_id;
/* To avoid setting SHO_hastegrad to missing, since "." is less than 0 */
tmp_hastegrad = hastegrad;
if hastegrad = . then tmp_hastegrad = 99;
if first.SHO_id=1 then forste_hastegrad = hastegrad;
aktkat = aktivitetskategori3;
if uttilstand > 1 then aktkat = 1;
run;

PROC SQL;
	CREATE TABLE overforinger4 AS 
	SELECT *, min(aktkat) as SHO_aktivitetskategori3, 
   			min(tmp_hastegrad) as SHO_hastegrad, 
   			max(forste_hastegrad) as SHO_forste_hastegrad, 
			max(uttilstand) as SHO_uttilstand, 
			max(alder) as SHO_alder
	FROM overforinger4
	GROUP BY SHO_id;
QUIT;

proc sort data=overforinger4;
by pid SHO_nr_pid SHO_Intern_nr inndatotid utdatotid;
run;

data overforinger4;
set overforinger4;
if SHO_hastegrad = 99 then SHO_hastegrad = .;
/* Nulle liggedøgn hvis poliklinisk kontakt */
if SHO_aktivitetskategori3 = 3 then SHO_liggetid = 0;
drop lag_pid pasient_flag temp_id lag_utdato lag_behsh 
		min_opphold min_opphold2 inndatotid utdatotid forste_hastegrad aktkat lag_aktkat3
		dager_mellom sek_mellom overforing lag_overforing max_aggrshopp lag_hastegrad
		lag_utdatotid ny_aggrshopp ny_aggrshopp2 final_aggrshopp inndato utdato alder hastegrad
		aktivitetskategori3 behsh uttilstand aggrshoppID_Lnr;
format SHO_utdato SHO_inndato date10.;
format SHO_inndatotid SHO_utdatotid datetime18.;
format SHO_aktivitetskategori3 aktivitetskategori3f.;
format SHO_hastegrad SHO_forste_hastegrad hastegrad.;
%if &behold_datotid = 0 %then %do;
drop SHO_inndatotid SHO_utdatotid;
drop tmp_hastegrad;
%end;
run;

/*merge new sho variables back to original dataset*/
proc sql;
  create table &dsn as
  select a.*, b.*
  from &dsn a, overforinger4 b
  where a.pid=b.pid
    and a.oppholdsnr=b.oppholdsnr
  order by a.pid, b.sho_nr_pid, b.sho_intern_nr;
quit;

/*if not test, then delete intermediate datasets*/
%if %sysevalf(%superq(test)=,boolean) %then %let test = 0;
%if &test=0 %then %do;
  proc datasets nolist;
  	delete OVERFORINGER:;
  run;
%end;
%mend;