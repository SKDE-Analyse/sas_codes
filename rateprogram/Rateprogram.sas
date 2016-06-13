/*Options symbolgen mlogic mprint;*/

%include "\\tos-sastest-07\SKDE\rateprogram\master\Boomraader.sas";
%include "\\tos-sastest-07\SKDE\rateprogram\master\BoFormat.sas";
%include "\\tos-sastest-07\SKDE\rateprogram\develop\rateberegninger.sas";

/******  DATAGRUNNLAG  ****************************************************************/
%let Ratefil=skde_kur.ratetest09_17;;
%let RV_variabelnavn=ablasjon; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = ablasjon ved hjertearytmi; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = Inngrep; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/
%Let innbyggerfil=Innbygg.innb_2003_2015_bydel;

/******  HVA ØNSKER DU Å FÅ UT?  **************************************************************/
/* Ønsker du Årsvariasjonsfigurer og/eller Konfidensintervallfigurer? */
%let aarsobs=1;/* dersom du ønsker årsobservasjonene med i figur - dersom ikke må denne stå tom */
%let KIfigur=1;
%let Mine_boomraader=; /* Utvalgte områder til figurer - eks: komnr in (1900:1930) eller bydel in (1:15)*/ 
/* Hvilke bonivåer ønskes? ja eller nei, hvor 1 betyr ja */
%let kommune=; 		/*Bildefiler*/ %let Fig_AA_kom=; 	%let Fig_KI_kom=;
%let kommune_HN=; 	/*Bildefiler*/ %let Fig_AA_komHN=; 	%let Fig_KI_komHN=;
%let fylke=; 		/*Bildefiler*/ %let Fig_AA_fylke=; 	%let Fig_KI_fylke=;
%let sykehus_HN=; 	/*Bildefiler*/ %let Fig_AA_ShHN=; 	%let Fig_KI_ShHN=;
%let HF=1; 			/*Bildefiler*/ %let Fig_AA_HF=; 	%let Fig_KI_HF=;
%let RHF=; 			/*Bildefiler*/ %let Fig_AA_RHF=; 	%let Fig_KI_RHF=;
%let Oslo=; 		/*Bildefiler*/ %let Fig_AA_Oslo=; 	%let Fig_KI_Oslo=;
%let Verstkommune_HN=;
/* Dersom du skal ha bilde-filer */
%let bildeformat=png; /*Format*/
%let lagring="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Dataverktoy\SAS\Bildefiler"; /*Hvor skal filene lagres*/
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
%let StartÅr=2011;
%let SluttÅr=2015;
%Let aar=2013; /* Standardiseringsår defineres her*/
%Let aldersspenn=in (0:105); /*Definerer det aktuelle aldersspennet: (0:105) --> 0 til 105 år*/
%Let Alderskategorier=41; /*40, 41, 50, 51 eller 99
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
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd anno;
run;
