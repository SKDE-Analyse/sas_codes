
%macro omraade(HN = 0);

/*!
#### Form�l

Selve rateberegningene. Ratene beregnes basert p� &bo 

#### "Steg for steg"-beskrivelse

Kommer senere...

#### Avhengig av f�lgende datasett

- RV
- andel

#### Lager f�lgende datasett

- RV&Bo
- &Bo._Agg
- &Bo._Agg_Snitt
- alder
- &Bo._Agg_rate
- &Bo._AGG_CV
- NORGE_AGG_RATE2
- NORGE_AGG_RATE3
- NORGE_AGG_RATE4
- NORGE_AGG_RATE5

#### Avhengig av f�lgende variabler

- Slutt�r
- Start�r
- Bo
- aar
- forbruksmal

#### Definerer f�lgende makro-variabler

- Antall_aar

#### Kalles opp av f�lgende makroer

- [rateberegninger](#rateberegninger)

#### Bruker f�lgende makroer

Ingen

#### Annet

*/

/* Definer justering til direkte justering, hvis ikke definert */
%if %sysevalf(%superq(justering)=,boolean) %then %let justering = 1;

%global rate_var;
%if &justering = 0 %then %let rate_var = rv_rate;
%if &justering = 1 %then %let rate_var = rv_just_rate;
%if &justering = 2 %then %let rate_var = rv_ijust_rate;

%let Antall_aar=%sysevalf(&Slutt�r-&Start�r+2);
data RV&Bo;
set RV;
%if &HN = 1 %then %do;
If VertskommHN=1 then VK=1;
else if VertskommHN ne 1 then VK=0;
Where BoRHF=1;
%end;
run;

/*Aggregerer ratevariabel og innbyggere p� boomr�de, �r, alder og kj�nn*/
proc sql;
    create table tmp1&Bo._Agg as
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
   SELECT alder_ny,ErMann,&Bo,(AVG(N_RV)) AS N_RV,(AVG(N_Innbyggere)) AS N_Innbyggere
      FROM tmp1&Bo._Agg
      GROUP BY alder_ny, ErMann, &Bo;
QUIT;

/*Setter gjennomsnitts�r lik 9999*/
data &Bo._Agg_Snitt;
set &Bo._Agg_Snitt;
aar=9999;
run;

/*sl�r sammen �rsspesifikt og gjennomsnittsdatasett*/
Data tmp2&Bo._Agg;
set tmp1&Bo._Agg &Bo._Agg_Snitt;
run;

/*------------------
Aggregere opp innbyggere p� BoOmr-niv� (IKKE kj�nn og alder).
Beh�ves til rateberegninger og output-fil.
-----------------*/ 
PROC SQL;
   CREATE TABLE tmp3&Bo._Agg AS 
   SELECT aar, alder_ny, ErMann,&Bo, N_RV, N_Innbyggere, 
          (SUM(N_RV)) AS RV_tot,(SUM(N_Innbyggere)) AS Innbyggere_tot,(FREQ(N_Innbyggere)) AS Kategorier		/*Kategorier inneholder antall kj�nns/alderskategorier*/
      FROM tmp2&Bo._Agg
      GROUP BY aar, &Bo;
QUIT;

/*VURDERE OM OVENST�ENDE STEG KAN ERSTATTES (DELVIS?) MED PROC MEANS*/

/* hente hvilken innbyggerandel (av den nasjonale befolkningen) som befinner seg i hver kj�nns-og alderskategori */
/*Legges inn i nytt datasett sammen med tmp3*/

proc sql;
create table alder as
select distinct alderny
from andel;
quit;

PROC SQL;
 CREATE TABLE tmp4&Bo._Agg AS
 SELECT a.*, andel
 FROM tmp3&Bo._Agg a left join Andel b
 ON a.alder_ny=b.alderny and a.ermann=b.ermann;
QUIT;


