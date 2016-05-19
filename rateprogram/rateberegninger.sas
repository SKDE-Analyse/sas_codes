


%macro utvalgx;

%if &Antall_aar=2 %then %do;
	proc format; Value aar
	&År1="&År1" 9999='Snitt';	run;
%end;
%if &Antall_aar=3 %then %do;
	proc format; Value aar
	&År1="&År1" &År2="&År2" 9999='Snitt';	run;
%end;
%if &Antall_aar=4 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3" 9999='Snitt';	run;
%end;
%if &Antall_aar=5 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3"	&År4="&År4" 9999='Snitt';	run;
%end;
%if &Antall_aar=6 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3" &År4="&År4" &År5="&År5"	9999='Snitt';	run;
%end;
%if &Antall_aar=7 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3"	&År4="&År4" &År5="&År5"	&År6="&År6" 9999='Snitt';	run;
%end;
%if &Antall_aar=8 %then %do;
	proc format; Value aar
	&År1="&År1"	&År2="&År2" &År3="&År3"	&År4="&År4" &År5="&År5"	&År6="&År6" &År7="&År7" 9999='Snitt';	run;
%end;

options locale=NB_NO;

	data utvalgX;
	set &Ratefil; /*HER MÅ DET AGGREGERTE RATEGRUNNLAGSSETTET SETTES INN */
		RV=&RV_variabelnavn; /* Definerer RV som ratevariabel */
	keep RV ermann aar alder komnr bydel;
	&aldjust;
	run;

	/*----------------------------*/

	PROC SQL;
	   CREATE TABLE utvalgx AS
	   SELECT DISTINCT aar,KomNr,bydel,Alder,ErMann,(SUM(RV)) AS RV
	      FROM UTVALGX
		  where aar in &Periode and Ermann in &kjonn and Alder &aldersspenn and 0<komnr<2031
	      GROUP BY aar, KomNr, bydel, Alder, ErMann;	  
	QUIT;

	data innb_aar;
	set &innbyggerfil;
	keep aar komnr bydel Ermann Alder innbyggere;
	where aar in &Periode and Ermann in &kjonn and Alder &aldersspenn and 0<komnr<2031;
	&aldjust; 
	run;

	PROC SQL;
	   CREATE TABLE innb_aar AS 
	   SELECT DISTINCT aar,KomNr, bydel, Alder,ErMann,(SUM(Innbyggere)) AS Innbyggere
	      FROM innb_aar
	      GROUP BY aar, KomNr, Alder, bydel, ErMann;
	QUIT;

	PROC SQL;
	 CREATE TABLE utvalgx AS
	 SELECT *
	 FROM innb_aar left join utvalgx
	 ON utvalgx.komnr=innb_aar.komnr and utvalgx.bydel=innb_aar.bydel and utvalgx.aar=innb_aar.aar 
		and utvalgx.ermann=innb_aar.ermann and utvalgx.alder=innb_aar.alder;
	QUIT; 

	proc datasets nolist;
	delete innb_aar;
	run;

	/* Definere alderskategorier */

	%valg_kategorier;	

	data RV;
	set Utvalgx;
	where alder_ny ne .; 
	if RV=. then RV=0;
	run;

	Proc means data=RV min max noprint;
	var alder;
	class alder_ny;
	where alder_ny ne .;
	Output out=alderdef Min=Min Max=Max / AUTONAME AUTOLABEL INHERIT;
	Run;

	data alderdef;
	set alderdef;
	aldernytall=catx('-',put(min,3.),put(max,3.));
	ar='år';
	alderny=catx(' ',aldernytall,ar);
	run;

	PROC SQL;
	 CREATE TABLE RV AS
	 SELECT *
	 FROM RV left join alderdef
	 ON RV.alder_ny=alderdef.alder_ny;
	QUIT;

	data RV;
	set RV;
	keep aar alder ermann Innbyggere KomNr bydel rv alderny;
	format aar aar.;
	run;

	proc delete data=alderdef utvalgx;
	run;

	/* beregne andeler */
	proc sql;
	    create table Andel as
	    select distinct aar, alderny, ErMann, sum(innbyggere) as innbyggere 
	    from RV
		where aar=&aar
	    group by aar, alderny, ErMann;
	quit;

	proc sql;
	    create table Andel as
	    select distinct aar, alderny, ErMann, innbyggere, sum(innbyggere) as N_innbygg, innbyggere/sum(innbyggere) as andel  
	    from Andel;
	quit;

	/* legg på boområder */
	/*%include "\\tos-sastest-07\SKDE\rateprogram\Rateprogram_Boomraader.sas";
	%include "\\tos-sastest-07\SKDE\rateprogram\Rateprogram_BoFormat.sas";*/
	data RV;
	set RV;
	%Boomraader;
	rename alderny=alder_ny;
	run;
%mend utvalgx;

