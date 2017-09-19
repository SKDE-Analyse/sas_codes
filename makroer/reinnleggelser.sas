%macro reinnleggelser(dsn=, ReInn_Tid = 30, eks_diag=0, primaer = alle, forste_utdato =0, siste_utdato ='31Dec2020'd, kun_innleggelser = 0);

/*!
- opprettet av Arnfinn 1. des. 2016 

Makro for å markere EoC som er en reinnleggelse 

**Makroen Episode_of_care må være kjørt før reinnleggelse-makroen**

```
%reinnleggelser(dsn=, ReInn_Tid = 30, eks_diag=0, primaer = alle, forste_utdato =0, siste_utdato ='31Dec2020'd);
```

- `dsn`:             datasett man utfører analysen på
- `ReInn_Tid` (=30): tidskrav i dager mellom primæropphold og et eventuelt reinnleggelsesopphold
- `eks_diag` (=0):   Hvis ulik 0, innleggelser som inneholder hoved- eller bi-diagnoser, som brukt av kunnskapssenteret, er ikke en reinnl.
- `primaer` (=alle): Markere opphold som har primaer = 1 som primæropphold.
- `forste_utdato` (=0): Kun regne primære innleggelser etter denne dato
- `siste_utdato` (='31Dec2020'd): Ikke regne primære innleggelser etter denne dato
- `kun_innleggelser` (= 0): Hvis denne er ulik null, teller kun de som er `eoc_aktivitetskategori3 = 1` som en primærinnleggelse

Makroen produserer følgende 3 variabler
- `reinnleggelse`: Alle avdelingsopphold i en EoC som er en reinnleggelse (reinnleggelse = 1)
- `primaerinnleggelse`: Alle opphold som kan gi en reinnleggelse (primaerinnleggelse = 1)
- `primaer_med_reinn`: Primæropphold som fører til en reinnleggelse (primaer_med_reinn = 1)

Man kan så i ettertid telle opp antall opphold som er en reinnleggelse.

### Eksempel:
```
%reinnleggelser(dsn=mittdatasett, ReInn_Tid = 14, primaer = kols, forste_utdato ='18Dec2012', siste_utdato ='17Dec2015'd);
```
- Vil markere alle innleggelser som har `kols = 1` som primærinnleggelser (variablen `kols` må være definert som 1 på forhånd). 
- Innleggelser med utskrivelsesedato fra og med 14 dager før nyttår første år til og med 14 dager før nyttår siste år teller som primærinnleggelser. 
- Alle akutte innleggelser, som ikke har en av de ekskluderte diagnosene, som skjer innen 14 dager etter en primærinnleggelse, vil bli markert som en reinnleggelse
*/


/*
- Makro for å markere EoC som er en reinnleggelse.
- Bruker definisjonen til Kunnskapssenteret.
- Makroen Episode_of_care må være kjørt først.
*/

proc sort data=&dsn;
by pid eoc_inndato eoc_utdato;
drop EoC_reinnleggelse re_:;
run;

/*
Ekskludere opphold med gitte diagnoser (Folkehelseinstituttet 2016)
*/
%if &eks_diag ne 0 %then 
   %do; 
data &dsn;
set &dsn;

  array diagnose {*} Hdiag:;
  do i=1 to dim(diagnose);
    if substr(diagnose{i},1,1) in ('C') then re_Kreft=1;
    if substr(diagnose{i},1,2) in ('D0') then re_Kreft=1;
    if substr(diagnose{i},1,3) in ('D37','D38','D39','D40','D41','D42','D43','D44','D45','D46','D47','D48') then re_Kreft=1;
    if substr(diagnose{i},1,1) in ('V', 'W', 'X', 'Y') then re_ytre=1;
    if substr(diagnose{i},1,2) in ('T1','T2','T3','T6','T7','T9') then re_skade=1;
    if substr(diagnose{i},1,3) in ('T51','T52','T53','T54','T55','T56','T57','T58','T59') then re_skade=1;
    if substr(diagnose{i},1,2) in ('Z1','Z2','Z3','Z6','Z8','Z9') then re_faktor=1;
    if substr(diagnose{i},1,3) in ('Z00','Z01','Z02','Z04','Z05','Z06','Z07','Z08','Z09') then re_faktor=1;
    if substr(diagnose{i},1,3) in ('Z40','Z41','Z43','Z44','Z45','Z46','Z49') then re_faktor=1;
    if substr(diagnose{i},1,3) in ('Z50','Z51','Z52','Z53','Z55','Z56','Z57','Z58','Z59') then re_faktor=1;
    if substr(diagnose{i},1,3) in ('Z70','Z71','Z72','Z73','Z76','Z77','Z78','Z79') then re_faktor=1;
  end;

  if re_Kreft=1 or re_ytre=1 or re_skade=1 or re_faktor=1 then re_ekskluder = 1;
drop i;
run;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(re_ekskluder) AS eoc_re_ekskluder
	FROM &dsn
	GROUP BY EoC_id;
QUIT;
   %end;

/*
Markere linje som primaeropphold (primæropphold) hvis 
- variablen &primaer er lik én og 
(hvis primaer=alle -> markere alle døgnopphold som primaeropphold)
- det er en døgninnleggelse (kun hvis primaer = alle) og
- eoc_utdato er innenfor definert tidsperiode (&forste_utdato < eoc_utdato < &siste_utdato) og
- pasient skrevet ut levende
*/
data &dsn;
set &dsn;

