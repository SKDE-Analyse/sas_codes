%macro lag_aarsvarbilde;
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

%if %sysevalf(%superq(kolonneTo)=,boolean) %then %let kolonneTo = Innbyggere;
%if %sysevalf(%superq(figurnavn)=,boolean) %then %let figurnavn = AA_&RV_variabelnavn._&bo; 
%if %sysevalf(%superq(silent)=,boolean) %then %let silent = 0;

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
keep aar &bo &rate_var._sum Ant_Opphold_Sum Ant_Innbyggere_Sum;
run;

proc transpose data=&bo._fig out=snudd name=&rate_var._sum
prefix=rate;
by &bo notsorted;
id aar;
var &rate_var._sum;
run; quit;

data snudd;
set snudd;
drop &rate_var._sum;
aar=9999;
run;

proc sql;
create table &bo._aarsvar as 
select a.aar, a.&rate_var._sum, a.Ant_Opphold_Sum, a.Ant_Innbyggere_Sum, b.*
from &bo._fig a left join snudd b
on a.&bo=b.&bo;
quit;

data _null_;
set Norge_agg_rate;
If Aar=9999 then do;
call symput('Norge',(&rate_var));
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
rename Ant_innbyggere_sum=&kolonneTo;
rename Ant_opphold_sum=&forbruksmal;
run;

data &bo._aarsvar;
set &bo._aarsvar;
format &kolonneTo NLnum12.0 &forbruksmal NLnum12.0;
run;

proc sort data=&bo._aarsvar;
by descending rateSnitt;
run;


%if &NorgeSoyle=0 %then %do;
%if &silent=0 %then %do;
/*ods graphics on;*/
ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off HEIGHT=&hoyde width=&bredde;
ODS Listing style=stil_figur Image_dpi=300 GPATH=&lagring;
title;
proc sgplot data=&bo._aarsvar noborder noautolegend sganno=anno pad=(Bottom=5%);
where &Mine_Boomraader;
hbarparm category=&bo response=rateSnitt / fillattrs=(color=CX95BDE6); 
     Refline &Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=2) name="Ref1";
			%if &Antall_aar>1 and &aarsobs=1 %then %do; scatter x=rate&år1 y=&Bo / markerattrs=(symbol=squarefilled color=black size=5);%end;
			%if &Antall_aar>2 and &aarsobs=1 %then %do; scatter x=rate&år2 y=&Bo / markerattrs=(symbol=circlefilled color=black size=5); %end;
			%if &Antall_aar>3 and &aarsobs=1 %then %do; scatter x=rate&år3 y=&Bo / markerattrs=(symbol=trianglefilled color=black size=5);%end;
			%if &Antall_aar>4 and &aarsobs=1 %then %do; scatter x=rate&år4 y=&Bo / markerattrs=(symbol=Diamondfilled color=black size=5);%end;
			%if &Antall_aar>5 and &aarsobs=1 %then %do; scatter x=rate&år5 y=&Bo / markerattrs=(symbol=X color=black size=5);%end;
			%if &Antall_aar>6 and &aarsobs=1 %then %do; scatter x=rate&år6 y=&Bo / markerattrs=(symbol=circle color=black size=5);%end;
			%if &aarsobs=1 %then %do; Highlow Y=&Bo low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); %end;
     Yaxistable &forbruksmal &kolonneTo /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='Bosatte i opptaksområde' labelpos=top labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 &skala valueattrs=(size=7);
     inset (
		%if &Antall_aar>1 and &aarsobs=1 %then %do;"(*ESC*){unicode'25a0'x}"="   &år1" %end;  
	 	%if &Antall_aar>2 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cf'x}"="   &år2" %end;
	 	%if &Antall_aar>3 and &aarsobs=1 %then %do;"(*ESC*){unicode'25b2'x}"="   &år3" %end;
	 	%if &Antall_aar>4 and &aarsobs=1 %then %do;"(*ESC*){unicode'2666'x}"="   &år4" %end;
	 	%if &Antall_aar>5 and &aarsobs=1 %then %do;"(*ESC*){unicode'0058'x}"="   &år5" %end;
		%if &Antall_aar>6 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cb'x}"="   &år6" %end;
        "(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"=" &SnittOmraade, snitt") 
	 	/ position=bottomright textattrs=(size=7);