/* Ny versjon Rateprogram
Frank Olsen 19/10-15
*/

%macro omraadeNorge;
	%let Bo=Norge;

/*Makro for beregninger*/
proc sql;
    create table &Bo._Agg as
    select distinct aar, alder_ny, ErMann, &Bo,
(Sum(RV)) as N_RV, (SUM(Innbyggere)) as N_Innbyggere
    from RV where &Bo ne .
    group by aar, alder_ny, ErMann, &Bo;
quit;
/*-----------------------------
Lage gjennomsnitt for perioden
1. Lage gjennomsnitt
2. Legge til i BoOmr_Agg
-----------------------------*/

PROC SQL;
   CREATE TABLE &Bo._Agg_Snitt AS 
   SELECT aar,alder_ny,ErMann,&Bo,(AVG(N_RV)) AS N_RV,(AVG(N_Innbyggere)) AS N_Innbyggere
      FROM &Bo._Agg
      GROUP BY alder_ny, ErMann, &Bo;
QUIT;

data &Bo._Agg_Snitt;
set &Bo._Agg_Snitt;
Where aar=&aar;
aar=9999;
run;

Data &Bo._Agg;
set &Bo._Agg &Bo._Agg_Snitt;
run;

/*------------------
Aggregere opp innbyggere på BoOmr-nivå
-----------------*/ 
PROC SQL;
   CREATE TABLE &Bo._Agg AS 
   SELECT aar, alder_ny, ErMann,&Bo, N_RV, N_Innbyggere, 
          (SUM(N_RV)) AS RV_tot,(SUM(N_Innbyggere)) AS Innbyggere_tot,(FREQ(N_Innbyggere)) AS Kategorier
      FROM &Bo._Agg
      GROUP BY aar, &Bo;
QUIT;

/* hente inn nasjonale andeler */

PROC SQL;
 CREATE TABLE &Bo._Agg AS
 SELECT *
 FROM &Bo._Agg left join Andel
 ON &Bo._Agg.alder_ny=Andel.alderny;
QUIT;


%mend omraadeNorge;


%macro omraade;

data RV&Bo;
set RV;
run;

proc sql;
    create table &Bo._Agg as
    select distinct aar, alder_ny, ErMann, &Bo,
(Sum(RV)) as N_RV, (SUM(Innbyggere)) as N_Innbyggere
    from RV&Bo where &Bo ne .
    group by aar, alder_ny, ErMann, &Bo;
quit;
/*-----------------------------
Lage gjennomsnitt for perioden
1. Lage gjennomsnitt
2. Legge til i BoOmr_Agg
-----------------------------*/

PROC SQL;
   CREATE TABLE &Bo._Agg_Snitt AS 
   SELECT aar,alder_ny,ErMann,&Bo,(AVG(N_RV)) AS N_RV,(AVG(N_Innbyggere)) AS N_Innbyggere
      FROM &Bo._Agg
      GROUP BY alder_ny, ErMann, &Bo;
QUIT;

data &Bo._Agg_Snitt;
set &Bo._Agg_Snitt;
Where aar=&aar;
aar=9999;
run;

Data &Bo._Agg;
set &Bo._Agg &Bo._Agg_Snitt;
run;

/*------------------
Aggregere opp innbyggere på BoOmr-nivå
-----------------*/ 
PROC SQL;
   CREATE TABLE &Bo._Agg AS 
   SELECT aar, alder_ny, ErMann,&Bo, N_RV, N_Innbyggere, 
          (SUM(N_RV)) AS RV_tot,(SUM(N_Innbyggere)) AS Innbyggere_tot,(FREQ(N_Innbyggere)) AS Kategorier
      FROM &Bo._Agg
      GROUP BY aar, &Bo;
QUIT;

/* hente inn nasjonale andeler */

data andel;
set andel;
keep aar alderny ermann andel;
run;

proc sql;
create table alder as
select distinct alderny
from andel;
quit;

PROC SQL;
 CREATE TABLE &Bo._Agg AS
 SELECT *
 FROM &Bo._Agg left join Andel
 ON &Bo._Agg.alder_ny=Andel.alderny and &Bo._Agg.ermann=Andel.ermann;
QUIT;

/* Tillegg for SVC */

PROC SQL;
   CREATE TABLE &Bo._AGG AS 
   SELECT *, /* SUM_of_N_RV */ (SUM(N_RV)) AS RV_jN, 
          /* SUM_of_N_Innbyggere */ (SUM(N_Innbyggere)) AS Innbyggere_jN
      FROM &Bo._AGG
      GROUP BY alder_ny, ermann, aar;
QUIT;

/* Beregninger */

