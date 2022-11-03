%macro kjonn_fodselsar(inndata=, pasid=);

data lnr;
  set &inndata(keep=&pasid kjonn fodselsar);
run;

proc sort data=lnr; by &pasid; run;

proc sort data=lnr nodupkey out=lnr_dupkjonn;
  by &pasid kjonn; 
run;

data dupkjonn;
  set lnr_dupkjonn;
  by &pasid kjonn;
  if first.&pasid =0 or last.&pasid=0 then output;
run;

title color=darkblue height=5 "3a: antall pasienter med ulike kjønn";
proc sql;
  select count(distinct &pasid) as unikid
  from dupkjonn;
quit;

proc transpose data=dupkjonn out=dupkjonn2;
  by &pasid;
  var kjonn;
run;

/* Fødselsår */
proc sort data=lnr nodupkey out=lnr_dupfod;
  by &pasid fodselsar; 
run;

data dupfod;
  set lnr_dupfod;
  by &pasid fodselsar;
  if first.&pasid =0 or last.&pasid=0 then output;
run;

proc transpose data=dupfod out=dupfodtrans;
  by &pasid;
  var fodselsar;
run;

data dupfodtrans;
  set dupfodtrans;
  diff=col2-col1;
run;

title color=darkblue height=5 '3b: antall pasienter med ulike fodselsår';
proc sql;
  select count(distinct &pasid) as unikid
  from dupfodtrans;
quit;

title color=darkblue height=5 '3b: differanse mellom årene';
proc freq data=dupfodtrans;
  tables diff;
run;

%mend kjonn_fodselsar;