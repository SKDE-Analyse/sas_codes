%macro Episode_of_care(
dsn=, 
EoC_tid=28800, 
forste_hastegrad = 1, 
behold_datotid=0, 
debug = 0, 
nulle_liggedogn = 0, 
inndeling = 0,
separer_ut_poli = 0,
separer_ut_dag = 0,
minaar=0
);

/*!
### Beskrivelse

Makro for å markere opphold som regnes som en sykehusepisode. 
Inndatasettet må inneholde pid inndato utdato inntid og uttid

```
%Episode_of_care(dsn=, Eoc_tid=28800, forste_hastegrad=1, behold_datotid=0, debug=0, nulle_liggedogn=0);
```

### Parametre

- `dsn`: datasett man utfører analysen på
- `Eoc_tid` (=28800): tidskrav i sekunder (default 28800 er 8 timer) for opphold med tidsdifferanse - må være et tall
- `forste_hastegrad` (=1): Hastegrad for første kontakt hvis ulik 0. Hvis 0: hastegrad for første døgnopphold
- `behold_datotid` (=0): Hvis ulik 0, så beholdes disse 
- `debug` (=0): Spytter ut midlertidige datasett hvis forskjellig fra null
- `nulle_liggedogn` (=0): Hvis forskjellig fra null, så settes antall EoC_liggedogn til null hvis opphold er <8 timer
- `inndeling` (= 0):
  - 0: alle kontakter til pasient, uavhengig av behandler, teller som en episode
  - 1: alle kontakter til pasient internt i et behandlende RHF teller som en episode
  - 2: alle kontakter til pasient internt i et behandlende HF teller som en episode
  - 3: alle kontakter til pasient internt i et behandlende sykehus teller som en episode
- `separer_ut_poli` (=0): Hvis ulik null teller alle poliklinikkonsultasjoner og konsultasjoner hos avtalespesialist som egne EoC (alle konsultasjoner der aktivitetskategori3 ikke er 1 eller 2)
- `separer_ut_dag` (=0): Hvis ulik null teller alle dagbehandlinger som egne EoC (alle konsultasjoner der aktivitetskategori3 er 2)
  
Episode of care omfatter da:
- Dersom inndatotid på nytt opphold er før utdatotid på forrige opphold
- Dersom nytt opphold er innen *x* sekunder fra utdatotid på forrige opphold

### Variabler

Makroen lager 12 (eventuelt 14) nye variabler:
1.  `EoC_nr_pid`: Nummererte EoC-opphold pr pid, dersom EoC består av flere opphold har disse samme nummer
2.  `EoC_id`: Unik ID for hver EoC (pid+EoC_nr_pid)
3.  `EoC_Intern_nr`: Nummerer oppholdene innenfor hver EoC for hver pid
4.  `EoC_Antall_i_EoC`: Antall opphold i EoC
5.  `EoC_inndato`: inndato på første opphold i EoC
6.  `EoC_utdato`: utdato på siste opphold i EoC
7.  [eventuelt] `EoC_inndatotid`: inntid (dato og tidspunkt) på første opphold i EoC (hvis behold_datotid ulik 0))
8.  [eventuelt] `EoC_utdatotid`: uttid (dato og tidspunkt) på siste opphold i EoC (hvis behold_datotid ulik 0))
9.  `EoC_aar`: år ved utskriving - alternativt minaar=1 (år ved første opphold)
10. `EoC_liggetid`: tidsdifferanse mellom inndatotid på det første oppholdet og utdatotid på det siste oppholdet i EoC
11. `EoC_aktivitetskategori3`: 1 hvis ett av oppholdene er døgn, eller 2 hvis ett av oppholdene er dag (og ingen døgn), eller 3 hvis oppholdene er kun poli
12. `EoC_hastegrad`: 1 hvis ett av oppholdene er akutt, 4 ellers
13. `EoC_forste_hastegrad`: Hastegrad for første avdelingsopphold. 1 for akutt, 4 for elektiv
14. `EoC_uttilstand`: max(uttilstand) for oppholdene i en EoC ("som død" hvis ett av oppholdene er "som død")

### Endringslogg

- 26.10.2016 Opprettet av Frank Olsen
- 26.10.2016 Endret av Frank Olsen
- november 2016 Diverse endringer av Arnfinn
- desember 2016, Arnfinn
  - nytt argument: nulle_liggedogn
  - diverse andre endringer
- mai 2017, Arnfinn
  - eoc_hastegrad defineres kun for innleggelser
- august 2017, Arnfinn
  - hastegrad_inn = hastegrad hvis døgn
  - hvis kols = 0 så er EoC_hastegrad = min(hastegrad_inn)
  - hvis kols ne 0 så er EoC_hastegrad = min(hastegrad)
  - EoC-makroen fungerte ikke hvis man hadde med avtalespesialister
- april 2018, Arnfinn
  - nytt argument: inndeling 
  - nytt argument: separer_ut_poli
- mars 2020, Frank
	- nytt: dersom man ønsker å bruke første opphold for å definere EoC_Aar
	--> minaar=1

*/

