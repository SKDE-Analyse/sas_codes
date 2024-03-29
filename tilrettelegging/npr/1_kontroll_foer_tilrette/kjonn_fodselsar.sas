﻿%macro kjonn_fodselsar(inndata=,lnr=, kjonn=, fodselsar=);

/* kjønn */
data lnr;
  set &inndata(keep=&lnr &kjonn &fodselsar);
run;

proc sort data=lnr; by &lnr; run;

proc sort data=lnr nodupkey out=lnr_dupkjonn;
  by &lnr &kjonn; 
run;

data dupkjonn;
  set lnr_dupkjonn;
  by &lnr &kjonn;
  if first.&lnr =0 or last.&lnr=0 then output;
run;

title color=darkblue height=5 "2a: antall pasienter med ulike kjønn";
proc sql;
  select count(distinct &lnr) as unikid
  from dupkjonn;
quit;

proc transpose data=dupkjonn out=dupkjonn2;
  by &lnr;
  var &kjonn;
run;

/* Fødselsår */
proc sort data=lnr nodupkey out=lnr_dupfod;
  by &lnr &fodselsar; 
run;

data dupfod;
  set lnr_dupfod;
  by &lnr &fodselsar;
  if first.&lnr =0 or last.&lnr=0 then output;
run;

proc transpose data=dupfod out=dupfodtrans;
  by &lnr;
  var &fodselsar;
run;

data dupfodtrans;
  set dupfodtrans;
  diff=col2-col1;
run;

title color=darkblue height=5 "2b: range fødselsår";
proc sql;
  select min(&fodselsar) as min_fodselsar, 
         max(&fodselsar) as max_fodselsar
  from lnr;
quit;

title color=darkblue height=5 "2b: antall pasienter med ulike fodselsår";
proc sql;
  select count(distinct &lnr) as unikid
  from dupfodtrans;
quit;

title color=darkblue height=5 "2b: differanse mellom årene";
proc freq data=dupfodtrans;
  tables diff;
run;

proc datasets nolist;
delete lnr lnr_dupkjonn dupkjonn dupkjonn2 lnr_dupfod dupfod dupfodtrans;
run;
%mend kjonn_fodselsar;
