


Proc format;
value type
1="&label_en"
2="&label_to";
run;
/*Hente inn en rater*/
data en;
set &navn_en._bohf;
ant_opphold = &navn_en;
en_rate = ratesnitt;
type = 1;
en_ant = ant_opphold;
if bohf = 1 then no_snitt = norge;
run;



/*Hente inn to rater*/
data to;
set &navn_to._bohf;
ant_opphold = &navn_to;
to_rate = ratesnitt;
type = 2;
to_ant = ant_opphold;
if bohf = 1 then no_snitt = norge;
run;



/*Hente inn liggetid*/
data tre;
set &navn_tre._bohf;
liggetid = &navn_tre;
run;



/*Slå sammen en og to*/
data &navn_en._andeler;
set en to tre;
format type type.;
Run;

proc sql;
   create table &navn_en._andeler as 
   select *, SUM(ratesnitt) as tot_ratesnitt,sum (liggetid) AS ligget, sum (en_rate) AS rate_en, sum (to_rate) as rate_to, sum (to_ant) as tot_ant, sum (en_ant) as ant_en
   from &navn_en._andeler
   group by  Bohf ;
quit;


proc sql;
   create table &navn_en._andeler as 
   select *, sum(no_snitt) as norge_snitt
   from &navn_en._andeler
quit;

data &navn_en._andeler;
Set &navn_en._andeler;
if type=2 then do;
	 labelpos=ratesnitt+0.05;
     Ant_opphold=.;
     Innbyggere=.;
end;
gj_liggetid = ligget/tot_ant;
Andel=rate_en/rate_to;
label gj_liggetid="Liggetid" tot_ant="&label_to." en_ant="&label_en.";
rate_original=ratesnitt;      
format en_rate to_rate 8.2  ratesnitt 8.1 ant_innbyggere 8.0;
keep Bohf en_rate type Plassering Mistext ratesnitt Innbyggere gj_liggetid rate_to rate_en ligget Andel ant_en en_ant tot_ant to_ant labelpos  ;
run;

data &navn_en._andeler;
set &navn_en._andeler;
where en_ant ne .;
if type = 1 then do;
if bohf = 8888 then andel_no = andel;
posisjon = 0.005;
end;
run;

proc sql;
   create table  &navn_en._andeler as 
   select *, max(andel) as maks, min(andel) as minimum
   from  &navn_en._andeler;
   quit;

data  &navn_en._andeler; 
set  &navn_en._andeler;
FT2=round((maks/minimum),0.1);
drop maks minimum;
run;

Data _null_;
set &navn_en._andeler;
call symput('FT2', trim(left(put(FT2,8.1))));
run;


proc sort data=&navn_en._andeler;
by descending andel en_ant;
run;

%let figfil = fig4b_eldre;
%include "&filbane/include/figurer/lag_figur.sas";

Proc datasets nolist;
delete en to tre test;
run;



