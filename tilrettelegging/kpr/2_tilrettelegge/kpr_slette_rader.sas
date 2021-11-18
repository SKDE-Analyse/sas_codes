%macro kpr_slette_rader(inndata=, utdata=);

/* 
Hvis kpr_lnr er missing -> slette radene da vi ikke kan gjøre noe med de
    - NB: også slette tilhørende rader i takst- og diagnosefilene.
    - NB: må kjøre tilrettelegging på hovedfil (regning) før diagnose- og takstfil.
 */

%if &sektor=regning %then %do; 
proc sql;
	create table slette as
	select enkeltregning_lnr
	from &inndata
	where kpr_lnr eq . ;
quit;
%end;

proc sql;
	create table &utdata as
	select *
	from &inndata
	where enkeltregning_lnr not in (select enkeltregning_lnr from slette);
quit;

%mend;