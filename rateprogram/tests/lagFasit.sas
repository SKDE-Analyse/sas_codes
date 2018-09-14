/*!
Kode for � lage referansedatasett til test av rateprogrammet

Kj�res enten ved � kopiere denne koden inn i et SAS-prosjekt, eller
ved � ta koden inn med 
```
%include "\\tos-sas-skde-01\SKDE_SAS\felleskoder\master\rateprogram\tests\lagFasit.sas";
```
*/

%let branch = master;
%let filbane=\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch;
%include "&filbane\rateprogram\tests\makroer.sas";

%testAnno(lagReferanse = 1);
%testUtvalgx(lagReferanse = 1);
%testRateberegninger(lagReferanse = 1);

/*
Tester datasettene vi nettopp har produsert
*/
%testAnno(lagReferanse = 0);
%testUtvalgx(lagReferanse = 0);
%testRateberegninger(lagReferanse = 0);

