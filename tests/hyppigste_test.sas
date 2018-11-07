%macro hyppigste_test(branch = master, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste hyppigste-makro.

Kjører hyppigste-makroen på et test-datasett (`test.hyppigste_start`).
Sammenligner dette datasettet med en referanse (`test.ref_hyppigste_&navn`).

### Parametre

- `branch = master`: Bestemmer hvilken hyppigste-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `test.hyppigste_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `test.ref_hyppigste_&navn` på nytt.

*/

%include "\\tos-sas-skde-01\SKDE_SAS\felleskoder\&branch\makroer\hyppigste.sas";

/*
Lage nytt startsett, basert på test.pseudosens_avd_magnus og test.pseudosens_avtspes_magnus
etter eoc.
*/ 
%if &lagNyStart ne 0 %then %do;

data tmp;
set test.pseudosens_avd_magnus test.pseudosens_avtspes_magnus;
kontakt = 1;
run;

data test.hyppigste_start;
set tmp (drop = fil institusjonID behandlingsstedKode2 SpesialistKomHN AvtaleRHF hdiag3tegn ICD10Kap bdiag: nc: episodeFag drg korrvekt drg_type polUtforende_1 Normaltariff: Tdiag: Fag_SKDE KoblingsID);
run;

proc delete data = tmp;

%end; /* lagNyStart */


/*!
### Tester

#### Test default

Kjører med `%hyppigste(VarName=hdiag, data_inn=test.hyppigste_start, test = testset_&navn);`

*/

%let navn = default;

%hyppigste(VarName=hdiag, data_inn=test.hyppigste_start, test = testset_&navn);

%if &lagNyRef ne 0 %then %do;
data test.ref_hyppigste_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_hyppigste_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


/*!
#### Test Ant_i_liste

Kjører med `Ant_i_liste = 20`

*/

%let navn = Ant_i_liste;

%hyppigste(Ant_i_liste = 20, VarName=hdiag, data_inn=test.hyppigste_start, test = testset_&navn);

%if &lagNyRef ne 0 %then %do;
data test.ref_hyppigste_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_hyppigste_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


/*!
#### Test VarName

Kjører med `VarName=behsh`

*/

%let navn = VarName;

%hyppigste(Ant_i_liste = 10, VarName=behsh, data_inn=test.hyppigste_start, test = testset_&navn);

%if &lagNyRef ne 0 %then %do;
data test.ref_hyppigste_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_hyppigste_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


/*!
#### Test where

Kjører med `Where=Where Behrhf=1`

*/

%let navn = where;

%hyppigste(Ant_i_liste = 10, VarName=hdiag, data_inn=test.hyppigste_start, test = testset_&navn, Where=Where Behrhf=1);

%if &lagNyRef ne 0 %then %do;
data test.ref_hyppigste_&navn;
set testset_&navn;
run;
%end;

proc compare base=test.ref_hyppigste_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = testset_&navn;
%end;


%mend;
