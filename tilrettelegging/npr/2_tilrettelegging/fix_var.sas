/* fix variable anomaly that was discovered in the step 1 control */

%macro fix_var(inndata=, utdata=);

data &utdata;
  set &inndata(rename=(alderldager=alderldager_orig fodselsar=fodselsar_orig));

    alderldager=alderldager_orig;
    if alderldager<0 then alderldager=0;

    
    /* isolated case, one line in 2018 to be fixed */
    if aar=2018 and aktivitetskategori3=3 and year(inndato) ne 2018 then inndato=utdato;

run;

%mend;