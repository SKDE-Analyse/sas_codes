%macro Harmonisering_behniva(dsn=);

proc format; 
value Tredelt_beh_niva 
1 = 'Innlagt døgn'
2 = 'Dagbehandling'
3 = 'Poliklinisk konsultasjon';
run;

data &dsn;
set &dsn;
	if aar in (2012,2013,2014) then do;
		if behandlingsniva8 = 1 and liggetid ge 1 then Tredelt_beh_niva = 1;
		if behandlingsniva8 = 1 and liggetid = 0 then Tredelt_beh_niva = 2;
		if behandlingsniva8 in (2,4) then Tredelt_beh_niva = 2;
		if behandlingsniva8 in (3,5,6,7,8) then Tredelt_beh_niva = 3;
		end;
	if aar = 2015 then do;
		if aktivitetskategori3 = 1 then Tredelt_beh_niva = 1;
		if aktivitetskategori3 = 2 then Tredelt_beh_niva = 2;
		if aktivitetskategori3 = 3 then Tredelt_beh_niva = 3;
		end;
	format Tredelt_beh_niva Tredelt_beh_niva.;
run;
%mend Harmonisering_behniva;
