%macro kpr_slette_rader(inndata=, utdata=);

data &utdata;
set &inndata;
if kpr_lnr eq . then delete;
run;

%mend;