/*
En samling tester av rateprogrammet
*/


%macro test1(branch = master);

/*!
Test av rateprogrammet i sin helhet. Kjører rateprogrammet fra A til Å.

Variabel-valg finnes i sas\definerVariabler.sas

*/

%include "\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch\rateprogram\tests\makroer.sas";

%testAnno(branch = &branch, slettDatasett = 0);

%testUtvalgX(alene = 0, branch = &branch, slettDatasett = 0, definerVariabler = 1);

%testRateberegninger(alene = 0, branch = &branch, slettDatasett = 1, definerVariabler = 0);

%mend;

%macro test2(branch = master);

/*!

Test av deler av rateprogrammet hver for seg.

*/

%include "\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch\rateprogram\tests\makroer.sas";

%include "&filbane\rateprogram\sas\definerVariabler.sas";
%definerVariabler;

%testRateberegninger(alene = 1, branch = &branch);

%testUtvalgX(alene = 1, branch = &branch);

%mend;
