%macro aggreger_test(branch = master, debug = 0, lagNyRef = 0, lagNyStart = 0);

/*!
Makro for å teste aggreger-makro.

Kjører aggreger-makroen på et test-datasett (`skde_tst.agg_start`).
Sammenligner dette datasettet med en referanse (`skde_tst.ref_agg_&navn`).

### Parametre

- `branch = master`: Bestemmer hvilken aggreger-makro som kjøres (hvilken mappe den ligger i)
- `debug = 0`: Hvis ulik null, sletter ikke midlertidig referansedatasett `testset_:`.
- `lagNyRef = 0`: Hvis ulik null, lage startdatasettet `skde_tst.agg_start` på nytt.
- `lagNyStart = 0` Hvis ulik null, lage referansedatasettene `skde_tst.ref_agg_&navn` på nytt.

*/

%include "\\tos-sas-skde-01\SKDE_SAS\makroer\&branch.\aggreger.sas";

/*
Lage nytt startsett, basert på skde_tst.pseudosens_avd_magnus og skde_tst.pseudosens_avtspes_magnus
etter eoc.
*/ 
%if &lagNyStart ne 0 %then %do;

data tmp;
set skde_tst.pseudosens_avd_magnus skde_tst.pseudosens_avtspes_magnus;
run;

%episode_of_care(dsn = tmp);

data tmp;
set tmp;

innlegg = .;
poli = .;

If eoc_aktivitetskategori3 = 1 and eoc_Liggetid ge 1 then innlegg = 1;
else if eoc_uttilstand in (2, 3) then innlegg = 1; * ut som død eller selvmord;
else if (eoc_aktivitetskategori3 = 1 and eoc_Liggetid=0) then poli = 1;
else if eoc_aktivitetskategori3 in (2,3) then poli = 1;

if poli = 1 then eoc_Liggetid = 0;

elektiv = .;
ohjelp = .;
if eoc_hastegrad = 4 then elektiv = 1;
if eoc_hastegrad = 1 then ohjelp = 1;

off = .;
priv = .;
if behrhf in (1:4) then off = 1;
else priv = 1;

run;

data skde_tst.agg_start;
set tmp (drop = fil institusjonID behandlingsstedKode2 SpesialistKomHN AvtaleRHF hdiag3tegn ICD10Kap bdiag: nc: episodeFag drg korrvekt drg_type polUtforende_1 Normaltariff: Tdiag: Fag_SKDE KoblingsID);
run;

proc delete data = tmp;

%end; /* lagNyStart */


/*
Test default
*/

%let navn = default;

data tmp;
set skde_tst.agg_start;
kontakt = 1;
run;

%aggreger(inndata = tmp, utdata = testset_&navn, agg_var = kontakt);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_agg_&navn;
set testset_&navn;
run;
%end;

proc compare base=skde_tst.ref_agg_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = tmp testset_&navn;
%end;

/*
Test kreft
*/

%let navn = kreft;

data tmp;
set skde_tst.agg_start;
array diagnose {*} Hdiag:;
	do i=1 to dim(diagnose);
		if substr(diagnose{i},1,1) in ('C')  then kreft=1; 
	end;
run;

%aggreger(inndata = tmp, utdata = testset_&navn, agg_var = kreft);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_agg_&navn;
set testset_&navn;
run;
%end;

proc compare base=skde_tst.ref_agg_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = tmp testset_&navn;
%end;

/*
Test uten elektiv, ohjelp, priv, off, innlegg og poli
*/

%let navn = redusert;

data tmp;
set skde_tst.agg_start (drop = elektiv ohjelp priv off innlegg poli);
kontakt = 1;
run;

%aggreger(inndata = tmp, utdata = testset_&navn, agg_var = kontakt);

%if &lagNyRef ne 0 %then %do;
data skde_tst.ref_agg_&navn;
set testset_&navn;
run;
%end;

proc compare base=skde_tst.ref_agg_&navn. compare=testset_&navn. BRIEF WARNING LISTVAR;

%if &debug = 0 %then %do;
proc delete data = tmp testset_&navn;
%end;


%mend;
