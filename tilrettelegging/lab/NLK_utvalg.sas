%macro NLK_utvalg(dsn=);
/* Makro som flagger opp analysene til labatlas basert på NLKkoder i KUHR-data */
data &dsn._ut;
    set &dsn.;
/*ALAT*/
if NLK = 'NPU19651'             then ALAT=1;
/*Albumin	*/
else if NLK = 'NPU19673'        then Albumin=1;
/*ASAT	*/
else if NLK = 'NPU19654'        then ASAT=1;
/*CA125	*/
else if NLK = 'NPU01448'        then CA125=1;
/*CEA	*/
else if NLK = 'NPU19719'        then CEA=1;
/*CRP	*/
else if NLK in ('NOR05091',
                'NPU19748')     then CRP=1;
/*D-dimer	*/
else if NLK in ('NPU19767',
                'NPU28289')     then D_dimer=1;
/*Ferritin	*/
else if NLK = 'NPU19763'        then Ferritin=1;
/*fT4	*/
else if NLK = 'NPU03579'        then T4=1;

/*Fosfat	*/
else if NLK in ('NOR25615', 
                'NPU03096')     then Fosfat=1;
/*GammaGT	*/
else if NLK = 'NPU19657'        then GammaGT=1;
/*Glukose*/
else if NLK in ('NPU02192',
                'NOR25616')     then Glukose=1;
/*HbA1c	*/
else if NLK in ('NPU03835',
                'NPU27300',
                'NPU29296')     then HbA1c=1;
/*HDL-kolesterol	*/
else if NLK = 'NPU01567'        then HDL=1;
/*Homocystein	*/
else if NLK = 'NPU04073'        then Homocystein=1;
/*INR	*/
else if NLK = 'NPU01685'        then INR=1;
/*Kalium	*/
else if NLK in ('NOR25614',
                'NPU03230')     then Kalium=1;
/*Kalsium	*/
else if NLK in ('NPU01443',
                'NPU04144')     then Kalsium=1;
/*Karbamid	*/
else if NLK = 'NPU01459'        then Karbamid=1;
/*Kreatinin	*/
else if NLK = 'NPU04998'        then Kreatinin=1;
/*Laktatdehydrogenerase	*/
else if NLK = 'NPU19658'        then LaktatD=1;
/*Laktoseintoleranse*/
else if NLK in ('NPU36378',
                'NPU58626',
                'NPU58627',
                'NPU58628')     then Laktose=1;
/*LDL-kolesterol*/
else if NLK = 'NPU01568'        then LDL=1;
/*MMA	*/
else if NLK = 'NPU02780'        then MMA=1;
/*Magnesium	*/
else if NLK = 'NPU02647'        then Magnesium=1;

/*Natrium	*/
else if NLK in ('NOR25613',
                'NPU03429')     then Natrium=1;
/*NIPT	*/
else if NLK in ('NPU53990',
                'NPU53991',
                'NPU53992',
                'NPU53993',
                'NPU53995')     then NIPT=1;
/*NT-proBNP*/
else if NLK = 'NPU21571'        then NT_pro=1;

/*Proteinelektroforese*/
else if NLK in ('NPU03300',
                'NPU02642',
                'NPU19844',
                'NOR35249',
                'NPU28875')     then pro_el=1;
/*PSA	*/
else if NLK in ('NPU08669',
                'NPU12534',
                'NOR25702')     then PSA=1;
/*TSH	*/
else if NLK in ('NPU03577',
                'NPU27547')     then TSH=1;
/*Totalkolesterol	*/
else if NLK = 'NPU01566'        then kol=1;
/*Vitamin B12	*/
else if NLK in ('NPU01700',
                'NPU03605',
                'NPU27125',
                'NOR05918')     then B12=1;
/*Vitamin B9 (Folat)*/
else if NLK = 'NPU02070'        then B9=1;

/*Vitamin D3	*/
else if NLK in ('NPU01435',
                'NPU10267',
                'NPU26810')     then Dvit=1;
/* 35 stk analyser */
if ALAT or Albumin or ASAT or CA125 or CEA or CRP or D_dimer or Ferritin or T4 or Fosfat or 
    GammaGT or Glukose or HbA1c or HDL or Homocystein or INR or Kalium or Kalsium or Karbamid or
    Kreatinin or LaktatD or Laktose or LDL or MMA or Magnesium or Natrium or NIPT or NT_pro or 
    pro_el or PSA or TSH or kol or B12 or B9 or Dvit then utvalg = 1;
/* kun skrive ut datasett som inkluderer treff på analyser */
if utvalg eq 1 then output;
run;
%mend NLK_utvalg;