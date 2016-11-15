


%macro utvalgx;
%let aarsvarfigur=1;
/*Beregne Âr1, Âr2 osv*/
%let Periode=(&Start≈r:&Slutt≈r);
%let Antall_aar=%sysevalf(&Slutt≈r-&Start≈r+2);
%let ≈r1=%sysevalf(&Start≈r);
%if &Antall_aar ge 2 %then %do;
	%let ≈r2=%sysevalf(&Start≈r+1);
%end;
%if &Antall_aar ge 3 %then %do;
	%let ≈r3=%sysevalf(&Start≈r+2);
%end;
%if &Antall_aar ge 4 %then %do;
	%let ≈r4=%sysevalf(&Start≈r+3);
%end;
%if &Antall_aar ge 5 %then %do;
	%let ≈r5=%sysevalf(&Start≈r+4);
%end;
%if &Antall_aar ge 6 %then %do;
	%let ≈r6=%sysevalf(&Start≈r+5);
%end;
%if &Antall_aar ge 7 %then %do;
	%let ≈r7=%sysevalf(&Start≈r+6);
%end;


%if &Antall_aar=2 %then %do;
	proc format; Value aar
	&≈r1="&≈r1" 9999='Snitt';	run;
%end;
%if &Antall_aar=3 %then %do;
	proc format; Value aar
	&≈r1="&≈r1" &≈r2="&≈r2" 9999='Snitt';	run;
%end;
%if &Antall_aar=4 %then %do;
	proc format; Value aar
	&≈r1="&≈r1"	&≈r2="&≈r2" &≈r3="&≈r3" 9999='Snitt';	run;
%end;
%if &Antall_aar=5 %then %do;
	proc format; Value aar
	&≈r1="&≈r1"	&≈r2="&≈r2" &≈r3="&≈r3"	&≈r4="&≈r4" 9999='Snitt';	run;
%end;
%if &Antall_aar=6 %then %do;
	proc format; Value aar
	&≈r1="&≈r1"	&≈r2="&≈r2" &≈r3="&≈r3" &≈r4="&≈r4" &≈r5="&≈r5"	9999='Snitt';	run;
%end;
%if &Antall_aar=7 %then %do;
	proc format; Value aar
	&≈r1="&≈r1"	&≈r2="&≈r2" &≈r3="&≈r3"	&≈r4="&≈r4" &≈r5="&≈r5"	&≈r6="&≈r6" 9999='Snitt';	run;
%end;
%if &Antall_aar=8 %then %do;
	proc format; Value aar
	&≈r1="&≈r1"	&≈r2="&≈r2" &≈r3="&≈r3"	&≈r4="&≈r4" &≈r5="&≈r5"	&≈r6="&≈r6" &≈r7="&≈r7" 9999='Snitt';	run;
%end;

options locale=NB_NO;

	data utvalgX;
	set &Ratefil; /*HER M≈ DET AGGREGERTE RATEGRUNNLAGSSETTET SETTES INN */
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
	ar='Âr';
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

	/*test 13/6-16*/
	data RV;
	set RV;
	%Boomraader;
	run;

	/* beregne andeler */
	proc sql;
	    create table Andel as
	    select distinct aar, alderny, ErMann, sum(innbyggere) as innbyggere 
	    from RV
		where aar=&aar and &boomraadeN /*test 13/6-16*/
	    group by aar, alderny, ErMann;
	quit;

	proc sql;
	    create table Andel as
	    select distinct aar, alderny, ErMann, innbyggere, sum(innbyggere) as N_innbygg, innbyggere/sum(innbyggere) as andel  
	    from Andel;
	quit;

	/* legg pÂ boomrÂder */
	/*%include "\\tos-sastest-07\SKDE\rateprogram\Rateprogram_Boomraader.sas";
	%include "\\tos-sastest-07\SKDE\rateprogram\Rateprogram_BoFormat.sas";*/
	data RV;
	set RV;
/*	%Boomraader; test 13/6-16*/
	where &boomraade;
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
Aggregere opp innbyggere pÂ BoOmr-nivÂ
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
%let Antall_aar=%sysevalf(&Slutt≈r-&Start≈r+2);
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
Aggregere opp innbyggere pÂ BoOmr-nivÂ
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
if aar ne 9999 then do;
	KI_N=RV_rate-(1.96*SD_rate);
	KI_O=RV_rate+(1.96*SD_rate);
	KI_N_J=RV_just_rate-(1.96*SDJUSTRate);
	KI_O_J=RV_just_rate+(1.96*SDJUSTRate);
