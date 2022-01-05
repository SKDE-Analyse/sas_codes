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
- Lager 'pid_kpr' fra 'KPR_lnr' (l�penummer) og sletter 'KPR_lnr'
*/
PID_KPR=KPR_lnr+0;
Drop KPR_lnr;
/*
- Rename 'hoveddiagnoseKode' til 'Hdiag'. 
*/
rename hoveddiagnoseKode = HdiagKPR;
/*
- Lager 'bydel_org' og sletter 'bydel2'. 
*/
bydel_org = bydel2 + 0;
drop bydel2;
/* 
- Lager 'kontakttype_kpr'. Endre kontakttype_kpr '-1' til '0'. Slette 'kontakttypenavn' og 'kuhrKontakttypeId'.
 */
kontakttype_KPR = kuhrKontakttypeId +0;
if kontakttype_KPR eq -1 then kontakttype = 0;
drop kontakttypenavn kuhrKontakttypeId;
format kontakttype_kpr kontakttype_kpr.;
/*
- Lager 'refusjonutbetalt' fra 'refusjonutbetaltbel�p'. 
*/
refusjonutbetalt = 'refusjonutbetaltbel�p'n + 0;
drop 'refusjonutbetaltbel�p'n;
%end;

run;

%mend;