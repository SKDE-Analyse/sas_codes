%macro etter_kontroll(inndata=, aar=);

title "&aar. ";
proc sql;
  select count(*)            as ant_linjer     format=nlnum12.0,
         count(distinct pid) as ant_pasienter  format=nlnum12.0
  from &inndata;
quit;

title "&aar. - kjønn og alder";
proc freq data=&inndata;
  tables ermann alder/ missing;
run;

title "&aar. - missing pid";
proc freq data=&inndata;
  tables bohf offpriv/ missing;
  where pid=.;
run;

title "&aar. - missing bohf";
proc freq data=&inndata;
  tables komnr tknr pasient_kommune_nr offpriv/ missing;
  where bohf=.;
run;

%mend;