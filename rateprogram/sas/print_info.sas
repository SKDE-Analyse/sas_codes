%macro print_info();

options nodate;
data _null_;
call symput ('timenow',put (time(),hhmm.));
call symput ('datenow',put (date(),DDMMYY10.));
run;

title "Utskrift fra rateprogram (&datenow, &timenow)";

ods text="Filbane:      '&filbane.'";
ods text="Ratefil:      '&Ratefil.'";
ods text="Ratevariabel: '&RV_variabelnavn.'";
ods text="Første del av datasettnavn: '&forbruksmal._'";
ods text=" ";
ods text=" ";
ods text="Periode: &StartÅr - &SluttÅr";
ods text="Aldersspenn: '&aldersspenn.'";
ods text="Alderskategorier: '&Alderskategorier.'";

%mend;