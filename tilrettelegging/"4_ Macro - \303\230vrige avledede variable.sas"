
/***********************************************************************************************
************************************************************************************************
MACRO FOR AVLEDEDE VARIABLE

Innhold i macroen:
	4.1 Retting av ugyldig fødselsår og avleding av aldersgrupper
	4.2 Definisjon av Alder, Ald_gr og Ald_gr5
	4.3 Omkoding av KJONN til ErMann 
	4.4 Omkoding av utgåtte organisasjonsnummer
	4.5 DRGTypeHastegrad



3.	Formater og labels
	3.1	Legger på formater
	3.2	Legger på labels

4.  Splitting på år
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

if aar=2011 and fodselsar < 1901 then fodselsar=9999;
if aar=2012 and fodselsar < 1902 then fodselsar=9999;
if aar in (2013,2014,2015) and fodselsar < 1904 then fodselsar=9999;


/*
4.2 Definerer Alder, ald_gr og Ald_gr5
**************************************************
*/
/*Definerer Alder basert på Fodselsår*/
Alder=aar-fodselsar;
if fodselsar=9999 then alder=.; /*Ugyldig*/

/*Definerer variabel for aldersgrupper tilsvarende Ald_gr5 definert i Fantomet*/;
if 0 <= Alder <=14 then Ald_gr5=1;
if 15 <= Alder <= 49 then Ald_gr5=2;
if 50 <= Alder <= 64 then Ald_gr5=3;
if 65 <= Alder <= 79 then Ald_gr5=4;
if Alder > 79 then Ald_gr5=5;

/*Definerer variabel for aldersgrupper tilsvarende Ald_gr definert i Fantomet*/
if Alder=0 then ald_gr=1;
if Alder=1 then ald_gr=2;
if Alder=2 then ald_gr=3;
if Alder=3 then ald_gr=4;
if Alder=4 then ald_gr=5;
if Alder=5 then ald_gr=6;
if 6 <= Alder <= 9 then ald_gr=7;
if 10 <= Alder <= 14 then ald_gr=8;
if 15 <= Alder <= 19 then ald_gr=9;
if 20 <= Alder <= 24 then ald_gr=10;
if 25 <= Alder <= 29 then ald_gr=11;
if 30 <= Alder <= 34 then ald_gr=12;
if 35 <= Alder <= 39 then ald_gr=13;
if 40 <= Alder <= 44 then ald_gr=14;
if 45 <= Alder <= 49 then ald_gr=15;
if 50 <= Alder <= 54 then ald_gr=16;
if 55 <= Alder <= 59 then ald_gr=17;
if 60 <= Alder <= 64 then ald_gr=18;
if 65 <= Alder <= 69 then ald_gr=19;
if 70 <= Alder <= 74 then ald_gr=20;
if 75 <= Alder <= 79 then ald_gr=21;
if 80 <= Alder <= 84 then ald_gr=22;
if 85 <= Alder <= 89 then ald_gr=23;
if Alder > 89 then ald_gr=24;


/*
**************************************************
4.3 Omkoding av KJONN til ErMann 	
**************************************************
*/
if KJONN=1 /*1 ='Mann' */ then ErMann=1;
else if KJONN=2 /*2 ='Kvinne' */ then ErMann=0;
else if KJONN in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ErMann=.;
*drop KJONN; /*Kontrollert ok*/;


/**************************************************
4.4 Omkoding av utgåtte organisasjonsnummer - Slette dette fra 2016-data hvis variabelen ikke brukes i det hele tall 
**************************************************
Koder om utgåtte organisasjonsnummer til nåværende organisasjonsnr.*/

InstitusjonId_omkodet=InstitusjonId;
if InstitusjonId=979230281 /*'Aleris Bergen OLD'*/ then InstitusjonId_omkodet=879790522	 /*'Aleris Bergen'*/;
else if InstitusjonId=979177445	/*'Aleris Tromsø OLD'*/ then InstitusjonId_omkodet=993240184 /*'Aleris Tromsø'*/;
else if InstitusjonId=874435252	/*'Aleris Trondheim OLD'*/ then InstitusjonId_omkodet=974504863	/*'Aleris Trondheim'*/;
else if InstitusjonId=981113950	/*'Feiring OLD'*/ then InstitusjonId_omkodet=973144383 /*'Feiringklinikken'*/;
else if InstitusjonId=959549087	/*'Glittreklinikken OLD'*/ then InstitusjonId_omkodet=974116561	 /*'Glittreklinikken'*/;
else if InstitusjonId=974116588	/*'Martina Hansens Hospital OLD'*/ then InstitusjonId_omkodet=985962170	/*'Martina Hansens hospital'*/;
else if InstitusjonId=973254979 /*Revmatismesykehuset OLD*/ then InstitusjonId_omkodet=985773238 /*Revmatismesykehuset Lillehammer*/;
else if InstitusjonId=981028848 /*SØRLANDSPARKEN SPESIALISTSENTER AS med organisasjonsnummer 981 028 848 ble slettet 02.06.2012*/ then InstitusjonId_omkodet=981096363/*TERES SØRLANDSPARKEN*/;
else if InstitusjonId=982746868 /*KLINIKK STOKKAN AS med organisasjonsnummer 982 746 868 ble slettet 02.06.2012*/ then InstitusjonId_omkodet=982755999 /*'Klinikk Stokkan AS' */;
else if InstitusjonId=982838339 /*TROMSØ PRIVATE SYKEHUS AS med organisasjonsnummer 982 838 339 ble slettet 02.06.2012*/ then InstitusjonId_omkodet=983084478 /*'Tromsø private sykehus AS*/;  
else if InstitusjonId=983887473 /*Colosseum klinikken Stavanger AS' /*COLOSSEUMKLINIKKEN STAVANGER AS med organisasjonsnummer 983 887 473 ble slettet 02.06.2012*/ then InstitusjonId_omkodet=983896383 /*Colosseumklinikken Stavanger AS*/;
else if InstitusjonId=992133732 /*TERES KLINIKKEN BODØ AS med organisasjonsnummer 992 133 732 ble slettet 02.06.2012*/ then InstitusjonId_omkodet=995818728 /*TERES KLINIKKEN BODØ*/;


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

