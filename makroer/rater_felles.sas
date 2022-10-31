

%macro rater_felles(offentlig=1, privat = 1, kun_total = 0, kun_poli = 0, innlegg = 1, hastegrad = 1, unik = 1, Ratefil=helseatl.k_u_&agg_var._18);

%Let Alderskategorier=30;

%if &kun_poli = 0 %then %do;

/*********
 * Total *
**********/

%let RV_variabelnavn= tot; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;

 %if &unik ne 0 %then %do;
/******  tot_unik  ****************************************************************/
%let RV_variabelnavn= tot_unik; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;
%end; /* &unik ne 0 */

%end; /* kun_poli = 0 */

%if &kun_total = 0 %then %do;

/***************
 * Poliklinikk *
 ***************/

/******  poli  ****************************************************************/
%let RV_variabelnavn= poli; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;

%if &offentlig ne 0 %then %do;

/******  poli_off  ****************************************************************/
%let RV_variabelnavn= poli_off; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._off; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._off; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;

%end; /* &offentlig ne 0 */


%if &privat ne 0 %then %do;
/******  poli_priv  ****************************************************************/
%let RV_variabelnavn= poli_priv; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._priv; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._priv; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;
%end; /* &privat ne 0 */


/************
 * Personer *
 ************/
 %if &unik ne 0 %then %do;

/******  poli_unik  ****************************************************************/
%let RV_variabelnavn= poli_unik; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;

%if &kun_poli = 0 %then %do;
%if &offentlig ne 0 %then %do;

/******  off_unik  ****************************************************************/
%let RV_variabelnavn= off_unik; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;

%end; /* &offentlig ne 0 */
%end; /* &kun_poli = 0 */

%if &privat ne 0 %then %do;
/******  priv_unik  ****************************************************************/
%let RV_variabelnavn= priv_unik; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;
%end; /* &privat ne 0 */

%end; /* &unik ne 0 */

/******************
 * Akutt/planlagt *
 ******************/

%if &hastegrad ne 0 %then %do;

/******  elek  ****************************************************************/
%let RV_variabelnavn= elek; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;


/******  ohj  ****************************************************************/
%let RV_variabelnavn= ohj; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;

%end; /* hastegrad ne 0 */

/****************
 * Innleggelser *
 ****************/

%if &innlegg ne 0 %then %do;

 /******  inn  ****************************************************************/
%let RV_variabelnavn= inn; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._&RV_variabelnavn; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._&RV_variabelnavn; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;


/******  eoc_liggetid  ****************************************************************/
%let RV_variabelnavn= eoc_liggetid; /*navn på ratevariabel i det aggregerte datasettet*/
%Let ratevariabel = &agg_var._liggetid; /*Brukes til å lage "pene" overskrifter*/
%Let forbruksmal = &agg_var._liggetid; /*Brukes til å lage tabell-overskrift i Årsvarfig, gir også navn til 'ut'-datasett*/

%utvalgx;
%omraadeNorge;
%rateberegninger;

proc datasets nolist;
delete RV: Norge: figur: Andel Alder: Bo: HN: Kom: Fylke: VK: bydel: snudd ;
run;

%forholdstall;

%end; /* innlegg ne 0 */

%end; /* &kun_total = 0 */

%mend;