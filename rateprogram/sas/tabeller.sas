
%macro tabell_1;

/*!
#### Formål
{: .no_toc}


*/

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

%macro tabell_1e;
/*!
#### Formål
{: .no_toc}


*/


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
		sum=' '*(RV_just_rate="&standard rater"*Format=12.&rateformat 
		Ant_Opphold="&forbruksmal"*Format=12.0 Ant_Innbyggere='Antall innbyggere'*Format=12.0)
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
	TABLE &Bo=' ', sum=' '*(RV_just_rate="&standard rater"*Format=12.&rateformat 
	Ant_Opphold="&forbruksmal"*Format=12.0 Ant_Innbyggere='Antall innbyggere'*Format=12.0)*aar=' '
	/BOX={LABEL="&Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none';
	Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;

data HNsnitt;
set &bo._Fig;
keep aar RV_just_rate_sum;
where aar=9999 /*and BoRHF=1*/;/*MÅ FIXES*/
run;
%end;
%mend tabell_1e;


/* Tabeller med ujust og KI*/

%macro Tabell_CV;
/*!
#### Formål
{: .no_toc}


*/


Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

PROC TABULATE
DATA=&Bo._Agg_CV Format=Nlnum12.3;
	VAR CV SCV OBV RCV;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
	mean=' '*(CV*Format=Nlnum12.3 SCV*Format=Nlnum12.3 OBV*Format=Nlnum12.3 RCV*Format=Nlnum12.3)
	/BOX={Label="CV - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "Variasjonsmål &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;
%mend tabell_cv;

%macro Tabell_CVe;
/*!
#### Formål
{: .no_toc}


*/


Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

PROC TABULATE
DATA=&Bo._Agg_CV Format=12.3;
	VAR CV SCV OBV RCV;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
	mean=' '*(CV*Format=12.3 SCV*Format=12.3 OBV*Format=12.3 RCV*Format=12.3)
	/BOX={Label="CV - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "Variasjonsmål &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;
%mend tabell_cve;

%macro tabell_3N;
/*!
#### Formål
{: .no_toc}


*/


Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

PROC TABULATE DATA=&Bo._Agg_Rate;	
	VAR Ant_Innbyggere Ant_Opphold RV_rate RV_just_rate SDJUSTRate KI_N_J KI_O_J;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
		sum=''*(Ant_Innbyggere='Innbyggere'*Format=Nlnum12.0 Ant_Opphold="&forbruksmal"*Format=Nlnum12.0 RV_rate='Ujust.rate'*Format=Nlnum12.&rateformat 
		RV_just_rate='Just.rate'*Format=Nlnum12.&rateformat SDJUSTRate='Std.avvik'*Format=Nlnum12.3
		KI_N_J='Nedre KI'*Format=Nlnum12.3 KI_O_J='Øvre KI'*Format=Nlnum12.3 ) 
		/BOX={LABEL="Rater - &SnittOmraade" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &Min_alder - &Max_alder år, &SnittOmraade";
RUN;
%mend tabell_3N;

%macro tabell_3Ne;
/*!
#### Formål
{: .no_toc}


*/


Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

PROC TABULATE DATA=&Bo._Agg_Rate;	
	VAR Ant_Innbyggere Ant_Opphold RV_rate RV_just_rate SDJUSTRate KI_N_J KI_O_J;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
		sum=''*(Ant_Innbyggere='Innbyggere'*Format=12.0 Ant_Opphold="&forbruksmal"*Format=12.0 RV_rate='Ujust.rate'*Format=12.&rateformat 
		RV_just_rate='Just.rate'*Format=12.&rateformat SDJUSTRate='Std.avvik'*Format=12.3
		KI_N_J='Nedre KI'*Format=12.3 KI_O_J='Øvre KI'*Format=12.3 ) 
		/BOX={LABEL="Rater - &SnittOmraade" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &Min_alder - &Max_alder år, &SnittOmraade";
RUN;
%mend tabell_3Ne;

%macro Tabell_3;
/*!
#### Formål
{: .no_toc}


*/

Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

PROC TABULATE DATA=&Bo._Agg_Rate ;	
	VAR Ant_Innbyggere Ant_Opphold RV_rate RV_just_rate SDJUSTRate KI_N_J KI_O_J;
	CLASS &Bo /	ORDER=UNFORMATTED MISSING;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar=''*&Bo='',
		sum=''*(Ant_Innbyggere='Innbyggere'*Format=Nlnum12.0 Ant_Opphold="&forbruksmal"*Format=Nlnum12.0 RV_rate='Ujust.rate'*Format=Nlnum12.&rateformat 
		RV_just_rate='Just.rate'*Format=Nlnum12.&rateformat SDJUSTRate='Std.avvik'*Format=Nlnum12.3
		KI_N_J='Nedre KI'*Format=Nlnum12.3 KI_O_J='Øvre KI'*Format=Nlnum12.3 )  
		/BOX={LABEL="Rater - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;

PROC TABULATE
DATA=&Bo._Agg_CV Format=Nlnum12.3;
	VAR CV SCV OBV RCV;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
	mean=' '*(CV*Format=Nlnum12.3 SCV*Format=Nlnum12.3 OBV*Format=Nlnum12.3 RCV*Format=Nlnum12.3)
	/BOX={Label="CV - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "Variasjonsmål &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;
%mend Tabell_3;

%macro Tabell_3e;
/*!
#### Formål
{: .no_toc}


*/

Data _null_;
set aldersspenn;
call symput('Min_alder', trim(left(put(minalder,8.))));
call symput('Max_alder', trim(left(put(maxalder,8.))));
run;

PROC TABULATE DATA=&Bo._Agg_Rate ;	
	VAR Ant_Innbyggere Ant_Opphold RV_rate RV_just_rate SDJUSTRate KI_N_J KI_O_J;
	CLASS &Bo /	ORDER=UNFORMATTED MISSING;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar=''*&Bo='',
		sum=''*(Ant_Innbyggere='Innbyggere'*Format=12.0 Ant_Opphold="&forbruksmal"*Format=12.0 RV_rate='Ujust.rate'*Format=12.&rateformat 
		RV_just_rate='Just.rate'*Format=12.&rateformat SDJUSTRate='Std.avvik'*Format=12.3
		KI_N_J='Nedre KI'*Format=12.3 KI_O_J='Øvre KI'*Format=12.3 )  
		/BOX={LABEL="Rater - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;

PROC TABULATE
DATA=&Bo._Agg_CV Format=12.3;
	VAR CV SCV OBV RCV;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
	mean=' '*(CV*Format=12.3 SCV*Format=12.3 OBV*Format=12.3 RCV*Format=12.3)
	/BOX={Label="CV - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "Variasjonsmål &ratevariabel, &Min_alder - &Max_alder år, &Bo";
RUN;
%mend Tabell_3e;

