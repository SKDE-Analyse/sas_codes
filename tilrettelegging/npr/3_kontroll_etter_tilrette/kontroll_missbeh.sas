/* Kontrollere at alle rader har gyldig kode for behandlingssted og har fått tildelt behsh, behhf og behrhf */
%macro beh_missing(dsn=);

/* proc freq data=&dsn; tables institusjonid HF tjenesteenhetreshid fagenhetlokal  /norow nocol nopercent; 
where behsh eq . or behhf eq . or behrhf eq . ;
run; */

data tmp;
set hnana.t20_magnus_avd_2020(keep=aar behsh behhf behrhf koblingsid)
    hnana.t20_magnus_avd_2019(keep=aar behsh behhf behrhf koblingsid)
    hnana.t20_magnus_avd_2018(keep=aar behsh behhf behrhf koblingsid)
    hnana.t20_magnus_avd_2017(keep=aar behsh behhf behrhf koblingsid)
    hnana.t20_magnus_avd_2016(keep=aar behsh behhf behrhf koblingsid);
where  behsh eq . or behhf eq . or behrhf eq . ;
run;

%mend;


