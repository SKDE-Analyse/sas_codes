
%macro aarsvar;
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