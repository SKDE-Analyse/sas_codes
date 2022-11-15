/* Input variable  : bydel2 for RHF (specified in the argument, original bydel var from NPR) */
/* Output variable : bydel (komnr and bydel together) */

%macro bydel(inndata=, bydel=);

data &inndata;
  set &inndata;

  bydel_tmp=&bydel;
/* Tove 07.04.2022:fikse ugyldige bydeler! */
if komnr = 5001 and bydel_tmp not in (01:04) then bydel_tmp = 0;
if komnr = 4601 and bydel_tmp not in (01:08) then bydel_tmp = 0;
if komnr = 1103 and bydel_tmp not in (01:09) then bydel_tmp = 0;
if komnr = 301  and bydel_tmp not in (01:17) then bydel_tmp = 0;

  /* Create variable 'bydel' for the kommune with bydel */
  if komnr in (301,4601,5001,1103) then do;
    if bydel_tmp <= 0 then bydel = komnr*100+99; /*hvis følgende komnr mangler bydel lage bydel udef, feks 30199*/
    else bydel=komnr*100+bydel_tmp;
  end;

  /* All other kommune get missing value for bydel */
  else bydel=.;
drop bydel_tmp bydel2;
run;
%mend;