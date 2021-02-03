/* Kontrollere at alle rader har gyldig kode for boområde og har fått tildelt boshhn, bohf og borhf */
/* For de med missing bohf/borhf, se hvilke behandlingssteder eller HF det gjelder  */


%macro bohf_missing(dsn=);

data tmp;
set hnana.t20_magnus_avd_2020(keep=aar bohf borhf komnr)
    hnana.t20_magnus_avd_2019(keep=aar bohf borhf komnr)
    hnana.t20_magnus_avd_2018(keep=aar bohf borhf komnr)
    hnana.t20_magnus_avd_2017(keep=aar bohf borhf komnr)
    hnana.t20_magnus_avd_2016(keep=aar bohf borhf komnr);
where bohf = . or borhf eq .;
run;

%mend;


/* BOHF = 99 dvs komnr = 9999 */
/* Antall og hvilket behandlingssted */
%macro bohf_99(dsn=);

proc freq data=&dsn; tables komnr behandlingsstedkode2 institusjonid icd10kap /norow nocol nopercent; 
where bohf eq 99 ; 
run;

%mend;