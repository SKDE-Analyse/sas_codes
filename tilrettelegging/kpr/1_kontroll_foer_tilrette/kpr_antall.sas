%macro kpr_antall(aar=);
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
			max(dato) 							as maxinn format YYMMDD10., /*max dato*/
			min(aar) 							as minaar, 
			max(aar) 							as maxaar
	FROM &inn ;
	QUIT;
	
	proc sql noprint;
	  select unik_enkeltregning, uten_kpr_lnr
		into :regning, :missing_kprid
		from regning_&aar.;
	quit;
	
	title color=darkblue height=5 '1a: Regningsfilen: sjekk mot utleveringsinfo';
	proc print data=regning_&aar;run;
	
	%if &missing_kprid ne 0 %then %do;
	/*se nærmere på radene som ikke har kpr_lnr*/
	/*de blir slettet i tilretteleggingen*/
	
	data missing;
	set &inn.;
	where kpr_lnr eq .;
	run;
	
	title color=red height=5 '1b: antall linjer uten kpr_lnr - blir slettet!!';
	
	proc freq data=missing;
	  tables kommuneNr alder kjonn tjenestetype; 
	run;
	%end;
	
	
	 proc datasets nolist; delete regning_&aar. ; run; 
	
	%mend;