/*Makro som kjøres for å kategorisere behander i eget HF, annet hf eller privat

Krav: dersom avtspesdata er inkludert i datasettet må det finnes en variabel ved navn avtspes som er enten 1 eller ikke 1 

Makroen lager variabelen beh_kat med veridene 1 (eget HF), 2 (annet off) , 3 (privat)

*/

%macro beh_eget_annet_priv(inndata=, utdata=, as_data=1);

    proc format;
    value beh_kat3F
    1 = 'Eget HF'
    2 = 'Annet HF'
    3 = 'Privat';
    run;

    /*Kjører datasteg dersom det er avtspesdata i innfila */
    %if &as_data eq 1 %then %do;
    
    data &inndata._1;
    set &inndata;
        /*Setter behhf lik private for avtalespesialister */
        if avtspes=1 then behHF=27;
    run;

    %end;
    /*Hvis det ikke er avtspesdata i fila lager vi bare et nytt datasett likt inndatasett */
    %if &as_data ne 1 %then %do;
    
        data &inndata._1;
        set &inndata;
        run;
    
     %end;

    
    /*Bruker datasett bo_beh_kat3 i HNREF for å legge på variabelen beh_kat */
    proc sql;
        create table &utdata as
        select a.*, b.beh_kat format beh_kat3F. label "Tredelt kategorisering av behandler (Eget, Annet, Privat)"
        from &inndata._1 as a
            left join hnref.bo_beh_kat3 as b 
            on (a.boHF=b.boHF and a.BehHF=b.BehHF);
    quit;

    /*Lager tre nye variabler basert på beh_kat*/
    data &utdata:
    set &utdata;
    eget=0;
    annet=0;
    privat=0;
    if beh_kat=1 then eget=1;
    if beh_kat=2 then annet=1;
    if beh_kat=3 then privat=1;
    run;
    
    proc datasets nolist;
        delete &inndata._1;
        run;
    
    %mend;