data &Bo._Agg;
set &Bo._Agg;
/* ny SVC */ e_i=RV_jN*(N_Innbyggere/Innbyggere_jN);
	rate_RV=(RV_tot/Innbyggere_tot)*(&rate_pr/Kategorier); 
	just_rate_RV=((N_RV/N_Innbyggere)*&rate_pr)*Andel; 
	SD=(&rate_pr/Innbyggere_tot)*(sqrt(RV_tot))*(1/Kategorier); 
	VarJust=(N_RV/(N_Innbyggere**2))*(andel**2)*(&rate_pr**2); 
run;


proc sql;
    create table &Bo._Agg_rate as
    select distinct aar, &Bo, /* ny SVC */ kategorier,
(sum(rate_RV)) as RV_rate, (sum(just_rate_RV)) as RV_just_rate, 
(sum(N_Innbyggere)) as Ant_Innbyggere, (sum(N_RV)) as Ant_Opphold,
(sum(SD)) as SD_rate, (sqrt(sum(VarJust))) as SDJUSTRate, /* ny SVC */ (sum(e_i)) as ei 
    from &Bo._Agg
    group by aar, &Bo;
quit;

/* Til kartkategorier */
proc sql;
    create table &Bo._Agg_rate as
    select distinct aar, &Bo, RV_rate, RV_just_rate, Ant_Innbyggere, Ant_Opphold, SD_rate, SDJUSTRate, /* ny SVC */ ei, kategorier,
	(mean(RV_just_rate)) as mean 
	from &Bo._Agg_rate
group by aar;
   quit;

data &Bo._Agg_rate;
set &Bo._Agg_rate;
KI_N=RV_rate-(1.96*SD_rate);
KI_O=RV_rate+(1.96*SD_rate);
KI_N_J=RV_just_rate-(1.96*SDJUSTRate);
KI_O_J=RV_just_rate+(1.96*SDJUSTRate);
MCV=RV_just_rate*Ant_Innbyggere;
SDCV=RV_just_rate**2*Ant_Innbyggere;
/* ny alternativ SVC */ 
obs_grunnlag=((Ant_Opphold-ei)/ei)**2;
random_grunnlag=1/ei;
run;

/* Beregne CV og SVC */

PROC SQL;
   CREATE TABLE &Bo._AGG_CV AS 
   SELECT aar, /* ny SVC */ kategorier,
          /* SUM_of_Ant_Innbyggere */
            (SUM(Ant_Innbyggere)) AS SUM_of_Ant_Innbyggere, 
          /* SUM_of_MCV */
            (SUM(MCV)) AS SUM_of_MCV, 
          /* SUM_of_SDCV */
            (SUM(SDCV)) AS SUM_of_SDCV,
		  /* SUM_of_obs_grunnlag */ /* ny SVC */
            (SUM(obs_grunnlag)) AS SUM_of_obs_grunnlag,
		  /* SUM_of_random_grunnlag */ /* ny SVC */
            (SUM(random_grunnlag)) AS SUM_of_random_grunnlag,
		  /* SUM_of_Ant_Opphold */ /* ny SVC */
            (SUM(Ant_Opphold)) AS SUM_of_Ant_Opphold,
		/* SUM_of_ei */ /* ny SVC */
            (SUM(ei)) AS SUM_of_ei,
		  /* SUM_of_BoOmråde */ /* ny SVC */
			(COUNT(&Bo)) AS Boomr
      FROM &Bo._AGG_Rate
      GROUP BY aar;
QUIT;

data &Bo._AGG_CV;
set &Bo._AGG_CV;
meancv=SUM_of_MCV/SUM_of_Ant_Innbyggere; /* endrer navn fra mean til meanCV */
SD=sqrt((SUM_of_SDCV/SUM_of_Ant_Innbyggere)-meancv**2);
CV=SD/meancv;
/* ny SVC */
SCV=100*((SUM_of_obs_grunnlag-SUM_of_random_grunnlag)/Boomr);
OBV=SUM_of_obs_grunnlag;
RCV=SUM_of_random_grunnlag;
/*SCV=100*(OBV-RCV);*/
run;

/* Legge til SD i BoOmr_Agg_rate - funker ikke NBNBN */

proc sort data=&Bo._Agg_rate;
by aar;
run;

data &Bo._Agg_rate;
Merge &Bo._Agg_rate &Bo._AGG_CV;
By aar;
drop SUM_of_Ant_Innbyggere SUM_of_MCV SUM_of_SDCV meancv CV;
run;
%mend omraade;

%macro lag_kart;
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
/*Kartmakroer*/
%let Kartlag=_Kartlag;
%let kart_=skdekart.kart_;
%let kartaar=_2015; /* kommunestruktur som ligger til grunn*/

data &Bo._Agg_rate;
set &Bo._Agg_rate;
if (MEAN-SD)<RV_just_rate<(MEAN+SD) then RV_kart=2;
if (MEAN-SD)>=RV_just_rate then RV_kart=1;
if (MEAN+SD)<=RV_just_rate then RV_kart=3;
if SDJUSTRate=. then RV_kart=.;
run;

