%macro proc_stdrate(
    dsn=, /*Grunnlagsdatsettet det skal beregnes rater fra*/
    rate_var=, /*Ratevariabel, kan v�re aggregert (verdier st�rre enn en) eller dikotom (0,1)*/
    bo=bohf, /*BoHf, BoRHF eller BoShHN, BoHf er default*/
	alder_min=0, /*Laveste alder i utvalget, 0 er default*/
	alder_max=105, /*H�yeste alder i utvalget, 105 er default*/
    rmult=1000, /*Ratemultiplikator, dvs rate pr, 1000 er default*/
	indirekte=, /*Settes lik 1 dersom indirekte, ellers direkte metode, direkte er default*/
    standardaar=, /*Standardiserings�r*/
    start=, /*Start�r*/
    slutt=, /*Slutt�r*/
    utdata=, /*Navn p� utdatasett, utdatasettet er p� "wide" form*/
    long=, /*if long=1 --> skriv ut "langt" datasett, ikke aktivert er default*/
    innbygg_dsn=innbygg.INNB_SKDE_BYDEL, /*Innbyggerdatasett: innbygg.INNB_SKDE_BYDEL, innbygg.INNB_SKDE_BYDEL er default*/
    /*Til boomr�de-makroen: Standard er:(inndata=pop, indreOslo = 0, bydel = 1);*/
    bodef_indreoslo=0, /*0 er standard, 0 er default*/
    bodef_bydel=1, /*1 er standard, 1 er default*/
	test=0 /*0 (default) er for � slette midlertidige datasett, 1 er for � beholde dem */
);

/*! 
### Beskrivelse

Makro for � beregne rater

```
kortversjon (kj�res med default verdier for resten)
%proc_stdrate(dsn=, rate_var=, standardaar=, start=, slutt=, utdata=);
```
### Input
- datasett med variabel det skal beregnes rater p�, 
	- kan v�re 0,1 variabel eller aggregert
	- m� innheolde bo-niv�et det skal kj�res rater p�

### Output
- &utdata + evt. long_&utdata

### Endringslogg:
- februar 2022 opprettet, Frank
*/

/***Formatering****/ 
proc format;
value aar_fmt
2000="2000"
2001="2001"
2002="2002"
2003="2003"
2004="2004"
2005="2005"
2006="2006"
2007="2007"
2008="2008"
2009="2009"
2010="2010"
2011="2011"
2012="2012"
2013="2013"
2014="2014"
2015="2015"
2016="2016"
2017="2017"
2018="2018"
2019="2019"
2020="2020"
2021="2021"
2022="2022"
2023="2023"
2024="2024"
2025="2025"
2026="2026"
2027="2027"
2028="2028"
2029="2029"
2030="2030"
2031="2031"
2032="2032"
2033="2033"
2034="2034"
2035="2035"
2036="2036"
2037="2037"
2038="2038"
2039="2039"
9999="Snitt";

value nyalder_fmt
1="0-4 �r"
2="5-9 �r"
3="10-14 �r"
4="15-19 �r"
5="20-24 �r"
6="25-29 �r"
7="30-34 �r"
8="35-39 �r"
9="40-44 �r"
10="45-49 �r"
11="50-54 �r"
12="55-59 �r"
13="60-64 �r"
14="65-69 �r"
15="70-74 �r"
16="75-79 �r"
17="80-84 �r"
18="85-89 �r"
19="90-94 �r"
20="95-105 �r";
run;

/*****Hent inn ratedata*****/
data xyz_rateutvalg;
set &dsn;
keep aar ermann alder &bo &rate_var nyalder;
if alder in (&alder_min:&alder_max);

if alder in (0:4) then nyalder=1;
else if alder in (5:9) then nyalder=2;
else if alder in (10:14) then nyalder=3;
else if alder in (15:19) then nyalder=4;
else if alder in (20:24) then nyalder=5;
else if alder in (25:29) then nyalder=6;
else if alder in (30:34) then nyalder=7;
else if alder in (35:39) then nyalder=8;
else if alder in (40:44) then nyalder=9;
else if alder in (45:49) then nyalder=10;
else if alder in (50:54) then nyalder=11;
else if alder in (55:59) then nyalder=12;
else if alder in (60:64) then nyalder=13;
else if alder in (65:69) then nyalder=14;
else if alder in (70:74) then nyalder=15;
else if alder in (75:79) then nyalder=16;
else if alder in (80:84) then nyalder=17;
else if alder in (85:89) then nyalder=18;
else if alder in (90:94) then nyalder=19;
else if alder in (95:105) then nyalder=20;

