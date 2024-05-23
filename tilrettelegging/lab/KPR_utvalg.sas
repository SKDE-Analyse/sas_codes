%macro KPR_utvalg(dsn=);
/* Makro som flagger opp analysene til labatlas basert på takster i KPR-data */
data &dsn._ut;
    set &dsn.; 
	 if takstkode in ('709') 			        then HbA1c = 1;
else if lowcase(takstkode eq ('705k')) 			then CRP = 1;
else if lowcase(takstkode eq ('708a')) 			then Glukose = 1;

if hbA1c or crp or glukose utvalg = 1;
if utvalg eq 1 then output;
run;

%mend KPR_utvalg;