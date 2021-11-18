%macro kpr_konvertering(inndata= , utdata=);


data &utdata;
set &inndata;


%if &diagnose eq 1 %then %do; /*kjøres kun på diagnose-fil*/
/*
- Rename 'diagnoseKode' til 'diag'. 
*/
rename diagnoseKode = diag;
/* 
- Lager 'erHdiag'. Sletter 'erHoveddiagnose'.
 */
erHdiag = erhoveddiagnose +0;
drop erhoveddiagnose;
format erHdiag erHdiag.;
%end;


%if &diagnose ne 1 %then %do; /*Koden under kjøres ikke hvis diagnose=1*/
/*
- Lager 'kpr_pid' fra 'KPR_lnr' (løpenummer) og sletter 'KPR_lnr'
*/
KPR_PID=KPR_lnr+0;
Drop KPR_lnr;
/*
- Rename 'hoveddiagnoseKode' til 'Hdiag'. 
*/
rename hoveddiagnoseKode = Hdiag;
/*
- Lager 'bydel_org' og sletter 'bydel2'. 
*/
bydel_org = bydel2 + 0;
drop bydel2;
/* 
- Lager 'kontakttype'. Endre kontakttype '-1' til '0'. Slette 'kontakttypenavn' og 'kuhrKontakttypeId'.
 */
kontakttype = kuhrKontakttypeId +0;
if kontakttype eq -1 then kontakttype = 0;
drop kontakttypenavn kuhrKontakttypeId;
format kontakttype kontakttype.;
/*
- Lager 'refusjonutbetalt' fra 'refusjonutbetaltbeløp'. 
*/
refusjonutbetalt = 'refusjonutbetaltbeløp'n + 0;
drop 'refusjonutbetaltbeløp'n;
%end;

run;

%mend;