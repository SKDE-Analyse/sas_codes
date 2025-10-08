%macro kpr_kjonn(inndata=,lnr=, kjonn=, fodselsar=);

  /* Prepare a sorted, deduplicated view for all checks */
  data lnr / view=lnr;
    set &inndata(keep=&lnr &kjonn &fodselsar aar alder);
  run;

  /* Kjønn: Find patients with more than one gender */
  proc sort data=lnr out=lnr_dupkjonn nodupkey;
    by &lnr &kjonn;
  run;

  data dupkjonn;
    set lnr_dupkjonn;
    by &lnr;
    retain count_kjonn 0;
    if first.&lnr then count_kjonn=0;
    count_kjonn+1;
    if last.&lnr and count_kjonn>1 then output;
  run;

  title color=darkblue height=5 "5a: antall pasienter med ulike kjønn. Hvis antall større enn 1 000 må dette undersøkes nærmere";
  proc sql;
    select count(*) as unikid from dupkjonn;
  quit;

  /* Cleanup */
  proc datasets nolist;
    delete lnr_dupkjonn dupkjonn ;
  quit;

%mend;