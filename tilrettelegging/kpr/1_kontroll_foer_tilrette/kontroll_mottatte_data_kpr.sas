%macro kontroll_mottatte_data_kpr;
/*test git for meg*/
    /* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
    data _null_;
    dset=open("&inn");
    call symputx ('aar_e',varnum(dset,'aar'));
    call symput ('kpr_lnr',varnum(dset,'kpr_lnr'));
    call symput ('enkeltregning_lnr',varnum(dset,'enkeltregning_lnr'));
    call symput ('dato',varnum(dset,'dato'));
    call symput ('kjonn',varnum(dset,'kjonn'));
    call symput ('alder',varnum(dset,'alder'));
    call symput ('fodselsaar',varnum(dset,'fodselsaar'));
    call symput ('kommuneNr',varnum(dset,'kommuneNr'));
    call symput ('bydel',varnum(dset,'bydel'));
    call symput ('tjenestetype',varnum(dset,'tjenestetype'));
    run;

	data _null_;
    dset_t=open("&inn_takst");
    call symput ('aar_t',varnum(dset_t,'aar'));
    call symput ('enkeltregning_lnr_t',varnum(dset_t,'enkeltregning_lnr'));
    run;

    data _null_;
    dset_d=open("&inn_diag");
    call symput ('aar_d',varnum(dset_d,'aar'));
    call symput ('enkeltregning_lnr_d',varnum(dset_d,'enkeltregning_lnr'));
    run;


    %if &kpr_lnr ne 0 and &enkeltregning_lnr ne 0 and &dato ne 0 and 
        &kjonn ne 0 and &alder ne 0 and &fodselsaar ne 0 and &aar_e ne 0 and &tjenestetype ne 0 and
		&kommuneNr ne 0 and &bydel ne 0 %then %do;


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
    
    /* ------------------ */
    /* 2 - regningsnummer */
    /* ------------------ */
	%include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_enkeltregning.sas";
	%kpr_enkeltregning(aar=&aar.);
        
    /* ---------------------- */
    /* 3/4 - kjønn og fødselsår */
    /* ---------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_kjonn_alder.sas";
    %kpr_kjonn_alder(inndata=&inn,lnr=kpr_lnr, kjonn=kjonn, fodselsar=fodselsaar);
  


    /* ------------------ */
    /* 5 - komnr / bydel  */
    /* ------------------ */

    /* dette steget bruker makro fra "&filbane/tilrettelegging/npr/1_kontroll_foer_tilrette/1_kontroll_komnr_bydel.sas */
    %include "&filbane/tilrettelegging/npr/1_kontroll_foer_tilrette/1_kontroll_komnr_bydel.sas";
	%include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_komnr_ukjent.sas";
	%kontroll_komnr_bydel(inndata=&inn, aar=&aar, komnr=kommuneNr, bydel=bydel);
    %kpr_komnr_ukjent(inndata=&inn, aar=&aar.);

	/* --------------------------------------------------- */
    /* 6 - pasienter med flerer komnr eller regningsnummer */
    /* --------------------------------------------------- */
	%include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_aktivitet_lopenr.sas";
	%kpr_aktivitet_lopenr(aar=&aar.);

	%end;

	%else %do;
	title color=purple height=5 'MANGLER VARIABLE(R)';
	proc sql;
  		create table m (note char(12));
  		insert into m values ('mangler variabler!');
  		select *
  		from m;
	quit;
	%end;

    /* ---------------------------------------------------------------- */
    /* 7 - Har mottatte variabler lik type og lengde som referanse satt */
    /* ---------------------------------------------------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_type_lengde_format.sas";
    %kpr_type_lengde_format;
        

%mend kontroll_mottatte_data_kpr;