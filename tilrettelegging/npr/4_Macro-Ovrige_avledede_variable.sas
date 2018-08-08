%Macro Avledede (innDataSett=, utDataSett=);


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

/*
I datasettet er det registrert 27 personer over 110 år, som er høyeste oppnådde alder for bosatte i Norge i denne perioden, jfr.
Wikipedias kronologiske liste over eldste levende personer i Norge siden 1964 (http:
//no.wikipedia.org/wiki/Liste_over_Norges_eldste_personer#Kronologisk_liste_over_eldste_levende_personer_i_Norge_siden_01.01.1964).
Høyeste alder i datasetett er 141 år. Feilaktig høy alder kan påvirke gjennomsnittsalder i små strata. Velger derfor å definere
alder som ugyldig når oppgitt alder er høyere enn eldste person registret i Norge på dette tidspunktet.

Satte opprinnelig et krav om at personene måtte være bosatt i Norge, ettersom det er her vi har tall for eldste nålevende personer.
Dette innebærer imidlertid at mange opphold for personer bosatt i utlandet med alder over 110 år, og en særlig opphopning rundt
årstallet 1899 (som muligens er feilkoding av 1999 eller missing-verdi).Velger derfor også å nullstille alder for utenlandske borgere etter
samme regel som for norske.
*/

if fodselsar > aar then fodselsar=9999;
if aar in (2013,2014,2015,2016,2017) and fodselsar < 1904 then fodselsar=9999;
if aar in (2018) and fodselsar < 1909 then fodselsar=9999;

%if &avtspes ne 0 %then %do;

fodselsar_innrapp=fodselsar;

if fodselsar=9999 then do;
    fodselsar=fodselsAar_ident19062018;
    if fodselsar > aar then fodselsar=9999;
    if aar in (2013,2014,2015,2016,2017) and fodselsar < 1904 then fodselsar=9999;
end;

if utdato lt MDY (1,1,2013) then utdato = .;
if utdato ge MDY (1,1,2018) then utdato = .;
/* Det er fremdeles noen feil i utdato da pasienter som har vært hos avtalespesialist ett år
er registrert med utdato året etter. */
%end;

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
- Definere `hastegrad` og `DRGtypeHastegrad` (kun for somatikk). 
Definerer `hastegrad = 4` (planlagt) for avtalespesialistkonsultasjoner.
*/

%if &somatikk ne 0 %then %do;
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
%end;

%if &avtspes ne 0 %then %do;
hastegrad=4;
%end;

run;

%mend;
