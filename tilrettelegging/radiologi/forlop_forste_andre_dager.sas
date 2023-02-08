%macro forlop_forste_andre_dager(dsn=,forste=,andre=,sortering=,d1=,d2=,d3=);

/*! 
### Beskrivelse

Makro for å lage flagg for forløp av undersøkelser
1. Første (forste) er første type undersøkelse - den som inntreffer først i tid
    - må være en "flagg"-variabel, dvs merket som 1
2. Andre (andre) er andre type undersøkelse - den som inntreffer etter den første i tid
    - må være en "flagg"-variabel, dvs merket som 1
3. Sortering - by pid inndato tid
4. Antall dager mellom første og andre - d1, d2, d3 dersom man ønsker å teste ut forskjellige krav

```
kortversjon (kjøres med default verdier for resten)
%forlop_forste_andre_dager(dsn=,forste=,andre=,sortering=pid inndato tid ,d1=);
```
### Input
- dsn - datasett med varible det skal beregnes forløp på, 
	- må inneholde de to undersøkelsene 
	- det kjøres et where statement når data hentes inn: where &forste=1 or &andre=1

### Output
    Datasett med flagg for
        1. case=1 - tilfeller hvor det kommer en "andre" etter den "første"
        2. dager - antall dager mellom undersøkelsene
        3. merke&d1=1 (og evt merke&d2=1 og merke&d3=1) 
        Flaggene legges nå på "andre" undersøkelsen
    Og en tabell som viser antall


### Endringslogg:
- februar 2023 opprettet, Frank
*/

data forste_andre_&dsn;
set &dsn;
where &forste=1 or &andre=1;
run;

proc sql;
create table forste_andre_&dsn as
select *, max(&forste) as &forste._pas, max(&andre) as &andre._pas
from forste_andre_&dsn
group by pid;
run;

data forste_andre_&dsn;
set forste_andre_&dsn;
where &forste._pas=1 and &andre._pas=1;
run;

proc sort data=forste_andre_&dsn;
by &sortering;
run;

data forste_andre_&dsn;
set forste_andre_&dsn;
by &sortering;
if first.pid then pid_nr=0;
pid_nr+1;
lag_&forste=lag(&forste);
lag_&forste._dato=lag(inndato);
lag_pid=lag(pid);
run;

data forste_andre_&dsn;
set forste_andre_&dsn;
if &forste=1 and &andre=. then do;
	lag_&forste=.; lag_&forste._dato=.; lag_pid=.;
end;
if pid ne lag(pid) then do;
	lag_&forste=.; lag_&forste._dato=.;
end;
run;

data forste_andre_&dsn;
set forste_andre_&dsn;
if &andre=1 and lag_&forste=1 and pid=lag_pid then do;
	case=1;
	dager=inndato-lag_&forste._dato;
end;
if case=1 and dager le &d1 then dager&d1=1;
%if &d2 gt 0 %then %do;
if case=1 and dager le &d2 then dager&d2=1;
%end;
%if &d3 gt 0 %then %do;
if case=1 and dager le &d3 then dager&d3=1;
%end;
run;

%if &d2 lt 1 %then %do;
title "Antall med maksimalt &d1 dager mellom &forste og &andre undersøkelse";
%end;
%if &d2 gt 0 %then %do;
title "Antall med maksimalt &d1 og &d2 dager mellom &forste og &andre undersøkelse";
%end;
%if &d3 gt 0 %then %do;
title "Antall med maksimalt &d1, &d2 og &d3 dager mellom &forste og &andre undersøkelse";
%end;
PROC FREQ DATA=forste_andre_&dsn;
	TABLES dager&d1 /  SCORES=TABLE;
	%if &d2 gt 0 %then %do;
	TABLES dager&d2 /  SCORES=TABLE;
	%end;
	%if &d3 gt 0 %then %do;
	TABLES dager&d3 /  SCORES=TABLE;
	%end;
RUN; title;

%mend forlop_forste_andre_dager;