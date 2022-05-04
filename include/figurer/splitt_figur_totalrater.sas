


Proc format;
value type
1="&label_en"
2="&label_to";
run;
/*Hente inn type en rater*/
data en;
set &navn_en._bohf;
ant_opphold = &navn_en;
en_rate = ratesnitt;
type = 1;
en_ant = ant_opphold;

run;


/*Hente inn type to rater*/
data to;
set &navn_to._bohf;
ant_opphold = &navn_to;
to_rate = ratesnitt;
type = 3;
to_ant = ant_opphold;
run;



/*Hente inn tot rater*/
data tot;
set &navn_tot._bohf;
ant_opphold = &navn_tot;
tot_rate = ratesnitt;
type = 2;
tot_ant = ant_opphold;
run;


/*Slå sammen en og to og tot*/
data smelt;
set en to tot;
format type type.;
Run;

proc sql;
   create table smelt as 
   select *, SUM(tot_rate) as tot_ratesnitt, sum(ant_opphold) as AntOpph, sum (en_rate) AS rate_en, sum (to_rate) as rate_to
   from smelt
   group by  Bohf ;
quit;

data smelt;
Set smelt;
if type=2 then do;
	 labelpos=ratesnitt+0.05;
/*     Ant_opphold=.;*/
     Innbyggere=.;
end;
Andel=en_rate/tot_ratesnitt;
label Innbyggere="Innb." to_ant="&label_to." en_ant="&label_en."; 
rate_original=ratesnitt;
Length Mistext $ 10;
if antopph lt 30 then do;
	rate_en = .;
    Mistext = "N<30";
    Plassering = tot_ratesnitt/100;
	tot_ratesnitt = .;
	Andel = .;
end; 
format en_rate to_rate 8.2  ratesnitt 8.1 ant_innbyggere 8.0;
keep Bohf en_rate rate_en Mistext type Plassering ratesnitt Innbyggere Andel AntOpph en_ant to_ant to_rate rate_to tot_ratesnitt labelpos sortering;
run;

proc sql;
   create table smelt   as 
   select *, max(tot_ratesnitt) as maks, min(tot_ratesnitt) as minimum
   from smelt;
   quit;

   
   
   
data smelt; 
set smelt;
FT2=round((maks/minimum),0.1);
run;

Data _null_;
set smelt;
call symput('FT2', trim(left(put(FT2,8.1))));
run;

data smelt;
set smelt;
if bohf = 8888 then do;
ratesnitt_no = tot_ratesnitt;
rate_en_no = rate_en;

rate_en =.;
end;
label en_ant="&label_en" to_ant="&label_to";
plass = maks/1000;
drop maks minimum ratesnitt ;
run;

proc sort data=smelt;
by descending &sortering;
run;

/*Lager figur og lagrer bildefil*/

%let fontst = 7;
%let mappe = rapport;
%let bildeformat = pdf;

%include "&filbane/include/figurer/fig2_eldre.sas";


%let fontst = 9;
%let mappe = faktaark;
%let bildeformat = pdf;

%include "&filbane/include/figurer/fig2_eldre.sas";


%let fontst = 7;
%let mappe = png;
%let bildeformat = png;

%include "&filbane/include/figurer/fig2_eldre.sas";



ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=pdf border=off ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\Helseatlas\Eldre\&katalog"   ;
proc sgplot data=smelt  noborder noautolegend sganno=Anno pad=(bottom=6%);
hbarparm category=bohf response=tot_RateSnitt / outlineattrs=(color=CX00509E) fillattrs=(color=CX95BDE6) missing name="hp1" legendlabel="&label_to"; 
hbarparm category=bohf response=Ratesnitt_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CXC3C3C3);
hbarparm category=bohf response=rate_en / outlineattrs=(color=CX00509E) fillattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_en"; 
hbarparm category=bohf response=rate_en_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CX4C4C4C);
     scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;
     scatter x=plass y=bohf /datalabel=Andel  datalabelpos=right markerattrs=(size=0) 

        datalabelattrs=(color=white  size=7);
xaxis label=" Antall pr. 1 000 innbyggere ((*ESC*){unicode'2265'x}75 år)" labelattrs=(color=black size=7) offsetmin=0.02 OFFSETMAX=0.02  &xskala valuesformat=nlnum8.0   valueattrs=(size=7);
Keylegend "hp2" "hp1"/ noborder location=inside position=bottomright down=2;
Yaxistable en_ant to_ant /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) 
         offsetmax=0.03 offsetmin=0.03 type=discrete discreteorder=data valueattrs=(size=7) ;
Format andel percent8. en_ant to_ant  ratesnitt_no rate_en_no nlnum8.0 ;
run;
ods graphics off;

ODS Graphics ON /reset=All imagename="&figurnavn" imagefmt=png border=off ;
ODS Listing Image_dpi=300 GPATH="\\hn.helsenord.no\RHF\SKDE\ANALYSE\Helseatlas\Eldre\&katalog.\png"   ;
proc sgplot data=smelt  noborder noautolegend sganno=Anno pad=(bottom=6%);
hbarparm category=bohf response=tot_RateSnitt / outlineattrs=(color=CX00509E) fillattrs=(color=CX95BDE6) missing name="hp1" legendlabel="&label_to"; 
hbarparm category=bohf response=Ratesnitt_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CXC3C3C3);
hbarparm category=bohf response=rate_en / outlineattrs=(color=CX00509E) fillattrs=(color=CX00509E) missing name="hp2" legendlabel="&label_en"; 
hbarparm category=bohf response=rate_en_no / outlineattrs=(color=CX4C4C4C) fillattrs=(color=CX4C4C4C);
     scatter x=plassering y=bohf /datalabel=Mistext datalabelpos=right markerattrs=(size=0) ;
     scatter x=plass y=bohf /datalabel=Andel  datalabelpos=right markerattrs=(size=0) 

        datalabelattrs=(color=white  size=7);
xaxis label=" Antall pr. 1 000 innbyggere ((*ESC*){unicode'2265'x}75 år)" labelattrs=(color=black size=7) offsetmin=0.02 OFFSETMAX=0.02  &xskala valuesformat=nlnum8.0   valueattrs=(size=7);
Keylegend "hp2" "hp1"/ noborder location=inside position=bottomright down=2;
Yaxistable en_ant to_ant /Label location=inside position=right labelpos=bottom valueattrs=(size=7 family=arial) labelattrs=(size=7);
yaxis display=(noticks noline) label='Opptaksområde' labelattrs=(size=7) 
         offsetmax=0.03 offsetmin=0.03 type=discrete discreteorder=data valueattrs=(size=7) ;
Format andel percent8. en_ant to_ant  ratesnitt_no rate_en_no nlnum8.0 ;
run;
ods graphics off;


/* Sletter datasett */
Proc datasets nolist;
delete en to test ;
run;


