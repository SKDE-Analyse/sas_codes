


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
type = 2;
to_ant = ant_opphold;
run;


/*Slå sammen en og to*/
data smelt;
set en to;
format type type.;
Run;

proc sql;
   create table smelt as 
   select *, SUM(ratesnitt) as tot_ratesnitt, sum(ant_opphold) as AntOpph, sum (en_rate) AS rate_en, sum (to_rate) as rate_to
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

%let figfil = fig2_eldre;
%include "&filbane/include/figurer/lag_figur.sas";


/* Sletter datasett */
Proc datasets nolist;
delete en to test ;
run;


