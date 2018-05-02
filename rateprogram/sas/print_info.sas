%macro print_info();

options nodate;
data _null_;
call symput ('timenow',put (time(),hhmm.));
call symput ('datenow',put (date(),DDMMYY10.));
run;

title "Utskrift fra rateprogram (&datenow, &timenow)";

ods text="Ratevariabel: &RV_variabelnavn";
ods text="F�rste del av datasettnavn: '&forbruksmal._'";
ods text=" ";
ods text=" ";
ods text="Periode: &Start�r - &Slutt�r";
ods text="Aldersspenn: '&aldersspenn.'";
ods text="Alderskategorier: '&Alderskategorier.'";

%mend;