%if &bo=bohf %then %do;
    where &rate_var ge 1 and bohf in (1:23) and aar in (&start:&slutt);
    format bohf bohf_fmt.;
%end;
%if &bo=borhf %then %do;
    where &rate_var ge 1 and borhf in (1:4) and aar in (&start:&slutt);
    format borhf borhf_fmt.;
%end;
%if &bo=boshhn %then %do;
    where &rate_var ge 1 and boshhn in (1:11) and aar in (&start:&slutt);
    format boshhn boshhn_fmt.;
%end; 
format nyalder nyalder_fmt.;   
run;

/*Tabell - fordeling p� alder*/
proc means data=xyz_rateutvalg n mean std min max median q1 q3 QRANGE;
var alder;
weight &rate_var;
run;

/**Aggregere ratevariabel**/
/*Over �r, bo, alder og kj�nn*/
proc sql;
	create table xyz_ratedsn0 as
	select aar, &bo, nyalder, ermann,
		sum(&rate_var) as antall
	from xyz_rateutvalg
	group by aar, &bo, nyalder, ermann;
quit;
/*Norge: Over �r, alder og kj�nn. Norge=8888*/
proc sql;
	create table xyz_ratedsnN as
	select aar, nyalder, ermann,
		sum(&rate_var) as antall
	from xyz_rateutvalg
	group by aar, nyalder, ermann;
quit;
data xyz_ratedsnN;
set xyz_ratedsnN;
&bo=8888;
run;
/*Sl�r sammen boomr�de og Norge*/
data xyz_ratedsn;
set xyz_ratedsn0 xyz_ratedsnN;
run;
/*For gjennomsnitt i perioden - over bo, alder og kj�nn. Aar=9999*/
proc sql;
	create table xyz_ratedsnsnitt as
	select &bo, nyalder, ermann,
		sum(antall) as antall
	from xyz_ratedsn
	group by &bo, nyalder, ermann;
quit;
data xyz_ratedsnsnitt;
set xyz_ratedsnsnitt;
aar=9999;
antall=antall/(&slutt-&start+1);
run;
/*Sl�r sammen enkelt�r og gjennomsnitt*/
data xyz_ratedsn;
set xyz_ratedsn xyz_ratedsnsnitt;
run;

/*****Hent inn innbyggerdata*****/
data xyz_pop;
set &innbygg_dsn;
where aar in (&start:&slutt) and alder in (&alder_min:&alder_max);
run;
%boomraader(inndata=xyz_pop, indreOslo=&bodef_indreoslo, bydel=&bodef_bydel);

data xyz_pop;
set xyz_pop;
%if &bo=bohf %then %do;
    drop komnr bydel boshhn borhf fylke;
    format bohf bohf_fmt.;
%end;
%if &bo=borhf %then %do;
    drop komnr bydel boshhn bohf fylke;
    format borhf borhf_fmt.;
%end;
%if &bo=boshhn %then %do;
    drop komnr bydel bohf borhf fylke;
    format boshhn boshhn_fmt.;
%end;

if alder in (0:4) then nyalder=1;
else if alder in (5:9) then nyalder=2;
else if alder in (10:14) then nyalder=3;
else if alder in (15:19) then nyalder=4;
else if alder in (20:24) then nyalder=5;
else if alder in (25:29) then nyalder=6;
else if alder in (30:34) then nyalder=7;
else if alder in (35:39) then nyalder=8;
else if alder in (40:44) then nyalder=9;
else if alder in (45:49) then nyalder=10;
else if alder in (50:54) then nyalder=11;
else if alder in (55:59) then nyalder=12;
else if alder in (60:64) then nyalder=13;
else if alder in (65:69) then nyalder=14;
else if alder in (70:74) then nyalder=15;
else if alder in (75:79) then nyalder=16;
else if alder in (80:84) then nyalder=17;
else if alder in (85:89) then nyalder=18;
else if alder in (90:94) then nyalder=19;
else if alder in (95:105) then nyalder=20;
format nyalder nyalder_fmt.;  
run;

