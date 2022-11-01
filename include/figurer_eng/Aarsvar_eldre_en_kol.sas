


options locale=NB_no;


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
merge &varnavn._BOHF_aarsvar pers;
by bohf;
if bohf = 8888 then snittrate = ratesnitt;
drop aar norge;
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
run;

Data _null_;
set &varnavn._SAMLET;
call symput('FT2', trim(left(put(FT2,8.1))));
run;


proc sort data=&varnavn._SAMLET;
by descending &sortering;
run;

/*	Lager figur	*/


%let figfil = fig1e_eldre;
%include "&filbane/include/figurer_eng/lag_figur.sas";


/*	Sletter datasett	*/

Proc datasets nolist;
delete &varnavn._AARSV_NO pers &varnavn._BOHF_aarsvar;
run;