run;Title; ods listing close; /*ods graphics off;*/
%end;
%end;

/*Alternativ årsvariasjonsfigur*/
%if &NorgeSoyle=1 %then %do;

data tmpNORGE_AGG_RATE5;
set NORGE_AGG_RATE5;
rename Innbyggere=&kolonneTo;
run;

data &bo._aarsvar;
set &bo._aarsvar tmpNORGE_AGG_RATE5;
run;

proc datasets nolist;
delete tmpNORGE_AGG_RATE5;
run;

data &bo._aarsvar;
set &bo._aarsvar;
if &bo=. then &bo=8888;
if &bo=8888 then snittrate=ratesnitt;
run;

proc sort data=&bo._aarsvar;
by descending rateSnitt;
run;

%if &silent=0 %then %do;
ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=&bildeformat  border=off HEIGHT=&hoyde width=&bredde;
ODS Listing style=stil_figur Image_dpi=300 GPATH=&lagring;
title;
proc sgplot data=&bo._aarsvar noborder noautolegend sganno=anno pad=(Bottom=5%);
where &Mine_Boomraader;
hbarparm category=&bo response=RateSnitt / fillattrs=(color=CX95BDE6); 
hbarparm category=&bo response=Snittrate / fillattrs=(color=CXC3C3C3);
			%if &Antall_aar>1 and &aarsobs=1 %then %do; scatter x=rate&år1 y=&Bo / markerattrs=(symbol=squarefilled color=black);%end;
			%if &Antall_aar>2 and &aarsobs=1 %then %do; scatter x=rate&år2 y=&Bo / markerattrs=(symbol=circlefilled color=black); %end;
			%if &Antall_aar>3 and &aarsobs=1 %then %do; scatter x=rate&år3 y=&Bo / markerattrs=(symbol=trianglefilled color=black);%end;
			%if &Antall_aar>4 and &aarsobs=1 %then %do; scatter x=rate&år4 y=&Bo / markerattrs=(symbol=Diamondfilled color=black);%end;
			%if &Antall_aar>5 and &aarsobs=1 %then %do; scatter x=rate&år5 y=&Bo / markerattrs=(symbol=X color=black);%end;
			%if &Antall_aar>6 and &aarsobs=1 %then %do; scatter x=rate&år6 y=&Bo / markerattrs=(symbol=circle color=black);%end;
			%if &aarsobs=1 %then %do; Highlow Y=&Bo low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1); %end;
     Yaxistable &forbruksmal &kolonneTo /Label location=inside labelpos=bottom position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='Bosatte i opptaksområde' labelpos=top labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 &skala /*values=(0 to 7 by 1)*/ /*valuesformat=comma8.0*/ valueattrs=(size=7);
%if &aarsobs=1 %then %do;
	inset (
		%if &Antall_aar>1 and &aarsobs=1 %then %do;"(*ESC*){unicode'25a0'x}"="   &år1" %end;  
	 	%if &Antall_aar>2 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cf'x}"="   &år2" %end;
	 	%if &Antall_aar>3 and &aarsobs=1 %then %do;"(*ESC*){unicode'25b2'x}"="   &år3" %end;
	 	%if &Antall_aar>4 and &aarsobs=1 %then %do;"(*ESC*){unicode'2666'x}"="   &år4" %end;
	 	%if &Antall_aar>5 and &aarsobs=1 %then %do;"(*ESC*){unicode'0058'x}"="   &år5" %end;
		%if &Antall_aar>6 and &aarsobs=1 %then %do;"(*ESC*){unicode'25cb'x}"="   &år6" %end;
        ) 
          / position=bottomright textattrs=(size=7);
%end;
run;Title; ods listing close;
%end;

%end;


%mend lag_aarsvarbilde;