end;
If aar=9999 then do; /*Etter innspill fra HelseVest (Jofrid) - KI for snitt skal ganges med 1/rot(antall_Âr) */
/*	KI_N=(1/(sqrt((&antall_aar-1))))*(RV_rate-(1.96*SD_rate));*/
/*	KI_O=(1/(sqrt((&antall_aar-1))))*(RV_rate+(1.96*SD_rate));*/
/*	KI_N_J=(1/(sqrt((&antall_aar-1))))*(RV_just_rate-(1.96*SDJUSTRate));*/
/*	KI_O_J=(1/(sqrt((&antall_aar-1))))*(RV_just_rate+(1.96*SDJUSTRate));*/

	KI_N=(RV_rate-((1/(sqrt((&antall_aar-1))))*(1.96*SD_rate)));
	KI_O=(RV_rate+((1/(sqrt((&antall_aar-1))))*(1.96*SD_rate)));
	KI_N_J=(RV_just_rate-((1/(sqrt((&antall_aar-1))))*(1.96*SDJUSTRate)));
	KI_O_J=(RV_just_rate+((1/(sqrt((&antall_aar-1))))*(1.96*SDJUSTRate)));

end;
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
		  /* SUM_of_BoOmrÂde */ /* ny SVC */
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
				3='St¯rre enn gjennomsnitt + 1*st.avvik';
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

/*%if &bo ne bydel %then %do;
title "Kart &Bo, avvik fra snittet for landet, &standard rater, &ratevariabel, &Min_alder - &Max_alder Âr, Snitt for perioden";
proc gmap data=&Bo._Kart map=&kart_&Bo&kartaar density=1;
id &bo;
choro col&antall_aar/CDEFAULT=CXFFFF99 midpoints=(1,2,3);
label col&antall_aar='Ratekategorier';
run;
quit;
Title; %end;

%if &bo=bydel %then %do;
title "Kart &Bo, avvik fra snittet for landet, &standard rater, &ratevariabel, &Min_alder - &Max_alder Âr, Snitt for perioden";
proc gmap data=&Bo._Kart map=&kart_&Bo&kartaar anno=skdekart.oslo_txt_anno density=1;
id &bo;
choro col&antall_aar/CDEFAULT=CXFFFF99 midpoints=(1,2,3) anno=skdekart.oslo_hf_anno;
label col&antall_aar='Ratekategorier';
run;
quit;
Title; %end;*/

