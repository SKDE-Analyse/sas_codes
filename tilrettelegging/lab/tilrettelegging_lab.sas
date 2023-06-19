%macro tilrettelegging_LAB(inndata=, aar=);
    /*! 
    ### Beskrivelse
    
    Makro for å tilrettelegge LAB-data (NLK-filer).
    
    ```
    %tilrettelegging_lab(inndata=,aar=);
    ```
    
    ### Input 
          - Inndata: 
          - aar:
    
    ### Output 
          - Utdata med variablene:
    
    ### Endringslogg:
        - Opprettet juni 2023, Tove J
     */
    
    
    data lab_&aar.;
    set &inndata;
    run;
     
    data lab_&aar.;
    set lab_&aar.;
    
    rename pasientlopenummer = pid;
        
    /* skille på offentlig og privat */
    if fagomraade_kode eq "PO" then off = 1;
    if fagomraade_kode eq "LR" then priv = 1;
    
    /*omkode pasient_kjonn til ermann*/
         if pasient_kjonn eq 1     			then ermann=1; /* Mann */
         if pasient_kjonn eq 2     			then ermann=0; /* Kvinne */
         if pasient_kjonn not in  (1:2) 	then ermann=.;
         drop pasient_kjonn;
         format ermann ermann.;
        
    /*dele nlkkode-variabel slik at en kode per celle*/
    array nlk {*} $ nlkkode1-nlkkode181;
        do i=1 to 181;
            ncrp{i}=scan(nlkkoder,i,","); 
        end;
    drop i;
        
    /*år, måned og inndato fra dato variabel*/
    aar = year(dato);
    inndato = dato;
    format inndato eurdfdd10.;
    drop dato;
    run;
    
    /* omkode komnr og bydel -> omkodet komnr heter "komnr_mottatt" */
    %include "&filbane/tilrettelegging/radiologi/omkoding_komnr_bydel.sas";
    %omkoding_komnr_bydel(inndata=lab_&aar., pas_komnr=pasient_kommune);
    
    /* fornye komnr/bydel */
    /* bydelsnr er allerede omkodet -> trenger ikke kjøre makro bydeler etter fornying */
    %include "&filbane/makroer/forny_komnr.sas";
    %forny_komnr(inndata=lab_&aar., kommune_nr=komnr_mottatt);
    
    /* for å omkode behandler-komnr må komnr-bosted renames for å ikke overskrives */
    data lab_&aar.;
    set lab_&aar.;
    rename komnr = komnr_bosted; 
    drop nr komnr_inn komnr_mottatt;
    run;
    
    %forny_komnr(inndata=lab_&aar., kommune_nr=behandler_kommunenr);
    
    data lab_&aar.;
    set lab_&aar.;
    rename komnr = komnr_behandler komnr_bosted=komnr;
    drop nr komnr_inn behandler_kommunenr;
    run;
    
    /* boomraader */
    %include "&filbane/makroer/boomraader.sas";
    %boomraader(inndata=lab_&aar.);
    
    data lab_&aar.;
    retain 
    pid 
    aar 
    inndato
    ErMann
    alder
    komnr
    bydel
    bohf
    borhf
    boshhn
    nlkkode1-nlkkode181;
    set lab_&aar.;
    /* sette på bo-formater */
    format bohf bohf_fmt. borhf borhf_fmt. boshhn boshhn_fmt.;
    run;
    
    /* sortere */
    proc sort data=lab_&aar.;
    by pid inndato;
    run;
    
    /* lagre tilrettelagt datasett */
    /* data skde20.NLK_&aar._T23;
    set lab_&aar;
    run; */
    %mend tilrettelegging_lab;