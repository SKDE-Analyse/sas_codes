/*!
Felles makroer for testing av rateprogrammet. Kan også brukes til produksjon av test-datasett.
*/

%macro inkluderFormater;

%include "&filbane\formater\SKDE_somatikk.sas";
%include "&filbane\formater\NPR_somatikk.sas";
%include "&filbane\formater\bo.sas";
%include "&filbane\formater\beh.sas";
%include "&filbane\formater\komnr.sas";

%mend;


%macro testAnno(branch=master, lagReferanse = 0, slettDatasett = 1);

/*!
Makro for å teste kode i ../Stiler/ (logo)
*/

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch;

ods text="Test Anno";

%include "&filbane\Stiler\stil_figur.sas";
%include "&filbane\Stiler\Anno_logo_kilde_NPR_SSB.sas";

%if &lagReferanse = 0 %then %do;
proc compare base=skde_arn.ref_rate_anno compare=anno BRIEF WARNING LISTVAR;
%end;
%else %do;
data skde_arn.ref_rate_anno;
set anno;
run;
%end;

%if &slettDatasett ne 0 %then %do;
proc datasets nolist;
delete anno;
%end;


%mend;


%macro testUtvalgX(branch=master, alene = 1, lagReferanse = 0, definerVariabler = 1, slettDatasett = 1);

/*!
Makro for å teste utvalgx-makroen i rateprogrammet.
*/

ods text="Test UtvalgX";


%if (&alene NE 0) %then %do;
data anno;
set skde_arn.ref_rate_anno;
run;
%end;

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch;

%include "&filbane\makroer\boomraader.sas";
%include "&filbane\rateprogram\rateberegninger.sas";

%inkluderFormater;

%if &definerVariabler ne 0 %then %do;
%include "&filbane\rateprogram\sas\definerVariabler.sas";
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

%if &slettDatasett ne 0 %then %do;
proc datasets nolist;
delete rv andel anno;
%end;


%mend;


%macro testRateberegninger(branch=master, alene = 1, lagReferanse = 0, definerVariabler = 1, slettDatasett = 1);

/*!
Makro for å teste rateberegning-makroen (rateprogrammet)
*/

ods text="Test Rateberegninger";

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
%let filbane=\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch;

%include "&filbane\makroer\boomraader.sas";
%include "&filbane\rateprogram\rateberegninger.sas";

%inkluderFormater;

%if &definerVariabler ne 0 %then %do;
%include "&filbane\rateprogram\sas\definerVariabler.sas";
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

%if &slettDatasett ne 0 %then %do;
proc datasets nolist;
delete rv: andel anno Norge: BoRHF: bohf: BoShHN: komnr: komnrHN: fylke: bydel: alder konsultasjoner_norge;
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
