


/* 	Henter antall personer fra unik-datasett	*/

data kons;
set &varnavn_to._bohf;
run;

proc sql;
create table kons AS 
select bohf, &varnavn_to AS kons, sum(&varnavn_to) AS Sum_kons
from kons;
run;


/* Setter sammen datasett	*/

data &varnavn._BOHF_aarsvar;
set &varnavn._BOHF;
run;

proc sort data=kons;
by bohf;
run;

proc sort data=&varnavn._BOHF_aarsvar;
by bohf;
run;

data &varnavn._SAMLET;
merge &varnavn._BOHF_aarsvar kons ;
by bohf;
Kons_per_pas = kons/&varnavn;
if bohf = 8888 then snittrate = ratesnitt;
label &varnavn="&label_en" &kol_to="&label_to";
rate_original=ratesnitt;
Length Mistext $ 10;
if &varnavn lt 30 then do;
     ratesnitt=.;
	 rate2013=.; rate2014=.; rate2015=.; min=.; max=.;
     Mistext="N<30";
     Plassering=Norge/100;
end;
run;

proc sql;
   create table &varnavn._SAMLET as 
   select *, max(ratesnitt) as maks, min(ratesnitt) as minimum
   from &varnavn._SAMLET;
   quit;

data &varnavn._SAMLET; 
set &varnavn._SAMLET;
FT2=round((maks/minimum),0.1);
drop maks minimum;
Format &varnavn comma8.0 &kol_to comma8.1 ; 
run;

Data _null_;
set &varnavn._SAMLET;
call symput('FT2', trim(left(put(FT2,8.1))));
run;

proc sort data=&varnavn._SAMLET;
by descending &sortering;
run;




/*	Lager figur	*/


%let fontst = 7;
%let mappe = rapport;
%let bildeformat = pdf;

%include "&filbane.\include\master\figurer_eng\fig1_eldre.sas";


%let fontst = 9;
%let mappe = faktaark;
%let bildeformat = pdf;

%include "&filbane.\include\master\figurer_eng\fig1_eldre.sas";


%let fontst = 7;
%let mappe = png;
%let bildeformat = png;

%include "&filbane.\include\master\figurer_eng\fig1_eldre.sas";



/*	Sletter datasett	*/

Proc datasets nolist;
delete &varnavn._AARSV_NO pers kons &varnavn._BOHF_aarsvar;
run;