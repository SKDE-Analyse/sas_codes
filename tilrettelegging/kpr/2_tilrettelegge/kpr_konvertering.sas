%macro kpr_konvertering(inndata= , utdata=);


data &utdata;
set &inndata;

/*
- Lager 'kpr_pid' fra 'KPR_lnr' (løpenummer) og sletter 'KPR_lnr'
*/
KPR_PID=KPR_lnr+0;
Drop KPR_lnr;

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
- Rename 'hoveddiagnoseKode' til 'diagnose'. 
*/
rename hoveddiagnoseKode = diagnose;

/*
- Lager 'refusjonutbetalt' fra 'refusjonutbetaltbeløp'. 
*/
refusjonutbetalt = 'refusjonutbetaltbeløp'n + 0;
drop 'refusjonutbetaltbeløp'n;

run;

%mend;