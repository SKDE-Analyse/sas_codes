/*
Janice Shu 02/02/2018

Made the format for the numbers into macro so that tabell_1 can output both number format depending on what "tallformat" specifies. (NLnum or Excel)
Therefore tabell_1e is now obsolete.
Similarly for tabell_3Ne, tabell_CVe, tabell_3e

Created new macro, lag_tabeller, to make the appropriate tabeller based on "vis_tabeller"=1,2,or 3.



*/
%macro tabell_1;

/*!

Makro for å lage tabell over rater, kontakter og innbyggere i de ulike boområder, fordelt på år.

*/
%if %sysevalf(%superq(silent)=,boolean) %then %let silent = 0;

/*finn min og max alder*/
/*finn min og max alder*/
proc sql;
create table aldersspenn as
select distinct max(alder) as maxalder, min(alder) as minalder
from RV;
quit;
Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

%if &silent ne 0 %then %do;
ods select none;
%end;

PROC TABULATE DATA=&Bo._Agg_Rate out=&bo._Fig;	
	VAR RV_just_rate Ant_Opphold Ant_Innbyggere;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
%if &bo = Norge %then %do;
	TABLE aar='',
%end;
%else %do;
	CLASS &Bo /	ORDER=UNFORMATTED MISSING;
	TABLE &Bo=' ', 
%end;
    sum=' '*(RV_just_rate="&standard rater"*Format=&talltabformat..&rateformat 
	Ant_Opphold="&forbruksmal"*Format=&talltabformat..0 
%if &bo = Norge %then %do;
    Ant_Innbyggere='Antall innbyggere'*Format=&talltabformat..0)
%end;
%else %do;
    Ant_Innbyggere='Antall innbyggere'*Format=&talltabformat..0)*aar=' '
%end;
	/BOX={LABEL="&Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none';
%if &silent=0 %then %do;
	Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder år, &Bo";
run;
%end;
%else %do;
run;
ods select all;
%end;

%if &bo ne Norge %then %do;
data HNsnitt;
set &bo._Fig;
keep aar RV_just_rate_sum;
where aar=9999 /*and BoRHF=1*/;/*MÅ FIXES*/
run;
%end;

%mend tabell_1;


/* Tabeller med ujust og KI*/

%macro Tabell_CV;
/*!

Makro for å lage tabell med
- variasjonskoeffisient
- systematisk variasjonskoeffisient
- OBV
- RCV

*/

%if %sysevalf(%superq(silent)=,boolean) %then %let silent = 0;

Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

%put WARNING: Bo: &bo;
%if &silent=0 and &bo ne Norge %then %do;
PROC TABULATE
DATA=&Bo._Agg_CV Format=&talltabformat..3;
	VAR CV SCV OBV RCV;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
	mean=' '*(CV*Format=&talltabformat..3 SCV*Format=&talltabformat..3 OBV*Format=&talltabformat..3 RCV*Format=&talltabformat..3)
	/BOX={Label="CV - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "Variasjonsmål &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;
%end;

%mend tabell_cv;

%macro Tabell_3;
/*!
Makro som lager en tabell med 
- innbyggere
- kontakter
- ujustert rate
- direkte justert rate
- indirekte juster rate
- Standardavvik
- Nedre og øvre konfidensinterval

Kjøres hvis 

```
%Let Vis_Tabeller=3;
```
*/
%if %sysevalf(%superq(silent)=,boolean) %then %let silent = 0;

Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

%if &silent ne 0 %then %do;
ods select none;
%end;
PROC TABULATE DATA=&Bo._Agg_Rate ;	
	VAR Ant_Innbyggere Ant_Opphold RV_rate RV_just_rate RV_ijust_rate SDJUSTRate KI_N_J KI_O_J;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
%if &bo = Norge %then %do;
	TABLE aar='',
%end;
%else %do;
	CLASS &Bo /	ORDER=UNFORMATTED MISSING;
	TABLE aar=''*&Bo='',
%end;
		sum=''*(Ant_Innbyggere='Innbyggere'*Format=&talltabformat..0 
        Ant_Opphold="&forbruksmal"*Format=&talltabformat..0 
        RV_rate='Ujust.rate'*Format=&talltabformat..&rateformat 
		RV_just_rate='Dir.just.rate'*Format=&talltabformat..&rateformat 
        RV_ijust_rate='Ind.just.rate'*Format=&talltabformat..&rateformat 
        SDJUSTRate='Std.avvik'*Format=&talltabformat..3
		KI_N_J='Nedre KI'*Format=&talltabformat..3 KI_O_J='Øvre KI'*Format=&talltabformat..3 )  
		/BOX={LABEL="Rater - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;
%if &silent ne 0 %then %do;
ods select all;
%end;

%mend Tabell_3;

%macro lag_tabeller;

	%if &Vis_tabeller=1 %then %do;	
		%tabell_1;
	%end;
		
	%if &Vis_tabeller=2 %then %do;	
		%tabell_1; %tabell_CV;	
	%end;
		
	%if &Vis_tabeller=3 %then %do;	
		%tabell_1; %tabell_CV; %tabell_3;	
	%end;

%mend;
