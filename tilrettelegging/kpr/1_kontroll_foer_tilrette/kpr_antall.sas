%macro kpr_antall;
/* ------------------------ */
/* REGNINGSFILEN/HOVEDFILEN */
/* ------------------------ */

PROC SQL;
CREATE TABLE regning_&aar. AS
SELECT 	&aar as aar, 
		count(distinct kpr_lnr)  			as pasienter, /*unike løpenummer*/
		sum(missing (kpr_lnr))				as uten_kpr_lnr, /*regninger uten løpenummer*/
		count(*) 							as rader, /*antall regninger*/
		count(distinct enkeltregning_lnr) 	as unik_enkeltregning, /*kontroll antall unike regninger*/
		min(dato) 							as mininn format YYMMDD10., /*min dato*/
		max(dato) 							as maxinn format YYMMDD10. /*max dato*/
  FROM &inn ;
QUIT;

/* -------- */
/* TAKSTFIL */
/* -------- */
/*antall unike regninger i takstfil, burde være lik antall regninger i hovedfil*/
PROC SQL;
CREATE TABLE takst_&aar. AS
  SELECT  &aar as aar,
          count(distinct enkeltregning_lnr) 	as unik_regning_takst 
  FROM &inn_takst;
QUIT;

/* ----------- */
/* DIAGNOSEFIL */
/* ----------- */
/*antall unike regninger i diagnosefil, burde være lik antall regninger i hovedfil*/
PROC SQL;
CREATE TABLE diag_&aar. AS
  SELECT  &aar as aar,
          count(distinct enkeltregning_lnr) 	as unik_regning_diag 
  FROM &inn_diag;
QUIT;


/* Slå sammen datasettene og beregn differanse i antall regninger  */
proc sql;
	create table joined_&aar. as
	select a.*, b.unik_regning_takst, c.unik_regning_diag, 
			(a.unik_enkeltregning - b.unik_regning_takst) as diff_regning_takst,
			(a.unik_enkeltregning - c.unik_regning_diag) as diff_regning_diag
	from regning_&aar. a
	left join takst_&aar b ON a.aar=b.aar
	left join diag_&aar c ON a.aar=c.aar;
quit;

proc delete data= regning_&aar. takst_&aar. diag_&aar.; run;
%mend;
