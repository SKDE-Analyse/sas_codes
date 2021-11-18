%macro kpr_konvertering(inndata= , utdata=);


data &utdata;
set &inndata;


%if &diagnose eq 1 %then %do; /*kj�res kun p� diagnose-fil*/
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


%if &diagnose ne 1 %then %do; /*Koden under kj�res ikke hvis diagnose=1*/
/*
- Lager 'kpr_pid' fra 'KPR_lnr' (l�penummer) og sletter 'KPR_lnr'
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
- Lager 'refusjonutbetalt' fra 'refusjonutbetaltbel�p'. 
*/
refusjonutbetalt = 'refusjonutbetaltbel�p'n + 0;
drop 'refusjonutbetaltbel�p'n;
%end;

run;

%mend;