goptions reset=pattern;
%if &bo=BoRHF %then %do;
title "Kart &Bo, &standard rater, &ratevariabel, &Min_alder - &Max_alder Âr, Snitt for perioden";
proc gmap data=&Bo._fig map=&kart_&Bo&kartaar density=1;
where aar=9999;
id &bo;
choro RV_just_rate_sum/levels=4;
label RV_just_rate_sum='Rate';
run;
quit;
Title;
%end;
%if &bo ne BoRHF and &bo ne bydel %then %do;
title "Kart &Bo, &standard rater, &ratevariabel, &Min_alder - &Max_alder Âr, Snitt for perioden";
proc gmap data=&Bo._fig map=&kart_&Bo&kartaar density=1;
where aar=9999;
id &bo;
choro RV_just_rate_sum/levels=5;
label RV_just_rate_sum='Rate';
run;
quit;
Title;
%end;
%if &bo=bydel %then %do;
title "Kart &Bo, &standard rater, &ratevariabel, &Min_alder - &Max_alder Âr, Snitt for perioden";
proc gmap data=&Bo._fig map=&kart_&Bo&kartaar anno=skdekart.oslo_txt_anno density=1;
where aar=9999;
id &bo;
choro RV_just_rate_sum / levels=5 anno=skdekart.oslo_hf_anno;
label RV_just_rate_sum='Rate';
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
Aggregere opp innbyggere pÂ BoOmr-nivÂ
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
		  /* SUM_of_BoOmrÂde */ /* ny SVC */
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
		/BOX={LABEL="&SnittOmraade" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none';
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder Âr, &SnittOmraade";
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
	Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder Âr, &Bo";
RUN;

data HNsnitt;
set &bo._Fig;
keep aar RV_just_rate_sum;
where aar=9999 /*and BoRHF=1*/;/*M≈ FIXES*/
run;
%end;
%mend tabell_1;

%macro tabell_1e;

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
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder Âr, &SnittOmraade";
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
	Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder Âr, &Bo";
RUN;

data HNsnitt;
set &bo._Fig;
keep aar RV_just_rate_sum;
where aar=9999 /*and BoRHF=1*/;/*M≈ FIXES*/
run;
%end;
%mend tabell_1e;


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
		Title "VariasjonsmÂl &ratevariabel, &Min_alder - &Max_alder Âr, &Bo";
RUN;
%mend tabell_cv;

%macro Tabell_CVe;

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
		Title "VariasjonsmÂl &ratevariabel, &Min_alder - &Max_alder Âr, &Bo";
RUN;
%mend tabell_cve;

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
		KI_N_J='Nedre KI'*Format=Nlnum12.3 KI_O_J='ÿvre KI'*Format=Nlnum12.3 ) 
		/BOX={LABEL="Rater - &SnittOmraade" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &Min_alder - &Max_alder Âr, &SnittOmraade";
RUN;
%mend tabell_3N;

%macro tabell_3Ne;

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
		KI_N_J='Nedre KI'*Format=12.3 KI_O_J='ÿvre KI'*Format=12.3 ) 
		/BOX={LABEL="Rater - &SnittOmraade" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &Min_alder - &Max_alder Âr, &SnittOmraade";
RUN;
%mend tabell_3Ne;

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
		KI_N_J='Nedre KI'*Format=Nlnum12.3 KI_O_J='ÿvre KI'*Format=Nlnum12.3 )  
		/BOX={LABEL="Rater - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder Âr, &Bo";
RUN;

PROC TABULATE
DATA=&Bo._Agg_CV Format=Nlnum12.3;
	VAR CV SCV OBV RCV;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
	mean=' '*(CV*Format=Nlnum12.3 SCV*Format=Nlnum12.3 OBV*Format=Nlnum12.3 RCV*Format=Nlnum12.3)
	/BOX={Label="CV - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "VariasjonsmÂl &ratevariabel, &Min_alder - &Max_alder Âr, &Bo";
RUN;
%mend Tabell_3;

%macro Tabell_3e;
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
		KI_N_J='Nedre KI'*Format=12.3 KI_O_J='ÿvre KI'*Format=12.3 )  
		/BOX={LABEL="Rater - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &Min_alder - &Max_alder Âr, &Bo";
RUN;

PROC TABULATE
DATA=&Bo._Agg_CV Format=12.3;
	VAR CV SCV OBV RCV;
	CLASS aar /	ORDER=UNFORMATTED MISSING;
	TABLE aar='',
	mean=' '*(CV*Format=12.3 SCV*Format=12.3 OBV*Format=12.3 RCV*Format=12.3)
	/BOX={Label="CV - &Bo" STYLE={JUST=LEFT VJUST=BOTTOM}} MISSTEXT='none'	;	;
		Title "VariasjonsmÂl &ratevariabel, &Min_alder - &Max_alder Âr, &Bo";
RUN;
%mend Tabell_3e;

/* Ârsvariasjonsfigur */
%macro lag_aarsvarbilde;

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

/*data _null_;
set norgesnitt;
call symput('Norge',(rv_just_rate_sum));
run;*/

data _null_;
set Norge_agg_rate;
If Aar=9999 then do;
call symput('Norge',(rv_just_rate));
Call symput('Norge_KI_N',(KI_N_J));
Call symput('Norge_KI_O',(KI_O_J));
end;
run;

options locale=NB_NO;

data &bo._aarsvar;
set &bo._aarsvar;
where aar=9999;
max=max(of ra:);
min=min(of ra:);
Norge=&Norge;
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

/*data &forbruksmal._&bo; set &bo._aarsvar; run;*/

%include "&filbane.Stiler\stil_figur.sas";
%include "&filbane.Stiler\Anno_logo_kilde_NPR_SSB.sas";

/*ods graphics on;*/
ODS Graphics ON /reset=All imagename="AA_&RV_variabelnavn._&bo" imagefmt=&bildeformat  border=off HEIGHT=&hoyde width=&bredde;
ODS Listing style=stil_figur Image_dpi=300 GPATH=&lagring;
title;
proc sgplot data=&bo._aarsvar noborder noautolegend sganno=anno pad=(Bottom=5%);
where &Mine_Boomraader;
hbarparm category=&bo response=rateSnitt / fillattrs=(color=CX95BDE6); 
     Refline &Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=2) name="Ref1";
			%if &Antall_aar>2 and &aarsobs=1 %then %do; scatter x=rate&Âr1 y=&Bo / markerattrs=(symbol=squarefilled color=black size=5);%end;
			%if &Antall_aar>2 and &aarsobs=1 %then %do; scatter x=rate&Âr2 y=&Bo / markerattrs=(symbol=circlefilled color=black size=5); %end;
			%if &Antall_aar>3 and &aarsobs=1 %then %do; scatter x=rate&Âr3 y=&Bo / markerattrs=(symbol=trianglefilled color=black size=5);%end;
			%if &Antall_aar>4 and &aarsobs=1 %then %do; scatter x=rate&Âr4 y=&Bo / markerattrs=(symbol=Diamondfilled color=black size=5);%end;
			%if &Antall_aar>5 and &aarsobs=1 %then %do; scatter x=rate&Âr5 y=&Bo / markerattrs=(symbol=X color=black size=5);%end;
			%if &Antall_aar>6 and &aarsobs=1 %then %do; scatter x=rate&Âr6 y=&Bo / markerattrs=(symbol=circle color=black size=5);%end;
			%if &aarsobs=1 %then %do; Highlow Y=&Bo low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); %end;
     Yaxistable Innbyggere &forbruksmal /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='BoomrÂde/opptaksomrÂde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 &skala /*values=(0 to 7 by 1)*/ /*valuesformat=comma8.0*/ valueattrs=(size=7);
     inset (
		%if &Antall_aar>2 and &aarsobs=1 %then %do;"(*ESC*){unicode'25a0'x}"="   &Âr1" %end;  
	 	%if &Antall_aar>2 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cf'x}"="   &Âr2" %end;
	 	%if &Antall_aar>3 and &aarsobs=1 %then %do;"(*ESC*){unicode'25b2'x}"="   &Âr3" %end;
	 	%if &Antall_aar>4 and &aarsobs=1 %then %do;"(*ESC*){unicode'2666'x}"="   &Âr4" %end;
	 	%if &Antall_aar>5 and &aarsobs=1 %then %do;"(*ESC*){unicode'0058'x}"="   &Âr5" %end;
		%if &Antall_aar>6 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cb'x}"="   &Âr6" %end;
        "(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"=" &SnittOmraade, snitt") 
	 	/ position=bottomright textattrs=(size=7);
