%macro kpr_slette_rader(inndata=, utdata=);

/* 
Hvis kpr_lnr er missing -> slette radene da vi ikke kan gj�re noe med de
    - NB: ogs� slette tilh�rende rader i takst- og diagnosefilene.
    - NB: m� kj�re tilrettelegging p� hovedfil (regning) f�r diagnose- og takstfil.
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