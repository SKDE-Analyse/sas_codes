%macro Episode_of_care(dsn=, EoC_tid=28800, forste_hastegrad = 1, behold_datotid=0, debug = 0, nulle_liggedogn = 0, kols = 0);
/*!
### Beskrivelse

Inndatasettet m� inneholde inndato utdato inntid og uttid
inntid og uttid m� (forel�pig) hentes fra parvus

```
%Episode_of_care(dsn=, Eoc_tid=28800, forste_hastegrad=1, behold_datotid=0, debug=0, nulle_liggedogn=0);
```

### Parametre

1. `dsn`: datasett man utf�rer analysen p�
2. `Eoc_tid` (=28800): tidskrav i sekunder (default 28800 er 8 timer) for opphold med tidsdifferanse - m� v�re et tall
3. `forste_hastegrad` (=1): Hastegrad for f�rste kontakt hvis ulik 0. Hvis 0: hastegrad for f�rste d�gnopphold
4. `behold_datotid` (=0): Hvis ulik 0, s� beholdes disse 
5. `debug` (=0): Spytter ut midlertidige datasett hvis forskjellig fra null
6. `nulle_liggedogn` (=0): Hvis forskjellig fra null, s� settes antall EoC_liggedogn til null hvis opphold er <8 timer

Episode of care omfatter da:
- Dersom inndatotid p� nytt opphold er f�r utdatotid p� forrige opphold
- Dersom nytt opphold er innen *x* sekunder fra utdatotid p� forrige opphold

### Variabler

Makroen lager 12 (eventuelt 14) nye variabler:
1.  `EoC_nr_pid`: Nummererte EoC-opphold pr pid, dersom EoC best�r av flere opphold har disse samme nummer
2.  `EoC_id`: Unik ID for hver EoC (pid+EoC_nr_pid)
3.  `EoC_Intern_nr`: Nummerer oppholdene innenfor hver EoC for hver pid
4.  `EoC_Antall_i_EoC`: Antall opphold i EoC
5.  `EoC_inndato`: inndato p� f�rste opphold i EoC
6.  `EoC_utdato`: utdato p� siste opphold i EoC
7.  [eventuelt] `EoC_inndatotid`: inntid (dato og tidspunkt) p� f�rste opphold i EoC (hvis behold_datotid ulik 0))
8.  [eventuelt] `EoC_utdatotid`: uttid (dato og tidspunkt) p� siste opphold i EoC (hvis behold_datotid ulik 0))
9.  `EoC_aar`: �r ved utskriving
10. `EoC_liggetid`: tidsdifferanse mellom inndatotid p� det f�rste oppholdet og utdatotid p� det siste oppholdet i EoC
11. `EoC_aktivitetskategori3`: 1 hvis ett av oppholdene er d�gn, eller 2 hvis ett av oppholdene er dag (og ingen d�gn), eller 3 hvis oppholdene er kun poli
12. `EoC_hastegrad`: 1 hvis ett av oppholdene er akutt, 4 ellers
13. `EoC_forste_hastegrad`: Hastegrad for f�rste avdelingsopphold. 1 for akutt, 4 for elektiv
14. `EoC_uttilstand`: max(uttilstand) for oppholdene i en EoC ("som d�d" hvis ett av oppholdene er "som d�d")

### Forfatter

Opprettet 26.10.2016 av Frank Olsen

Endret 26.10.2016 av Frank Olsen

Endret 29.11.2016 av Arnfinn

*/

/* 
Slette EoC-variabler som lages i denne makroen
*/
data &dsn;
set &dsn;
drop EoC:;
run;

/*
Nye tidsvariabler, b�de dato og tidspunkt p� d�gnet for ut og inn
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
	EoC_diff=inndatotid-tmp_utdatotid; /*Tidsdifferanse (timer) mellom inndatotid p� dette oppholdet og utdatotid p� forrige opphold */
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
by pid inndatotid utdatotid EoC_overlapp descending EoC_brudd;
*by pid inndatotid utdatotid;
run;

/*Fyller inn blanke, dvs fyller inn EoC_nr_pid p� de som ikke er merket med blanke*/
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
%if &nulle_liggedogn ne 0 %then %do; * Nulle ut liggetid hvis oppholdet er mindre enn �tte timer;
	if EoC_utdatotid - EoC_inndatotid < 28800 then EoC_liggetid = 0;
%end;
	drop EoC_brudd EoC_innen_t lag_utdatotid EoC_overlapp;
run;

/*
Hastegrad for f�rste opphold, hvis forste_hastegrad = 1, eller f�rste d�gnopphold
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
EoC_hastegrad regnes kun p� innleggelser (AHS, 9. mai 2017)
*/
data &dsn;
set &dsn;
by EoC_id;
if first.EoC_id=1 then forste_hastegrad = hastegrad;
aktkat = aktivitetskategori3;
if uttilstand > 1 then aktkat = 1;
if aktkat = 1 then hastegrad_inn = hastegrad;
run;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *, min(aktkat) as EoC_aktivitetskategori3, 
   %if &kols eq 0 %then %do;
   min(hastegrad_inn) as EoC_hastegrad, 
   %end;
   %else %do;
   min(hastegrad) as EoC_hastegrad, 
   %end;
   max(forste_hastegrad) as EoC_forste_hastegrad, max(uttilstand) as EoC_uttilstand, max(alder) as EoC_alder
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
drop lag_pid EoC_diff inndatotid utdatotid forste_hastegrad aktkat hastegrad_inn;
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
