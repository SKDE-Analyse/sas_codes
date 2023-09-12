%macro kontroll_mottatte_data_kpr(mottatt_aar=);

    /* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
    data _null_;
    dset=open("&inn");
    call symput ('aar',varnum(dset,'aar'));
    call symput ('kpr_lnr',varnum(dset,'kpr_lnr'));
    call symput ('enkeltregning_lnr',varnum(dset,'enkeltregning_lnr'));
    call symput ('dato',varnum(dset,'dato'));
    call symput ('kjonn',varnum(dset,'kjonn'));
    call symput ('fodselsar',varnum(dset,'fodselsar'));
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



    /* ----------------------------- */
    /* 1 - antall pasienter og rader */
    /* ----------------------------- */
    %if &kpr_lnr ne 0 and &enkeltregning_lnr ne 0 and &dato ne 0 and 
        &kjonn ne 0 and &fodselsar ne 0 and &aar ne 0 %then %do;
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_antall.sas";
    %kpr_antall(aar=&mottatt_aar);
    
    /* ---------------------- */
    /* 2 - kjønn og fødselsår */
    /* ---------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_kjonn_alder.sas";
    %kpr_kjonn_alder(inndata=&inn,lnr=kpr_lnr, kjonn=kjonn, fodselsar=fodselsar);
  
    /* -------------------------------------- */
    /* 3 - min og maks-verdier for år og dato */
    /* -------------------------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_min_maks_dato.sas";
    %kpr_min_maks_dato;
    %end;
        
    /* ---------------------------------------------------------------- */
    /* 4 - Har mottatte variabler lik type og lengde som referanse satt */
    /* ---------------------------------------------------------------- */
    %include "&filbane/tilrettelegging/kpr/1_kontroll_foer_tilrette/kpr_type_lengde_format.sas";
    %kpr_type_lengde_format;
        
%mend kontroll_mottatte_data_kpr;
    