%if &primaer ne alle and &kun_innleggelser = 0 %then
   %do;
      primaeropphold = .;
      if &primaer = 1 and &forste_utdato le eoc_utdato le &siste_utdato and EoC_uttilstand = 1 then tmp_eoc_primaer = 1; /* døgninnleggelser med &primaer lik 1 er aktuelle primæropphold */
   %end;
%else %if &primaer ne alle and &kun_innleggelser ne 0 %then
   %do;
      primaeropphold = .;
      if eoc_aktivitetskategori3 = 1 and &primaer = 1 and &forste_utdato le eoc_utdato le &siste_utdato and EoC_uttilstand = 1 then tmp_eoc_primaer = 1; /* døgninnleggelser med &primaer lik 1 er aktuelle primæropphold */
   %end;
%else 
   %do;
      tmp_eoc_primaer = .;
      if eoc_aktivitetskategori3 = 1 and &forste_utdato < eoc_utdato < &siste_utdato and EoC_uttilstand = 1 then tmp_eoc_primaer = 1; /* alle døgninnleggelser er aktuelle primæropphold */
   %end;
	drop primaeropphold; * for sikkerhets skyld;
run;

/*
Markere alle linjer i sammen EoC som primaeropphold, hvis en av linjene er markert som tmp_eoc_primaer
(for &primaer = alle vil tmp_eoc_primaer alltid være lik primaeropphold)
*/ 

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(tmp_eoc_primaer) AS primaeropphold
	FROM &dsn
	GROUP BY EoC_id;
QUIT;

/*
Markere reinnleggelser
(akutte innleggelser mindre enn 30 dager (default) etter en primærinnleggelse)
*/
proc sort data = &dsn;
by pid eoc_id eoc_inndato;
run;

data &dsn;
set &dsn;

by pid;

retain _eoc_utdato;
retain _pid;
retain _eoc_id;
retain _eoc_liggetid;

if first.pid and primaeropphold = 1 then do;
	_pid = pid;
	_eoc_id = eoc_id;
	_eoc_utdato = eoc_utdato;
	_eoc_liggetid = eoc_liggetid;
end;

if _pid = pid and _eoc_id ne eoc_id and not first.pid then do;
	if eoc_aktivitetskategori3 = 1 and eoc_hastegrad = 1 and eoc_re_ekskluder ne 1 and 0 < EoC_inndato - _EoC_utdato < &reinn_tid then do;
		tmp_ReInnleggelse = 1;
		tmp_primaer_eoc_id = _eoc_id;
		tmp_primaer_eoc_liggetid = _eoc_liggetid;
	end;
end;

if primaeropphold = 1 then do;
	_eoc_utdato = eoc_utdato;
	_pid = pid;
	_eoc_id = eoc_id;
	_eoc_liggetid = eoc_liggetid;
end;

drop _eoc_utdato _pid _eoc_id _eoc_liggetid;
run;

proc sort data=&dsn;
by EoC_id;
run;

/*
Markere alle linjer i sammen EoC som EoC_reinnleggelse, hvis en av linjene er markert som tmp_ReInnleggelse
*/ 

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(tmp_ReInnleggelse) AS reinnleggelse, max(tmp_primaer_eoc_id) as primaer_eoc_id, max(tmp_primaer_eoc_liggetid) as primaer_eoc_liggetid
	FROM &dsn
	GROUP BY EoC_id;
QUIT;

/*
Finne tilbake til de primære opphold som fører til en reinnleggelse
*/
data qwerty;
set &dsn;
	tmp_primaer_eoc_reinn = 1;
	eoc_id = primaer_eoc_id;
	keep eoc_id tmp_primaer_eoc_reinn;
	where reinnleggelse = 1 and eoc_intern_nr = 1;
run;

/*
Kun unike eoc_id før kobling med hovedfila, ellers har man ikke kontroll på antall linjer etterpå (dobling av linjer)
*/

proc sort data = qwerty;
by eoc_id;
run;

data qwerty;
set qwerty;
by eoc_id;
if first.eoc_id = 1 then tmp_unik_eoc = 1;
run;

data qwerty;
set qwerty;
where tmp_unik_eoc = 1;
run;

data &dsn;
merge &dsn qwerty;
	by eoc_id;
	drop primaer_med_reinn tmp_unik_eoc;
run;

proc sql;
	create table &dsn as
	select *, max(tmp_primaer_eoc_reinn) as primaer_med_reinn
	from &dsn
	group by eoc_id;
quit;

/*
Opphold som var en primærinnleggelse men som ikke hadde reinnleggelse,
og der pasient dør innen 30 dager, teller ikke som en primærinnleggelse.
*/


data &dsn;
set &dsn;

	if doddato ne . then do;
		if doddato - eoc_utdato le 30 and primaer_med_reinn = . and primaeropphold = 1 then primaeropphold = .;
	end;

run;

data &dsn;
set &dsn;
	drop tmp_ReInnleggelse eoc_re_ekskluder tmp_primaer_eoc_id tmp_primaer_eoc_liggetid tmp_eoc_primaer tmp_primaer_eoc_reinn primaer_eoc_id primaer_eoc_liggetid;
	%if &eks_diag ne 0 %then
      %do; 
         drop re_Kreft re_ytre re_skade re_faktor re_ekskluder;
      %end;
run;


proc datasets nolist;
delete qwerty:;

%mend;
