/*!
Standardiseringsgrupper

Inkludere makroer: Todeltalder, Tredeltalder, Firedeltalder, Femdeltalder
*/

%Macro Todeltalder;

Proc univariate data=utvalgx noprint;
var alder;
weight rv;
Output out=Alderskvartiler 	pctlpre=P_ pctlpts= 0 to 100 by 50;
Run;
Data Alderskvartiler;
set Alderskvartiler;
StartGr1=P_0;
SluttGr1=P_50;
startGr2=P_50+1;
SluttGr2=P_100;
run;

data _null_;
set alderskvartiler;
call symput('StartGr1', trim(left(put(StartGr1,8.))));
call symput('SluttGr1', trim(left(put(SluttGr1,8.))));
call symput('StartGr2', trim(left(put(startGr2,8.))));
call symput('SluttGr2', trim(left(put(SluttGr2,8.))));
run;
Proc datasets nolist;
delete Alderskvartiler;
run;
%Mend Todeltalder;

%Macro Tredeltalder;
Proc univariate data=utvalgx noprint;
var alder;
weight rv;
Output out=Alderskvartiler 	pctlpre=P_ pctlpts= 0,33,66,100;
Run;
Data Alderskvartiler;
set Alderskvartiler;
StartGr1=P_0;
SluttGr1=P_33;
startGr2=P_33+1;
SluttGr2=P_66;
StartGr3=P_66+1;
SluttGR3=P_100;
run;

data _null_;
set alderskvartiler;
call symput('StartGr1', trim(left(put(StartGr1,8.))));
call symput('SluttGr1', trim(left(put(SluttGr1,8.))));
call symput('StartGr2', trim(left(put(startGr2,8.))));
call symput('SluttGr2', trim(left(put(SluttGr2,8.))));
call symput('StartGr3', trim(left(put(StartGr3,8.))));
call symput('SluttGr3', trim(left(put(SluttGr3,8.))));
run;
Proc datasets nolist;
delete Alderskvartiler;
run;
%Mend Tredeltalder;

%Macro Firedeltalder;
Proc univariate data=utvalgx noprint;
var alder;
weight rv;
Output out=Alderskvartiler 	pctlpre=P_ pctlpts= 0 to 100 by 25;
Run;
Data Alderskvartiler;
set Alderskvartiler;
StartGr1=P_0;
SluttGr1=P_25;
startGr2=P_25+1;
SluttGr2=P_50;
StartGr3=P_50+1;
SluttGr3=P_75;
StartGr4=P_75+1;
SluttGR4=P_100;
run;

data _null_;
set alderskvartiler;
call symput('StartGr1', trim(left(put(StartGr1,8.))));
call symput('SluttGr1', trim(left(put(SluttGr1,8.))));
call symput('StartGr2', trim(left(put(startGr2,8.))));
call symput('SluttGr2', trim(left(put(SluttGr2,8.))));
call symput('StartGr3', trim(left(put(StartGr3,8.))));
call symput('SluttGr3', trim(left(put(SluttGr3,8.))));
call symput('StartGr4', trim(left(put(startGr4,8.))));
call symput('SluttGr4', trim(left(put(SluttGr4,8.))));
run;
Proc datasets nolist;
delete Alderskvartiler;
run;
%Mend Firedeltalder;

%Macro Femdeltalder;
proc univariate data=utvalgx noprint;
var Alder;
weight rv;
output out=Alderskvantiler  pctlpre=P_ pctlpts= 0 to 100 by 20;
run;
Data Alderskvantiler;
set Alderskvantiler;
StartGr1=P_0;
SluttGr1=P_20;
startGr2=P_20+1;
SluttGr2=P_40;
StartGr3=P_40+1;
SluttGr3=P_60;
StartGr4=P_60+1;
SluttGR4=P_80;
StartGr5=P_80+1;
SluttGR5=P_100;
drop _freq_ _type_ Antall Max Median Min q1 q3;
run;
data _null_;
set alderskvantiler;
call symput('Kvantil1start', trim(left(put(StartGr1,8.))));
call symput('Kvantil1Slutt', trim(left(put(SluttGr1,8.))));
call symput('Kvantil2start', trim(left(put(startGr2,8.))));
call symput('Kvantil2slutt', trim(left(put(SluttGr2,8.))));
call symput('Kvantil3start', trim(left(put(StartGr3,8.))));
call symput('Kvantil3slutt', trim(left(put(SluttGr3,8.))));
call symput('Kvantil4start', trim(left(put(startGr4,8.))));
call symput('Kvantil4slutt', trim(left(put(SluttGr4,8.))));
call symput('Kvantil5start', trim(left(put(startGr5,8.))));
call symput('Kvantil5slutt', trim(left(put(SluttGr5,8.))));
run;
Proc datasets nolist;
delete Alderskvantiler;
run;
%Mend Femdeltalder;
