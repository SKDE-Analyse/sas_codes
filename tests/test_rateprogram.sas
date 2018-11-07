
%macro test_rateprogram(branch = master, lag_ref = 0);
/*!
Kjør tester av rateprogrammet
*/


%include "\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch\tests\makroer.sas";
%include "\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch\tests\makroer_rateprogram.sas";

/*
Test av rateprogrammet hver for seg, uavhengig av rekkefølge

Referansedatasettene lages her, hvis bedt om.
*/
%testAnno(branch = &branch, slettDatasett = 1, lagReferanse = &lag_ref);
%testUtvalgX(alene = 1, branch = &branch, slettDatasett = 1, lagReferanse = &lag_ref);
%testRateberegninger(alene = 1, branch = &branch, slettDatasett = 1, lagReferanse = &lag_ref);


/*
Test av rateprogrammet i sin helhet. Kjører rateprogrammet fra A til Å.
*/
%testAnno(branch = &branch, slettDatasett = 0, lagReferanse = 0);
%testUtvalgX(alene = 0, branch = &branch, slettDatasett = 0, definerVariabler = 1, lagReferanse = 0);
%testRateberegninger(alene = 0, branch = &branch, slettDatasett = 1, definerVariabler = 0, lagReferanse = 0);

%mend;
