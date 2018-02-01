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

%if &bo=Norge %then %do;
PROC TABULATE DATA=&Bo._Agg_Rate out=norgesnitt;	
	VAR RV_just_rate Ant_Opphold Ant_Innbyggere;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
		sum=' '*(RV_just_rate="&standard rater"*Format=NLnum12.&rateformat 
		Ant_Opphold="&forbruksmal"*Format=NLNUM12.0 Ant_Innbyggere='Antall innbyggere'*Format=NLNUM12.0)
		/BOX={LABEL="&SnittOmraade" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none';
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder år, &SnittOmraade";
RUN;

data norgesnitt;
set norgesnitt;
keep aar RV_just_rate_sum;
where aar=9999;
run;
%end;

%if &bo ne Norge %then %do;
PROC TABULATE DATA=&Bo._Agg_Rate out=&bo._Fig;	
	VAR RV_just_rate Ant_Opphold Ant_Innbyggere;
	CLASS &Bo /	ORDER=UNFORMATTED MISSING;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE &Bo=' ', sum=' '*(RV_just_rate="&standard rater"*Format=NLnum12.&rateformat 
	Ant_Opphold="&forbruksmal"*Format=NLNUM12.0 Ant_Innbyggere='Antall innbyggere'*Format=NLNUM12.0)*aar=' '
	/BOX={LABEL="&Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none';
	Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;

data HNsnitt;
set &bo._Fig;
keep aar RV_just_rate_sum;
where aar=9999 /*and BoRHF=1*/;/*MÅ FIXES*/
run;
%end;
%mend tabell_1;