run;Title; ods listing close; /*ods graphics off;*/

%mend lag_aarsvarbilde;

%macro lag_aarsvarfigur;
/**/
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

/*data _null_;
set norgesnitt;
call symput('Norge',(rv_just_rate_sum));
run;*/

data _null_;
set Norge_agg_rate;
If Aar=9999 then do;
call symput('Norge',(rv_just_rate));
Call symput('Norge_KI_N',(KI_N_J));
Call symput('Norge_KI_O',(KI_O_J));
end;
run;

options locale=NB_NO;

data &bo._aarsvar;
set &bo._aarsvar;
where aar=9999;
max=max(of ra:);
min=min(of ra:);
Norge=&Norge;
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

/*data &forbruksmal._&bo; set &bo._aarsvar; run;*/

%include "&filbane.Stiler\stil_figur.sas";
%include "&filbane.Stiler\Anno_logo_kilde_NPR_SSB.sas";

/*ods graphics on;*/
ods listing style=stil_figur gpath="%sysfunc(getoption(work))";
title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &bo, &Min_alder - &Max_alder Âr, &min_aar - &max_aar";
proc sgplot data=&bo._aarsvar noborder noautolegend sganno=anno pad=(Bottom=5%);
where &Mine_Boomraader;
hbarparm category=&bo response=rateSnitt / fillattrs=(color=CX95BDE6); 
     Refline &Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=2) name="Ref1";
			%if &Antall_aar>2 and &aarsobs=1 %then %do; scatter x=rate&Âr1 y=&Bo / markerattrs=(symbol=squarefilled color=black);%end;
			%if &Antall_aar>2 and &aarsobs=1 %then %do; scatter x=rate&Âr2 y=&Bo / markerattrs=(symbol=circlefilled color=black); %end;
			%if &Antall_aar>3 and &aarsobs=1 %then %do; scatter x=rate&Âr3 y=&Bo / markerattrs=(symbol=trianglefilled color=black);%end;
			%if &Antall_aar>4 and &aarsobs=1 %then %do; scatter x=rate&Âr4 y=&Bo / markerattrs=(symbol=Diamondfilled color=black);%end;
			%if &Antall_aar>5 and &aarsobs=1 %then %do; scatter x=rate&Âr5 y=&Bo / markerattrs=(symbol=X color=black);%end;
			%if &Antall_aar>6 and &aarsobs=1 %then %do; scatter x=rate&Âr6 y=&Bo / markerattrs=(symbol=circle color=black);%end;
			%if &aarsobs=1 %then %do; Highlow Y=&Bo low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); %end;
     Yaxistable Innbyggere &forbruksmal /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='BoomrÂde/opptaksomrÂde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 &skala /*values=(0 to 7 by 1)*/ /*valuesformat=comma8.0*/ valueattrs=(size=7);
     inset (
		%if &Antall_aar>2 and &aarsobs=1 %then %do;"(*ESC*){unicode'25a0'x}"="   &Âr1" %end;  
	 	%if &Antall_aar>2 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cf'x}"="   &Âr2" %end;
	 	%if &Antall_aar>3 and &aarsobs=1 %then %do;"(*ESC*){unicode'25b2'x}"="   &Âr3" %end;
	 	%if &Antall_aar>4 and &aarsobs=1 %then %do;"(*ESC*){unicode'2666'x}"="   &Âr4" %end;
	 	%if &Antall_aar>5 and &aarsobs=1 %then %do;"(*ESC*){unicode'0058'x}"="   &Âr5" %end;
		%if &Antall_aar>6 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cb'x}"="   &Âr6" %end;
        "(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"=" &SnittOmraade, snitt") 
	 	/ position=bottomright textattrs=(size=7);
