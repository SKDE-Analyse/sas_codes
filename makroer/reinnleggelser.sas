%macro reinnleggelser(dsn=, ReInn_Tid = 30, eks_diag=1, primaer = alle);

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
%if &eks_diag ne 0 %then %do; 
data &dsn;
set &dsn;

*  array diagnose {*} Hdiag: Bdiag:;
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

*  do i=1 to dim(diagnose);
*    if substr(diagnose{i},1,2) in ('T4','T8') then re_skade=.;
*    if substr(diagnose{i},1,3) in ('T50') then re_skade=.;
*    if substr(diagnose{i},1,3) in ('Z03','Z42','Z47','Z48','Z54','Z74','Z75') then re_faktor=.;
*  end;

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
Markere linje som eoc_primaer (primæropphold) hvis variablen &primaer er lik én og det er en døgninnleggelse
(hvis primaer=alle -> markere alle døgnopphold som eoc_primaer)
*/
data &dsn;
set &dsn;
eoc_primaer = .;
%if &primaer ne alle %then %do;
	if &primaer = 1 and eoc_aktivitetskategori3 = 1 then eoc_primaer = 1; /* døgninnleggelser med &primaer lik 1 er aktuelle primæropphold */
%end;
%else %do;
	if eoc_aktivitetskategori3 = 1 then eoc_primaer = 1; /* alle døgninnleggelser er aktuelle primæropphold */
%end;
run;

/*
Markere alle linjer i sammen EoC som eoc_primaer, hvis en av linjene er markert som eoc_primaer
*/ 
PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(eoc_primaer) AS eoc_primaer
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

if first.pid and eoc_primaer = 1 then do;
	_pid = pid;
	_eoc_id = eoc_id;
	_eoc_utdato = eoc_utdato;
end;

if _pid = pid and _eoc_id ne eoc_id and not first.pid then do;
	if eoc_aktivitetskategori3 = 1 and eoc_hastegrad = 1 and eoc_re_ekskluder ne 1 and EoC_inndato - _EoC_utdato < &ReInn_Tid then do;
		ReInnleggelse = 1;
	end;
end;

if eoc_primaer = 1 then do;
	_eoc_utdato = eoc_utdato;
	_pid = pid;
	_eoc_id = eoc_id;
end;

drop _eoc_utdato _pid _eoc_id;
run;

proc sort data=&dsn;
by EoC_id;
run;

PROC SQL;
	CREATE TABLE &dsn AS 
	SELECT *,MAX(ReInnleggelse) AS EoC_reinnleggelse
	FROM &dsn
	GROUP BY EoC_id;
QUIT;

data &dsn;
set &dsn;
drop ReInnleggelse re_: eoc_re_ekskluder eoc_primaer;
run;

%mend;
