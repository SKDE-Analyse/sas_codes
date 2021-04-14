%Macro Avledede_som (innDataSett=, utDataSett=);


/*!

MACRO FOR AVLEDEDE VARIABLE

### Innhold i macroen:
1. Retting av ugyldig f�dsels�r og avleding av aldersgrupper
2. Definisjon av Alder, Ald_gr og Ald_gr5
3. Omkoding av KJONN til ErMann
5. DRGTypeHastegrad




### Steg for steg

*/

Data &Utdatasett;
set &Inndatasett;

/* fix variable anomaly that was discovered in the step 1 control */

alderIdager_org=alderIdager;
if alderIdager ne . then do;
if alderIdager < 0 then alderIdager=.;
end;

/* isolated case, one line in 2018, one line in 2019 to be fixed */
if aar=2018 and liggetid>6000 then inndato=utdato;
if aar=2019 and liggetid> 800 then inndato=utdato;

liggetid_org=liggetid;
liggetid=utdato-inndato;

/*!
- Retting av ugyldig f�dsels�r
*/
fodselsar_org=fodselsar;
if fodselsar > aar or fodselsar=. then fodselsar=9999;
if aar-fodselsar > 110 then fodselsar=9999;


/*!
- Definerer Alder basert p� Fodsels�r
*/

Alder=aar-fodselsar;
if fodselsar=9999 then alder=.; /*Ugyldig*/

/*!
- Omkoding av KJONN til ErMann
*/
     if KJONN=1 /*1 ='Mann' */   then ErMann=1; /* Mann */
else if KJONN=2 /*2 ='Kvinne' */ then ErMann=0; /* Kvinne */
else if KJONN in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ErMann=.;


/*!
- Definere `hastegrad` og `DRGtypeHastegrad` (kun for somatikk). 
Definerer `hastegrad = 4` (planlagt) for avtalespesialistkonsultasjoner.
*/

%if &somatikk=1 %then %do;
    hastegrad=.;
    if innmateHast in (1,2,3)   then hastegrad=1; /*Akutt*/
    if innmateHast=4            then hastegrad=4; /*Planlagt*/
    if innmateHast=5            then hastegrad=5; /*Tilbakef�ring av pasient fra annet sykehus (gjelder fra 2016)*/

         if DRG_type='M' and hastegrad=4 /*Planlagt*/   then DRGtypeHastegrad=1;
    else if DRG_type='M' and hastegrad=1 /*Akutt*/      then DRGtypeHastegrad=2;
    else if DRG_type='K' and hastegrad=4 /*Planlagt*/   then DRGtypeHastegrad=3;
    else if DRG_type='K' and hastegrad=1 /*Akutt*/      then DRGtypeHastegrad=4;
    if DRG_TYPE=' ' then DRGtypeHastegrad=9;
    if hastegrad=.  then DRGtypeHastegrad=9;
%end;



%if &avtspes=1 %then %do;
    /*!
    - Sett alle hos avtalespesialister til planlagt (hastegrad 4), poliklinikk (omsorgsniva 3, utdato=inndato)
    - Omdefinere aar fra utdato
    */
    hastegrad=4;

    omsorgsniva_org=omsorgsniva;
    omsorgsniva=3; 

    utdato_org=utdato;
    utdato=inndato;

    aar_org=aar;
    aar=year(utdato);
    /*
    ************************************************************************************************
    3.7	FAG_SKDE
    ************************************************************************************************
    /*!
    - Lager ny harmonisert variabel fra FAG og Fag_navn (gjelder kun avtalespesialister). 
    */

    if Fag = 1 then Fag_SKDE = 1;
    if Fag = 2 then Fag_SKDE = 2;
    if Fag = 3 then Fag_SKDE = 3;
    if Fag = 4 then Fag_SKDE = 4;
    if Fag = 5 then Fag_SKDE = 5;
    if Fag in (6:10,24,25) then Fag_SKDE = 6;
    if Fag in (11:14) then Fag_SKDE = 11;
    if Fag = 15 then Fag_SKDE = 15;
    if Fag = 16 then Fag_SKDE = 16;
    if Fag = 17 then Fag_SKDE = 17;
    if Fag = 18 then Fag_SKDE = 18;
    if Fag = 19 then Fag_SKDE = 19;
    if Fag = 20 then Fag_SKDE = 20;
    if Fag = 21 then Fag_SKDE = 21;
    if Fag = 22 then Fag_SKDE = 22;
    if Fag = 23 then Fag_SKDE = 23;
    if Fag = 30 then Fag_SKDE = 30;
    if Fag = 31 then Fag_SKDE = 31;

    AvtSpes=1;

%end;

run;

%mend;