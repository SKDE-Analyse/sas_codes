%let filbane=\\tos-sas-skde-01\SKDE_SAS\;
%let branch = master;
%include "&filbane.rateprogram\&branch\tests\makroer.sas";

%testAnno(lagReferanse = 1);
%testUtvalgx(lagReferanse = 1);
%testOmraadeNorge(lagReferanse = 1);
%testRateberegninger(lagReferanse = 1);

/*
Tester datasettene vi nettopp har produsert
*/
%testAnno(lagReferanse = 0);
%testUtvalgx(lagReferanse = 0);
%testOmraadeNorge(lagReferanse = 0);
%testRateberegninger(lagReferanse = 0);

