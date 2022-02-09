%macro ratefig_aarsvar(
    dsn=, /*Grunnlagsdatsettet for figur, som regel utdata fra rateprogram*/
    /*dsn må inneholde variablene rate: og nrate*/
    ytabdata=, /*Dersom nødvendig, hente inn data til Y-axis table fra annet datsett*/
    /* datasett må være på samme form som dsn, avslått som default */
    yvariabel1=antsnitt, /*Variabel 1 til Y-axis table, antsnitt som default*/
	yvariabel2=popsnitt, /*Variabel 2 til Y-axis table, popsnitt som default*/
	ylabel1=Antall, /*Label til Y-axis table, variabel 1, , Antall som default*/
	ylabel2=Innbyggere, /*Label til Y-axis table, variabel 2, Innbyggere som default*/
	yvarformat1=Nlnum8.0, /*Format på Y-axis table variabel 1, Nlnum8.0 som default 1*/
	yvarformat2=NLnum8.0, /*Format på Y-axis table variabel 2, Nlnum8.0 som default*/
    bo=bohf, /*BoHf, BoRHF eller BoShHN, BoHF som default*/
    start=, /* Startår */
    slutt=, /* Sluttår */
    soyle=1, /*1 dersom man ønsker Norge som søyle, tom dersom Norge som ref linje, 1 som default */
    skala=, /* Skala på x-aksen på figurene - eks: values=(0 to 0.8 by 0.2), ikke angitt som default */
    lagre=1, /*lik 1 dersom lagring av bildefil, 1 som default*/
    figurnavn=, /*navn på bildefil - filnavn blir: &figurnavn._&bo._aarsvar*/
    bildeformat=png, /*Format, png som default*/
    xlabel =  /*Tekst under x-aksen*/
);
/*! 
### Beskrivelse

Makro for å lage ratefigur med årsvariasjon.

```
kortversjon (kjøres med default verdier for resten)
%ratefig_aarsvar(dsn=, start=, slutt=, figurnavn=);
```
### Input
- datasett/output fra rateprogram
- datasett må inneholde alle rate-variabelene og nrate
- eventuelt, hente inn data fra annet datasett til y-axis table
- følgende let-statement:
    - 

### Output
- bildefil med valgt format lagres på angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
*/

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

data xyz_&dsn;
set &dsn;
if &bo=8888 then nrate=ratesnitt;
run;

data _null_;
set xyz_&dsn;
If &bo=8888 then do;
call symput('NorgeSnitt',(nrate));
end;
run;

/*Yaxis-table - hente verdier fra annet datasett*/
%if &ytabdata ne . %then %do;
data xyz_tabdata;
set &ytabdata;
keep &bo &yvariabel1 &yvariabel2;
run;

data xyz_tabdata;
set xyz_tabdata;
yvar1=&yvariabel1;
yvar2=&yvariabel2;
label yvar1="&ylabel1" yvar2="&ylabel2";  
run;

proc sql;
create table xyz_&dsn as
select a.*, b.yvar1, b.yvar2
from xyz_&dsn as a left join xyz_tabdata as b
on a.&bo=b.&bo;
run;
%end;

/*Yaxis-table - fra samme datasett*/
%if &ytabdata = . %then %do;
data xyz_&dsn;
set xyz_&dsn;
yvar1=&yvariabel1;
yvar2=&yvariabel2;
label yvar1="&ylabel1" yvar2="&ylabel2"; 
%end;

/*Legg på format på y-axis table variable*/
data xyz_&dsn;
set xyz_&dsn;
format yvar1 &yvarformat1 yvar2 &yvarformat2;
drop min max;
run;

/*legg på max og min for den aktuelle perioden*/
data xyz_&dsn;
set xyz_&dsn;
max=max(of rate&start-rate&slutt);
min=min(of rate&start-rate&slutt);
run;

/*sorter datasett*/
proc sort data=xyz_&dsn;
by descending rateSnitt;
run;


