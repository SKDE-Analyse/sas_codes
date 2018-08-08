%global aldersspenn;
%macro alders_oppslag(utvalg=);
data _null_;
    set helseatl.alders_oppslagstabell;

	if upcase(utvalg)=upcase("&utvalg.") then do;
      call symput('min',min);
      call symput('max',max);
    end;
run;
%Let aldersspenn=in (&min:&max);
%mend;