
%macro rateprogram_test(branch = null, lagNyRef = 0);
/*!
Kjør tester av rateprogrammet
*/

%include "&filbane/tests/makroer_rateprogram.sas";

/*
Test av rateprogrammet hver for seg, uavhengig av rekkefølge

Referansedatasettene lages her, hvis bedt om.
*/
%testRateberegninger(alene = 1, branch = &branch, slettDatasett = 1, lagReferanse = &lagNyRef);
%testUtvalgX(alene = 1, branch = &branch, slettDatasett = 1, lagReferanse = &lagNyRef);
%testAnno(branch = &branch, slettDatasett = 1, lagReferanse = &lagNyRef);

/*
Test av rateprogrammet i sin helhet. Kjører rateprogrammet fra A til Å.
*/
%testAnno(branch = &branch, slettDatasett = 0, lagReferanse = 0);
%testUtvalgX(alene = 0, branch = &branch, slettDatasett = 0, definerVariabler = 1, lagReferanse = 0);
%testRateberegninger(alene = 0, branch = &branch, slettDatasett = 1, definerVariabler = 0, lagReferanse = 0);

%mend;
