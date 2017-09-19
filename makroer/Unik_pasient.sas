%macro Unik_pasient(inn_data=, pr_aar=, sorter=, Pid=, Merke_variabel=);

/*!
### Beskrivelse

For � finne unike pasienter, oppholdsnr og antall opphold pr pasient ut fra et *merke*
```
%Unik_pasient(inn_data=, pr_aar=, sorter=, Pid=, Merke_variabel=);
```

### Parametre

1. `Inn_data`: datasett man utf�rer analysen p�
2. `pr_aar`: settes=aar dersom man �nsker � finne unike pasienter pr �r, ellers la st� tom
3. `sorter`: Andre variable det skal sorteres p�, f.eks inndato og utdato
4. `Pid`: Settes `=PID` s� lenge *PID* angir pasient_id
5. `Merke_variabel`: Variabel det skal telles opp fra, m� v�re merket med 1 for aktuelle

Det lages tre nye variable i datasettet:
1. `Unik_Pas_<Merke_variabel>` --> lik 1 for unike pasienter
2. `Nr_pr_pas_<Merke_variabel>` --> Nummererer de aktuelle oppholdene pr pasient i rekkef�lge
3. `N_pr_pas_<Merke_variabel>` --> Antall opphold totalt pr pasient, settes p� alle opphold

### Forfatter

Opprettet 1/12-15 av Frank Olsen
*/

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