%macro boomraader_test(branch = master, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste boomraader-makro.

Kjører boomraader-makroen på et test-datasett (`skde_tst.boomr_start`).
Sammenligner dette datasettet med en referanse (`skde_tst.ref_boomr_&navn`).

### Parametre

- `branch = master`: Bestemmer hvilken boomraader-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `skde_tst.boomr_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `skde_tst.ref_boomr_&navn` på nytt.

*/

%include "\\tos-sas-skde-01\SKDE_SAS\makroer\&branch.\boomraader.sas";

/*
Lage nytt startsett, basert på skde_tst.pseudosens_avd_magnus
*/
%if &lagNyStart ne 0 %then %do;

data tmp;
set skde_tst.pseudosens_avd_magnus skde_tst.pseudosens_avtspes_magnus;
run;

data skde_tst.boomr_start;
set tmp (drop = fil institusjonID behandlingsstedKode2 SpesialistKomHN AvtaleRHF hdiag3tegn ICD10Kap bdiag: nc: episodeFag drg korrvekt drg_type polUtforende_1 Normaltariff: Tdiag: Fag_SKDE KoblingsID);
run;

proc delete data = tmp;

%end; /* lagNyStart */


/*
Test default
*/

%let num = default;

data testset_&num;
set skde_tst.boomr_start;
%boomraader();
run;

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_boomr_&num;
set testset_&num;
run;
%end;

proc compare base=skde_tst.ref_boomr_&num. compare=testset_&num. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&num;
%end;

/*
Test haraldsplass = 1
*/

%let num = haraldsplass;

data testset_&num;
set skde_tst.boomr_start;
%boomraader(haraldsplass = 1, indreOslo = 0, bydel = 1, barn = 0, boaar=2015);
run;

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_boomr_&num;
set testset_&num;
run;
%end;

proc compare base=skde_tst.ref_boomr_&num. compare=testset_&num. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&num;
%end;

/*
Test indreOslo = 1
*/

%let num = indreOslo;

data testset_&num;
set skde_tst.boomr_start;
%boomraader(haraldsplass = 0, indreOslo = 1, bydel = 1, barn = 0, boaar=2015);
run;

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_boomr_&num;
set testset_&num;
run;
%end;

proc compare base=skde_tst.ref_boomr_&num. compare=testset_&num. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&num;
%end;

/*
Test bydel = 0
*/

%let num = bydel;

data testset_&num;
set skde_tst.boomr_start;
%boomraader(haraldsplass = 0, indreOslo = 0, bydel = 0, barn = 0, boaar=2015);
run;

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_boomr_&num;
set testset_&num;
run;
%end;

proc compare base=skde_tst.ref_boomr_&num. compare=testset_&num. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&num;
%end;

/*
Test barn = 1
*/

%let num = barn;

data testset_&num;
set skde_tst.boomr_start;
%boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1, barn = 1, boaar=2015);
run;

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_boomr_&num;
set testset_&num;
run;
%end;

proc compare base=skde_tst.ref_boomr_&num. compare=testset_&num. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&num;
%end;


/*
Test boaar = 2012
*/

%let num = boaar;

data testset_&num;
set skde_tst.boomr_start;
%boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1, barn = 0, boaar = 2012);
run;

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_boomr_&num;
set testset_&num;
run;
%end;

proc compare base=skde_tst.ref_boomr_&num. compare=testset_&num. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&num;
%end;


%mend;
