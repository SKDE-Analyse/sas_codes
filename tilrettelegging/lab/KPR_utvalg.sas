%macro KPR_utvalg(dsn=);
/* Makro som flagger opp analysene til labatlas basert på takster i KPR-data */
data &dsn._ut;
    set &dsn.; 

	 if takstkode eq         '709' 			    then HbA1c = 1;
else if lowcase(takstkode eq '705k') 			then CRP = 1;
else if lowcase(takstkode eq '708b') 			then gammaGT_alat = 1;
else if lowcase(takstkode eq '708a') 			then Glukose = 1;
else if takstkode eq         '710'              then INR = 1;
else if lowcase(takstkode eq '708e') 			then Kalium = 1;
else if lowcase(takstkode eq '708d') 			then Kreatinin = 1;
else if lowcase(takstkode eq '708c') 			then kolesterol_tot = 1;

if hbA1c or CRP or gammaGT_alat or Glukose or INR or Kalium or Kreatinin or kolesterol_tot then utvalg = 1;
if utvalg eq 1 then output;
run;

%mend KPR_utvalg;