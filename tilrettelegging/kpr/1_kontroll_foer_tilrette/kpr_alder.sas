%macro kpr_alder(inndata=,lnr=, kjonn=, fodselsar=);

  /* Prepare a sorted, deduplicated view for all checks */
  data lnr / view=lnr;
    set &inndata(keep=&lnr &fodselsar aar alder);
  run;

  /* Alder: Find patients with more than one age in the same year */
  proc sort data=lnr out=lnr_dupalder nodupkey;
    by &lnr aar alder;
  run;

  data dupalder;
    set lnr_dupalder;
    by &lnr aar;
    retain count_alder 0;
    if first.aar and first.&lnr. then count_alder=0;
    count_alder+1;
    if last.aar and last.&lnr. and count_alder>1 then output;
  run;

  title color=darkblue height=5 "4a: antall pasienter med ulik rapportert alder på ett år. Utlevering av alder varierer, noen ganger er det alder på konsultasjonstidspunkt som er angitt (unikid=flere millioner), andre ganger beregnet til aar - fodselsar (unikid=under 100).";
  proc sql;
    select count(*) as unikid from dupalder;
  quit;

  /* Compare reported alder with calculated alder */
  data alder_diff;
    set lnr;
    alder_calc = aar - &fodselsar;
    diff = (alder_calc ne alder);
  run;

  /* Summarize number of rows and unique IDs with differing age */
  proc sql noprint;
    select count(*) into :n_rows_diff from alder_diff where diff=1;
    select count(distinct &lnr) into :n_id_diff from alder_diff where diff=1;
  quit;

  data alder_diff_summary;
    n_rows_diff = &n_rows_diff;
    n_id_diff = &n_id_diff;
  run;

  title color=darkblue height=5 "4b: Effekt av tilrettelegging: antall rader og unike PID hvor beregnet alder avviker fra rapportert alder.";
  proc print data=alder_diff_summary label noobs; run;

  /* Fødselsår: Find patients with more than one fødselsår */
  proc sort data=lnr out=lnr_dupfod nodupkey;
    by &lnr &fodselsar;
  run;

  data dupfod;
    set lnr_dupfod;
    by &lnr;
    retain count_fod 0;
    if first.&lnr then count_fod=0;
    count_fod+1;
    if last.&lnr and count_fod>1 then output;
  run;

  /* Range and difference in fødselsår */
  title color=darkblue height=5 "4c: range fødselsår.";
  proc sql;
    select min(&fodselsar) as min_fodselsar, 
           max(&fodselsar) as max_fodselsar
    from lnr;
  quit;

  title color=darkblue height=5 "4d: antall pasienter med ulike fodselsår. Bør være få (under 100).";
  proc sql;
    select count(*) as unikid from dupfod;
  quit;

  /* Difference in fødselsår for those with more than one */
  data dupfodtrans;
    set dupfod;
    by &lnr;
    retain prev_fod;
    if first.&lnr then prev_fod=.;
    diff = &fodselsar - prev_fod;
    if not first.&lnr then output;
    prev_fod = &fodselsar;
  run;

  title color=darkblue height=5 "4e: differanse mellom årene";
  proc freq data=dupfodtrans;
    tables diff;
  run;

  /* Cleanup */
  proc datasets nolist;
    delete lnr_dupalder dupalder lnr_dupfod dupfod dupfodtrans alder_diff alder_diff_summary;
  quit;

%mend;