/*j st�r for kj�nns og alderskategori (sum-tellevariabel)*/
/*Tar med alt fra tmp4 og legger til noen variabler*/
/*Datasettet &Bo._AGG brukes videre i rateberegningene*/

PROC SQL;
   CREATE TABLE &Bo._AGG AS 
   SELECT *, (SUM(N_RV)) AS RV_jN, 
           (SUM(N_Innbyggere)) AS Innbyggere_jN
      FROM tmp4&Bo._AGG
      GROUP BY alder_ny, ermann, aar;
QUIT;

%if %sysevalf(%superq(test)=,boolean) %then %let test = 0;
%if &test=0 %then %do;
proc delete data=tmp1&Bo._Agg tmp2&Bo._Agg tmp3&Bo._Agg tmp4&Bo._Agg;
run;
%end;

/* Beregninger */

data &Bo._Agg;
set &Bo._Agg;
/*
RV_jN= Antall case i hver kj�nns/alderskategori i hvert boomr�de. 
N_Innbyggere = Innbyggere i hver kj�nns/alderskategori for hvert boomr�de.  
Innbyggere_jN = Innbyggere i hver kj�nns/alderskategori i Norge
*/

/*HER FOREG�R DEN DIREKTE JUSTERINGEN!!!! */
	e_i=RV_jN*(N_Innbyggere/Innbyggere_jN);  
	rate_RV=(RV_tot/Innbyggere_tot)*(&rate_pr/Kategorier); 
	just_rate_RV=((N_RV/N_Innbyggere)*&rate_pr)*Andel; 
	SD=(&rate_pr/Innbyggere_tot)*(sqrt(RV_tot))*(1/Kategorier); 
	VarJust=(N_RV/(N_Innbyggere**2))*(andel**2)*(&rate_pr**2); 
run;

/*Summerer over kj�nns/alderskategorier. Sitter igjen med rater/andre variable for hvert boomr�de og �r.*/
proc sql;
    create table tmp1&Bo._Agg_rate as
    select distinct aar, &Bo, /* ny SVC */ kategorier,
(sum(rate_RV)) as RV_rate, (sum(just_rate_RV)) as rv_just_rate, 
(sum(N_Innbyggere)) as Ant_Innbyggere, (sum(N_RV)) as Ant_Opphold,
(sum(SD)) as SD_rate, (sqrt(sum(VarJust))) as SDJUSTRate, /* ny SVC */ (sum(e_i)) as ei 
    from &Bo._Agg
    group by aar, &Bo;
quit;

/* Til kartkategorier */
/*Lager variabel mean som brukes i kartmakro til visuell utforming*/
proc sql;
    create table tmp2&Bo._Agg_rate as
    select distinct aar, &Bo, RV_rate, rv_just_rate, Ant_Innbyggere, Ant_Opphold, SD_rate, SDJUSTRate, /* ny SVC */ ei, kategorier,
	(mean(rv_just_rate)) as mean 
	from tmp1&Bo._Agg_rate
group by aar;
   quit;

   /*Legges p� konfidensintervall. Konfidensintervallene gir konfidens for justeringen?*/
data tmp2&Bo._Agg_rate;
set tmp2&Bo._Agg_rate;
if aar ne 9999 then do;
	KI_N=RV_rate-(1.96*SD_rate);
	KI_O=RV_rate+(1.96*SD_rate);
	KI_N_J=rv_just_rate-(1.96*SDJUSTRate);
	KI_O_J=rv_just_rate+(1.96*SDJUSTRate);
