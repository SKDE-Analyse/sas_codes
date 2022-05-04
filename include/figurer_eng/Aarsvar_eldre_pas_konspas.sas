



/* 	Henter antall personer fra unik-datasett	*/

data pers;
set &varnavn._unik_bohf;
run;

proc sql;
create table pers AS 
select bohf, &varnavn._unik AS Pasienter, sum(&varnavn._unik) AS Sum_pat
from pers;
run;


/* Setter sammen datasett	*/

data &varnavn._BOHF_aarsvar;
set &varnavn._BOHF;
run;

proc sort data=pers;
by bohf;
run;

proc sort data=&varnavn._BOHF_aarsvar;
by bohf;
run;

data &varnavn._SAMLET;
merge &varnavn._BOHF_aarsvar pers ;
by bohf;
if bohf = 8888 then snittrate = ratesnitt;
rate_original=ratesnitt;
kons_pr_pas = &varnavn/pasienter;
Length Mistext $ 10;
if &varnavn lt 30 then do;
     ratesnitt=.;
	 rate2013=.; rate2014=.; rate2015=.; min=.; max=.;
     Mistext="N<30";
     Plassering=Norge/100;
end;
label &varnavn="&label_en" Pasienter="Pat." kons_pr_pas="Cons./pat.";
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

%include "&filbane/include/figurer_eng/fig1b_eldre.sas";


%let fontst = 9;
%let mappe = faktaark;
%let bildeformat = pdf;

%include "&filbane/include/figurer_eng/fig1b_eldre.sas";


%let fontst = 7;
%let mappe = png;
%let bildeformat = png;

%include "&filbane/include/figurer_eng/fig1b_eldre.sas";


/*
Engelsk versjon 31. aug. 2017
Slettet kode fra original-fil; hent tilbake fra ../figurer/. hvis den likevel trengs
*/

/*	Sletter datasett	*/

Proc datasets nolist;
delete &varnavn._AARSV_NO pers &varnavn._BOHF_aarsvar;
run;