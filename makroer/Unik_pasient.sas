%macro Unik_pasient(inn_data=, pr_aar=, sorter=, Pid=, Merke_variabel=);
%if &pr_aar=aar %then %do;
proc sort data=&inn_data;
by aar &pid descending &Merke_variabel &sorter;
run;

Data &inn_data;
set &inn_data;
by aar &pid descending &Merke_variabel &sorter;
If first.&&pid=1 and &Merke_variabel=1 then Unik_Pas_&Merke_variabel=1;
if first.&&pid=1 then Nr_pr_pas_&Merke_variabel=0;
Nr_pr_pas_&Merke_variabel+1;
if &Merke_variabel=. then Nr_pr_pas_&Merke_variabel=.;
run;

PROC SQL;
	CREATE TABLE &inn_data AS 
	SELECT *,(MAX(Nr_pr_pas_&Merke_variabel)) AS N_pr_Pas_&Merke_variabel
	FROM &inn_data
		GROUP BY aar, &PID;
QUIT;
%end;
%else %do;
proc sort data=&inn_data;
by &pid descending &Merke_variabel &sorter;
run;

Data &inn_data;
set &inn_data;
by &pid descending &Merke_variabel &sorter;
If first.&&pid=1 and &Merke_variabel=1 then Unik_Pas_&Merke_variabel=1;
if first.&&pid=1 then Nr_pr_pas_&Merke_variabel=0;
Nr_pr_pas_&Merke_variabel+1;
if &Merke_variabel=. then Nr_pr_pas_&Merke_variabel=.;
run;

PROC SQL;
	CREATE TABLE &inn_data AS 
	SELECT *,(MAX(Nr_pr_pas_&Merke_variabel)) AS N_pr_Pas_&Merke_variabel
	FROM &inn_data
		GROUP BY &PID;
QUIT;
%end;
%mend Unik_pasient;