run;Title; ods listing close; /*ods graphics off;*/

%mend lag_aarsvarfigur;

%Macro KI_figur;
Data &bo._KI_Fig; set &bo._agg_rate; Where aar=9999; Norge=&Norge; Norge_KI_N=&Norge_KI_N; Norge_KI_O=&Norge_KI_O;
Label Ant_Innbyggere='Innbyggere' Ant_Opphold=&forbruksmal; format Ant_opphold 8.0; run;
data &bo._KI_Fig;
set &bo._KI_Fig;
format Ant_Innbyggere NLnum12.0 Ant_Opphold NLnum12.0;
run;

proc sort data=&bo._KI_Fig; by descending RV_just_rate; run;

ods listing style=stil_figur;
title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &bo, &Min_alder - &Max_alder Âr, rate med 95% KI, &min_aar - &max_aar";
proc sgplot data=&bo._KI_Fig noborder noautolegend sganno=anno pad=(Bottom=5%);
where &Mine_Boomraader;
hbarparm category=&bo response=RV_just_rate / limitlower=KI_N_J limitupper=KI_O_J Limitattrs=(Color=black) fillattrs=(color=CX95BDE6); 
	 Refline Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=1);
	 Refline Norge_KI_N / axis=x lineattrs=(Thickness=.5 color=Black pattern=2);
	 Refline Norge_KI_O / axis=x lineattrs=(Thickness=.5 color=Black pattern=2);
     Yaxistable Ant_Innbyggere Ant_opphold /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='BoomrÂde/opptaksomrÂde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 &skala /*values=(0 to 7 by 1)*/ /*valuesformat=comma8.0*/ valueattrs=(size=7);
     inset ("(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"=" KI, rate &SnittOmraade"
			"(*ESC*){unicode'2014'x}"=" Rate, &SnittOmraade") / position=bottomright textattrs=(size=7);
run; Title; ods listing close; 
%Mend KI_figur;

%macro KI_bilde;
Data &bo._KI_Fig; set &bo._agg_rate; Where aar=9999; Norge=&Norge; Norge_KI_N=&Norge_KI_N; Norge_KI_O=&Norge_KI_O;
Label Ant_Innbyggere='Innbyggere' Ant_Opphold=&forbruksmal; format Ant_opphold 8.0; run;
data &bo._KI_Fig;
set &bo._KI_Fig;
format Ant_Innbyggere NLnum12.0 Ant_Opphold NLnum12.0;
run;

proc sort data=&bo._KI_Fig; by descending RV_just_rate; run;