/* 
Slette EoC-variabler som lages i denne makroen
*/
data &dsn;
set &dsn;
drop EoC:;
run;

/*
Nye tidsvariabler, både dato og tidspunkt på døgnet for ut og inn.
Definerer også tmp_poli, som er lik 1 hvis aktivitetskategori3 ikke er (1,2)
*/
data &dsn;
set &dsn;
tmp_poli = .;
if inntid=. then inntid=0;
if uttid=. then uttid=0;
inndatotid=dhms(innDato,0,0,innTid);
utdatotid=dhms(utDato,0,0,utTid);
%if &separer_ut_poli ne 0 %then %do;
if aktivitetskategori3 not in (1,2) then tmp_poli = 1;
%end;
%if &separer_ut_dag ne 0 %then %do;
if aktivitetskategori3 = 2 then tmp_poli = 1;
%end;
format inndatotid utdatotid datetime18.;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_1;
set &dsn;
run;
%end;

%if &inndeling = 1 %then %do;
    %let beh = behrhf;
%end;
%else %if &inndeling = 2 %then %do;
    %let beh = behhf;
%end;
%else %if &inndeling = 3 %then %do;
    %let beh = behsh;
%end;

proc sort data=&dsn;
by tmp_poli pid inndatotid utdatotid;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_2;
set &dsn;
run;
%end;

data &dsn(drop = tmp_utdatotid);
set &dsn;
by tmp_poli pid;

retain tmp_utdatotid;

if first.pid then do;
	tmp_utdatotid = utdatotid;
end;

lag_pid=lag(pid);
lag_utdatotid=lag(utdatotid);
%if &inndeling ne 0 %then %do;
    lag_beh = lag(&beh);
%end;

/* Beregne tidsdifferansen mellom opphold */
if lag_pid=pid then do;
	if lag_utdatotid>inndatotid then EoC_overlapp=1;
	EoC_diff=inndatotid-tmp_utdatotid; /* Tidsdifferanse (sekunder) mellom inndatotid på dette oppholdet og utdatotid på forrige opphold */
	if EoC_diff>&EoC_Tid then do;
		tmp_utdatotid = utdatotid;
	end;
	else if utdatotid > tmp_utdatotid then do;
		tmp_utdatotid = utdatotid;
	end;
end;
format lag_utdatotid datetime18. EoC_diff time10.;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_3;
set &dsn;
run;
%end;

proc sort data=&dsn;
by tmp_poli pid inndatotid utdatotid;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_3b;
set &dsn;
run;
%end;

/* Markere opphold som ikke skal inngå i EoC fra forrige linje som brudd i EoC */
data &dsn;
set &dsn;
if (pid=lag_pid and EoC_diff>=&EoC_tid) or (Pid ne lag_pid and EoC_diff=.) then EoC_brudd=1;
%if &inndeling ne 0 %then %do;
  if (pid=lag_pid and &beh ne lag_beh) then EoC_brudd=1;
%end;

if tmp_poli = 1 then EoC_brudd=1;

run;

%if &debug ne 0 %then %do;
data &dsn.debug_4;
set &dsn;
run;
%end;

/*Nummerere EoC-oppholdene*/
proc sort data=&dsn;
by pid tmp_poli EoC_brudd inndatotid utdatotid;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_4b;
set &dsn;
run;
%end;

data &dsn;
set &dsn;
by pid tmp_poli EoC_brudd inndatotid utdatotid;
if EoC_brudd=1 then do;
	if first.pid=1 and EoC_brudd=1 then EoC_nr_pid=0; /*Nummererer EoC-oppholdene som har blitt merket med EoC_brudd*/
	EoC_nr_pid+1;
