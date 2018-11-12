/*!
Felles makroer for testing av sas-kode.
*/

%macro sammenlignData(fil =, lagReferanse = 0, crit =);

/*!
Makro for � sammenligne to datasett, der referansedatasettet ligger i mappa `&filbane\tests\data\`.

*/

%if &lagReferanse ne 0 %then %do;
/*
Lagre data p� disk
*/

data tmp;
set &fil;
/* Fjern alle formater f�r lagring */
FORMAT _ALL_ ; 
run;

/* Lagre data som csv p� disk */
proc export data=tmp outfile="&filbane\tests\data\&fil..csv" dbms=csv replace;
run;

%end; /* &lagReferanse ne 0 */

/* Hent referansedata fra disk */
proc import datafile = "&filbane\tests\data\&fil..csv" out=ref_&fil dbms=csv replace;
run;

/*
Lagre som csv og importer tilbake igjen, for � f� mest mulig likt utgangspunkt
*/

data tmp;
set &fil; 
/* Fjern alle formater f�r lagring */
FORMAT _ALL_ ; 
run;

/* Skriv data til csv p� work og importer data fra samme fil, for � f� tilsvarende data som referanse */
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