proc format;
value RV_kart 1='Mindre enn gjennomsnitt - 1*st.avvik'
				2='Rundt gjennomsnitt'
				3='Større enn gjennomsnitt + 1*st.avvik';
run;

data &Bo._Agg_rate;
set &Bo._Agg_rate;
format RV_kart RV_kart.;
run;

proc sort data=&Bo._Agg_rate;
By &Bo;
run;

proc transpose data=&Bo._Agg_rate out=&Bo._Kart;
By &Bo;
Var RV_kart;
run;

PATTERN1 VALUE=SOLID COLOR=CXCECEFF;
PATTERN2 VALUE=SOLID COLOR=CX8282FF;
PATTERN3 VALUE=SOLID COLOR=CX4A4AFF;
legend1 ACROSS=1 POSITION=(MIDDLE RIGHT INSIDE)
LABEL=(JUSTIFY=Left );

title "Kart &Bo, avvik fra snittet for landet, &standard rater, &ratevariabel, &Min_alder - &Max_alder år, Snitt for perioden";
proc gmap data=&Bo._Kart map=&kart_&Bo&kartaar;
id &bo;
choro col&antall_aar/CDEFAULT=CXFFFF99 legend=legend1 midpoints=(1,2,3);
label col&antall_aar='Ratekategorier';
run;
quit;
Title;

goptions reset=pattern;
%if &bo=BoRHF %then %do;
title "Kart &Bo, &standard rater, &ratevariabel, &Min_alder - &Max_alder år, Snitt for perioden";
proc gmap data=&Bo._fig map=&kart_&Bo&kartaar;
where aar=9999;
id &bo;
choro RV_just_rate_sum/levels=4;
*label RV_just_rate_sum;
run;
quit;
Title;
%end;
%if &bo ne BoRHF %then %do;
title "Kart &Bo, &standard rater, &ratevariabel, &Min_alder - &Max_alder år, Snitt for perioden";
proc gmap data=&Bo._fig map=&kart_&Bo&kartaar;
where aar=9999;
id &bo;
choro RV_just_rate_sum/levels=8;
*label RV_just_rate_sum;
run;
quit;
Title;
%end;

%mend lag_kart;

%macro omraadeHN;

data RV&Bo;
set RV;
If VertskommuneHN=1 then VK=1;
else if VertskommuneHN ne 1 then VK=0;
Where BoRHF=1;
run;

proc sql;
    create table &Bo._Agg as
    select distinct aar, alder_ny, ErMann, &Bo,
(Sum(RV)) as N_RV, (SUM(Innbyggere)) as N_Innbyggere
    from RV&Bo where &Bo ne .
    group by aar, alder_ny, ErMann, &Bo;
quit;
/*-----------------------------
Lage gjennomsnitt for perioden
1. Lage gjennomsnitt
2. Legge til i BoOmr_Agg
-----------------------------*/

PROC SQL;
   CREATE TABLE &Bo._Agg_Snitt AS 
   SELECT aar,alder_ny,ErMann,&Bo,(AVG(N_RV)) AS N_RV,(AVG(N_Innbyggere)) AS N_Innbyggere
      FROM &Bo._Agg
      GROUP BY alder_ny, ErMann, &Bo;
QUIT;

data &Bo._Agg_Snitt;
set &Bo._Agg_Snitt;
Where aar=&aar;
aar=9999;
run;

Data &Bo._Agg;
set &Bo._Agg &Bo._Agg_Snitt;
run;

/*------------------
Aggregere opp innbyggere på BoOmr-nivå
-----------------*/ 
PROC SQL;
   CREATE TABLE &Bo._Agg AS 
   SELECT aar, alder_ny, ErMann,&Bo, N_RV, N_Innbyggere, 
          (SUM(N_RV)) AS RV_tot,(SUM(N_Innbyggere)) AS Innbyggere_tot,(FREQ(N_Innbyggere)) AS Kategorier
      FROM &Bo._Agg
      GROUP BY aar, &Bo;
QUIT;

/* hente inn nasjonale andeler */

data andel;
set andel;
keep aar alderny ermann andel;
run;

proc sql;
create table alder as
select distinct alderny
from andel;
quit;

PROC SQL;
 CREATE TABLE &Bo._Agg AS
 SELECT *
 FROM &Bo._Agg left join Andel
 ON &Bo._Agg.alder_ny=Andel.alderny and &Bo._Agg.ermann=Andel.ermann;
QUIT;

/* Tillegg for SVC */

PROC SQL;
   CREATE TABLE &Bo._AGG AS 
   SELECT *, /* SUM_of_N_RV */ (SUM(N_RV)) AS RV_jN, 
          /* SUM_of_N_Innbyggere */ (SUM(N_Innbyggere)) AS Innbyggere_jN
      FROM &Bo._AGG
      GROUP BY alder_ny, ermann, aar;
QUIT;

/* Beregninger */

