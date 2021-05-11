/* antall innleggelse, &var, poli, etc , per behandlingssykehus / HF */

/* Se om antall liggedøgn samsvarer med tidligere år  */


%macro liggedogn(beh=behsh, var=liggetid);

data tmp;
set hnana.T21M03_MAGNUS_AVD_2021_feb(keep=aar pid &beh &var)
    hnana.T20T3_MAGNUS_AVD_2020(keep=aar pid &beh &var)
    hnana.T20T2_MAGNUS_AVD_2019(keep=aar pid &beh &var)
    hnana.T20T2_MAGNUS_AVD_2018(keep=aar pid &beh &var);
where &var > 0;
format &beh &beh._fmt.;
run;

proc sql;
    select aar, &beh,
        sum(&var) as &var._tot,
        count(distinct pid) as ant_pids,
        calculated &var._tot / calculated ant_pids as snitt_dogn
    from tmp
    group by &beh, aar;
quit;

%mend;