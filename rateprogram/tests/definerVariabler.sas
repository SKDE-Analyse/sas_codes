/*
Definere variabler
*/


%macro definerVariabler;

%global Ratefil RV_variabelnavn ratevariabel forbruksmal innbyggerfil aarsvarfigur aarsobs NorgeSoyle KIfigur Mine_boomraader vis_ekskludering;
%global kommune Fig_AA_kom Fig_KI_kom kommune_HN Fig_AA_komHN Fig_KI_komHN fylke Fig_AA_fylke Fig_KI_fylke sykehus_HN Fig_AA_ShHN Fig_KI_ShHN;
%global HF Fig_AA_HF Fig_KI_HF RHF Fig_AA_RHF Fig_KI_RHF Oslo Fig_AA_Oslo Fig_KI_Oslo Verstkommune_HN;
%global bildeformat lagring hoyde bredde skala;
%global Vis_Tabeller TallFormat kart rateformat Ut_sett;
%global Start�r Slutt�r aar aldersspenn Alderskategorier aldjust standard kjonn rate_pr boomraade boomraadeN SnittOmraade;


/******  DATAGRUNNLAG  ****************************************************************/
%let Ratefil=skde_kur.ratetest_11_15;
%let RV_variabelnavn=poli; /*navn p� ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = Poliklinikk; /*Brukes til � lage "pene" overskrifter*/
%Let forbruksmal = Konsultasjoner; /*Brukes til � lage tabell-overskrift i �rsvarfig, gir ogs� navn til 'ut'-datasett*/
%Let innbyggerfil=Innbygg.innb_2004_2015_bydel_allebyer;

/******  HVA �NSKER DU � F� UT?  **************************************************************/
%let aarsvarfigur=0; /* �nsker du �rsvariasjonsfigurer og/eller Konfidensintervallfigurer? */
%let aarsobs=1;/* dersom du �nsker �rsobservasjonene med i figur - dersom ikke m� denne st� tom */
%let NorgeSoyle=1; /* dersom du �nsker Norge som s�yle i figur - dersom ikke m� det st� =0 */
%let KIfigur=;
%let Mine_boomraader=; /* Utvalgte omr�der til figurer - eks: komnr in (1900:1930) eller bydel in (1:15)*/ 
%let vis_ekskludering=; /* Vis tabeller for ekskludering*/
/* Hvilke boniv�er �nskes? ja eller nei, hvor 1 betyr ja */
%let kommune=; 	    /*Bildefiler*/ %let Fig_AA_kom=; 	%let Fig_KI_kom=;
%let kommune_HN=1; 	/*Bildefiler*/ %let Fig_AA_komHN=; 	%let Fig_KI_komHN=;
%let fylke=1; 		/*Bildefiler*/ %let Fig_AA_fylke=; 	%let Fig_KI_fylke=;
%let sykehus_HN=1; 	/*Bildefiler*/ %let Fig_AA_ShHN=; 	%let Fig_KI_ShHN=;
%let HF=1; 			/*Bildefiler*/ %let Fig_AA_HF=; 	%let Fig_KI_HF=;
%let RHF=1; 		/*Bildefiler*/ %let Fig_AA_RHF=; 	%let Fig_KI_RHF=;
%let Oslo=1; 		/*Bildefiler*/ %let Fig_AA_Oslo=; 	%let Fig_KI_Oslo=;
%let Verstkommune_HN=; /* AHS aug 2017: Mulig at VK ikke fungerer? */
/* Dersom du skal ha bilde-filer */
%let bildeformat=png; /*Format*/
%let lagring="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Data\SAS\Bildefiler"; /*Hvor skal filene lagres*/
%let hoyde=8.0cm; %let bredde=11.0cm; /*H�yde (8) og Bredde (11) p� bildefilene, gjelder kun bilde-filer*/
%let skala=; /* Skala p� x-aksen p� figurene - eks: values=(0 to 0.8 by 0.2) */

/* Hvilke tabeller �nsker du? */
%Let Vis_Tabeller=; /*1=Enkel tabell, 2=Enkel + CV og SCV, 3=Enkel + CV og SCV + Ujusterte rater og KI*/
%Let TallFormat=; /*Tallformat i tabeller: NLnum=tusenskilletegn, Excel=klart til excel */
/* Vil du ha kart? */
%let kart=; /* ja eller nei */

%let rateformat=2; /*Antall desimaler p� rate: 0,1 eller 2*/

%let Ut_sett=; /*Utdata, dersom du �nsker stor tabell med KI osv., --> Ut_sett=1 */


/******  PERIODE OG ALDER  **************************************************************/
%let Start�r=2011;
%let Slutt�r=2015;
%Let aar=2013; /* Standardiserings�r defineres her*/
%Let aldersspenn=in (0:105); /*Definerer det aktuelle aldersspennet: (0:105) --> 0 til 105 �r*/
%Let Alderskategorier=30; /*20, 21, 30, 31, 40, 41, 50, 51 eller 99
							20=2-delt med alle aldre, 21=2-delt KUN med aldre med RV
							30 3-delt med alle aldre, 31=3-delt KUN med aldre med RV
							40=4-delt med alle aldre, 41=4-delt KUN med aldre med RV
							50 5-delt med alle aldre, 51=5-delt KUN med aldre med RV
							99=Egendefinert(99) */
%macro Alderkat; /*M� fylles inn dersom egendefinert alderskategorier*/
if 0<=alder<=14 then alder_ny=1; 
else if 15<=alder<=49 then alder_ny=2;
else if 50<=alder<=64 then alder_ny=3;
else if 65<=alder<=79 then alder_ny=4;
else if 80<=alder then alder_ny=5;
%mend;

/******  JUSTERING  ********************************************************************/
%Let aldjust=/*=Ermann=1*/; /*Aktiveres KUN dersom KUN aldersjustering*/
%Let standard = Kj�nns- og aldersstandardiserte; /*Brukes til � lage figur og tabell-overskrifter */
%Let kjonn=(0,1); /*Dersom b�de menn og kvinner (0,1), dersom kun menn (1), dersom kun kvinner (0)*/
%Let rate_pr=1000; /*Definerer rate pr 1.000 eller 100.000 innbyggere eller osv */
%Let boomraade=BoRHF in (1:4); /*Definerer Boomr�der det skal beregnes rater for utfra BoRHF - her kan man velge andre kriterier, feks BoHF, komnr osv*/
%Let boomraadeN=BoRHF in (1:4); /*Definerer Boomr�der som det beregnes "nasjonale" andeler utfra BoRHF - her kan man velge andre kriterier, feks BoHF, komnr osv*/
%let SnittOmraade=Norge; /*Definerer Snittlinja p� figurene - m� v�re samsvar med boomraade ovenfor*/

%mend;
