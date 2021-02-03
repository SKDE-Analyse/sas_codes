/* antall innleggelse, &var, poli, etc , per behandlingssykehus / HF */

/* Se om antall liggedøgn samsvarer med tidligere år  */


%macro liggedogn(beh=behsh, var=liggetid);

%include "&filbane\2_tilrettelegging\formater_beh.sas";
%fmt_beh;

data tmp;
set hnana.t20_magnus_avd_2020(keep=aar pid &beh &var)
    hnana.t20_magnus_avd_2019(keep=aar pid &beh &var)
    hnana.t20_magnus_avd_2018(keep=aar pid &beh &var)
    hnana.t20_magnus_avd_2017(keep=aar pid &beh &var)
    hnana.t20_magnus_avd_2016(keep=aar pid &beh &var);
where &var > 0;
format &beh &beh._fmt.;
run;

proc sql;
    select aar, &beh,
        sum(&var) as &var._tot,
        count(distinct pid) as ant_pids
    from tmp
    group by &beh, aar;
quit;

%mend;