/**Aggregere populasjon**/
/*Over �r, bo, alder og kj�nn*/
proc sql;
	create table xyz_pop_area0 as
	select aar, &bo, nyalder, ermann,
		sum(innbyggere) as pop
	from xyz_pop
	group by aar, &bo, nyalder, ermann;
quit;
/*Norge: Over �r, alder og kj�nn. Norge=8888*/
proc sql;
	create table xyz_pop_areaN as
	select aar, nyalder, ermann,
		sum(innbyggere) as pop
	from xyz_pop
	group by aar, nyalder, ermann;
quit;
data xyz_pop_areaN;
set xyz_pop_areaN;
&bo=8888;
run;
/*Sl�r sammen boomr�de og Norge*/
data xyz_pop_area;
set xyz_pop_area0 xyz_pop_areaN;
run;
/*For gjennomsnitt i perioden - over bo, alder og kj�nn. Aar=9999*/
proc sql;
	create table xyz_popsnitt as
	select &bo, nyalder, ermann,
		sum(pop) as pop
	from xyz_pop_area
	group by &bo, nyalder, ermann;
quit;
data xyz_popsnitt;
set xyz_popsnitt;
aar=9999;
pop=pop/(&slutt-&start+1);
run;
/*Sl�r sammen enkelt�r og gjennomsnitt*/
data xyz_pop_area;
set xyz_pop_area xyz_popsnitt;
run;
/*Referansepopulasjon for Norge, i standardiserings�r*/
proc sql;
	create table xyz_popN as
	select nyalder, ermann,
		sum(innbyggere) as Npop
	from xyz_pop
	where aar=&standardaar
	group by nyalder, ermann;
quit;

/*******sl� sammen ratedata og populasjonsdata, og beregn rate****************/
proc sql;
create table xyz_ratedata as
select a.*,antall
from xyz_pop_area as a left join xyz_ratedsn as b
on a.&bo=b.&bo and a.aar=b.aar and a.nyalder=b.nyalder and a.ermann=b.ermann;
run;

data xyz_ratedata;
set xyz_ratedata;
if antall=. then antall=0;
run;

/*for indirekte justering - 
i) beregne events nasjonalt i standardiserings�r
ii) merge inn i popN datasettet (referansepopulasjonen)*/
proc sql;
	create table xyz_eventN as
	select nyalder, ermann,
		sum(antall) as Nevent
	from xyz_ratedata
	where aar=&standardaar
	group by nyalder, ermann;
quit;
proc sql;
create table xyz_popN as
select a.*,b.Nevent
from xyz_popN as a left join xyz_eventN as b
on a.nyalder=b.nyalder and a.ermann=b.ermann;
run;

/**Selve standardiseringa skjer her**/
ods exclude all;
%if &indirekte ne 1 %then %do;
proc stdrate data=xyz_ratedata refdata=xyz_popN method=direct stat=rate(mult=&rmult);
%end;
%if &indirekte=1 %then %do;
proc stdrate data=xyz_ratedata refdata=xyz_popN method=indirect stat=rate(mult=&rmult);
%end;
by &bo aar;
population event=antall total=pop;
%if &indirekte ne 1 %then %do;
	reference total=Npop;
%end;
%if &indirekte=1 %then %do;
	reference event=Nevent total=Npop;
%end;
strata ermann nyalder /*/ stats*/;
ods output stdrate=xyz_StdRate_&utdata;
run;
ods exclude none; 

data xyz_StdRate_&utdata;
set xyz_StdRate_&utdata;
format aar aar_fmt. &bo &bo._fmt.;
run; 

/***********Lag aldersfigurer***********/
PROC SQL;
   CREATE TABLE xyz_aldersfig AS
   SELECT DISTINCT aar,Alder,ErMann,(SUM(&rate_var)) AS RV
      FROM xyz_rateutvalg
      GROUP BY aar, Alder, ErMann;	  
