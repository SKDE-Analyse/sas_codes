/* Input variable  : bydel2 for RHF (specified in the argument, original bydel var from NPR) */
/* Output variable : bydel (komnr and bydel together) */

%macro bydel(inndata=, utdata=, bydel=bydel2);


data &utdata(drop=bydel_tmp);
  set &inndata;

  bydel_tmp=&bydel;

  /* First fix any bydel errors found in step 1 (error_bydel_&aar file) */
  if aar=2020 and komnr=5001 and bydel_tmp=6 then bydel_tmp=0; /* T2020T3 SOM */

  /* Create variable 'bydel' for the kommune with bydel */
  if komnr in (301,4601,5001,1103) then do;
    if bydel_tmp = 0 then bydel = komnr*100+99; /*hvis følgende komnr mangler bydel lage bydel udef, feks 30199*/
    else bydel=komnr*100+bydel_tmp;
  end;

  /* All other kommune get missing value for bydel */
  else bydel=.;

run;
%mend;