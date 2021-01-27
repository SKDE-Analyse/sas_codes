/* Fornye gamle komnr til komnr i bruk pr 1.2.20xx */

%macro forny_komnr_loop(inndata=, utdata=);

/* hente inn csv-fil */
data forny_komnr;
  infile "&csvbane\forny_komnr.csv"
  delimiter=';'
  missover firstobs=2 DSD;

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

data test;
set &inndata(keep=lopenr komnrhjem2 episode_lnr);
komnr = komnrhjem2; /* i mottatt data er komnr = komnrhjem2 */
run;

/* Run a loop to fornew komnr until all komnr become missing (i.e. no more to fix)*/
%do %until (&sumkom<1);
    proc sql;
    	create table go&i as
    	select *
        from test a left join forny b
    	on a.komnr=b.komnr;
    quit;

    data go&i(rename=(komnr=komnr_orig&i  nykom=komnr)); 
      set go&i; 
    run;

    proc sql;
    	select sum(komnr) into :sumkom
    	from go&i;
    quit;

    data test;
      set go&i;
    run;

    %let i = %eval(&i+1);
%end;

/* save final komnr fix - komnr_orig1 as input, komnr as output (newest komnr)*/

data test_out;
  set test;

  %let j=2;

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
  from &inndata a, test_out b
  where a.episode_lnr=b.episode_lnr;
quit;

%mend;



