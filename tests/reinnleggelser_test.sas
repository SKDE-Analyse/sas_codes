%macro reinnleggelser_test(branch = null, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste reinnleggelse-makro.

Kjører reinnleggelse-makroen på et test-datasett (`test.reinn_start`).
Sammenligner dette datasettet med en referanse (`test.ref_reinn1` og `test.ref_reinn2`).

### Parametre

- `branch = master`: Bestemmer hvilken reinnleggelse-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset1` og `testset2`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.reinn_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_reinn1` og `test.ref_reinn2` på nytt.

*/

%include "&filbane/makroer/reinnleggelser.sas";

/*
Lage nytt startsett, basert på test.pseudosens_avd_magnus
*/
%if &lagNyStart ne 0 %then %do;

data tmp;
set test.pseudosens_avd_magnus;
run;

%episode_of_care(dsn=tmp);

data test.reinn_start;
set tmp (drop = fil institusjonID behandlingsstedKode2 SpesialistKomHN AvtaleRHF hdiag3tegn ICD10Kap bdiag: nc: episodeFag drg korrvekt drg_type polUtforende_1 Normaltariff: Tdiag: Fag_SKDE KoblingsID);
run;

proc delete data = tmp;

%end; /* lagNyStart */

data reinn1;
set test.reinn_start;
run;

%reinnleggelser(dsn=reinn1, eks_diag=1);

%sammenlignData(fil = reinn1, lagReferanse = &lagNyRef);

data reinn2;
set test.reinn_start;
run;

%reinnleggelser(dsn=reinn2);

%sammenlignData(fil = reinn2, lagReferanse = &lagNyRef);

data reinn3;
set test.reinn_start;
run;

%reinnleggelser(dsn=reinn3, ReInn_Tid = 120);

%sammenlignData(fil = reinn3, lagReferanse = &lagNyRef);

data reinn4;
set test.reinn_start;
run;

%reinnleggelser(dsn=reinn4, kun_innleggelser = 0);

%sammenlignData(fil = reinn4, lagReferanse = &lagNyRef);


%if &debug = 0 %then %do;
proc delete data = reinn1 reinn2 reinn3 reinn4;
%end;

%mend;
