/*!
Denne filen inneholder et eksempel på hvordan man kjører rateprogrammet, med en beskrivelse av de ulike variablene
man kan bruke. Filen skal være kjørbar som et *sas*-program slik den er.

Den kan også fungere som en test av rateprogrammet. Kjøres slik:
```
%include "&filbane\rateprogram\Rateprogram.sas";
```
*/
options sasautos=("&filbane\makroer" SASAUTOS);

%include "&filbane\formater\SKDE_somatikk.sas";
%include "&filbane\formater\NPR_somatikk.sas";
%include "&filbane\formater\bo.sas";
%include "&filbane\formater\beh.sas";
%include "&filbane\formater\komnr.sas";

%include "&filbane\rateprogram\rateberegninger.sas";

%include "&filbane\stiler\stil_figur.sas";
%include "&filbane\stiler\Anno_logo_kilde_NPR_SSB.sas";

/******  DATAGRUNNLAG  ****************************************************************/
%let Ratefil=skde_kur.ratetest_11_15;
%let RV_variabelnavn=poli; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = Poliklinikk; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = Konsultasjoner; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/
%Let innbyggerfil=Innbygg.innb_2004_2017_bydel_allebyer;
%let manglerKomnr = 0; /* Hvis ulik 0 -> definere komnr og bydel basert på bohf (brukes hvis komnr mangler i datasettet)*/
%let aldersfigur = 1; /* Settes til null hvis man ikke vil ha ut aldersdistribusjonen i utvalget */
%let haraldsplass = 0; /* Settes til ulik null hvis man vil dele Bergen i Haukland og Haraldsplass */
%let indreOslo = 0; /* Settes til ulik null hvis man vil slå sammen Lovisenberg og diakonhjemmet */
%let bydel = 1; /* Settes til null hvis man ikke har bydel i datasettet */
%let barn = 0; /* Settes til ulik null hvis man vil ha opptaksområdestruktur som i barnehelseatlaset */

/******  HVA ØNSKER DU Å FÅ UT?  **************************************************************/
%let aarsvarfigur=1; /* Ønsker du Årsvariasjonsfigurer og/eller Konfidensintervallfigurer? */
%let aarsobs=1;/* dersom du ønsker årsobservasjonene med i figur - dersom ikke må denne stå tom */
%let NorgeSoyle=1; /* dersom du ønsker Norge som søyle i figur - dersom ikke må det stå =0 */
%let KIfigur=;
%let Mine_boomraader=; /* Utvalgte områder til figurer - eks: komnr in (1900:1930) eller bydel in (1:15)*/ 
%let vis_ekskludering=1; /* Vis tabeller for ekskludering*/
/* Hvilke bonivåer ønskes? ja eller nei, hvor 1 betyr ja */
%let kommune=; 		/*Bildefiler*/ %let Fig_AA_kom=; 	%let Fig_KI_kom=;
%let kommune_HN=1; 	/*Bildefiler*/ %let Fig_AA_komHN=; 	%let Fig_KI_komHN=;
%let fylke=1; 		/*Bildefiler*/ %let Fig_AA_fylke=; 	%let Fig_KI_fylke=;
%let sykehus_HN=1; 	/*Bildefiler*/ %let Fig_AA_ShHN=; 	%let Fig_KI_ShHN=;
%let HF=1; 			/*Bildefiler*/ %let Fig_AA_HF=; 	%let Fig_KI_HF=;
%let RHF=1;			/*Bildefiler*/ %let Fig_AA_RHF=; 	%let Fig_KI_RHF=;
%let Oslo=; 		/*Bildefiler*/ %let Fig_AA_Oslo=; 	%let Fig_KI_Oslo=;
%let Vertskommune_HN=;
/* Dersom du skal ha bilde-filer */
%let bildeformat=png; /*Format*/
%let lagring="\\hn.helsenord.no\RHF\SKDE\Analyse\Data\SAS\Bildefiler"; /*Hvor skal filene lagres*/
%let hoyde=8.0cm; %let bredde=11.0cm; /*Høyde (8) og Bredde (11) på bildefilene, gjelder kun bilde-filer*/
%let skala=; /* Skala på x-aksen på figurene - eks: values=(0 to 0.8 by 0.2) */

