%macro boomraader_test(branch = null, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste boomraader-makro.

Kjører boomraader-makroen på et test-datasett (`test.boomr_start`).
Sammenligner dette datasettet med en referanse (`test.ref_boomr_&navn`).

### Parametre

- `branch = master`: Bestemmer hvilken boomraader-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.boomr_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_boomr_&navn` på nytt.

*/

%include "&filbane/makroer/boomraader.sas";

/*
Lage nytt startsett, basert på test.pseudosens_avd_magnus
*/
%if &lagNyStart ne 0 %then %do;

data tmp;
set test.pseudosens_avd_magnus test.pseudosens_avtspes_magnus;
run;

data test.boomr_start;
set tmp (drop = fil institusjonID behandlingsstedKode2 SpesialistKomHN AvtaleRHF hdiag3tegn ICD10Kap bdiag: nc: episodeFag drg korrvekt drg_type polUtforende_1 Normaltariff: Tdiag: Fag_SKDE KoblingsID);
run;

proc delete data = tmp;

%end; /* lagNyStart */


/*
Test default
*/

%let navn = default;

data boomr_&navn;
set test.boomr_start;
%boomraader();
run;

%sammenlignData(fil = boomr_&navn, lagReferanse = &lagNyRef);

%if &debug = 0 %then %do;
proc delete data = boomr_&navn;
%end;

/*
Test haraldsplass = 1
*/

%let navn = haraldsplass;

data boomr_&navn;
set test.boomr_start;
%boomraader(haraldsplass = 1, indreOslo = 0, bydel = 1, barn = 0, boaar=2015);
run;

%sammenlignData(fil = boomr_&navn, lagReferanse = &lagNyRef);

%if &debug = 0 %then %do;
proc delete data = boomr_&navn;
%end;

/*
Test indreOslo = 1
*/

%let navn = indreOslo;

data boomr_&navn;
set test.boomr_start;
%boomraader(haraldsplass = 0, indreOslo = 1, bydel = 1, barn = 0, boaar=2015);
run;

%sammenlignData(fil = boomr_&navn, lagReferanse = &lagNyRef);

%if &debug = 0 %then %do;
proc delete data = boomr_&navn;
%end;

/*
Test bydel = 0
*/

%let navn = bydel;

data boomr_&navn;
set test.boomr_start;
%boomraader(haraldsplass = 0, indreOslo = 0, bydel = 0, barn = 0, boaar=2015);
run;

%sammenlignData(fil = boomr_&navn, lagReferanse = &lagNyRef);

%if &debug = 0 %then %do;
proc delete data = boomr_&navn;
%end;

/*
Test barn = 1
*/

%let navn = barn;

data boomr_&navn;
set test.boomr_start;
%boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1, barn = 1, boaar=2015);
run;

%sammenlignData(fil = boomr_&navn, lagReferanse = &lagNyRef);

%if &debug = 0 %then %do;
proc delete data = boomr_&navn;
%end;

/*
Test boaar = 2012
*/

%let navn = boaar;

data boomr_&navn;
set test.boomr_start;
%boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1, barn = 0, boaar = 2012);
run;

%sammenlignData(fil = boomr_&navn, lagReferanse = &lagNyRef);

%if &debug = 0 %then %do;
proc delete data = boomr_&navn;
%end;

%mend;
