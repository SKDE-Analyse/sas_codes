/*Andel kvinner*/

PROC TABULATE DATA=&ratenavn._&RV_variabelnavn._RV OUT=&ratenavn._&RV_variabelnavn._ermann; 
	VAR RV;
	CLASS ermann /	ORDER=UNFORMATTED MISSING;
	TABLE RV, ermann*(Sum PctSum);
RUN;

data &ratenavn._&RV_variabelnavn._ermann;
set &ratenavn._&RV_variabelnavn._ermann;
where ermann = 0;
length gruppe $ 40.;
length niva $ 40.;
Andel_kv = rv_pctsum_0;
keep Andel_kv gruppe niva;
gruppe = "&gruppe";
niva = "&niva";
run;


/*Alder - median, mean og første kvartil*/
PROC SQL;
	CREATE table &ratenavn._orden AS
		SELECT T.alder, T.RV
	FROM &ratenavn._&RV_variabelnavn._RV as T;
QUIT;


PROC MEANS  DATA=&ratenavn._orden
	FW=12
	PRINTALLTYPES 
	QMETHOD=OS
	VARDEF=DF 	
		MEAN 
		N	
		Q1 
		MEDIAN	;
	VAR alder;
	FREQ RV;
	OUTPUT OUT=&ratenavn._&RV_variabelnavn._alder (drop= _type_ _freq_) mean= /autoname ;
RUN;

data &ratenavn._&RV_variabelnavn._alder;
set &ratenavn._&RV_variabelnavn._alder;
length gruppe $ 40.;
length niva $ 40.;
gruppe = "&gruppe";
niva = "&niva";

run;


/*No-rate, antall og forholdstall*/ 


proc sql;
create table &ratenavn._&RV_variabelnavn._rater AS 
select rate, antall, gruppe, niva, bohf_org,  max(rate) as maks_rate, min(rate) as min_rate
from skde_pet.IA_&varnavn; 
quit;

data &ratenavn._&RV_variabelnavn._rater;
set &ratenavn._&RV_variabelnavn._rater;
if maks_rate = rate then maks_bohf = bohf_org;
if min_rate = rate then min_bohf = bohf_org;
run;

proc sql;
create table &ratenavn._&RV_variabelnavn._rater AS 
select rate, antall, gruppe, niva, bohf_org, maks_rate, min_rate, max(maks_bohf) as maks_bohf, min(min_bohf) as min_bohf
from &ratenavn._&RV_variabelnavn._rater; 
quit;

data &ratenavn._&RV_variabelnavn._rater;
set &ratenavn._&RV_variabelnavn._rater;
if maks_rate = rate then delete;
if min_rate = rate then delete;
run;

proc sql;
create table &ratenavn._&RV_variabelnavn._rater AS 
select rate, antall, gruppe, niva, bohf_org,  maks_rate, min_rate, maks_bohf, min_bohf, max(rate) as maks_to_rate, min(rate) as min_to_rate
from &ratenavn._&RV_variabelnavn._rater; 
quit;

data &ratenavn._&RV_variabelnavn._rater;
set &ratenavn._&RV_variabelnavn._rater;
where bohf_org = 8888;
keep Gruppe Niva N No_rate FT bohf_org maks_rate min_rate FT2 maks_to_rate  min_to_rate maks_bohf min_bohf ;
n = antall;
no_rate = rate;
FT = maks_rate/min_rate;
FT2 = maks_to_rate/min_to_rate;
run;

data skde_pet.&ratenavn._&RV_variabelnavn._tabell;
merge &ratenavn._&RV_variabelnavn._rater &ratenavn._&RV_variabelnavn._alder &ratenavn._&RV_variabelnavn._ermann;
by gruppe niva;
if gruppe in ('Primærhelsetjenesten') then do;
alder_mean = .;
end;
run;


/*	Sletter datasett	*/

Proc datasets nolist;
delete &ratenavn._&RV_variabelnavn._tabell &ratenavn._orden &ratenavn._&RV_variabelnavn._rater &ratenavn._&RV_variabelnavn._alder &ratenavn._&RV_variabelnavn._ermann;
run;