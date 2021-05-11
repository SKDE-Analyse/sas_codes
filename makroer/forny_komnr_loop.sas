/* Fornye gamle komnr til komnr i bruk pr 1.1.20xx */
/* Input variable  : KomNrHjem2 in RHF data (specified in the argument, original kommunenummer varialbe from NPR) */
/* Output variable : KomNr */

/* OBS: husk at bydeler blir ikke oppdatert når denne makroen kjøres. Hvis det er bydeler i datasettet må det lages etter at denne makroen er kjørt. */

%macro forny_komnr_loop(inndata=, utdata=, kommune_nr=komnrhjem2 /*Kommunenummer som skal fornyes*/);

/* hente inn csv-fil */
data forny_komnr;
  infile "&filbane\data\forny_komnr.csv"
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

/* kun beholde gml komnr og nytt komnr */
data forny(keep=komnr nykom);
set forny_komnr(rename=(ny_komnr = nykom gml_komnr=komnr));
run;


%let i=1;
%let sumkom=1;

data &inndata;
  set &inndata;
  nr=_n_;
run;

data tmp_forny;
set &inndata(keep=&kommune_nr nr);
komnr = &kommune_nr; /* i mottatt data er komnr = komnrhjem2 */
run;

/* Run a loop to fornew komnr until all komnr become missing (i.e. no more to fix)*/
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

    proc sql;
    	select sum(komnr) into :sumkom
    	from go&i;
    quit;
%put &sumkom;
    data tmp_forny;
      set go&i;
    run;
%put &i;


    %let i = %eval(&i+1);
%put &i;

%end;

%put &i;
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
  create table &utdata as
  select a.*, b.komnr
  from &inndata a, tmp_forny_out b
  where a.nr=b.nr;
quit;

%mend;



