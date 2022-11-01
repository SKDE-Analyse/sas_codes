%macro kpr_kjonn_alder(inndata=);

proc sort data=&inndata;
  by kpr_lnr;
run;

proc sort data=&inndata nodupkey out=lnr_dupkjonn;
  by kpr_lnr kjonn; 
run;

data dupkjonn;
  set lnr_dupkjonn;
  by kpr_lnr kjonn;
  if first.kpr_lnr =0 or last.kpr_lnr=0 then output;
run;

title 'ulike kjønn';
proc sql;
  select count(distinct kpr_lnr) as unikid
  from dupkjonn;
quit;

proc transpose data=dupkjonn out=dupkjonn2;
  by kpr_lnr;
  var kjonn;
run;

 /* if there are no dup (0 observations in WORK.DUPKJONN) then will get ERROR message from proc summary and proc print.  
 it's OK!! */
proc summary data=dupkjonn2 nway ;
  class col1 col2;
  output out=kjonn_kombo;
run;

title 'kombinasjon av kjønn';
proc print data=kjonn_kombo(drop=_type_ rename=(col1=kjonn1 col2=kjonn2));
run;



/* Fødselsår */

proc sort data=&inndata nodupkey out=lnr_dupfod;
  by kpr_lnr fodselsar; 
run;

data dupfod;
  set lnr_dupfod;
  by kpr_lnr fodselsar;
  if first.kpr_lnr =0 or last.kpr_lnr=0 then output;
run;

proc transpose data=dupfod out=dupfodtrans;
  by kpr_lnr;
  var fodselsar;
run;

 /* if there are no dup (0 observations in WORK.DUPFOD) then will get 'variable uninitialized' message from data step. 
 it's OK!! */
data dupfodtrans;
  set dupfodtrans;
  diff=col2-col1;
run;

title 'ulike fodselsår';
proc sql;
  select count(distinct kpr_lnr) as unikid
  from dupfodtrans;
quit;

title 'differanse mellom årene';
proc freq data=dupfodtrans;
  tables diff;
run;
title;

%mend;