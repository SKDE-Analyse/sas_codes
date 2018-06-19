%macro lag_kart;

/*!
#### Form�l
{: .no_toc}

#### "Steg for steg"-beskrivelse
{: .no_toc}
1. 

#### Avhengig av f�lgende datasett
{: .no_toc}
-

#### Lager f�lgende datasett
{: .no_toc}

-

#### Avhengig av f�lgende variabler
{: .no_toc}

-

#### Definerer f�lgende variabler
{: .no_toc}


#### Kalles opp av f�lgende makroer
{: .no_toc}

-

#### Bruker f�lgende makroer
{: .no_toc}

-

#### Annet
{: .no_toc}

*/

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
				3='St�rre enn gjennomsnitt + 1*st.avvik';
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
title "Kart &Bo, avvik fra snittet for landet, &standard rater, &ratevariabel, &Min_alder - &Max_alder �r, Snitt for perioden";
proc gmap data=&Bo._Kart map=&kart_&Bo&kartaar density=1;
id &bo;
choro col&antall_aar/CDEFAULT=CXFFFF99 midpoints=(1,2,3);
label col&antall_aar='Ratekategorier';
run;
quit;
Title; %end;

%if &bo=bydel %then %do;
title "Kart &Bo, avvik fra snittet for landet, &standard rater, &ratevariabel, &Min_alder - &Max_alder �r, Snitt for perioden";
proc gmap data=&Bo._Kart map=&kart_&Bo&kartaar anno=skdekart.oslo_txt_anno density=1;
id &bo;
choro col&antall_aar/CDEFAULT=CXFFFF99 midpoints=(1,2,3) anno=skdekart.oslo_hf_anno;
label col&antall_aar='Ratekategorier';
run;
quit;
Title; %end;*/

goptions reset=pattern;
%if &bo=BoRHF %then %do;
title "Kart &Bo, &standard rater, &ratevariabel, &Min_alder - &Max_alder �r, Snitt for perioden";
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
title "Kart &Bo, &standard rater, &ratevariabel, &Min_alder - &Max_alder �r, Snitt for perioden";
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
title "Kart &Bo, &standard rater, &ratevariabel, &Min_alder - &Max_alder �r, Snitt for perioden";
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