/* Kontrollere at alle rader har gyldig kode for boområde og har fått tildelt boshhn, bohf og borhf */


%macro bo_missing(dsn=);

proc freq data=&dsn; tables bohf borhf /norow nocol nopercent; run;

data need_fix;
set &dsn;
where bohf eq . or borhf eq . ;
run;

%mend;