/* Hvilke tabeller ønsker du? */
%Let Vis_Tabeller=1; /*1=Enkel tabell, 2=Enkel + CV og SCV, 3=Enkel + CV og SCV + Ujusterte rater og KI*/
%Let TallFormat=NLnum; /*Tallformat i tabeller: NLnum=tusenskilletegn, Excel=klart til excel */
/* Vil du ha kart? */
%let kart=; /* ja eller nei */

%let rateformat=2; /*Antall desimaler på rate: 0,1 eller 2*/

%let Ut_sett=; /*Utdata, dersom du ønsker stor tabell med KI osv., --> Ut_sett=1 */

/******  PERIODE OG ALDER  **************************************************************/
%let StartÅr=2012;
%let SluttÅr=2015;
%Let aar=2015; /* Standardiseringsår defineres her*/
%Let aldersspenn=in (0:105); /*Definerer det aktuelle aldersspennet: (0:105) --> 0 til 105 år*/
%Let Alderskategorier=30; /*20, 21, 30, 31, 40, 41, 50, 51 eller 99
							20=2-delt med alle aldre, 21=2-delt KUN med aldre med RV
							30 3-delt med alle aldre, 31=3-delt KUN med aldre med RV
							40=4-delt med alle aldre, 41=4-delt KUN med aldre med RV
							50 5-delt med alle aldre, 51=5-delt KUN med aldre med RV
							99=Egendefinert(99) */
%macro Alderkat; /*Må fylles inn dersom egendefinert alderskategorier*/
if 0<=alder<=14 then alder_ny=1; 
else if 15<=alder<=49 then alder_ny=2;
else if 50<=alder<=64 then alder_ny=3;
else if 65<=alder<=79 then alder_ny=4;
else if 80<=alder then alder_ny=5;
%mend;

/******  JUSTERING  ********************************************************************/
%Let aldjust/*=Ermann=1*/; /*Aktiveres KUN dersom KUN aldersjustering*/
%Let standard = Kjønns- og aldersstandardiserte; /*Brukes til å lage figur og tabell-overskrifter */
%Let kjonn=(0,1); /*Dersom både menn og kvinner (0,1), dersom kun menn (1), dersom kun kvinner (0)*/
%Let rate_pr=1000; /*Definerer rate pr 1.000 eller 100.000 innbyggere eller osv */
%Let boomraade=BoRHF in (1:4); /*Definerer Boområder det skal beregnes rater for utfra BoRHF - her kan man velge andre kriterier, feks BoHF, komnr osv*/
%Let boomraadeN=BoRHF in (1:4); /*Definerer Boområder som det beregnes "nasjonale" andeler utfra BoRHF - her kan man velge andre kriterier, feks BoHF, komnr osv*/
%let SnittOmraade=Norge; /*Definerer Snittlinja på figurene - må være samsvar med boomraade ovenfor*/

/******  DU ER FERDIG  *******************************************************************/

/******************************************************************************************/
%utvalgx;

%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd;
run;

/*
Teste resultatene mot tidligere resultater
*/

proc compare base=skde_arn.test_rateprg_bohf compare=konsultasjoner_bohf BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=skde_arn.test_rateprg_norge compare=konsultasjoner_norge BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=skde_arn.test_rateprg_borhf compare=konsultasjoner_borhf BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=skde_arn.test_rateprg_boshhn compare=konsultasjoner_boshhn BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=skde_arn.test_rateprg_komnr compare=konsultasjoner_komnr BRIEF WARNING LISTVAR METHOD=ABSOLUTE;
proc compare base=skde_arn.test_rateprg_fylke compare=konsultasjoner_fylke BRIEF WARNING LISTVAR METHOD=ABSOLUTE;

