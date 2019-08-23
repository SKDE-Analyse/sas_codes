%macro unik_pasient_test(branch = null, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste unik_pasient-makro.

Kjører unik_pasient-makroen på et test-datasett (`test.unik_pasient_start`).
Sammenligner dette datasettet med en referanse (`test.ref_unik_pasient_&navn`).

### Parametre

- `branch = master`: Bestemmer hvilken unik_pasient-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.unik_pasient_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_unik_pasient_&navn` på nytt.

*/

%include "&filbane\makroer\unik_pasient.sas";

/*
Lage nytt startsett, basert på test.pseudosens_avd_magnus og test.pseudosens_avtspes_magnus
etter eoc.
*/ 
%if &lagNyStart ne 0 %then %do;

data tmp;
set test.pseudosens_avd_magnus test.pseudosens_avtspes_magnus;
kontakt = 1;
run;

data test.unik_pasient_start;
set tmp (drop = fil institusjonID behandlingsstedKode2 SpesialistKomHN AvtaleRHF hdiag3tegn ICD10Kap bdiag: nc: episodeFag drg korrvekt drg_type polUtforende_1 Normaltariff: Tdiag: Fag_SKDE KoblingsID);
run;

proc delete data = tmp;

%end; /* lagNyStart */


/*!
### Tester

Kjører alle testene med og uten `pr_aar`, siden makroen er delt i to på dette (halve makroen er kode som gjelder pr_aar, mens andre halvdel ikke gjelder pr_aar).

#### Test default

Kjører med `%Unik_pasient(inn_data=testset_&navn, pr_aar=, sorter=, Pid=PID, Merke_variabel=kontakt);`

*/

%let navn = default;

data testset_&navn;
set test.unik_pasient_start;
run;

%Unik_pasient(inn_data=testset_&navn, pr_aar=, sorter=, Pid=PID, Merke_variabel=kontakt);

%if &lagNyRef ne 0 %then %do;
data test.ref_unik_pasient_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_unik_pasient_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


/*!
#### Test pr_aar = aar

Kjører med `pr_aar = aar`

*/

%let navn = pr_aar;

data testset_&navn;
set test.unik_pasient_start;
run;

%Unik_pasient(inn_data=testset_&navn, pr_aar=aar, sorter=, Pid=PID, Merke_variabel=kontakt);

%if &lagNyRef ne 0 %then %do;
data test.ref_unik_pasient_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_unik_pasient_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


/*!
#### Test sorter

Sorterer også på hdiag `sorter=hdiag`.
*/

%let navn = sorter;

data testset_&navn;
set test.unik_pasient_start;
run;

%Unik_pasient(inn_data=testset_&navn, pr_aar=, sorter=hdiag, Pid=PID, Merke_variabel=kontakt);

%if &lagNyRef ne 0 %then %do;
data test.ref_unik_pasient_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_unik_pasient_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


/*!
#### Test sorter_aar

Sorterer også på hdiag `sorter=hdiag`, pr. år `pr_aar=aar`.

*/

%let navn = sorter_aar;

data testset_&navn;
set test.unik_pasient_start;
run;

%Unik_pasient(inn_data=testset_&navn, pr_aar=aar, sorter=hdiag, Pid=PID, Merke_variabel=kontakt);

%if &lagNyRef ne 0 %then %do;
data test.ref_unik_pasient_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_unik_pasient_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


/*!
#### Test pid

Unik Hdiag i stedet for unik pid `Pid=hdiag`

*/

%let navn = pid;

data testset_&navn;
set test.unik_pasient_start;
run;

%Unik_pasient(inn_data=testset_&navn, pr_aar=, sorter=, Pid=hdiag, Merke_variabel=kontakt);

%if &lagNyRef ne 0 %then %do;
data test.ref_unik_pasient_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_unik_pasient_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


/*!
#### Test pid pr_aar

Unik Hdiag i stedet for unik pid `Pid=hdiag`, per år `pr_aar=aar`.

*/

%let navn = pid_aar;

data testset_&navn;
set test.unik_pasient_start;
run;

%Unik_pasient(inn_data=testset_&navn, pr_aar=aar, sorter=, Pid=hdiag, Merke_variabel=kontakt);

%if &lagNyRef ne 0 %then %do;
data test.ref_unik_pasient_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_unik_pasient_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


%mend;