QUIT;

/*For � f� rikitg farge p� menn og kvinner*/
proc sql;
create table xyz_color as 
select distinct ermann
from xyz_aldersfig;
quit;


data xyz_ermanncolor;
set xyz_color;
id='ermann';
if ermann=0 then do; 
fillcolor='CX00509E';
value='Kvinner';
end;
if ermann=1 then do;
fillcolor='CX95BDE6';
value='Menn';
end;
run;

proc sgplot data=xyz_aldersfig dattrmap=xyz_ermanncolor noautolegend noborder sganno=anno pad=(Bottom=4% );
styleattrs /*datacolors=(CX00509E CX95BDE6)*/ DATACONTRASTCOLORS=(CX00509E);
	vbar alder / response=RV stat=sum group=ermann groupdisplay=cluster name="Vbar" grouporder=ascending attrid=ermann;
	keylegend "Vbar" / location=outside position=topright noborder;
    yaxis label="Antall";
	xaxis fitpolicy=thin offsetmin=0.035 label='Alder, ett-�rig';
run;

PROC SQL;
   CREATE TABLE xyz_aldersfigkat AS
   SELECT DISTINCT aar,nyAlder,ErMann,(SUM(&rate_var)) AS RV
	FROM xyz_rateutvalg where alder in (&alder_min:&alder_max)
      GROUP BY aar, nyAlder, ErMann;	  
QUIT;


proc sgplot data=xyz_aldersfigkat dattrmap=xyz_ermanncolor  noautolegend noborder sganno=anno pad=(Bottom=4% );
styleattrs /*datacolors=(CX00509E CX95BDE6)*/ DATACONTRASTCOLORS=(CX00509E);
	vbar nyalder / response=RV stat=sum group=ermann groupdisplay=cluster name="Vbar" grouporder=ascending attrid=ermann;
	keylegend "Vbar" / location=outside position=topright noborder;
    yaxis label="Antall";
	xaxis fitpolicy=thin offsetmin=0.035 label='Alder, 5-�rige alderskategorier';
run;

/**************Lag tabeller***********/
data xyz_tmp_rate;
set xyz_StdRate_&utdata;
drop Method RateMult ExpectedEvents RefPopTime StdErr Type;
rename ObservedEvents=Antall PopTime=Populasjon Stdrate=Rate LowerCL=LCL UpperCL=UCL;
run;

proc tabulate data=xyz_tmp_rate;
	VAR Rate Antall populasjon;
	CLASS aar &bo/	ORDER=UNFORMATTED MISSING;
	TABLE 
&bo={LABEL="" STYLE={NOBREAKSPACE=ON} STYLE(CLASSLEV)={NOBREAKSPACE=ON}},
aar={LABEL="Justert rate"}*Rate={LABEL=""}*F=8.2*Sum={LABEL=""} 
aar={LABEL="Antall"}*Antall={LABEL=""}*F=8.0*Sum={LABEL=""}
aar={LABEL="Innbyggere"}*populasjon={LABEL=""}*F=8.0*Sum={LABEL=""};
RUN;

proc tabulate data=xyz_tmp_rate;
	VAR crudeRate rate lcl ucl;
	CLASS aar &bo/	ORDER=UNFORMATTED MISSING;
	TABLE 
&bo={LABEL="" STYLE={NOBREAKSPACE=ON} STYLE(CLASSLEV)={NOBREAKSPACE=ON}},
aar={LABEL="Ujustert Rate"}*crudeRate={LABEL=""}*F=8.2*Sum={LABEL=""}
aar={LABEL="Justert Rate"}*Rate={LABEL=""}*F=8.2*Sum={LABEL=""}  
aar={LABEL="Lower CL"}*lcl={LABEL=""}*F=8.2*Sum={LABEL=""}
aar={LABEL="Upper CL"}*ucl={LABEL=""}*F=8.2*Sum={LABEL=""};
RUN;

