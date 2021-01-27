%macro bydel(inndata=, utdata=);


data &utdata;
  set &inndata;
  if komnr in (301,4601,5001,1103) then do;
    /* Lager bydel=99 hvis det mangler i datasettet */
    if bydel2 = 0 then bydel = komnr*100+99; /*hvis følgende komnr mangler bydel lage bydel udef, feks 30199*/
    else bydel=komnr*100+bydel2;
  end;
  else bydel=.;

run;
%mend;