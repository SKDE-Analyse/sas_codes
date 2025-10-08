/* *Makro teller opp antall bosted og enkeltregninger per pasient/løpenummer */
/******************/
/*HVA KONTROLLERES*/
/******************/

/* 1. Kan det være flere ID-er i et kpr_lnr?
	  Se på antall enkeltregning_lnr og bostedavledet per kpr_lnr */

/*  Makroen aggregerer antall bosted og regninger per kpr_lnr
	Output viser antall pasienter som har x antall bosted og regninger

	Årsfilene kontrolleres individuelt 
*/

%macro kpr_aktivitet_lopenr(aar=);
proc sql;
	create table pr_lopenr_&aar. as
	select *, 
			count(distinct kommuneNr) as ant_bosted,
			count(distinct enkeltregning_lnr) as ant_regninger
	from &inn
	where kpr_lnr ne .
	group by kpr_lnr;
quit;

title color=darkblue height=5 "7a: Antall pasienter som har X antall bosted (KommuneNr)";
proc sql;
	select ant_bosted, count(distinct kpr_lnr) as ant_pas
	from pr_lopenr_&aar.
	group by ant_bosted;
quit;

title color=darkblue height=5 "7b: Antall pasienter som har X antall regninger";
proc sql;
	select ant_regninger, count(distinct kpr_lnr) as ant_pas
	from pr_lopenr_&aar.
	group by ant_regninger;
quit;
title;

proc datasets nolist;
delete pr_lopenr_&aar.;
run;
%mend;