/*!
Felles makroer for testing av rateprogrammet. Kan også brukes til produksjon av test-datasett.
*/

%macro testAnno(branch=master, lagReferanse = 0, slettDatasett = 1);

/*!
Makro for å teste kode i ../Stiler/ (logo)
*/

ods text="Test Anno";

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch;

%include "&filbane\Stiler\stil_figur.sas";
%include "&filbane\Stiler\Anno_logo_kilde_NPR_SSB.sas";
%include "&filbane\tests\makroer.sas";

%sammenlignData(fil = anno, lagReferanse = &lagReferanse);

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

%if %sysevalf(%superq(silent)=,boolean) %then %let silent = 1;

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch;

%include "&filbane\makroer\boomraader.sas";
%include "&filbane\rateprogram\rateberegninger.sas";
%include "&filbane\tests\makroer.sas";

%inkluderFormater;

%if &definerVariabler ne 0 %then %do;
%include "&filbane\rateprogram\sas\definerVariabler.sas";
%definerVariabler;
%end;

%if (&alene ne 0) %then %do;
/* Importere datasettet "anno" fra disk, hvis anno-makroen ikke er kjørt først */
proc import datafile = "&filbane\tests\data\anno.csv" out=anno dbms=csv replace;
run;
%end;

%utvalgx;

proc sort data=rv;
by aar komnr bydel alder ermann;
run;

proc sort data=andel;
by alderny ermann;
run;

/* Filen RV er for stor til å inkluderes i repo, så ligger på server */
%if &lagReferanse = 0 %then %do;
proc compare base=test.ref_rate_rv compare=rv BRIEF WARNING LISTVAR;
%end;
%else %do;
data test.ref_rate_rv;
set rv;
run;
%end;

%sammenlignData(fil = andel, lagReferanse = &lagReferanse);

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

%if %sysevalf(%superq(silent)=,boolean) %then %let silent = 1;

%local filbane;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch;


%if (&alene ne 0) %then %do;

%include "&filbane\makroer\boomraader.sas";
%include "&filbane\rateprogram\rateberegninger.sas";
%include "&filbane\tests\makroer.sas";

%inkluderFormater;

%if &definerVariabler ne 0 %then %do;
%include "&filbane\rateprogram\sas\definerVariabler.sas";
%definerVariabler;
%end;

/*
Lese datasett fra disk som brukes videre i rateberegninger-makroen

Det vil da være mulig å kjøre denne makroen uavhengig av om man har kjørt de makroene som kommer tidligere i rateprogrammet
*/

proc import datafile = "&filbane\tests\data\anno.csv" out=anno dbms=csv replace;
run;

data rv;
set test.ref_rate_rv;
run;

proc import datafile = "&filbane\tests\data\andel.csv" out=andel dbms=csv replace;
run;

%end; /* %if (&alene ne 0) */

%let kommune=; 
%let kommune_HN=1; 
%let fylke=1; 
%let sykehus_HN=1; 
%let HF=1; 	
%let RHF=1; 
%let Oslo=1; 
%let Verstkommune_HN=;

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

   %sjekkeBoDatasett(bolist = Norge BoRHF bohf BoShHN komnr komnrHN fylke bydel);

%end;
%else %do;
/*
   Lagre det siste referansedatasettet
*/

   %lagreBoDatasett(bolist = Norge BoRHF bohf BoShHN komnr komnrHN fylke bydel);

%end;

%if &slettDatasett ne 0 %then %do;
proc datasets nolist;
delete rv: andel anno Norge: BoRHF: bohf: BoShHN: komnr: komnrHN: fylke: bydel: 
alder konsultasjoner_norge snudd hnsnitt aldersspenn konsultasjoner:;
%end;

%mend;

%macro lagreBoDatasett(bolist=);

/*
Lagre datasettene i repo ved å loope over alle boområdene
*/

%local nwords;
%local i;
%local bo;
%local boSort;

%let nwords=%sysfunc(countw(&bolist));
%do i=1 %to &nwords;
	%let bo =  %scan(&bolist, &i);

	proc sort data=&Bo._Agg_cv;
	by aar boomr;
	run;

	%sammenlignData(fil =&Bo._Agg_cv, lagReferanse = 1);

   %let boSort = &bo;
   %if &bo = komnrHN %then %let boSort = komnr;
   
	proc sort data=&Bo._Agg_rate;
	by aar &bosort;
	run;

	%sammenlignData(fil =&Bo._Agg_rate, lagReferanse = 1);

%end;

%mend;

%macro sjekkeBoDatasett(bolist=);

/*
Sjekk alle datasettene mot referanse ved å loope over alle boområdene
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

   %sammenlignData(fil =&Bo._Agg_cv, lagReferanse = 0, crit =  CRITERION=0.00001);

   %let boSort = &bo;
   %if &bo = komnrHN %then %let boSort = komnr;
   
   proc sort data=&Bo._Agg_rate;
   by aar &boSort;
   run;

   %sammenlignData(fil =&Bo._Agg_rate, lagReferanse = 0, crit =  CRITERION=0.00001);

%end;

%mend;
