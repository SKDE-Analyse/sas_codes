
/***********************************************************************************************
************************************************************************************************
MACRO FOR AVLEDEDE VARIABLE

Innhold i macroen:
	4.1 Retting av ugyldig fødselsår og avleding av aldersgrupper
	4.2 Definisjon av Alder, Ald_gr og Ald_gr5
	4.3 Omkoding av KJONN til ErMann 
	4.4 Omkoding av utgåtte organisasjonsnummer
	4.5 DRGTypeHastegrad

************************************************************************************************
***********************************************************************************************/

%Macro Avledede (innDataSett=, utDataSett=);
Data &Utdatasett;
set &Inndatasett;
/*
********************************************************
4.1 Retting av ugyldig fødselsår
*********************************************************
I datasettet er det registrert 27 personer over 110 år, som er høyeste oppnådde alder for bosatte i Norge i denne perioden, jfr. 
Wikipedias kronologiske liste over eldste levende personer i Norge siden 1964 (http:
//no.wikipedia.org/wiki/Liste_over_Norges_eldste_personer#Kronologisk_liste_over_eldste_levende_personer_i_Norge_siden_01.01.1964).
Høyeste alder i datasetett er 141 år. Feilaktig høy alder kan påvirke gjennomsnittsalder i små strata. Velger derfor å definere 
alder som ugyldig når oppgitt alder er høyere enn eldste person registret i Norge på dette tidspunktet.*/

/*Satte opprinnelig et krav om at personene måtte være bosatt i Norge, ettersom det er her vi har tall for eldste nålevende personer.
Dette innebærer imidlertid at mange opphold for personer bosatt i utlandet med alder over 110 år, og en særlig opphopning rundt 
årstallet 1899 (som kan mistenkes være brukt som missing-verdi.Velger derfor også å nullstille alder for utenlandske borgere etter 
samme regel som for norske*/

if aar=2012 and fodselsar < 1902 then fodselsar=9999;
if aar in (2013,2014,2015,2016) and fodselsar < 1904 then fodselsar=9999;
if aar=2012 and fodselsar >2012 then fodselsar=9999;
if aar=2013 and fodselsar >2013 then fodselsar=9999;
if aar=2014 and fodselsar >2014 then fodselsar=9999;
if aar=2015 and fodselsar >2015 then fodselsar=9999;
if aar=2016 and fodselsar >2016 then fodselsar=9999;


/*
4.2 Definerer Alder, ald_gr og Ald_gr5
**************************************************
*/
/*Definerer Alder basert på Fodselsår*/
Alder=aar-fodselsar;
if fodselsar=9999 then alder=.; /*Ugyldig*/


/*
**************************************************
4.3 Omkoding av KJONN til ErMann 	
**************************************************
*/
if KJONN=1 /*1 ='Mann' */ then ErMann=1;
else if KJONN=2 /*2 ='Kvinne' */ then ErMann=0;
else if KJONN in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ErMann=.;
*drop KJONN; /*Kontrollert ok*/;



/****************************************
*** 4.5 hastegrad og DRGtypeHastegrad ***
****************************************/

hastegrad=.;
if innmateHast in (1,2,3) then hastegrad=1; /*Akutt*/
if innmateHast=4 then hastegrad=4; /*Planlagt*/
if innmateHast=5 then hastegrad=5; /*Tilbakeføring av pasient fra annet sykehus (gjelder fra 2016)*/

if DRG_type='M' and hastegrad=4 /*Planlagt*/ then DRGtypeHastegrad=1;
else if DRG_type='M' and hastegrad=1 /*Akutt*/ then DRGtypeHastegrad=2;
else if DRG_type='K' and hastegrad=4 /*Planlagt*/ then DRGtypeHastegrad=3;
else if DRG_type='K' and hastegrad=1 /*Akutt*/ then DRGtypeHastegrad=4;
if DRG_TYPE=' ' then DRGtypeHastegrad=9;
if hastegrad=. then DRGtypeHastegrad=9;

run;


%Mend Avledede;