ODS Graphics ON /reset=All imagename="KI_&RV_variabelnavn._&bo" imagefmt=&bildeformat  border=off HEIGHT=&hoyde width=&bredde;
ODS Listing style=stil_figur Image_dpi=300 GPATH=&lagring;
proc sgplot data=&bo._KI_Fig noborder noautolegend sganno=anno pad=(Bottom=5%);
where &Mine_Boomraader;
hbarparm category=&bo response=RV_just_rate / limitlower=KI_N_J limitupper=KI_O_J Limitattrs=(Color=black) fillattrs=(color=CX95BDE6); 
	 Refline Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=1);
	 Refline Norge_KI_N / axis=x lineattrs=(Thickness=.5 color=Black pattern=2);
	 Refline Norge_KI_O / axis=x lineattrs=(Thickness=.5 color=Black pattern=2);
     Yaxistable Ant_Innbyggere Ant_opphold /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='BoomrÂde/opptaksomrÂde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 &skala /*values=(0 to 7 by 1)*/ /*valuesformat=comma8.0*/ valueattrs=(size=7);
     inset ("(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"=" KI, rate &SnittOmraade"
			"(*ESC*){unicode'2014'x}"=" Rate, &SnittOmraade") / position=bottomright textattrs=(size=7);
run;Title; ods listing close;
%mend KI_bilde;

%macro lagre_dataNorge;
	data &forbruksmal._&bo; set &bo._agg_rate; run;
%mend lagre_dataNorge;
%macro lagre_dataN;
%if &Ut_sett=1 %then %do;
	data &forbruksmal._S_&bo; set &bo._agg_rate; run;
%end;
%else %do;
	data &forbruksmal._&bo; set &bo._aarsvar; drop aar rv_just_rate_sum; run;
%end;
%mend lagre_dataN;
%macro lagre_dataHN;
%if &Ut_sett=1 %then %do;
	data &forbruksmal._S_&bo._HN; set &bo._agg_rate; run;
%end;
%else %do;
	data &forbruksmal._&bo._HN; set &bo._aarsvar; drop aar rv_just_rate_sum; run;
%end;
%mend lagre_dataHN;

%macro aarsvar;
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

/*data _null_;
set norgesnitt;
call symput('Norge',(rv_just_rate_sum));
run;*/

data _null_;
set Norge_agg_rate;
If Aar=9999 then do;
call symput('Norge',(rv_just_rate));
Call symput('Norge_KI_N',(KI_N_J));
Call symput('Norge_KI_O',(KI_O_J));
end;
run;

options locale=NB_NO;

data &bo._aarsvar;
set &bo._aarsvar;
where aar=9999;
max=max(of ra:);
min=min(of ra:);
Norge=&Norge;
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
%mend aarsvar;

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

%if &tallformat=NLnum %then %do;
title "Aldersstruktur for snitt i perioden (&min_aar-&max_aar), Andeler for &boomraadeN, Rater for &boomraade";
PROC TABULATE DATA=NORGE_AGG_SNITT;	
	VAR N_RV N_Innbyggere;
	CLASS alder_ny /	ORDER=data MISSING;
	TABLE alder_ny={LABEL=""} all={Label="Totalt"},
	N_RV={LABEL="&ratevariabel"}*(Sum={LABEL="&forbruksmal"}*F=NLNUM12.0 ColPctSum={LABEL="Andel (%)"}*F=NLNUM8.1*{STYLE={JUST=CENTER}}) 
	N_Innbyggere={LABEL="Innbyggere"}*(Sum={LABEL="Antall"}*F=NLNUM12.0 ColPctSum={LABEL="Andel (%)"}*F=NLNUM8.1*{STYLE={JUST=CENTER}})
	/ BOX={LABEL="Alderskategorier"};
RUN; Title;
%end;

%if &tallformat=Excel %then %do;
title "Aldersstruktur for snitt i perioden (&min_aar-&max_aar), Andeler for &boomraadeN, Rater for &boomraade";
PROC TABULATE DATA=NORGE_AGG_SNITT;	
	VAR N_RV N_Innbyggere;
	CLASS alder_ny /	ORDER=data MISSING;
	TABLE alder_ny={LABEL=""} all={Label="Totalt"},
	N_RV={LABEL="&ratevariabel"}*(Sum={LABEL="&forbruksmal"}*F=12.0 ColPctSum={LABEL="Andel (%)"}*F=8.1*{STYLE={JUST=CENTER}}) 
	N_Innbyggere={LABEL="Innbyggere"}*(Sum={LABEL="Antall"}*F=12.0 ColPctSum={LABEL="Andel (%)"}*F=8.1*{STYLE={JUST=CENTER}})
	/ BOX={LABEL="Alderskategorier"};
