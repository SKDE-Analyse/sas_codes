
/* se om det er samsvar mellom HF i mottatte data vs BEHHF som vi lager */
%macro behhf(dsn=);
proc freq data=&dsn order=internal; tables behhf*hf /nocol norow nopercent;run;
%mend;