data &Bo._Agg;
set &Bo._Agg;
/* ny SVC */ e_i=RV_jN*(N_Innbyggere/Innbyggere_jN);
	rate_RV=(RV_tot/Innbyggere_tot)*(&rate_pr/Kategorier); 
	just_rate_RV=((N_RV/N_Innbyggere)*&rate_pr)*Andel; 
	SD=(&rate_pr/Innbyggere_tot)*(sqrt(RV_tot))*(1/Kategorier); 
	VarJust=(N_RV/(N_Innbyggere**2))*(andel**2)*(&rate_pr**2); 
run;


proc sql;
    create table &Bo._Agg_rate as
    select distinct aar, &Bo, /* ny SVC */ kategorier,
(sum(rate_RV)) as RV_rate, (sum(just_rate_RV)) as RV_just_rate, 
(sum(N_Innbyggere)) as Ant_Innbyggere, (sum(N_RV)) as Ant_Opphold,
(sum(SD)) as SD_rate, (sqrt(sum(VarJust))) as SDJUSTRate, /* ny SVC */ (sum(e_i)) as ei 
    from &Bo._Agg
    group by aar, &Bo;
quit;

/* Til kartkategorier */
proc sql;
    create table &Bo._Agg_rate as
    select distinct aar, &Bo, RV_rate, RV_just_rate, Ant_Innbyggere, Ant_Opphold, SD_rate, SDJUSTRate, /* ny SVC */ ei, kategorier,
	(mean(RV_just_rate)) as mean 
	from &Bo._Agg_rate
group by aar;
   quit;

data &Bo._Agg_rate;
set &Bo._Agg_rate;
KI_N=RV_rate-(1.96*SD_rate);
KI_O=RV_rate+(1.96*SD_rate);
KI_N_J=RV_just_rate-(1.96*SDJUSTRate);
KI_O_J=RV_just_rate+(1.96*SDJUSTRate);
MCV=RV_just_rate*Ant_Innbyggere;
SDCV=RV_just_rate**2*Ant_Innbyggere;
/* ny alternativ SVC */ 
obs_grunnlag=((Ant_Opphold-ei)/ei)**2;
random_grunnlag=1/ei;
run;

/* Beregne CV og SVC */

PROC SQL;
   CREATE TABLE &Bo._AGG_CV AS 
   SELECT aar, /* ny SVC */ kategorier,
          /* SUM_of_Ant_Innbyggere */
            (SUM(Ant_Innbyggere)) AS SUM_of_Ant_Innbyggere, 
          /* SUM_of_MCV */
            (SUM(MCV)) AS SUM_of_MCV, 
          /* SUM_of_SDCV */
            (SUM(SDCV)) AS SUM_of_SDCV,
		  /* SUM_of_obs_grunnlag */ /* ny SVC */
            (SUM(obs_grunnlag)) AS SUM_of_obs_grunnlag,
		  /* SUM_of_random_grunnlag */ /* ny SVC */
            (SUM(random_grunnlag)) AS SUM_of_random_grunnlag,
		  /* SUM_of_Ant_Opphold */ /* ny SVC */
            (SUM(Ant_Opphold)) AS SUM_of_Ant_Opphold,
		/* SUM_of_ei */ /* ny SVC */
            (SUM(ei)) AS SUM_of_ei,
		  /* SUM_of_BoOmråde */ /* ny SVC */
			(COUNT(&Bo)) AS Boomr
      FROM &Bo._AGG_Rate
      GROUP BY aar;
QUIT;

data &Bo._AGG_CV;
set &Bo._AGG_CV;
meancv=SUM_of_MCV/SUM_of_Ant_Innbyggere; /* endrer navn fra mean til meanCV */
SD=sqrt((SUM_of_SDCV/SUM_of_Ant_Innbyggere)-meancv**2);
CV=SD/meancv;
/* ny SVC */
SCV=100*((SUM_of_obs_grunnlag-SUM_of_random_grunnlag)/Boomr);
OBV=SUM_of_obs_grunnlag;
RCV=SUM_of_random_grunnlag;
/*SCV=100*(OBV-RCV);*/
run;

/* Legge til SD i BoOmr_Agg_rate - funker ikke NBNBN */

proc sort data=&Bo._Agg_rate;
by aar;
run;

data &Bo._Agg_rate;
Merge &Bo._Agg_rate &Bo._AGG_CV;
By aar;
drop SUM_of_Ant_Innbyggere SUM_of_MCV SUM_of_SDCV meancv CV;
run;
%mend omraadeHN;

/*Standardiseringsgrupper*/

%Macro Firedeltalder;

Proc univariate data=utvalgx noprint;
var alder;
weight rv;
Output out=Alderskvartiler 	pctlpre=P_ pctlpts= 0 to 100 by 25;
Run;
Data Alderskvartiler;
set Alderskvartiler;
StartGr1=P_0;
SluttGr1=P_25;
startGr2=P_25+1;
SluttGr2=P_50;
StartGr3=P_50+1;
SluttGr3=P_75;
StartGr4=P_75+1;
SluttGR4=P_100;
run;