/***************Lag �rsvariasjonsfigur*********/
data _null_;
set xyz_tmp_rate;
If Aar=9999 and &bo=8888 then do;
call symput('NorgeSnitt',(rate));
Call symput('Norge_lcl',(lcl));
Call symput('Norge_ucl',(ucl));
end;
run;
/*Transponering*/
proc transpose data=xyz_tmp_rate out=xyz_tmp_rater prefix=rate;
var Rate;
id aar;
by &bo;
run;

proc transpose data=xyz_tmp_rate out=xyz_tmp_antall prefix=ant;
var antall;
id aar;
by &bo;
run;

proc transpose data=xyz_tmp_rate out=xyz_tmp_pop prefix=pop;
var populasjon;
id aar;
by &bo;
run;

proc transpose data=xyz_tmp_rate out=xyz_tmp_crude prefix=crude;
var CrudeRate;
id aar;
by &bo;
run;

proc transpose data=xyz_tmp_rate out=xyz_tmp_lcl prefix=lcl;
var lcl;
id aar;
by &bo;
run;

proc transpose data=xyz_tmp_rate out=xyz_tmp_ucl prefix=ucl;
var ucl;
id aar;
by &bo;
run;
/*sl� sammen transponerte datasett*/
data xyz_tmp_rater;
merge xyz_tmp_rater xyz_tmp_antall xyz_tmp_pop xyz_tmp_crude xyz_tmp_lcl xyz_tmp_ucl;
run;

data xyz_tmp_rater;
set xyz_tmp_rater;
max=max(of rate&start-rate&slutt);
min=min(of rate&start-rate&slutt);
run;

/**Forholdstall**/
proc transpose data=xyz_tmp_rate out=xyz_ft;
where Aar=9999 and &bo ne 8888;
var rate;
run;

data xyz_ft;
set xyz_ft;
&bo=8888;
max1=largest(1,of col:);
max2=largest(2,of col:);
max3=largest(3,of col:);
min1=smallest(1,of col:);
min2=smallest(2,of col:);
min3=smallest(3,of col:);
FT1=max1/min1;
FT2=max2/min2;
FT3=max3/min3;
keep &bo ft:;
format FT: 8.3;
run;

data _null_;
set xyz_ft;
call symput('FT1',put(FT1,4.2));
Call symput('FT2',put(FT2,4.2));
Call symput('FT3',put(FT3,4.2));
run;

%global Antall_aar;
%let Antall_aar=%sysevalf(&slutt-&start+2);
%global ar1;
%let ar1=%sysevalf(&start);
%if &Antall_aar ge 2 %then %do;
    %global ar2;
	%let ar2=%sysevalf(&start+1);
%end;
%if &Antall_aar ge 3 %then %do;
    %global ar3;
	%let ar3=%sysevalf(&start+2);
%end;
%if &Antall_aar ge 4 %then %do;
    %global ar4;
	%let ar4=%sysevalf(&start+3);
%end;
%if &Antall_aar ge 5 %then %do;
    %global ar5;
	%let ar5=%sysevalf(&start+4);
%end;
%if &Antall_aar ge 6 %then %do;
    %global ar6;
	%let ar6=%sysevalf(&start+5);
%end;
%if &Antall_aar ge 7 %then %do;
    %global ar7;
	%let ar7=%sysevalf(&start+6);
%end;

data xyz_tmp_rater;
set xyz_tmp_rater;
if &bo=8888 then nrate=ratesnitt;
label antsnitt="Events";
label popsnitt="Populasjon";
format antsnitt popsnitt nlnum8.0;
run;

proc sort data=xyz_tmp_rater;
by descending ratesnitt;
run;

proc sgplot data=xyz_tmp_rater noborder noautolegend sganno=anno pad=(Bottom=5%);
hbarparm category=&bo response=ratesnitt / fillattrs=(color=CX95BDE6); 
hbarparm category=&bo response=nrate / fillattrs=(color=CXC3C3C3);
     /* Refline &NorgeSnitt / axis=x lineattrs=(Thickness=.5 color=Black pattern=2) name="Ref1"; */
