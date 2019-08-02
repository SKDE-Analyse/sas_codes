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

fodselsar_innrapp=fodselsar;
fodt_mnd_org=fodt_mnd;

/* JS 17/07/2019- If year and month from persondata is available and valid, then use it as primary source */
/*10Jul2019 JS - bruker Persondata når fodselsar er ugyldig for alt, ikke bare avtspes*/
tmp_alder=aar-fodtAar_DSF_190619;
if fodtAar_DSF_190619 > 1900 and 0 <= tmp_alder <= 110 then 
do;
  fodselsar=fodtAar_DSF_190619;
  if  1 <= fodtMnd_DSF_190619 <= 12
  then fodt_mnd=fodtMnd_DSF_190619;
end;

/* if fødselsår is still invalid */
if fodselsar > aar or fodselsar=. then fodselsar=9999;
if aar-fodselsar > 110 then fodselsar=9999;


if utdato lt MDY (1,1,2014) then utdato = .;
if utdato ge MDY (1,1,2019) then utdato = .;

/*!
- Definerer Alder basert på Fodselsår
*/

Alder=aar-fodselsar;
if fodselsar=9999 then alder=.; /*Ugyldig*/

drop tmp_alder;
/*!
- Omkoding av KJONN til ErMann
*/
if KJONN=1 /*1 ='Mann' */ then ErMann=1; /* Mann */
else if KJONN=2 /*2 ='Kvinne' */ then ErMann=0; /* Kvinne */
else if KJONN in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ErMann=.;

%if &avtspes ne 0 %then %do;

If kjonn not in (1,2) and kjonn_DSF_190619 in (1,2) then do;
	if kjonn_DSF_190619 = 1 then ErMann = 1;
	else if kjonn_DSF_190619 = 2 then ErMann = 0;
end;

ulikt_kjonn=.;
if kjonn=1 and kjonn_DSF_190619=2 then ulikt_kjonn=1;
if kjonn=2 and kjonn_DSF_190619=1 then ulikt_kjonn=1;

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

/*
************************************************************************************************
3.7	FAG_SKDE
************************************************************************************************
/*!
- Lager ny harmonisert variabel fra FAG og Fag_navn (gjelder kun avtalespesialister). 
*/

if aar in (2013:2014) then do;

/***	2013 og 2014		***/

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

end;

/***	2015, 2016 og 2017	***/

if aar in  (2015:2017) then do;

if Fag_navn = "anestesi" then Fag_SKDE = 1;
if Fag_navn = "barn" then Fag_SKDE = 2;
if Fag_navn = "fys med" then Fag_SKDE = 3;
if Fag_navn = "gyn" then Fag_SKDE = 4;
if Fag_navn = "hud" then Fag_SKDE = 5;
if substr(Fag_navn,1,5)= 'indre' then Fag_SKDE = 6;
if substr(Fag_navn,1,3)= 'kir' then Fag_SKDE = 11;
if Fag_navn = "nevrologi" then Fag_SKDE = 15;
if Fag_navn = "ortopedi" then Fag_SKDE = 16;
if Fag_navn = "plastkir" then Fag_SKDE = 17;
if Fag_navn = "radiologi" then Fag_SKDE = 18;
if Fag_navn = "revma" then Fag_SKDE = 19;
if Fag_navn = "urologi" then Fag_SKDE = 20;
if Fag_navn = "ønh" then Fag_SKDE = 21;
if Fag_navn = "øye" then Fag_SKDE = 22;
if Fag_navn = "onkologi" then Fag_SKDE = 23;
if Fag_navn = "psykiatri" then Fag_SKDE = 30;
if Fag_navn = "psykologi" then Fag_SKDE = 31;

end;

if Fag_SKDE=. then do;
if institusjonID=113166 then FAG_SKDE=11; /* Morten Andersen - 'Kirurgi, urologi' */
if institusjonID=113255 then FAG_SKDE=11; /* Einar Christiansen - 'Kirurgi, urologi' */ 
if institusjonID=113284 then FAG_SKDE=21; /* Sverre Dølvik - 'ØNH' */
if institusjonID=113342 then FAG_SKDE=11; /* Øyvind Gallefoss - 'Kirurgi, ortopedi' */ 
if institusjonID=113381 then FAG_SKDE=11; /* Arve Gustavsen - 'Kirurgi, urologi' */
if institusjonID=113507 then FAG_SKDE=11; /* Trygve Kase - 'Kirurgi, ortopedi' */ 
if institusjonID=113660 then FAG_SKDE=21; /* Stein Helge Glad Nordahl - 'ØNH' */ 
if institusjonID=113756 then FAG_SKDE=22; /* David Simonsen - 'Øye' */
if institusjonID=113805 then FAG_SKDE=21; /* Michael Strand - 'ØNH' */
end;

tell_Normaltariff = tell_takst;
AvtSpes=1;
drop tell_takst;
%end;


run;

%mend;
