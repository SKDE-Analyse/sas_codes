%macro nc_koder(inndata=, xp=);
data &inndata;
set &inndata;
/* finne ut hvor mange ncsp-variabler som sendes inn */
array nc&xp._mottatt{*} $ nc&xp._: ;
	do i= 1 to dim(nc&xp._mottatt) ;
	end;
nkode=max(i)-1;
run;
/* lage makrovariabel som angir antall ncsp-variabler */
proc sql noprint;
	select nkode into: ant_nc trimmed
	from &inndata;
quit;

/* lage ny ncsp-variabler med store bokstaver og mellomrom fjernes */
data &inndata;
set &inndata;
array nc&xp._org{*} $ nc&xp._: ;
array nc&xp._ny{*} $ nc&xp.1-nc&xp.&ant_nc;
 	do j= 1 to dim(nc&xp._org) ;
   nc&xp._ny{j}=upcase(compress(nc&xp._org{j}));
end;
drop nc&xp._: j i nkode ;
run;
%mend nc_koder;