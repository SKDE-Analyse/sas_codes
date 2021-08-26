%macro forny_komnr(inndata=, kommune_nr=komnrhjem2);
/*! 
### Beskrivelse

Makro for � fornye gamle kommunenummer til kommunenummer i bruk pr 1.1.2021 .

```
%forny_komnr(inndata=, kommune_nr=komnrhjem2)
```

### Input 
- Inndata:
- kommune_nr:  Kommunenummer som skal fornyes, default er 'KomNrHjem2' - variabel utlevert fra NPR 

### Output 
- KomNr: Fornyet kommunenummer
- komnr_inn: Input kommunenummer beholdes i utdata for evnt kontroll

OBS: bydeler blir ikke oppdatert n�r denne makroen kj�res. 
Hvis det er bydeler i datasettet m� de fornyes etter at denne makroen er kj�rt. 
Se makro 'bydel': 
- \\&filbane\tilrettelegging\npr\2_tilrettelegging\bydel.sas

### Endringslogg:
- 2020 Opprettet av Tove og Janice
- august 2021, Tove
  - tatt bort 'utdata='
  - skrive melding til SAS-logg
  - dokumentasjon markdown

 */

/* lese inn csv-fil */
data forny_komnr;
  infile "&filbane\formater\forny_komnr.csv"
  delimiter=';'
  missover firstobs=3 DSD;

  format aar 4.;
  format gml_komnr 4.;
  format gml_navn $30.;
  format ny_komnr 4.;
  format ny_navn $30.;
  format kommentar $350.;
  format kommentar2 $350.;

  input	
  	aar
	  gml_komnr 
	  gml_navn $
	  ny_komnr 
	  ny_navn $
    kommentar $
	  kommentar2 $
	;
run;

/* beholde og gi nytt navn til variablene 'gml_komnr' og 'ny_komnr' fra innlest CSV-fil */
data forny		(keep=komnr nykom);	 
set forny_komnr	(rename=(ny_komnr = nykom  gml_komnr=komnr));
run;

/* gi nytt navn til kommunenummer fra inndata slik at det beholdes i utdata som variabel 'komnr_inn' */
/* lage radnummer for � bruke til merge i siste steg */
data &inndata (rename=(&kommune_nr = komnr_inn)); 
set &inndata;
  nr=_n_; 
run;

/* loop trenger kun innsendt kommunenummer og radnummer */
/* komnr_inn gis nytt navn f�r loop da merge skal gj�res med a.komnr=b.komnr */
data tmp_forny 	(rename= (komnr_inn = komnr));
set &inndata	(keep=komnr_inn nr); 
run;

/* Run a loop to fornew komnr until all komnr become missing (i.e. no more to fix)*/
%let i=1;
%let sumkom=1;

%do %until (&sumkom<1);
    proc sql;
    	create table go&i as
    	select *
        from tmp_forny a left join forny b
    	on a.komnr=b.komnr;
    quit;

    data go&i(rename=(komnr=komnr_orig&i  nykom=komnr)); 
      set go&i; 
    run;

    title 'antall komnr som m� fornyes';
    proc sql;
    select count( distinct (case when komnr>1 then komnr end)) into :sumkom
    from go&i;
    quit;

    data tmp_forny;
      set go&i;
    run;

    %let i = %eval(&i+1);
%end;

/* save final komnr fix - komnr_orig1 as input, komnr as output (newest komnr)*/
data tmp_forny_out;
  set tmp_forny;

  %let j=1;

  %do %until (&j=&i);
    %let prev_j=%eval(&j-1);
    if komnr_orig&j eq . 
    then komnr_orig&j = komnr_orig&prev_j;
    %let j = %eval(&j+1);
  %end;

  %let prev_j=%eval(&j-1);
  komnr=komnr_orig&prev_j;
run;

proc sql;
  create table &inndata as
  select b.komnr, a.* 
  from &inndata a, tmp_forny_out b
  where a.nr=b.nr;
quit;

/* Melding til loggen */
%put *------------------------------------------------*;
%put *** OBS: bydeler fornyes ikke i denne makroen! ***;
%put *------------------------------------------------*;

%put *--------------------------------------------------------------*;
%put * Bydeler m� oppdateres manuelt. Se makro 'bydel'.             *;
%put * \\&filbane\tilrettelegging\npr\2_tilrettelegging\bydel.sas   *;
%put *--------------------------------------------------------------*;

proc datasets nolist;
delete go: forny tmp_forny: forny_komnr;
run;
%mend;