data _null_;
set alderskvartiler;
call symput('StartGr1', trim(left(put(StartGr1,8.))));
call symput('SluttGr1', trim(left(put(SluttGr1,8.))));
call symput('StartGr2', trim(left(put(startGr2,8.))));
call symput('SluttGr2', trim(left(put(SluttGr2,8.))));
call symput('StartGr3', trim(left(put(StartGr3,8.))));
call symput('SluttGr3', trim(left(put(SluttGr3,8.))));
call symput('StartGr4', trim(left(put(startGr4,8.))));
call symput('SluttGr4', trim(left(put(SluttGr4,8.))));
run;
Proc datasets nolist;
delete Alderskvartiler;
run;
%Mend Firedeltalder;

%Macro Femdeltalder;
proc univariate data=utvalgx noprint;
var Alder;
weight rv;
output out=Alderskvantiler  pctlpre=P_ pctlpts= 0 to 100 by 20;
run;
Data Alderskvantiler;
set Alderskvantiler;
StartGr1=P_0;
SluttGr1=P_20;
startGr2=P_20+1;
SluttGr2=P_40;
StartGr3=P_40+1;
SluttGr3=P_60;
StartGr4=P_60+1;
SluttGR4=P_80;
StartGr5=P_80+1;
SluttGR5=P_100;
drop _freq_ _type_ Antall Max Median Min q1 q3;
run;
data _null_;
set alderskvantiler;
call symput('Kvantil1start', trim(left(put(StartGr1,8.))));
call symput('Kvantil1Slutt', trim(left(put(SluttGr1,8.))));
call symput('Kvantil2start', trim(left(put(startGr2,8.))));
call symput('Kvantil2slutt', trim(left(put(SluttGr2,8.))));
call symput('Kvantil3start', trim(left(put(StartGr3,8.))));
call symput('Kvantil3slutt', trim(left(put(SluttGr3,8.))));
call symput('Kvantil4start', trim(left(put(startGr4,8.))));
call symput('Kvantil4slutt', trim(left(put(SluttGr4,8.))));
call symput('Kvantil5start', trim(left(put(startGr5,8.))));
call symput('Kvantil5slutt', trim(left(put(SluttGr5,8.))));
run;
Proc datasets nolist;
delete Alderskvantiler;
run;
%Mend Femdeltalder;

%macro valg_kategorier;
%if &Alderskategorier=40 %then %do;
	%Firedeltalder;
	data utvalgx;
	set utvalgx;
		if Alder le &SluttGr1 then alder_ny=1; 
		else if alder ge &startGr2 and alder le &SluttGr2 then alder_ny=2;
		else if alder ge &StartGr3 and alder le &SluttGr3 then alder_ny=3;
		else if alder ge &StartGr4 then alder_ny=4;
	run;
%end;
%else %if &Alderskategorier=50 %then %do;
	%Femdeltalder;
	data utvalgx;
	set utvalgx;
		if alder le &Kvantil1slutt then alder_ny=1; 
		else if alder ge &Kvantil2start and alder le &Kvantil2slutt then alder_ny=2;
		else if alder ge &Kvantil3start and alder le &Kvantil3slutt then alder_ny=3;
		else if alder ge &Kvantil4start and alder le &Kvantil4slutt then alder_ny=4;
		else if alder ge &Kvantil5start then alder_ny=5;
	run;
%end;
%else %if &Alderskategorier=41 %then %do;
	%Firedeltalder;
	data utvalgx;
	set utvalgx;
		if alder ge &startgr1 and Alder le &SluttGr1 then alder_ny=1; 
		else if alder ge &startGr2 and alder le &SluttGr2 then alder_ny=2;
		else if alder ge &StartGr3 and alder le &SluttGr3 then alder_ny=3;
		else if alder ge &StartGr4  and alder le &SluttGr4 then alder_ny=4;
	run;
%end;
%else %if &Alderskategorier=51 %then %do;
	%Femdeltalder;
	data utvalgx;
	set utvalgx;
		if alder ge &Kvantil1start and Alder le &Kvantil1slutt then alder_ny=1; 
		else if alder ge &Kvantil2start and alder le &Kvantil2slutt then alder_ny=2;
		else if alder ge &Kvantil3start and alder le &Kvantil3slutt then alder_ny=3;
		else if alder ge &Kvantil4start and alder le &Kvantil4slutt then alder_ny=4;
		else if alder ge &Kvantil5start and alder le &Kvantil5slutt then alder_ny=5;
	run;
%end;
%else %if &Alderskategorier=99 %then %do;
	data utvalgx;
	set utvalgx;
		%Alderkat;
	run;