end;
if EoC_brudd=. then EoC_nr_pid=.;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_5;
set &dsn;
run;
%end;

proc sort data=&dsn;
by pid tmp_poli inndatotid utdatotid EoC_overlapp descending EoC_brudd;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_5b;
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

%if &debug ne 0 %then %do;
data &dsn.debug_6;
set &dsn;
run;
%end;

/* Gir alle EoC en unik id, basert på pid og eoc-nummer */
data &dsn;
set &dsn;
EoC_id = pid*1000 + EoC_nr_pid;
format EoC_id 16.;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_7;
set &dsn;
run;
%end;

proc sort data=&dsn;
by pid EoC_nr_pid inndatotid utdatotid;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_7b;
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
data &dsn.debug_8;
set &dsn;
run;
%end;

%if &minaar ne 1 %then %do;
PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(EoC_Intern_nr) AS EoC_Antall_i_EoC, min(inndato) as EoC_inndato, max(utdato) as EoC_utdato, min(inndatotid) as EoC_inndatotid, max(utdatotid) as EoC_utdatotid, max(aar) as EoC_aar
	FROM &dsn
	GROUP BY PID,EoC_nr_pid;
QUIT;
%end;

%if &minaar = 1 %then %do;
PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(EoC_Intern_nr) AS EoC_Antall_i_EoC, min(inndato) as EoC_inndato, max(utdato) as EoC_utdato, min(inndatotid) as EoC_inndatotid, max(utdatotid) as EoC_utdatotid, min(aar) as EoC_aar
	FROM &dsn
	GROUP BY PID,EoC_nr_pid;
QUIT;
%end;

%if &debug ne 0 %then %do;
data &dsn.debug_9;
set &dsn;
run;
%end;

data &dsn;
set &dsn;
	EoC_liggetid=EoC_utdato-EoC_inndato;
%if &nulle_liggedogn ne 0 %then %do; /* Nulle ut liggetid hvis oppholdet er mindre enn åtte timer */
	if EoC_utdatotid - EoC_inndatotid < 28800 then EoC_liggetid = 0;
%end;
	drop EoC_brudd lag_utdatotid EoC_overlapp;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_10;
set &dsn;
run;
%end;

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

%if &debug ne 0 %then %do;
data &dsn.debug_10b;
set &dsn;
run;
%end;

data &dsn;
set &dsn;
by EoC_id;
/* To avoid setting eoc_hastegrad to missing, since "." is less than 0 */
tmp_hastegrad = hastegrad;
if hastegrad = . then tmp_hastegrad = 99;
if first.EoC_id=1 then forste_hastegrad = hastegrad;
aktkat = aktivitetskategori3;
if uttilstand > 1 then aktkat = 1;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_11;
set &dsn;
run;
%end;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *, min(aktkat) as EoC_aktivitetskategori3, 
   min(tmp_hastegrad) as EoC_hastegrad, 
   max(forste_hastegrad) as EoC_forste_hastegrad, max(uttilstand) as EoC_uttilstand, max(alder) as EoC_alder
	FROM &dsn
	GROUP BY EoC_id;
QUIT;

%if &debug ne 0 %then %do;
data &dsn.debug_12;
set &dsn;
run;
%end;

proc sort data=&dsn;
by pid EoC_nr_pid EoC_Intern_nr inndatotid utdatotid;
run;

%if &debug ne 0 %then %do;
data &dsn.debug_12b;
set &dsn;
run;
%end;

data &dsn;
set &dsn;
if EoC_hastegrad = 99 then EoC_hastegrad = .;
/* Nulle liggedøgn hvis poliklinisk kontakt */
if EoC_aktivitetskategori3 = 3 then EoC_liggetid = 0;
%if &debug ne 0 %then %do;
drop lag_pid;
%end;
%else %if &debug eq 0 %then %do;
drop lag_pid EoC_diff inndatotid utdatotid forste_hastegrad aktkat tmp_poli;
%end;
format EoC_utdato EoC_inndato date10.;
format EoC_inndatotid EoC_utdatotid datetime18.;
format EoC_aktivitetskategori3 aktivitetskategori3f.;
format EoC_hastegrad EoC_forste_hastegrad hastegrad.;
%if &behold_datotid = 0 %then %do;
drop EoC_inndatotid EoC_utdatotid;
drop tmp_hastegrad;
%end;

run;

%mend;
