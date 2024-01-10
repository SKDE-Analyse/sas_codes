/*BESKRIVELSE:

Koder opp definisjonsvariabler for diagnostikk av endometriet (endometriebiopsi og utskraping)
Utvalgskriterier er ihht. definisjonene fra gynekologiatlaset.

NBNB! Takstendring fom 1 juli 2022 gjør at analyser av endometriebiopsi der data fra avtalespesialister er inkludert  ikke er komplette etter 2021.
Se mer utfyllende info lenger ned.

Koden kjøres i datasteg slik:

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;

data ditt_utdatasett;
set ditt_inndatasett;
%include "&filbane/utvalg/diagendo.sas";
run;

*/
%macro diagEndo(datasett =);

 
    array diagnose {*} Hdiag: Bdiag:;
         do i=1 to dim(diagnose);
    
            if substr(diagnose{i},1,1) in ('O') then Svskap_diag=1; 
    
    end;
    
    
    array Prosedyre {*} NC:;
        do i=1 to dim(prosedyre);
    
        if substr(prosedyre{i},1,5) in ('LCA06') then diagEndoB_p=1;  /*Endometriebiopsi*/
        if substr(prosedyre{i},1,5) in ('LUC05','LUC15') then diagEndoB_p=1;  /*Hysteroskopi/mikrohysteroskopi med biopsi*/
        if substr(prosedyre{i},1,5) in ('LCA13') then LCA13=1;  /*Fraksjonert abrasio*/
        if substr(prosedyre{i},1,5) in ('LCA10') then LCA10=1;  /*abrasio*/

        if prosedyre{i} in ('LCB28') then LCB28=1;/*Hysteroskopisk eksisjon av endometrium*/
		if prosedyre{i} in ('LCB32') then LCB32=1;/*Hysteroskopisk destruksjon av endometrium*/
        if prosedyre{i} in ('LCA16') then LCA16=1;/*Destruksjon av endometrium*/
    
    end;
    
    /*NB! Takst 207b er i praksis ikke i bruk. Takst 2014c ble pr. 1 juli 2022 slått sammen med takst 105, som dekker veldig mye forskjellig.
    Fom. 2022 kan vi derfor ikke lenger gjøre komplette analyser av bruk av endometriebiopsi, fordi data fra avtalespesialister ikke vil være komplett.
    En del avtalespesialistkontakter med endometriereseksjon vil ha aktuelle prosedyrekoder, men en vesentlig andel vil mangle.*/
    array takst {*} Normaltariff:;
        do j=1 to dim(takst); 
    
            if substr(takst{j},1,4) in ('214c') then diagEndoB_p=1; 
            if substr(takst{j},1,4) in ('207b') then diagEndoB_p=1; 
    
    
    end;
    
    if LCA10=1 and Svskap_diag ne 1 then do;					/*Fjerner pasienter med O-tilstandskoder, dette er behandling*/
        if (LCB28 ne 1 and LCB32 ne 1 and LCA16 ne 1) and avtspes ne 1 then diagEndoU_p=1;	/*Fjerner behandling (endometriereseksjon) og kjent feilkoding av LCA10/13 hos avtspes*/
    end;
    
    if LCA13=1 and Svskap_diag ne 1 then do;					/*Fjerner pasienter med O-tilstandskoder, dette er behandling*/
        if (LCB28 ne 1 and LCB32 ne 1 and LCA16 ne 1) and avtspes ne 1 then diagEndoU_p=1;	/*Fjerner behandling (endometriereseksjon) og kjent feilkoding av LCA10/13 hos avtspes*/
    end;
    
    if diagEndoU_p=1 then diagEndoB_p=.;
    
    if diagEndoB_p=1 or diagEndoU_p=1 then diagEndo_p=1;