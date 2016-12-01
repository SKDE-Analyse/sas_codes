%macro reinnleggelser(dsn=, ReInn_Tid = 30, eks_diag=1);

/*
- Makro for å markere EoC som er en reinnleggelse.
- Bruker definisjonen til Kunnskapssenteret.
- Makroen Episode_of_care må være kjørt først.
*/

proc sort data=&dsn;
by pid eoc_inndato eoc_utdato;
drop EoC_reinnleggelse re_:;
run;

%if &eks_diag ne 0 %then %do;
data &dsn;
set &dsn;

  array diagnose {*} Hdiag: Bdiag:;
  do i=1 to dim(diagnose);
    if substr(diagnose{i},1,1) in ('C') then re_Kreft=1;
    if substr(diagnose{i},1,2) in ('D0') then re_Kreft=1;
    if substr(diagnose{i},1,3) in ('D37','D38','D39','D40','D41','D42','D43','D44','D45','D46','D47','D48') then re_Kreft=1;

    if substr(diagnose{i},1,1) in ('V', 'W', 'X', 'Y') then re_ytre=1;
    if substr(diagnose{i},1,1) in ('T') then re_skade=1;
    if substr(diagnose{i},1,1) in ('Z') then re_faktor=1;
  end;

  do i=1 to dim(diagnose);
    if substr(diagnose{i},1,2) in ('T4','T8') then re_skade=.;
    if substr(diagnose{i},1,3) in ('T50') then re_skade=.;
    if substr(diagnose{i},1,3) in ('Z03','Z42','Z47','Z48','Z54','Z74','Z75') then re_faktor=.;
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

data &dsn;
set &dsn;
lag_pid = lag(pid);
lag_eoc_id = lag(eoc_id);
lag_EoC_utdato=lag(EoC_utdato);
lag_eoc_aktivitetskategori3=lag(eoc_aktivitetskategori3);
if pid=lag_pid and lag_eoc_aktivitetskategori3 > 0 and eoc_id ne lag_eoc_id then do; /* Samme person, ulik EoC , forrige opphold er innleggelse*/
	if eoc_aktivitetskategori3=1 and eoc_hastegrad=1 and eoc_re_ekskluder ne 1 then do; /* Dette oppholdet er akutt døgninnleggelse */
		if EoC_inndato-lag_EoC_utdato<&ReInn_Tid then ReInnleggelse=1;
	end;
end;
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
drop ReInnleggelse lag_pid lag_eoc_id lag_EoC_utdato lag_eoc_aktivitetskategori3 re_: eoc_re_ekskluder;
run;

%mend;
