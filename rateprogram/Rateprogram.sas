/*Options symbolgen mlogic mprint;*/

%include "\\tos-sastest-07\SKDE\rateprogram\master\Boomraader.sas";
%include "\\tos-sastest-07\SKDE\rateprogram\master\BoFormat.sas";
%include "\\tos-sastest-07\SKDE\rateprogram\develop\rateberegninger.sas";

/******  DATAGRUNNLAG  ****************************************************************/
%let Ratefil=skde_kur.ratetest09_17;;
%let RV_variabelnavn=ablasjon; /*navn p� ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = ablasjon ved hjertearytmi; /*Brukes til � lage "pene" overskrifter*/
%Let forbruksmal = Inngrep; /*Brukes til � lage tabell-overskrift i �rsvarfig, gir ogs� navn til 'ut'-datasett*/
%Let innbyggerfil=Innbygg.innb_2003_2015_bydel;

/******  HVA �NSKER DU � F� UT?  **************************************************************/
/* �nsker du �rsvariasjonsfigurer og/eller Konfidensintervallfigurer? */
%let aarsvarfigur=1;
%let KIfigur=; 
/* Hvilke boniv�er �nskes? ja eller nei, hvor 1 betyr ja */
%let kommune=; 		/*Bildefiler*/ %let Fig_AA_kom=; 	%let Fig_KI_kom=;
%let kommune_HN=; 	/*Bildefiler*/ %let Fig_AA_komHN=; 	%let Fig_KI_komHN=;
%let fylke=; 		/*Bildefiler*/ %let Fig_AA_fylke=; 	%let Fig_KI_fylke=;
%let sykehus_HN=; 	/*Bildefiler*/ %let Fig_AA_ShHN=; 	%let Fig_KI_ShHN=;
%let HF=1; 			/*Bildefiler*/ %let Fig_AA_HF=; 	%let Fig_KI_HF=;
%let RHF=; 			/*Bildefiler*/ %let Fig_AA_RHF=; 	%let Fig_KI_RHF=;
%let Oslo=; 		/*Bildefiler*/ %let Fig_AA_Oslo=; 	%let Fig_KI_Oslo=;
%let Verstkommune_HN=;
/* Dersom du skal ha bilde-filer */
%let bildeformat=jpeg; /*Format*/
%let lagring="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\Dataverktoy\SAS\Bildefiler"; /*Hvor skal filene lagres*/
%let hoyde=8.0cm; %let bredde=11.0cm; /*H�yde (8) og Bredde (11) p� bildefilene*/

/* Hvilke tabeller �nsker du? */
%Let Vis_Tabeller=1; /*1=Enkel tabell, 2=Enkel + CV og SCV, 3=Enkel + CV og SCV + Ujusterte rater og KI*/
%Let TallFormat=NLnum; /*Tallformat i tabeller: NLnum=tusenskilletegn, Excel=klart til excel */
/* Vil du ha kart? */
%let kart=; /* ja eller nei */

%let aarsobs=1;/* dersom du �nsker �rsobservasjonene med i figur - dersom ikke m� denne st� tom */
%let rateformat=2; /*Antall desimaler p� rate: 0,1 eller 2*/

%let Ut_sett=; /*Utdata, dersom du �nsker stor tabell med KI osv., --> Ut_sett=1 */

/******  PERIODE OG ALDER  **************************************************************/
%Let Periode=(2011:2015); /* Periode, dvs aktuelle �r m� defineres her*/
%Let aar=2013; /* Standardiserings�r defineres her*/
%Let �r1=2011; %Let �r2=2012; %Let �r3=2013; %Let �r4=2014; %Let �r5=2015;
%Let Antall_aar=6; /*Antall �r+1 - KUN dersom du �nsker kart */
%Let aldersspenn=in (0:105); /*Definerer det aktuelle aldersspennet: (0:105) --> 0 til 105 �r*/
%Let Alderskategorier=41; /*40, 41, 50, 51 eller 99
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
%Let aldjust/*=Ermann=1*/; /*Aktiveres KUN dersom KUN aldersjustering*/
%Let standard = Kj�nns- og aldersstandardiserte; /*Brukes til � lage figur og tabell-overskrifter */
%Let kjonn=(0,1); /*Dersom b�de menn og kvinner (0,1), dersom kun menn (1), dersom kun kvinner (0)*/
%Let rate_pr=1000; /*Definerer rate pr 1.000 eller 100.000 innbyggere eller osv */
%Let boomraade=BoRHF in (1,2,3,4); /*Definerer Boomr�de det skal beregnes rater for utfra BoRHF - her kan man velge andre kriterier, feks BoHF, komnr osv*/
%Let boomraadeN=BoRHF in (1:4); /*Definerer Boomr�de som det beregnes "nasjonale" andeler utfra BoRHF - her kan man velge andre kriterier, feks BoHF, komnr osv*/

/******  DU ER FERDIG  *******************************************************************/

/******************************************************************************************/
%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd anno;
run;