%end;
%mend;

%macro tabell_1;

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
		/BOX={LABEL='Norge' STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none';
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder år, &Bo";
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

/* Tabeller med ujust og KI*/

%macro Tabell_CV;

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

%macro tabell_3N;

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
		/BOX={LABEL="Rater - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &Min_alder - &Max_alder år, &Bo";
RUN;
%mend tabell_3N;

%macro Tabell_3;
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

/* årsvariasjonsfigur */

%macro lag_aarsvarfigur;

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

proc sql;
create table Norgeaarsspenn as
select distinct max(aar) as maxaar, min(aar) as minaar
from RV
where aar ne 9999;
quit;
Data _null_;
set Norgeaarsspenn;
call symput('Min_aar', trim(left(put(minaar,8.))));
call symput('Max_aar', trim(left(put(maxaar,8.))));
run;

data &bo._fig;
set &bo._fig;
keep aar &bo rv_just_rate_sum Ant_Opphold_Sum Ant_Innbyggere_Sum;
run;

proc transpose data=&bo._fig out=snudd name=RV_just_rate_Sum
prefix=rate;
by &bo notsorted;
id aar;
var RV_just_rate_Sum;
run; quit;

data snudd;
set snudd;
drop RV_just_rate_Sum;
aar=9999;
run;

proc sql;
create table &bo._aarsvar as 
select *
from &bo._fig left join snudd 
on &bo._fig.&bo=snudd.&bo;
quit;

data _null_;
set norgesnitt;
call symput('Norge',(rv_just_rate_sum));
run;

options locale=NB_NO;

data &bo._aarsvar;
set &bo._aarsvar;
where aar=9999;
max=max(of ra:);
min=min(of ra:);
rename Ant_innbyggere_sum=Innbyggere;
rename Ant_opphold_sum=&forbruksmal;
run;

data &bo._aarsvar;
set &bo._aarsvar;
format Innbyggere NLnum12.0 &forbruksmal NLnum12.0;
run;

proc sort data=&bo._aarsvar;
by descending rateSnitt;
run;

%include "\\tos-sastest-07\SKDE\SAS_Stiler\stil_figur.sas";
%include "\\tos-sastest-07\SKDE\SAS_Stiler\Anno_logo_kilde_NPR_SSB.sas";

ods graphics on;
ods listing style=stil_figur gpath="c:\temp";
title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &bo, &Min_alder - &Max_alder år, &min_aar - &max_aar";
proc sgplot data=&bo._aarsvar noborder noautolegend sganno=anno pad=(Bottom=5%);
hbarparm category=&bo response=rateSnitt / fillattrs=(color=CX95BDE6); 
     Refline &Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=2) name="Ref1";
			%if &Antall_aar>2 and &aarsobs=1 %then %do; scatter x=rate&år1 y=&Bo / markerattrs=(symbol=squarefilled color=black);%end;
			%if &Antall_aar>2 and &aarsobs=1 %then %do; scatter x=rate&år2 y=&Bo / markerattrs=(symbol=circlefilled color=black); %end;
			%if &Antall_aar>3 and &aarsobs=1 %then %do; scatter x=rate&år3 y=&Bo / markerattrs=(symbol=trianglefilled color=black);%end;
			%if &Antall_aar>4 and &aarsobs=1 %then %do; scatter x=rate&år4 y=&Bo / markerattrs=(symbol=Diamondfilled color=black);%end;
			%if &Antall_aar>5 and &aarsobs=1 %then %do; scatter x=rate&år5 y=&Bo / markerattrs=(symbol=X color=black);%end;
			%if &Antall_aar>6 and &aarsobs=1 %then %do; scatter x=rate&år6 y=&Bo / markerattrs=(symbol=circle color=black);%end;
			%if &aarsobs=1 %then %do; Highlow Y=&Bo low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); %end;
     Yaxistable Innbyggere &forbruksmal /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='Boområde/opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 /*values=(0 to 160 by 40)*/ /*valuesformat=comma8.0*/ valueattrs=(size=7);
     inset (
		%if &Antall_aar>2 and &aarsobs=1 %then %do;"(*ESC*){unicode'25a0'x}"="   &år1" %end;  
	 	%if &Antall_aar>2 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cf'x}"="   &år2" %end;
	 	%if &Antall_aar>3 and &aarsobs=1 %then %do;"(*ESC*){unicode'25b2'x}"="   &år3" %end;
	 	%if &Antall_aar>4 and &aarsobs=1 %then %do;"(*ESC*){unicode'2666'x}"="   &år4" %end;
	 	%if &Antall_aar>5 and &aarsobs=1 %then %do;"(*ESC*){unicode'0058'x}"="   &år5" %end;
		%if &Antall_aar>6 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cb'x}"="   &år6" %end;
        "(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"=" Norge, snitt") 
	 	/ position=bottomright textattrs=(size=7);
