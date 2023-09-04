%macro kontroll_mottatte_data_kpr(mottatt_aar=);

    /* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
    data _null_;
    dset=open("&inn");
    call symput ('aar_e',varnum(dset,'aar'));
    call symput ('kpr_lnr',varnum(dset,'kpr_lnr'));
    call symput ('enkeltregning_lnr',varnum(dset,'enkeltregning_lnr'));
    call symput ('dato',varnum(dset,'dato'));
    call symput ('kjonn',varnum(dset,'kjonn'));
    call symput ('alder',varnum(dset,'alder'));
    call symput ('fodselsar',varnum(dset,'fodselsar'));
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
        &kjonn ne 0 and &alder ne 0 and &fodselsar ne 0 and &aar_e ne 0 and &tjenestetype ne 0 and
		&kommuneNr ne 0 and &bydel ne 0 %then %do;

    /* ----------------------------- */
    /* 1 - antall pasienter og rader */
    /* ----------------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_antall.sas";
    %kpr_antall(aar=&mottatt_aar);
    
    /* ------------------ */
    /* 2 - regningsnummer */
    /* ------------------ */
	%include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_enkeltregning.sas";
	%kpr_enkeltregning;
        
    /* ---------------------- */
    /* 3/4 - kjønn og fødselsår */
    /* ---------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_kjonn_alder.sas";
    %kpr_kjonn_alder(inndata=&inn,lnr=kpr_lnr, kjonn=kjonn, fodselsar=fodselsar);
  


    /* ------------------ */
    /* 5 - komnr / bydel  */
    /* ------------------ */
	%include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_kontroll_komnr_bydel.sas";
	%kontroll_komnr_bydel(inndata=&inn, aar=&mottatt_aar, komnr=kommuneNr, bydel=bydel); /*komnr 1 feil + missing / */
    %komnr_ukjent(inndata=&inn, aar=&mottatt_aar);

	/* --------------------------------------------------- */
    /* 6 - pasienter med flerer komnr eller regningsnummer */
    /* --------------------------------------------------- */
	%include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_aktivitet_lopenr.sas";
	%kpr_aktivitet_lopenr;


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
    