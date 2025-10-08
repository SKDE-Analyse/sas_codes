%macro kpr_antall(aar=);
	/* ------------------------ */
	/* REGNINGSFILEN/HOVEDFILEN */
	/* ------------------------ */
	/* Get summary statistics directly into macro variables */
    proc sql noprint;
        select 
            count(distinct kpr_lnr),
            sum(missing(kpr_lnr)),
            count(*),
            count(distinct enkeltregning_lnr),
            min(dato),
            max(dato),
            min(aar),
            max(aar)
        into 
            :pasienter,
            :uten_kpr_lnr,
            :rader,
            :unik_enkeltregning,
            :mininn,
            :maxinn,
            :minaar,
            :maxaar
        from &inn;
    quit;

    title color=darkblue height=5 '1a: Regningsfilen: sjekk mot utleveringsinfo';

    /* Print a summary table */
    data regning_summary_&aar.;
        aar = &aar;
        pasienter = &pasienter;
        rader = &rader;
        unik_enkeltregning = &unik_enkeltregning;
        uten_kpr_lnr = &uten_kpr_lnr;
        mininn = &mininn;
        maxinn = &maxinn;
        minaar = &minaar;
        maxaar = &maxaar;
        format mininn maxinn yymmdd10.;
    run;

    proc print data=regning_summary_&aar.; run;

    %if &uten_kpr_lnr ne 0 %then %do;
        data missing_&aar.;
            set &inn;
            where kpr_lnr eq .;
        run;

        title color=red height=5 '1b: antall linjer uten kpr_lnr - blir slettet i tilrettelegging!!';
        proc freq data=missing_&aar.;
            tables kommuneNr alder kjonn tjenestetype;
        run;
    %end;

    proc datasets nolist; delete regning_summary_&aar. missing_&aar.; run;
	%mend;