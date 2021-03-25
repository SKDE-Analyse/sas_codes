%Macro Avledede_avtspes (innDataSett=, utDataSett=);


/*!

MACRO FOR AVLEDEDE VARIABLE

### Innhold i macroen:
1. Retting av ugyldig fødselsår og avleding av aldersgrupper
2. Definisjon av Alder, Ald_gr og Ald_gr5
3. Omkoding av KJONN til ErMann
5. DRGTypeHastegrad


### Steg for steg

*/

Data &Utdatasett;
set &Inndatasett;

/*!
- Retting av ugyldig fødselsår
/*


/* if fødselsår is  invalid */
if fodselsar > aar or fodselsar=. then fodselsar=9999;
if aar-fodselsar > 110 then fodselsar=9999;


/*!
- Definerer Alder basert på Fodselsår
*/

Alder=aar-fodselsar;
if fodselsar=9999 then alder=.; /*Ugyldig*/

/*!
- Omkoding av KJONN til ErMann
*/
if KJONN=1 /*1 ='Mann' */ then ErMann=1; /* Mann */
else if KJONN=2 /*2 ='Kvinne' */ then ErMann=0; /* Kvinne */
else if KJONN in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ErMann=.;

/*!
- Sett alle hos avtalespesialister til planlagt (hastegrad 4) poliklinikk (omsorgsniva 3, utdato=inndato)
*/
hastegrad=4;

omsorgsniva_org=omsorgsniva;
omsorgsniva=3; 

utdato_org=utdato;
utdato=inndato;
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


run;

%mend;
