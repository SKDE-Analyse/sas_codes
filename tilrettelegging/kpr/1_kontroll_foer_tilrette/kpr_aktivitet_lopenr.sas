/* *Makro teller opp antall bosted og enkeltregninger per pasient/løpenummer */
%macro kpr_aktivitet_lopenr(inndata=);
proc sql;
	create table pr_lopenr_&aar. as
	select *, 
			count(distinct kommuneNr) as ant_bosted,
			count(distinct enkeltregning_lnr) as ant_regninger
	from &inndata
	where kpr_lnr ne .
	group by kpr_lnr;
quit;

title"&aar. antall pasienter som har X antall bosted";
proc sql;
	select ant_bosted, count(distinct kpr_lnr) as ant_pas
	from pr_lopenr_&aar.
	group by ant_bosted;
quit;
title"&aar. antall pasienter som har X antall regninger";
proc sql;
	select ant_regninger, count(distinct kpr_lnr) as ant_pas
	from pr_lopenr_&aar.
	group by ant_regninger;
quit;
title;
%mend kpr_aktivitet_lopenr;