%if &lagre=1 %then %do;
ODS Graphics ON /reset=All imagename="&figurnavn._&bo._aarsvar" imagefmt=&bildeformat border=off height=500px /*HEIGHT=&hoyde width=&bredde*/;
ODS Listing style=stil_figur Image_dpi=300 GPATH="&bildesti";
%end;
title;
proc sgplot data=xyz_&dsn noborder noautolegend sganno=anno pad=(Bottom=5%);
%if &soyle ne 1 %then %do;  where &bo ne 8888; %end;
hbarparm category=&bo response=rateSnitt / fillattrs=(color=CX95BDE6);
%if &soyle = 1 %then %do; hbarparm category=&bo response=nrate / fillattrs=(color=CXC3C3C3); %end;
%if &soyle ne 1 %then %do; Refline &Norgesnitt / axis=x lineattrs=(Thickness=.5 color=Black pattern=2); %end;
%if &Antall_aar>1 %then %do; scatter x=rate&ar1 y=&bo / markerattrs=(symbol=circlefilled color=black size=5pt);%end;
%if &Antall_aar>2 %then %do; scatter x=rate&ar2 y=&bo / markerattrs=(symbol=circlefilled color=grey  size=7pt); %end;
%if &Antall_aar>3 %then %do; scatter x=rate&ar3 y=&bo / markerattrs=(symbol=circle       color=black size=9pt);%end;
%if &Antall_aar>4 %then %do; scatter x=rate&ar4 y=&bo / markerattrs=(symbol=circle       color=red size=9pt);%end;
%if &Antall_aar>5 %then %do; scatter x=rate&ar5 y=&bo / markerattrs=(symbol=circle       color=black size=11pt);%end;
%if &Antall_aar>6 %then %do; scatter x=rate&ar6 y=&bo / markerattrs=(symbol=circle       color=red size=11pt);%end;
Highlow Y=&bo low=Min high=Max / type=line lineattrs=(color=black thickness=1 pattern=1);
%if &soyle ne 1 %then %do;
Yaxistable yvar1 yvar2 /Label location=inside position=right labelpos=top valueattrs=(size=8 family=arial) labelattrs=(size=8);
%end;
%if &soyle = 1 %then %do;
Yaxistable yvar1 yvar2 /Label location=inside position=right labelpos=bottom valueattrs=(size=8 family=arial) labelattrs=(size=8);
%end;
yaxis display=(noticks noline) label='Bosatte i opptaksområde' labelpos=top labelattrs=(size=8 weight=bold) type=discrete discreteorder=data valueattrs=(size=8);

xaxis /*display=(nolabel)*/ offsetmin=0.02 &skala label="&xlabel" valueattrs=(size=8) offsetmax=0.05 ;

%if &Antall_aar=2 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    %if &soyle ne 1 %then %do;
    legenditem type=markerline name='Ref1' / label="Snitt, Norge" lineattrs=(Thickness=.5 color=Black pattern=2);
    keylegend "item1" "Ref1"/ across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
    %if &soyle = 1 %then %do;
    keylegend "item1" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
%end;

%if &Antall_aar=3 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    legenditem type=marker name='item2' / label="&ar2" markerattrs=(symbol=circlefilled color=grey  size=7pt);
    %if &soyle ne 1 %then %do;
    legenditem type=line name='Ref1' / label="Snitt, Norge" lineattrs=(Thickness=.5 color=Black pattern=2);
    keylegend "item1" "item2" "Ref1"/ across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
    %if &soyle = 1 %then %do;
    keylegend "item1" "item2" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
%end;

%if &Antall_aar=4 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    legenditem type=marker name='item2' / label="&ar2" markerattrs=(symbol=circlefilled color=grey  size=7pt);
    legenditem type=marker name='item3' / label="&ar3" markerattrs=(symbol=circle       color=black size=9pt);
    %if &soyle ne 1 %then %do;
    legenditem type=line name='Ref1' / label="Norge" lineattrs=(Thickness=.5 color=Black pattern=2);
    keylegend "item1" "item2" "item3" "Ref1"/ across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
    %if &soyle = 1 %then %do;
    keylegend "item1" "item2" "item3" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
%end;

%if &Antall_aar=5 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    legenditem type=marker name='item2' / label="&ar2" markerattrs=(symbol=circlefilled color=grey  size=7pt);
    legenditem type=marker name='item3' / label="&ar3" markerattrs=(symbol=circle       color=black size=9pt);
    legenditem type=marker name='item4' / label="&ar4" markerattrs=(symbol=circle       color=red size=9pt);
    %if &soyle ne 1 %then %do;
    legenditem type=markerline name='Ref1' / label="Snitt, Norge" lineattrs=(Thickness=.5 color=Black pattern=2);
    keylegend "item1" "item2" "item3" "item4" "Ref1"/ across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
    %if &soyle = 1 %then %do;
    keylegend "item1" "item2" "item3" "item4" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
%end;


%if &Antall_aar=6 %then %do;
    legenditem type=marker name='item1' / label="&ar1" markerattrs=(symbol=circlefilled color=black size=5pt);
    legenditem type=marker name='item2' / label="&ar2" markerattrs=(symbol=circlefilled color=grey  size=7pt);
    legenditem type=marker name='item3' / label="&ar3" markerattrs=(symbol=circle       color=black size=9pt);
    legenditem type=marker name='item4' / label="&ar4" markerattrs=(symbol=circle       color=red size=9pt);
    legenditem type=marker name='item5' / label="&ar5" markerattrs=(symbol=circle       color=red size=11pt);
    %if &soyle ne 1 %then %do;
    legenditem type=markerline name='Ref1' / label="Snitt, Norge" lineattrs=(Thickness=.5 color=Black pattern=2);
    keylegend "item1" "item2" "item3" "item4" "item5" "Ref1"/ across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
    %if &soyle = 1 %then %do;
    keylegend "item1" "item2" "item3" "item4" "item5" / across=1 position=bottomright location=inside noborder valueattrs=(size=8pt);
    %end;
%end;
run;Title; 
%if &lagre=1 %then %do;
ods listing close; ods graphics off;
%end;

proc datasets nolist;
delete xyz:;
run;

%mend ratefig_aarsvar;