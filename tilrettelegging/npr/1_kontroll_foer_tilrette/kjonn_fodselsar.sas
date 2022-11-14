%macro kjonn_fodselsar(inndata=);

/* kjønn */
data lnr;
  set &inndata(keep=lopenr kjonn fodselsar);
run;

proc sort data=lnr; by lopenr; run;

proc sort data=lnr nodupkey out=lnr_dupkjonn;
  by lopenr kjonn; 
run;

data dupkjonn;
  set lnr_dupkjonn;
  by lopenr kjonn;
  if first.lopenr =0 or last.lopenr=0 then output;
run;

title color=darkblue height=5 "2a: antall pasienter med ulike kjønn";
proc sql;
  select count(distinct lopenr) as unikid
  from dupkjonn;
quit;

proc transpose data=dupkjonn out=dupkjonn2;
  by lopenr;
  var kjonn;
run;

/* Fødselsår */
proc sort data=lnr nodupkey out=lnr_dupfod;
  by lopenr fodselsar; 
run;

data dupfod;
  set lnr_dupfod;
  by lopenr fodselsar;
  if first.lopenr =0 or last.lopenr=0 then output;
run;

proc transpose data=dupfod out=dupfodtrans;
  by lopenr;
  var fodselsar;
run;

data dupfodtrans;
  set dupfodtrans;
  diff=col2-col1;
run;

title color=darkblue height=5 "2b: range fødselsår";
proc sql;
  select min(fodselsar) as min_fodselsar, 
         max(fodselsar) as max_fodselsar
  from lnr;
quit;

title color=darkblue height=5 "2b: antall pasienter med ulike fodselsår";
proc sql;
  select count(distinct lopenr) as unikid
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
