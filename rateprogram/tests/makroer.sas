/*
Felles makroer for testing og produksjon av test-datasett
*/

%macro inkluderFormater;

%include "&filbane.Formater\master\SKDE_somatikk.sas";
%include "&filbane.Formater\master\NPR_somatikk.sas";
%include "&filbane.Formater\master\bo.sas";
%include "&filbane.Formater\master\beh.sas";
%include "&filbane.Formater\master\komnr.sas";

%mend;


%macro testAnno(lagReferanse = 0);

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\;

%include "&filbane.Stiler\stil_figur.sas";
%include "&filbane.Stiler\Anno_logo_kilde_NPR_SSB.sas";

%if &lagReferanse = 0 %then %do;
proc compare base=skde_arn.ref_rate_anno compare=anno BRIEF WARNING LISTVAR;
%end;
%else %do;
data skde_arn.ref_rate_anno;
set anno;
run;
%end;


%mend;


%macro testUtvalgX(branch=master, alene = 0, lagReferanse = 0, definerVariabler = 0);

%if (&alene NE 0) %then %do;
data anno;
set skde_arn.ref_rate_anno;
run;
%end;

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\;

%include "&filbane.Makroer\master\boomraader.sas";
%include "&filbane.rateprogram\&branch\rateberegninger.sas";

%inkluderFormater;

%if &definerVariabler ne 0 %then %do;
%include "&filbane.rateprogram\&branch\tests\definerVariabler.sas";
%definerVariabler;
%end;


%utvalgx;

proc sort data=rv;
by aar komnr bydel alder ermann;
run;

proc sort data=andel;
by alderny ermann;
run;

%if &lagReferanse = 0 %then %do;
proc compare base=skde_arn.ref_rate_rv compare=rv BRIEF WARNING LISTVAR;
proc compare base=skde_arn.ref_rate_andel compare=andel BRIEF WARNING LISTVAR;
%end;
%else %do;
data skde_arn.ref_rate_rv;
set rv;
run;

data skde_arn.ref_rate_andel;
set andel;
run;
%end;

%mend;


%macro testOmraadeNorge(branch=master, alene = 0, lagReferanse = 0, definerVariabler = 0);

%if (&alene NE 0) %then %do;
data anno;
set skde_arn.ref_rate_anno;
run;

data rv;
set skde_arn.ref_rate_rv;
run;

data andel;
set skde_arn.ref_rate_andel;
run;

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\;

%include "&filbane.Makroer\master\boomraader.sas";
%include "&filbane.rateprogram\&branch\rateberegninger.sas";

%inkluderFormater;

%if &definerVariabler ne 0 %then %do;
%include "&filbane.rateprogram\&branch\tests\definerVariabler.sas";
%definerVariabler;
%end;
%end;

%omraadeNorge;


proc sort data=norge_agg;
by aar alder_ny ermann innbyggere;
run;

proc sort data=norge_agg_snitt;
by aar alder_ny ermann;
run;


%if &lagReferanse = 0 %then %do;
proc compare base=skde_arn.ref_rate_norge_agg compare=norge_agg BRIEF WARNING LISTVAR;

proc compare base=skde_arn.ref_rate_norge_agg_snitt compare=norge_agg_snitt BRIEF WARNING LISTVAR;
%end;
%else %do;
data skde_arn.ref_rate_norge_agg;
set norge_agg;
run;

data skde_arn.ref_rate_norge_agg;
set norge_agg;
run;
%end;

%mend;


%macro testRateberegninger(branch=master, alene = 0, lagReferanse = 0, definerVariabler = 0);

%if (&alene NE 0) %then %do;

/*
Lese datasett fra disk som brukes videre i rateberegninger-makroen

Det vil da være mulig å kjøre denne makroen uavhengig av om man har kjørt de makroene som kommer tidligere i rateprogrammet
*/

data anno;
set skde_arn.ref_rate_anno;
run;

data rv;
set skde_arn.ref_rate_rv;
run;

data andel;
set skde_arn.ref_rate_andel;
run;

data norge_agg;
set skde_arn.ref_rate_norge_agg;
run;

data norge_agg_snitt;
set skde_arn.ref_rate_norge_agg_snitt;
run;

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\;

%include "&filbane.Makroer\master\boomraader.sas";
%include "&filbane.rateprogram\&branch\rateberegninger.sas";

%inkluderFormater;

%if &definerVariabler ne 0 %then %do;
%include "&filbane.rateprogram\&branch\tests\definerVariabler.sas";
%definerVariabler;
%end;
%end;


%rateberegninger;


/*
Må endre navn på datasett for kun HN sine kommuner
*/
data komnrHN_agg_rate;
set komnr_agg_rate;
run;

data komnrHN_agg_cv;
set komnr_agg_cv;
run;


/*
Kjører makroen for alle kommuner, ikke kun HN
*/

%let kommune=1; 
%let kommune_HN=; 
%let fylke=; 
%let sykehus_HN=; 
%let HF=; 	
%let RHF=; 
%let Oslo=; 
%let Verstkommune_HN=;

%rateberegninger;

%if &lagReferanse = 0 %then %do;
/*
Sammenligne datasettene med referansedatasett
*/

   %sjekkeDatasett(bolist = Norge BoRHF bohf BoShHN komnr komnrHN fylke bydel);

%end;
%else %do;
/*
   Lagre det siste referansedatasettet
*/

   %lagreDatasett(bolist = Norge BoRHF bohf BoShHN komnr komnrHN fylke bydel);

%end;


%mend;

%macro lagreDatasett(bolist=);

/*
Loop over alle boomr�dene
*/

%local nwords;
%local i;
%local bo;
%local boSort;

%let nwords=%sysfunc(countw(&bolist));
%do i=1 %to &nwords;
	%let bo =  %scan(&bolist, &i);
	data skde_arn.ref_rate_&Bo._AGG_CV;
	set &Bo._AGG_CV;
	run;

	proc sort data=skde_arn.ref_rate_&Bo._Agg_cv;
	by aar boomr;
	run;

	data skde_arn.ref_rate_&Bo._Agg_rate;
	set &Bo._Agg_rate;
	run;

   %let boSort = &bo;
   %if &bo = komnrHN %then %let boSort = komnr;
   
	proc sort data=skde_arn.ref_rate_&Bo._Agg_rate;
	by aar &bosort;
	run;

%end;

%mend;

%macro sjekkeDatasett(bolist=);

/*
Loop over alle boområdene
*/

%local nwords;
%local i;
%local bo;
%local boSort;

%let nwords=%sysfunc(countw(&bolist));
%do i=1 %to &nwords;
	%let bo =  %scan(&bolist, &i);

	proc sort data=&Bo._AGG_CV;
	by aar boomr;
	run;

   proc compare base=skde_arn.ref_rate_&Bo._AGG_CV compare=&Bo._AGG_CV BRIEF WARNING LISTVAR CRITERION=0.00001;

   %let boSort = &bo;
   %if &bo = komnrHN %then %let boSort = komnr;
   
	proc sort data=&Bo._Agg_rate;
	by aar &boSort;
	run;

   proc compare base=skde_arn.ref_rate_&Bo._Agg_rate compare=&Bo._Agg_rate BRIEF WARNING LISTVAR CRITERION=0.00001;

%end;

%mend;
