

%macro omraadeHN;

/*!
#### Formål
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}

1. 

#### Avhengig av følgende datasett
{: .no_toc}

-

#### Lager følgende datasett
{: .no_toc}

-

#### Avhengig av følgende variabler
{: .no_toc}

-

#### Definerer følgende variabler
{: .no_toc}


#### Kalles opp av følgende makroer
{: .no_toc}

-

#### Bruker følgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}

*/

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