/* Inkludere makroer:  KI_figur, KI_bilde */


%Macro KI_figur;
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

Data &bo._KI_Fig; set &bo._agg_rate; Where aar=9999; Norge=&Norge; Norge_KI_N=&Norge_KI_N; Norge_KI_O=&Norge_KI_O;
Label Ant_Innbyggere='Innbyggere' Ant_Opphold=&forbruksmal; format Ant_opphold 8.0; run;
data &bo._KI_Fig;
set &bo._KI_Fig;
format Ant_Innbyggere NLnum12.0 Ant_Opphold NLnum12.0;
run;

proc sort data=&bo._KI_Fig; by descending &rate_var; run;

ods listing style=stil_figur;
title "&standard rater pr &rate_pr innbyggere, &ratevariabel, &bo, &Min_alder - &Max_alder år, rate med 95% KI, &min_aar - &max_aar";
proc sgplot data=&bo._KI_Fig noborder noautolegend sganno=anno pad=(Bottom=5%);
where &Mine_Boomraader;
hbarparm category=&bo response=&rate_var / limitlower=KI_N_J limitupper=KI_O_J Limitattrs=(Color=black) fillattrs=(color=CX95BDE6); 
	 Refline Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=1);
	 Refline Norge_KI_N / axis=x lineattrs=(Thickness=.5 color=Black pattern=2);
	 Refline Norge_KI_O / axis=x lineattrs=(Thickness=.5 color=Black pattern=2);
     Yaxistable Ant_Innbyggere Ant_opphold /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='Boområde/opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
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

proc sort data=&bo._KI_Fig; by descending &rate_var; run;

ODS Graphics ON /reset=All imagename="KI_&RV_variabelnavn._&bo" imagefmt=&bildeformat  border=off HEIGHT=&hoyde width=&bredde;
ODS Listing style=stil_figur Image_dpi=300 GPATH=&lagring;
proc sgplot data=&bo._KI_Fig noborder noautolegend sganno=anno pad=(Bottom=5%);
where &Mine_Boomraader;
hbarparm category=&bo response=&rate_var / limitlower=KI_N_J limitupper=KI_O_J Limitattrs=(Color=black) fillattrs=(color=CX95BDE6); 
	 Refline Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=1);
	 Refline Norge_KI_N / axis=x lineattrs=(Thickness=.5 color=Black pattern=2);
	 Refline Norge_KI_O / axis=x lineattrs=(Thickness=.5 color=Black pattern=2);
     Yaxistable Ant_Innbyggere Ant_opphold /Label location=inside position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
     yaxis display=(noticks noline) label='Boområde/opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 &skala /*values=(0 to 7 by 1)*/ /*valuesformat=comma8.0*/ valueattrs=(size=7);
     inset ("(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"=" KI, rate &SnittOmraade"
			"(*ESC*){unicode'2014'x}"=" Rate, &SnittOmraade") / position=bottomright textattrs=(size=7);
run;Title; ods listing close;
%mend KI_bilde;
