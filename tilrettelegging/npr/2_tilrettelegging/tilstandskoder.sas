%macro tilstandskoder(inndata=,hoved= );

data &inndata;
set &inndata;
/* ----------------------- */
/* tilstand -> hdiag/bdiag */
/* ----------------------- */

array tilstand(*) $ tilstand:;
do i = 1 to dim(tilstand);
  tilstand(i)=upcase(compress(tilstand(i),"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890","ki")); /*The modifier "ki" means Keep the characters in the list and Ignore the case of the characters */
end;

if &hoved eq 1 then do;
hdiag=tilstand_1_1;
end;

if &hoved eq 2 then do;
hdiag2=tilstand_1_2;
end;

if &hoved eq 0 then do;
/* finne hvor mange bitilstander som er mottatt */
array tilstand_mottatt{*} $ tilstand_: ;
array tilstand_hoved{*}   $ tilstand_1_: ;
nbikode=dim(tilstand_mottatt)-dim(tilstand_hoved);
end;
drop i; 
run;

%if &hoved eq 0 %then %do;
/* lage makrovariabel som angir antall bidiagnose-variabler */
proc sql noprint;
	select nbikode into: ant_bikode trimmed
	from &inndata;
quit;

%let  end_bikode=%sysevalf(&ant_bikode+1);

data &inndata;
set &inndata;

array bdiag{*} $ bdiag1-bdiag&ant_bikode ;
array bTilstand{*} $ tilstand_2_1 -- tilstand_&end_bikode._1;
do i=1 to dim(bTilstand);
    bdiag{i}=(bTilstand{i});
end;

drop nbikode i; 
run; 
%end;

%mend tilstandskoder;