end;
If aar=9999 then do; /*Etter innspill fra HelseVest (Jofrid) - KI for snitt skal ganges med 1/rot(antall_�r) */
/*	KI_N=(1/(sqrt((&antall_aar-1))))*(RV_rate-(1.96*SD_rate));*/
/*	KI_O=(1/(sqrt((&antall_aar-1))))*(RV_rate+(1.96*SD_rate));*/
/*	KI_N_J=(1/(sqrt((&antall_aar-1))))*(rv_just_rate-(1.96*SDJUSTRate));*/
/*	KI_O_J=(1/(sqrt((&antall_aar-1))))*(rv_just_rate+(1.96*SDJUSTRate));*/

	KI_N=(RV_rate-((1/(sqrt((&antall_aar-1))))*(1.96*SD_rate)));
	KI_O=(RV_rate+((1/(sqrt((&antall_aar-1))))*(1.96*SD_rate)));
	KI_N_J=(rv_just_rate-((1/(sqrt((&antall_aar-1))))*(1.96*SDJUSTRate)));
	KI_O_J=(rv_just_rate+((1/(sqrt((&antall_aar-1))))*(1.96*SDJUSTRate)));

end;
MCV=rv_just_rate*Ant_Innbyggere;
SDCV=rv_just_rate**2*Ant_Innbyggere;
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
		  /* SUM_of_BoOmr�de */ /* ny SVC */
			(COUNT(&Bo)) AS Boomr
      FROM tmp2&Bo._AGG_Rate
      GROUP BY aar;
QUIT;

data &Bo._AGG_CV;
set &Bo._AGG_CV;
meancv=SUM_of_MCV/SUM_of_Ant_Innbyggere;
SD=sqrt((SUM_of_SDCV/SUM_of_Ant_Innbyggere)-meancv**2);
CV=SD/meancv;
SCV=100*((SUM_of_obs_grunnlag-SUM_of_random_grunnlag)/Boomr);
OBV=SUM_of_obs_grunnlag;
RCV=SUM_of_random_grunnlag;
run;

proc sort data=tmp2&Bo._Agg_rate;
by aar;
run;

data &Bo._Agg_rate;
retain aar bohf rv_rate RV_just_rate RV_ijust_rate;
Merge tmp2&Bo._Agg_rate &Bo._AGG_CV;
By aar;

/* calculate the INDIRECT adjusted rate */
factor=Ant_Opphold/ei;
RV_ijust_rate=factor*(SUM_of_Ant_Opphold/SUM_of_Ant_Innbyggere)*&rate_pr;

drop SUM_of_MCV SUM_of_SDCV meancv CV;
run;

%if %sysevalf(%superq(test)=,boolean) %then %let test = 0;
%if &test=0 %then %do;
proc delete data=tmp1&Bo._Agg_rate tmp2&Bo._Agg_rate;
run;
%end;

/*Tilpasning til � lage Norge som s�yle*/
PROC SQL;
   CREATE TABLE NORGE_AGG_RATE2 AS 
   SELECT aar, Norge, &rate_var, Ant_Innbyggere,Ant_Opphold
      FROM NORGE_AGG_RATE;
QUIT;

proc transpose data=NORGE_AGG_RATE2 out=NORGE_AGG_RATE3 name=&rate_var
prefix=rate;
*by &bo notsorted;
id aar;
var &rate_var;
run; quit;

data NORGE_AGG_RATE3;
set NORGE_AGG_RATE3;
&rate_var._sum=rateSnitt;
drop &rate_var;
aar=9999;
run;

data NORGE_AGG_RATE4;
set NORGE_AGG_RATE2;
where aar=9999;
drop &rate_var;
run;

proc sql;
create table NORGE_AGG_RATE5 as
select NORGE_AGG_RATE3.*, NORGE_AGG_RATE4.Norge, NORGE_AGG_RATE4.Ant_Innbyggere, NORGE_AGG_RATE4.Ant_Opphold
from NORGE_AGG_RATE3 left join NORGE_AGG_RATE4
on NORGE_AGG_RATE3.aar=NORGE_AGG_RATE4.aar;
quit; title;

data NORGE_AGG_RATE5;
set NORGE_AGG_RATE5;
rename Ant_Opphold=&forbruksmal;
rename Ant_Innbyggere=Innbyggere;
max=max(of ra:);
min=min(of ra:);
Norge=rateSnitt;
run; 
/*Slutt tilpasning til � lage Norge som s�yle*/
%mend omraade;
