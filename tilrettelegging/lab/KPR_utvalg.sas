%macro KPR_utvalg(dsn=);
/* Makro som flagger opp analysene til labatlas basert på takster i KPR-data */
data &dsn._ut;
    set &dsn.; 

	 if takstkode eq         '709' 			    then do;
                HbA1c = 1;
                ref = 157; end;
else if lowcase(takstkode eq '705k') 			then do;
                CRP = 1;
                ref = 51; end;
else if lowcase(takstkode eq '708b') 			then do;
                gammaGT_alat = 1;
                ref = 31; end;
else if lowcase(takstkode eq '708a') 			then do;
                Glukose = 1;
                ref = 24; end;
else if takstkode eq         '710'              then do;
                INR = 1;
                ref = 85; end;
else if lowcase(takstkode eq '708e') 			then do;
                Kalium = 1;
                ref = 32; end;
else if lowcase(takstkode eq '708d') 			then do;
                Kreatinin = 1;
                ref 32; end;
else if lowcase(takstkode eq '708c') 			then do;
                kol = 1;
                ref = 25; end;

if HbA1c or CRP or gammaGT_alat or Glukose or INR or Kalium or Kreatinin or kol then utvalg = 1;
if utvalg eq 1 then output;
run;

%mend KPR_utvalg;