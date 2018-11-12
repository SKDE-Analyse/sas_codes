/*!
Hovedtestfil som leser inn alle testene, slik at disse kan kjøres.
Inneholder også felles makroer som testene bruker.

Hentes inn på følgende måte:

```
%let filbane=\\tos-sas-skde-01\SKDE_SAS\felleskoder\master;
%include "&filbane\tests\tests.sas";
```
*/

/* Inkluder alle testene */
%include "&filbane\tests\aggreger_test.sas";
%include "&filbane\tests\boomraader_test.sas";
%include "&filbane\tests\Episode_of_care_test.sas";
%include "&filbane\tests\hyppigste_test.sas";
%include "&filbane\tests\rateprogram_test.sas";
%include "&filbane\tests\reinnleggelser_test.sas";
%include "&filbane\tests\unik_pasient_test.sas";

%macro test(branch = master, lag_ny_referanse = 0);
/*!
Makro som kjører alle testene
*/

%aggreger_test(branch = &branch, lagNyRef = &lag_ny_referanse);
%boomraader_test(branch = &branch, lagNyRef = &lag_ny_referanse);
%Episode_of_care_test(branch = &branch, lagNyRef = &lag_ny_referanse);
%hyppigste_test(branch = &branch, lagNyRef = &lag_ny_referanse);
%reinnleggelser_test(branch = &branch, lagNyRef = &lag_ny_referanse);
%unik_pasient_test(branch = &branch, lagNyRef = &lag_ny_referanse);
%rateprogram_test(branch = &branch, lagNyRef = &lag_ny_referanse);

%mend;

/*!
## Felles makroer for testing av sas-kode.
*/

%macro definer_filbane(branch = null);
/*!
Makro for å definere filbane.

Vil definere filbane hvis branch er definert, eller hvis filbane ikke tidligere er definert.

*/

%if &branch ne null %then %do;
%local filbane;
%let filbane = \\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch;
%end;
%else %do;
    /* Definer filbane til master hvis filbane ikke er definert tidligere */
    %if %sysevalf(%superq(filbane)=,boolean) %then %do;
    %let filbane = \\tos-sas-skde-01\SKDE_SAS\felleskoder\master;
    %end;
%end;

&filbane.
%mend;

%macro sammenlignData(fil =, lagReferanse = 0, crit =);

/*!
Makro for å sammenligne to datasett, der referansedatasettet ligger i mappa `&filbane\tests\data\`.

*/

%if &lagReferanse ne 0 %then %do;
/*
Lagre data på disk
*/

data tmp;
set &fil;
/* Fjern alle formater før lagring */
FORMAT _ALL_ ; 
run;

/* Lagre data som csv på disk */
proc export data=tmp outfile="&filbane\tests\data\&fil..csv" dbms=csv replace;
run;

%end; /* &lagReferanse ne 0 */

/* Hent referansedata fra disk */
proc import datafile = "&filbane\tests\data\&fil..csv" out=ref_&fil dbms=csv replace;
run;

/*
Lagre som csv og importer tilbake igjen, for å få mest mulig likt utgangspunkt
*/

data tmp;
set &fil; 
/* Fjern alle formater før lagring */
FORMAT _ALL_ ; 
run;

/* Skriv data til csv på work og importer data fra samme fil, for å få tilsvarende data som referanse */
proc export data=tmp outfile="%sysfunc(pathname(work))\tmp.csv" dbms=csv replace;
run;
proc import datafile = "%sysfunc(pathname(work))\tmp.csv" out=test_&fil dbms=csv replace;
run;

/*
Sammenlign nye data med referansedata 
*/
proc compare base=ref_&fil compare=test_&fil BRIEF WARNING LISTVAR &crit;
run;

/* Slett datasett */
proc datasets nolist;
delete tmp test_&fil ref_&fil;
run;

%mend;

%macro inkluderFormater;

%include "&filbane\formater\SKDE_somatikk.sas";
%include "&filbane\formater\NPR_somatikk.sas";
%include "&filbane\formater\bo.sas";
%include "&filbane\formater\beh.sas";
%include "&filbane\formater\komnr.sas";

%mend;

