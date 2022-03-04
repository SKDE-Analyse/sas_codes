%macro kpr_konvertering(inndata= , utdata=);

data &utdata;
set &inndata;

%if &diagnose eq 1 %then %do; /*kj�res kun p� diagnose-fil*/
/*
- Rename 'diagnoseKode' til 'diag'. 
*/
rename diagnoseKode = diag_kpr;
/* 
- Lager 'erHdiag'. Sletter 'erHoveddiagnose'.
 */
erhdiag_kpr = erhoveddiagnose +0;
drop erhoveddiagnose;
%end;


%if &regning eq 1 %then %do; /*Koden kj�res kun p� regningsfil*/
/*
- Lager 'pid_kpr' fra 'KPR_lnr' (l�penummer) og sletter 'KPR_lnr'
*/
pid_kpr=KPR_lnr+0;
Drop KPR_lnr;
/*
- Rename 'hoveddiagnoseKode' til 'Hdiag'. 
*/
rename hoveddiagnoseKode = hdiag_kpr;
/*
- Lager 'bydel_kpr' og sletter 'bydel2'. 
*/
bydel_kpr = bydel2 + 0;
drop bydel2;
/* 
- Lager 'kontakttype_kpr'. Endre kontakttype_kpr '-1' til '0'. Slette 'kontakttypenavn' og 'kuhrKontakttypeId'.
 */
kontakttype_kpr = kuhrKontakttypeId +0;
if kontakttype_kpr eq -1 then kontakttype_kpr = 0;
drop kontakttypenavn kuhrKontakttypeId;
/*
- Lager 'refusjonutbetalt' fra 'refusjonutbetaltbel�p'. 
*/
refusjonutbetalt = 'refusjonutbetaltbel�p'n + 0;
drop 'refusjonutbetaltbel�p'n;
%end;

run;

%mend;