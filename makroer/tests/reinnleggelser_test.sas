%macro reinnleggelser_test(branch = master, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste reinnleggelse-makro.

Kjører reinnleggelse-makroen på et test-datasett (`skde_tst.reinn_start`).
Sammenligner dette datasettet med en referanse (`skde_tst.ref_reinn1` og `skde_tst.ref_reinn2`).

### Parametre

- `branch = master`: Bestemmer hvilken reinnleggelse-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset1` og `testset2`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `skde_tst.reinn_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `skde_tst.ref_reinn1` og `skde_tst.ref_reinn2` på nytt.

*/

%include "\\tos-sas-skde-01\SKDE_SAS\makroer\&branch.\reinnleggelser.sas";

/*
Lage nytt startsett, basert på skde_tst.pseudosens_avd_magnus
*/
%if &lagNyStart ne 0 %then %do;

data tmp;
set skde_tst.pseudosens_avd_magnus;
run;

%episode_of_care(dsn=tmp);

data skde_tst.reinn_start;
set tmp (drop = fil institusjonID behandlingsstedKode2 SpesialistKomHN AvtaleRHF hdiag3tegn ICD10Kap bdiag: nc: episodeFag drg korrvekt drg_type polUtforende_1 Normaltariff: Tdiag: Fag_SKDE KoblingsID);
run;

proc delete data = tmp;

%end; /* lagNyStart */

data testset1;
set skde_tst.reinn_start;
run;

%reinnleggelser(dsn=testset1, eks_diag=1);

data testset2;
set skde_tst.reinn_ref;
run;

%reinnleggelser(dsn=testset2);

data testset3;
set skde_tst.reinn_ref;
run;

%reinnleggelser(dsn=testset3, ReInn_Tid = 120);

data testset4;
set skde_tst.reinn_ref;
run;

%reinnleggelser(dsn=testset4, kun_innleggelser = 0);


/*
Lag ny referanse
*/
%if &lagNyRef ne 0 %then %do;

data skde_tst.ref_reinn1;
set testset1;
run;

data skde_tst.ref_reinn2;
set testset2;
run;

data skde_tst.ref_reinn3;
set testset3;
run;

data skde_tst.ref_reinn4;
set testset4;
run;

%end; /* lagNyRef */

/*
Test eks_diag = 1
*/
proc compare base=skde_tst.ref_reinn1 compare=testset1 BRIEF WARNING LISTVAR;

/*
Test default
*/
proc compare base=skde_tst.ref_reinn2 compare=testset2 BRIEF WARNING LISTVAR;

/*
Test ReInn_Tid = 120
*/
proc compare base=skde_tst.ref_reinn3 compare=testset3 BRIEF WARNING LISTVAR;

/*
Test kun_innleggelser = 0
*/
proc compare base=skde_tst.ref_reinn4 compare=testset4 BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset1 testset2 testset3 testset4;
%end;

%mend;
