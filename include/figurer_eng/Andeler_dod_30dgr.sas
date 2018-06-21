
proc sort data=d30_&tema._&RV_variabelnavn._bohf out=dod_30;
by bohf;
run;

proc sort data=d365_&tema._&RV_variabelnavn._bohf out=dod_365;
by bohf;
run;

proc sort data=&tema._&RV_variabelnavn._bohf out=dod_tot;
by bohf;
run;

data samlefig;
merge dod_30 dod_365 dod_tot; 
by bohf;
Andel30 = d30_&tema._rate/&tema._rate;
Andel365 = d365_&tema._rate/&tema._rate;
if bohf = 8888 then do;
	andel30_no = andel30;
	andel365_no = andel365;	
end;
posisjon = 0.005;

label d30_&tema._ant='30 days' d365_&tema._ant='365 days' Andel365='Pct. 365days';
run;


proc sql;
create table samlefig as 
select *, max (andel365) as maks, min (andel365) as mini
from samlefig;
quit;


data samlefig;
set samlefig;
FT=round((maks/mini),0.1);
run;

Data _null_;
set samlefig;
call symput('FT', trim(left(put(FT,8.1))));
run;

proc sort data=samlefig;
by descending andel30;
run;

proc datasets nolist;
delete dod:;
run;

/*	Lager figur	*/


%let fontst = 7;
%let mappe = rapport;
%let bildeformat = pdf;

%include "&filbane\include\figurer_eng\fig4c_eldre.sas";


%let fontst = 9;
%let mappe = faktaark;
%let bildeformat = pdf;

%include "&filbane\include\figurer_eng\fig4c_eldre.sas";


%let fontst = 7;
%let mappe = png;
%let bildeformat = png;

%include "&filbane\include\figurer_eng\fig4c_eldre.sas";




