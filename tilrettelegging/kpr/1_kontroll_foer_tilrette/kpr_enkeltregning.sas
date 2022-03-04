/* MAKRO: FRA HOVEDFIL TIL SATELITT */
%macro kpr_enkeltregning;
proc sql;
	create table regninglnr_&aar. as
	select distinct enkeltregning_lnr,
		case when enkeltregning_lnr in (select enkeltregning_lnr from &diag ) then 1 end as ok_diag,
		case when enkeltregning_lnr in (select enkeltregning_lnr from &takst ) then 1 end as ok_takst
	from &hoved;
quit;
/*datasett skal være tomt hvis alt er ok*/
data regning_fail_&aar.;
set regninglnr_&aar.;
if ok_diag ne 1 or ok_takst ne 1;
run;

/*hvis datasett ikke er tomt: hvilke tjenestetyper gjelder det?*/
proc sql;
	create table sjekk_tjentype_&aar. as
	select a.*, b.tjenestetypenavn
	from regning_fail_&aar. a
	left join &hoved b
	on a.enkeltregning_lnr=b.enkeltregning_lnr;
quit;

proc sql;
	select tjenestetypenavn, count(*) as rad_diag
	from sjekk_tjentype_&aar.
	where ok_diag ne 1
	group by tjenestetypenavn;
quit;

proc sql;
	select tjenestetypenavn, count(*) as rad_takst
	from sjekk_tjentype_&aar.
	where ok_takst ne 1
	group by tjenestetypenavn;
quit;


















%mend kpr_enkeltregning;