
%macro kpr_bydel(inndata=, utdata=, bydel=bydel_org);

data &utdata(drop=bydel_tmp);
  set &inndata;

  bydel_tmp=&bydel;

  /* Create variable 'bydel' for the kommune with bydel */
  if komnr in (301,4601,1201,5001,1601,1103) then do;
    if bydel_tmp <= 0 then bydel = komnr*100+99; /*hvis følgende komnr mangler bydel lage bydel udef, feks 30199*/
    else bydel=komnr*100+bydel_tmp;
  end;

  /* All other kommune get missing value for bydel */
  else bydel=.;

run;
%mend;