RUN; Title;
%end;

%let aarsvarfigur=1;
/*Beregne Âr1, Âr2 osv*/
%let Periode=(&Start≈r:&Slutt≈r);
%let Antall_aar=%sysevalf(&Slutt≈r-&Start≈r+2);
%let ≈r1=%sysevalf(&Start≈r);
%if &Antall_aar ge 2 %then %do;
	%let ≈r2=%sysevalf(&Start≈r+1);
%end;
%if &Antall_aar ge 3 %then %do;
	%let ≈r3=%sysevalf(&Start≈r+2);
%end;
%if &Antall_aar ge 4 %then %do;
	%let ≈r4=%sysevalf(&Start≈r+3);
%end;
%if &Antall_aar ge 5 %then %do;
	%let ≈r5=%sysevalf(&Start≈r+4);
%end;
%if &Antall_aar ge 6 %then %do;
	%let ≈r6=%sysevalf(&Start≈r+5);
%end;
%if &Antall_aar ge 7 %then %do;
	%let ≈r7=%sysevalf(&Start≈r+6);
%end;

%let Bo=Norge; 	%omraade; /*mÂ lage egen for Norge*/
	%if &Vis_tabeller=1 %then %do;
		%if &tallformat=NLnum %then %do;
			%tabell_1;
		%end;
		%if &tallformat=Excel %then %do;
			%tabell_1e;
		%end;
	%end;

	%if &Vis_tabeller=2 %then %do;
		%if &tallformat=NLnum %then %do;
			%tabell_1;
		%end;
		%if &tallformat=Excel %then %do;
			%tabell_1e;
		%end;
	%end;

	%if &Vis_tabeller=3 %then %do;
		%if &tallformat=NLnum %then %do;
			%tabell_1; %tabell_3N;
		%end;
		%if &tallformat=Excel %then %do;
			%tabell_1e; %tabell_3Ne;
		%end;
	%end; %lagre_dataNorge;

	%if &RHF=1 %then %do;
		%let Bo=BoRHF;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_RHF=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_RHF ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_RHF=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_RHF ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &HF=1 %then %do;
		%let Bo=BoHF;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_HF=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_HF ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_HF=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_HF ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &sykehus_HN=1 %then %do;
		%let Bo=BoShHN;
		%omraadeHN; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_ShHN=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_ShHN ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_ShHN=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_ShHN ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &kommune=1 %then %do;
		%let Bo=komnr;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_kom=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_kom ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_kom=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_kom ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &kommune_HN=1 %then %do;
		%let Bo=komnr;
		%omraadeHN; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end; 
		%if &aarsvarfigur=1 and &Fig_AA_komHN=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_komHN ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_komHN=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_komHN ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

	%if &fylke=1 %then %do;
		%let Bo=fylke;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_fylke=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_fylke ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_fylke=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_fylke ne 1 %then %do;
			%KI_figur;
		%end; 
		%lagre_dataN;
	%end;

	%if &Verstkommune_HN=1 %then %do;
		%let Bo=VK;
		%omraadeHN; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end; 
		%lagre_dataN;
	%end;

		%if &oslo=1 %then %do;
		%let Bo=bydel;
		%omraade; 
		%if &Vis_tabeller=1 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e;
			%end;
		%end;
		%if &Vis_tabeller=2 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe;
			%end;
		%end;
		%if &Vis_tabeller=3 %then %do;
			%if &tallformat=NLnum %then %do;
				%tabell_1; %tabell_CV; %tabell_3;
			%end;
			%if &tallformat=Excel %then %do;
				%tabell_1e; %tabell_CVe; %tabell_3e;
			%end;
		%end;
		%if &kart=1 %then %do;
			%lag_kart;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_Oslo=1 %then %do;
			%lag_aarsvarbilde;
		%end;
		%if &aarsvarfigur=1 and &Fig_AA_Oslo ne 1 %then %do;
			%lag_aarsvarfigur;
		%end;
		%if &KIfigur=1 and &Fig_KI_Oslo=1 %then %do;
			%KI_bilde;
		%end;
		%if &KIfigur=1 and &Fig_KI_Oslo ne 1 %then %do;
			%KI_figur;
		%end;
		%lagre_dataN;
	%end;

%mend rateberegninger;