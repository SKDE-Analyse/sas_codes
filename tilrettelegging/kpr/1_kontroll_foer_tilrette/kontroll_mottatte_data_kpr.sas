%macro kontroll_mottatte_data_kpr;
/**************************************************************************/
/* Kontroller at alle nødvendige variabler er tilstede før kontroll gjøres */
/**************************************************************************/

/* Kontroll takstfilen */
data _null_;
        dset_t = open("&inn_takst");
        vars_t = 'aar enkeltregning_lnr'; /*variabler som må være tilstede i filen*/ 
        length missing_t $200;
        do i = 1 to countw(vars_t, ' ');
            varname_t = scan(vars_t, i, ' ');
            vnum_t = varnum(dset_t, varname_t);
            call symputx(cats(varname_t, '_t'), vnum_t);
            if vnum_t = 0 then missing_t = catx(' ', missing_t, varname_t);
        end;
        call symputx('missing_vars_t', missing_t);
    run;

    /* Kontroll diagnosefilen */
    data _null_;
        dset_d = open("&inn_diag");
        vars_d = 'aar enkeltregning_lnr'; /*variabler som må være tilstede i filen*/ 
        length missing_d $200;
        do i = 1 to countw(vars_d, ' ');
            varname_d = scan(vars_d, i, ' ');
            vnum_d = varnum(dset_d, varname_d);
            call symputx(cats(varname_d, '_d'), vnum_d);
            if vnum_d = 0 then missing_d = catx(' ', missing_d, varname_d);
        end;
        call symputx('missing_vars_d', missing_d);
    run;

    /* Kontroll regningsfilen/hovedfilen */
    data _null_;
        dset = open("&inn");
        vars = 'aar kpr_lnr enkeltregning_lnr dato kjonn alder fodselsaar kommuneNr bydel tjenestetype praksiskommune'; /*variabler som må være tilstede i filen*/ 
        length missing $200;
        do i = 1 to countw(vars, ' ');
            varname = scan(vars, i, ' ');
            vnum = varnum(dset, varname);
            call symputx(varname, vnum);
            if vnum = 0 then missing = catx(' ', missing, varname);
        end;
        call symputx('missing_vars', missing);
    run;

/* Print warnings if any variables are missing */
    %if "&missing_vars" ne "" %then %do;
        title color=purple height=5 "MANGLER VARIABLE(R) I HOVEDFILEN: &missing_vars";
        proc sql;
            create table m (note char(50));
            insert into m values ("Mangler variabler i hovedfilen: &missing_vars");
            select * from m;
        quit;
    %end;

    %if "&missing_vars_t" ne "" %then %do;
        title color=purple height=5 "MANGLER VARIABLE(R) I TAKSTFILEN: &missing_vars_t";
        proc sql;
            create table m_t (note char(50));
            insert into m_t values ("Mangler variabler i takstfilen: &missing_vars_t");
            select * from m_t;
        quit;
    %end;

    %if "&missing_vars_d" ne "" %then %do;
        title color=purple height=5 "MANGLER VARIABLE(R) I DIAGNOSEFILEN: &missing_vars_d";
        proc sql;
            create table m_d (note char(50));
            insert into m_d values ("Mangler variabler i diagnosefilen: &missing_vars_d");
            select * from m_d;
        quit;
    %end;

    /* Only continue if all required variables are present */
    %if "&missing_vars" = "" and "&missing_vars_t" = "" and "&missing_vars_d" = "" %then %do;


/*lager makrovariabel som angir årstall - brukes til navning av data senere*/
data _null_;
  set &inn.;
  call symputx("aar",aar);
run;

    /* ----------------------------- */
    /* 1 - antall pasienter og rader */
    /* ----------------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_antall.sas";
    %kpr_antall(aar=&aar.);
    
    /* ------------------------------------------ */
    /* 2 og 3 - sjekk av filene takst og diagnose */
    /* ------------------------------------------ */
	%include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_kobling_takst_diagnose.sas";
	%kpr_kobling_takst_diagnose(aar=&aar.);
        
    /* --------------------------- */
    /* 4 og 5 - alder og fødselsår */
    /* --------------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_alder.sas";
    %kpr_alder(inndata=&inn,lnr=kpr_lnr, fodselsar=fodselsaar);

    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_kjonn.sas";
    %kpr_kjonn(inndata=&inn,lnr=kpr_lnr, kjonn=kjonn);

    /* ------------------ */
    /* 6- komnr / bydel  */
    /* ------------------ */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_komnr_bydel.sas";
	%kpr_komnr_bydel(inndata=&inn, aar=&aar, komnr=kommuneNr, bydel=bydel);

	/* --------------------------------------------------- */
    /* 7 - pasienter med flerer komnr eller regningsnummer */
    /* --------------------------------------------------- */
	%include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_aktivitet_lopenr.sas";
	%kpr_aktivitet_lopenr(aar=&aar.);
   %end; 

    /* ---------------------------------------------------------------- */
    /* 8 - Har mottatte variabler lik type og lengde som referanse satt */
    /* ---------------------------------------------------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_type_lengde_format.sas";
    %kpr_type_lengde_format;
%mend;