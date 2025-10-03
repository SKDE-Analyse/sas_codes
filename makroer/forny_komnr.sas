%macro forny_komnr(inndata=, kommune_nr=komnrhjem2);

/* Import komnr CSV */
proc import datafile="&filbane/formater/forny_komnr.csv"
    out=forny_komnr
    dbms=csv
    replace;
    delimiter=';';
    getnames=yes;      /* Use first row as variable names */
    datarow=3;         /* Data starts on line 3 */
    guessingrows=1000;
run;

data forny (keep=komnr nykom);
  set forny_komnr(rename=(ny_komnr=nykom gml_komnr=komnr));
run;

/* Prepare input with original and working komnr */
data data_forny_input;
  set &inndata;
  komnr = &kommune_nr. + 0;
run;

/* Use a hash table to repeatedly update komnr until stable */
data &inndata(drop=rc prev_komnr nykom);
  if _N_ = 1 then do;
    declare hash h(dataset:"forny");
    h.defineKey('komnr');
    h.defineData('nykom');
    h.defineDone();
  end;
  set data_forny_input;
  length prev_komnr 8;
  do until (prev_komnr = komnr or komnr = .);
    prev_komnr = komnr;
    rc = h.find();
    if rc = 0 and nykom > 0 then komnr = nykom;
  end;
run;

/* Melding til loggen */
%put *------------------------------------------------*;
%put *** OBS: bydeler fornyes ikke i denne makroen! ***;
%put *------------------------------------------------*;
%put *--------------------------------------------------------------*;
%put * Bydeler må oppdateres manuelt. Se makro 'bydel'.             *;
%put * &filbane/tilrettelegging/npr/2_tilrettelegging/bydel.sas   *;
%put *--------------------------------------------------------------*;

proc datasets nolist;
  delete forny forny_komnr data_forny_input;
run;
title;
%mend;