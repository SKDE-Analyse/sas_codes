/* Avtalespesialister files have around 10 000 lines with unknown kjønn. */
/* Some of these do have known kjønn on file on a different line */
/* This program saves the original kjonn to kjonn_org and makes a new variable kjonn with replacement for unknow where possible */
/* Created 09.04.2021 */

%macro fix_kjonn(inndata=, utdata=);

* list of unique pid with unknown gender;
proc sort data=&inndata(keep=pid kjonn) nodupkey out=diffkjonn;
  by pid;
  where kjonn not in (1,2);
run;

title 'kjonn on original file - to be fixed';
proc freq data=diffkjonn;
  tables kjonn;
run;

* merge back to original file to get other lines in the file;
proc sql;
  create table diffkjonn2 as
  select distinct a.pid, a.kjonn
  from &inndata a, diffkjonn b
  where a.pid=b.pid;
run;

data diffkjonn2;
  set diffkjonn2;
  if kjonn not in (1,2) then kjonn=9;
run;

* check that pid with other lines specifying male or female belong to only, not both;
* the only possible values are 1,2,9.  Each pid should have max of 2 lines, so no line should have both first. and last. to be 0;
proc sort data=diffkjonn2;
  by pid kjonn;
run;

data problem;
  set diffkjonn2;
  by pid;
  if first.pid=0 and last.pid=0 then output;
run;

* sort the file by ascending order to keep the first instance of gender;

data diffkjonn3;
  set diffkjonn2;
  by pid;
  if first.pid then output;
run;

* what does the replacement gender look like?;
title 'kjonn as replacement';
proc freq data=diffkjonn3;
  tables kjonn;
run;

* merge new value back to original file;
data &utdata;
  set &inndata;
  rename kjonn=kjonn_org;
run;

proc sql;
  create table &utdata as
  select distinct b.*, a.kjonn
  from diffkjonn3 a right join &utdata b
  on a.pid=b.pid;
quit;

data &utdata;
  set &utdata;
  if kjonn = . then kjonn=kjonn_org;
run;

title '';

%mend;