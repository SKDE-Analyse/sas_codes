/* Kontrollere at alle rader har gyldig kode for behandlingssted og har fått tildelt behsh, behhf og behrhf */

/* hente inn HF fra parvus */



%macro behandler_missing(dsn=);

proc freq data=&dsn; tables behsh behhf behrhf /norow nocol nopercent; run;

data need_fix;
set &dsn;
where behsh eq . or behhf eq . or behrhf eq . ;
run;

%mend;



/* se om det er samsvar mellom HF i mottatte data vs BEHHF som vi lager */
%macro behhf(dsn=);
proc freq data=&dsn order=internal; tables behhf*hf /nocol norow nopercent;run;
%mend;