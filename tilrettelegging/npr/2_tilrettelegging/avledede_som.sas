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

/*!
- Retting av ugyldig f�dsels�r
*/

/* fix variable anomaly that was discovered in the step 1 control */

/* if the variable exists then do */
%if %sysevalf(%superq(alderIdager)=1,boolean) %then %do; 
  alderIdager_orig=alderIdager;
  if alderIdager<0 then alderIdager=0;
%end;

/* isolated case, one line in 2018, one line in 2019 to be fixed */
if aar=2018 and liggetid>6000 then inndato=utdato;
if aar=2019 and liggetid> 800 then inndato=utdato;

/* if f�dsels�r is  invalid */
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
if KJONN=1 /*1 ='Mann' */ then ErMann=1; /* Mann */
else if KJONN=2 /*2 ='Kvinne' */ then ErMann=0; /* Kvinne */
else if KJONN in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ErMann=.;


/*!
- Definere `hastegrad` og `DRGtypeHastegrad` (kun for somatikk). 
Definerer `hastegrad = 4` (planlagt) for avtalespesialistkonsultasjoner.
*/

%if &somatikk ne 0 %then %do;
hastegrad=.;
if innmateHast in (1,2,3) then hastegrad=1; /*Akutt*/
if innmateHast=4 then hastegrad=4; /*Planlagt*/
if innmateHast=5 then hastegrad=5; /*Tilbakef�ring av pasient fra annet sykehus (gjelder fra 2016)*/

if DRG_type='M' and hastegrad=4 /*Planlagt*/ then DRGtypeHastegrad=1;
else if DRG_type='M' and hastegrad=1 /*Akutt*/ then DRGtypeHastegrad=2;
else if DRG_type='K' and hastegrad=4 /*Planlagt*/ then DRGtypeHastegrad=3;
else if DRG_type='K' and hastegrad=1 /*Akutt*/ then DRGtypeHastegrad=4;
if DRG_TYPE=' ' then DRGtypeHastegrad=9;
if hastegrad=. then DRGtypeHastegrad=9;
%end;




run;

%mend;
