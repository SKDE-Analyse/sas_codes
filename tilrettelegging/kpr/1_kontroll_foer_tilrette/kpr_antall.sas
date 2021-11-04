

%macro kpr_antall;

PROC SQL;
CREATE TABLE regning_&aar. AS
SELECT 	&aar as aar, 
		count(distinct kpr_lnr)  								as pasienter, 
		sum(missing (kpr_lnr))									as uten_kpr_lnr,
		count(*) 																as rader, 
		count(distinct enkeltregning_lnr) 			as unik_enkeltregning,
		min(datotid) 														as mininn format datetime18., 
		max(datotid) 														as maxinn format datetime18.
  FROM &inn ;
QUIT;

PROC SQL;
CREATE TABLE takst_&aar. AS
  SELECT  &aar as aar,
          count(distinct enkeltregning_lnr) 	as unik_regning_takst
  FROM &inn_takst;
QUIT;

PROC SQL;
CREATE TABLE diag_&aar. AS
  SELECT  &aar as aar,
          count(distinct enkeltregning_lnr) 	as unik_regning_diag
  FROM &inn_diag;
QUIT;

proc sql;
	create table joined_&aar. as
	select a.*, b.unik_regning_takst, c.unik_regning_diag
	from regning_&aar. a
	left join takst_&aar b ON a.aar=b.aar
	left join diag_&aar c ON a.aar=c.aar;
quit;

data joined_&aar.;
set joined_&aar.;
diff_regning_takst = unik_enkeltregning - unik_regning_takst;
diff_regning_diag = unik_enkeltregning - unik_regning_diag;
run;

proc delete data= regning_&aar. takst_&aar. diag_&aar.; run;
%mend;
