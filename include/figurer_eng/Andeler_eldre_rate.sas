

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
run;


/*Hente inn to rater*/
data to;
set &navn_to._bohf;
ant_opphold = &navn_to;
to_rate = ratesnitt;
type = 2;
to_ant = ant_opphold;
run;

data tot;
set &navn_tot._bohf;
tot_ratesnitt = ratesnitt;
keep bohf tot_ratesnitt;
run;





/*Slå sammen en og to*/
data &navn_en._andeler;
set en to tot;
format type type.;
Run;

proc sql;
   create table &navn_en._andeler as 
   select *, max (tot_ratesnitt) as tot_rate, sum(to_ant) as antall_to, sum (en_rate) AS rate_en, sum (to_rate) as rate_to, sum(ant_opphold) as tot_ant
   from &navn_en._andeler
   group by  Bohf ;
quit;


data &navn_en._andeler;
Set &navn_en._andeler;
if type=2 then do;
	 labelpos=ratesnitt+0.05;
     Ant_opphold=.;
     Innbyggere=.;
end;
if bohf = 8888 then snittrate = ratesnitt;
	Andel=rate_en/tot_rate;
	Length Mistext $ 10;
	if tot_ant lt 30 then do;
		andel=.;
		Mistext="N<30";
		Plassering=0.01;
	end;
	rate_original=ratesnitt;
	format en_rate to_rate 8.2  ratesnitt 8.1 ant_innbyggere 8.0;
	label en_ant="&label_en" antall_to="&label_to";
	keep Bohf  type Plassering ratesnitt antall_to en_rate Innbyggere Andel en_ant tot_rate rate_en to_rate tot_ant labelpos No_snitt norge_snitt Mistext;
run;


data &navn_en._andeler;
set &navn_en._andeler;
where en_rate ne .;
if type = 1 then do;
if bohf = 8888 then andel_no = andel;
posisjon =  0.005;
end;
run;


proc sort data=&navn_en._andeler;
by descending andel en_ant;
run;

%let figfil = fig4_eldre;
%include "&filbane.\include\master\figurer_eng\lag_figur.sas";

Proc datasets nolist;
delete en to tot;
run;

