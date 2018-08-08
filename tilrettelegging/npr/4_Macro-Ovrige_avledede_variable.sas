%Macro Avledede (innDataSett=, utDataSett=);


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
/*

/*
I datasettet er det registrert 27 personer over 110 �r, som er h�yeste oppn�dde alder for bosatte i Norge i denne perioden, jfr. 
Wikipedias kronologiske liste over eldste levende personer i Norge siden 1964 (http:
//no.wikipedia.org/wiki/Liste_over_Norges_eldste_personer#Kronologisk_liste_over_eldste_levende_personer_i_Norge_siden_01.01.1964).
H�yeste alder i datasetett er 141 �r. Feilaktig h�y alder kan p�virke gjennomsnittsalder i sm� strata. Velger derfor � definere 
alder som ugyldig n�r oppgitt alder er h�yere enn eldste person registret i Norge p� dette tidspunktet.

Satte opprinnelig et krav om at personene m�tte v�re bosatt i Norge, ettersom det er her vi har tall for eldste n�levende personer.
Dette inneb�rer imidlertid at mange opphold for personer bosatt i utlandet med alder over 110 �r, og en s�rlig opphopning rundt 
�rstallet 1899 (som muligens er feilkoding av 1999 eller missing-verdi).Velger derfor ogs� � nullstille alder for utenlandske borgere etter 
samme regel som for norske.
*/

if aar in (2013,2014,2015,2016,2017) and fodselsar < 1904 then fodselsar=9999;
if aar=2013 and fodselsar >2013 then fodselsar=9999;
if aar=2014 and fodselsar >2014 then fodselsar=9999;
if aar=2015 and fodselsar >2015 then fodselsar=9999;
if aar=2016 and fodselsar >2016 then fodselsar=9999;
if aar=2017 and fodselsar >2017 then fodselsar=9999;

%if &avtspes ne 0 %then %do;
*fodselsar_innrapp=fodselsar;

if fodselsar=9999 then fodselsar=fodselsAar_ident19062018;
if fodselsAar_ident19062018 < 1904 and fodselsAar_ident19062018 ne . then fodselsar=9999;

if utdato lt MDY (1,1,2013) then utdato = .;
if utdato ge MDY (1,1,2018) then utdato = .;
* Det er fremdeles noen feil i utdato da pasienter som har v�rt hos avtalespesialist ett er registrer med utdato �ret etter. 
%end;

/*!
- Definerer Alder, ald_gr og Ald_gr5
*/

/*Definerer Alder basert p� Fodsels�r*/
Alder=aar-fodselsar;
if fodselsar=9999 then alder=.; /*Ugyldig*/

/*!
- Omkoding av KJONN til ErMann 	
*/
if KJONN=1 /*1 ='Mann' */ then ErMann=1; /* Mann */
else if KJONN=2 /*2 ='Kvinne' */ then ErMann=0; /* Kvinne */
else if KJONN in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ErMann=.;
*drop KJONN; /*Kontrollert ok*/;

%if &avtspes ne 0 %then %do;
If kjonn not in (1,2) and kjonn_ident19062018 in (1,2) then do;
	if kjonn_ident19062018 = 1 then ErMann = 1;
	else if kjonn_ident19062018 = 2 then ErMann = 0;
end;

ulikt_kjonn=.;
if kjonn=1 and kjonn_ident19062018=2 then ulikt_kjonn=1;
if kjonn=2 and kjonn_ident19062018=1 then ulikt_kjonn=1;
%end;

/*!
- hastegrad og DRGtypeHastegrad (kun for somatikk)
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