run;Title; ods listing close; ods graphics off;

%mend lag_aarsvarfigur;
%macro lagre_data;
	data &forbruksmal._&bo; set &bo._agg_rate; run;
%mend lagre_data;
%macro lagre_Kom_data;
	data &forbruksmal._&bo; set Komnr_agg_rate; run;
%mend lagre_Kom_data;
%macro lagre_KomHN_data;
	data &forbruksmal._&bo._HN; set Komnr_agg_rate; run;
%mend lagre_KomHN_data;

%macro rateberegninger;
proc sql;
create table Norgeaarsspenn as
select distinct max(aar) as maxaar, min(aar) as minaar
from RV
where aar ne 9999;
quit;
Data _null_;
set Norgeaarsspenn;
call symput('Min_aar', trim(left(put(minaar,8.))));
call symput('Max_aar', trim(left(put(maxaar,8.))));
run;

data norge_agg_snitt;
set Norge_agg_snitt;
alder=(substr(alder_ny,1,((find(alder_ny,'-','i'))-1)))-0;
run;

proc sort data=NORGE_AGG_SNITT;
by alder;
run;

title "Aldersstruktur for snitt i perioden (&min_aar-&max_aar)";
PROC TABULATE DATA=NORGE_AGG_SNITT;	
	VAR N_RV N_Innbyggere;
	CLASS alder_ny /	ORDER=data MISSING;
	TABLE alder_ny={LABEL=""} all={Label="Totalt"},
	N_RV={LABEL="&ratevariabel"}*(Sum={LABEL="&forbruksmal"}*F=NLNUM12.0 ColPctSum={LABEL="Andel (%)"}*F=NLNUM8.1*{STYLE={JUST=CENTER}}) 
	N_Innbyggere={LABEL="Innbyggere"}*(Sum={LABEL="Antall"}*F=NLNUM12.0 ColPctSum={LABEL="Andel (%)"}*F=NLNUM8.1*{STYLE={JUST=CENTER}})
	/ BOX={LABEL="Alderskategorier"};
RUN; Title;

%let Bo=Norge; 	%omraade; /*må lage egen for Norge*/
	%if &Vis_tabeller=1 %then %do;
		%tabell_1;
	%end;
	%if &Vis_tabeller=2 %then %do;
		%tabell_1; 
	%end;
	%if &Vis_tabeller=3 %then %do;
		%tabell_1; %tabell_3;
	%end; %lagre_data;

	%if &RHF=1 %then %do;
		%let Bo=BoRHF;
		%omraade;
		%if &Vis_tabeller=1 %then %do;
			%tabell_1;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%tabell_1; %tabell_CV;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%tabell_1; %tabell_CV; %tabell_3;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 %then %do;
			%lag_aarsvarfigur;
		%end; %lagre_data;
	%end;

	%if &HF=1 %then %do;
		%let Bo=BoHF;
		%omraade;
		%if &Vis_tabeller=1 %then %do;
			%tabell_1;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%tabell_1; %tabell_CV;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%tabell_1; %tabell_CV; %tabell_3;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 %then %do;
			%lag_aarsvarfigur;
		%end; %lagre_data;
	%end;

	%if &sykehus_HN=1 %then %do;
		%let Bo=BoShHN;
		%omraadeHN;
		%if &Vis_tabeller=1 %then %do;
			%tabell_1;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%tabell_1; %tabell_CV;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%tabell_1; %tabell_CV; %tabell_3;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 %then %do;
			%lag_aarsvarfigur;
		%end; %lagre_data;
	%end;

	%if &kommune=1 %then %do;
		%let Bo=komnr;
		%omraade;
		%if &Vis_tabeller=1 %then %do;
			%tabell_1;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%tabell_1; %tabell_CV;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%tabell_1; %tabell_CV; %tabell_3;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end; %lagre_Kom_data;
	%end;

	%if &kommune_HN=1 %then %do;
		%let Bo=komnr;
		%omraadeHN;
		%if &Vis_tabeller=1 %then %do;
			%tabell_1;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%tabell_1; %tabell_CV;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%tabell_1; %tabell_CV; %tabell_3;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end; %lagre_KomHN_data;
	%end;

	%if &fylke=1 %then %do;
		%let Bo=fylke;
		%omraade;
		%if &Vis_tabeller=1 %then %do;
			%tabell_1;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%tabell_1; %tabell_CV;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%tabell_1; %tabell_CV; %tabell_3;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 %then %do;
			%lag_aarsvarfigur;
		%end; %lagre_data;
	%end;

	%if &Verstkommune_HN=1 %then %do;
		%let Bo=VK;
		%omraadeHN;
		%if &Vis_tabeller=1 %then %do;
			%tabell_1;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%tabell_1; %tabell_CV;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%tabell_1; %tabell_CV; %tabell_3;
		%end; %lagre_data;
	%end;

%mend rateberegninger;