%if &Antall_aar>1 %then %do; scatter x=rate&ar1 y=&bo / markerattrs=(symbol=circlefilled color=black size=5pt);%end;
%if &Antall_aar>2 %then %do; scatter x=rate&ar2 y=&bo / markerattrs=(symbol=circlefilled color=grey  size=7pt); %end;
%if &Antall_aar>3 %then %do; scatter x=rate&ar3 y=&bo / markerattrs=(symbol=circle       color=black size=9pt);%end;
%if &Antall_aar>4 %then %do; scatter x=rate&ar4 y=&bo / markerattrs=(symbol=circle       color=red   size=9pt);%end;
%if &Antall_aar>5 %then %do; scatter x=rate&ar5 y=&bo / markerattrs=(symbol=circle       color=red   size=11pt);%end;
%if &Antall_aar>6 %then %do; scatter x=rate&ar6 y=&bo / markerattrs=(symbol=circle       color=black size=11pt);%end;

Highlow Y=&bo low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);

Yaxistable antsnitt popsnitt /Label location=inside labelpos=bottom position=right valueattrs=(size=7 family=arial) labelattrs=(size=7);
%if &indirekte ne 1 %then %do;
yaxis display=(noticks noline) label="&rate_var, &dsn, direkte metode, &alder_min - &alder_max �r" labelpos=top labelattrs=(size=7 weight=bold) type=discrete 
discreteorder=data valueattrs=(size=7);
%end;
%if &indirekte = 1 %then %do;
yaxis display=(noticks noline) label="&rate_var, &dsn, indirekte metode, &alder_min - &alder_max �r" labelpos=top labelattrs=(size=7 weight=bold) type=discrete 
discreteorder=data valueattrs=(size=7);
%end;
xaxis /*display=(nolabel)*/ offsetmin=0.02 valueattrs=(size=7) label="Rater pr &rmult, FT1=&FT1, FT2=&FT2, FT3=&FT3";

%if &Antall_aar=2 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    keylegend "item1" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
%end;

%if &Antall_aar=3 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    legenditem type=marker name='item2' / label="&ar2" markerattrs=(symbol=circlefilled color=grey  size=7pt);
    keylegend "item1" "item2" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
%end;

%if &Antall_aar=4 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    legenditem type=marker name='item2' / label="&ar2" markerattrs=(symbol=circlefilled color=grey  size=7pt);
    legenditem type=marker name='item3' / label="&ar3" markerattrs=(symbol=circle       color=black size=9pt);
    keylegend "item1" "item2" "item3" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
%end;

%if &Antall_aar=5 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    legenditem type=marker name='item2' / label="&ar2" markerattrs=(symbol=circlefilled color=grey  size=7pt);
    legenditem type=marker name='item3' / label="&ar3" markerattrs=(symbol=circle       color=black size=9pt);
    legenditem type=marker name='item4' / label="&ar4" markerattrs=(symbol=circle       color=red size=9pt);
    keylegend "item1" "item2" "item3" "item4" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
%end;


%if &Antall_aar=6 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    legenditem type=marker name='item2' / label="&ar2" markerattrs=(symbol=circlefilled color=grey  size=7pt);
    legenditem type=marker name='item3' / label="&ar3" markerattrs=(symbol=circle       color=black size=9pt);
    legenditem type=marker name='item4' / label="&ar4" markerattrs=(symbol=circle       color=red   size=9pt);
    legenditem type=marker name='item5' / label="&ar5" markerattrs=(symbol=circle       color=red   size=11pt);
    keylegend "item1" "item2" "item3" "item4" "item5" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);

%end;
run;

data &utdata;
set xyz_tmp_rater;
drop _:;
run;

proc sql;
create table &utdata as 
select *
from &utdata as a left join xyz_ft as b
on a.&bo=b.&bo;
run;

proc sort data = &utdata;
by &bo;
run;

%if &long=1 %then %do;
data long_&utdata;
set xyz_tmp_rate;
run;
%end;

/* Hvis ikke test=1 */
/*Skru av denne for � se midlertidige datasett*/
%if %sysevalf(%superq(test)=,boolean) %then %let test = 0;
%if &test=0 %then %do;
proc datasets nolist;
delete xyz_:;
run;
%end;

%mend proc_stdrate;