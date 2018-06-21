%macro alders_oppslag(utvalg=);
data _null_;
    set helseatl.alders_oppslagstabell;

	if utvalg="&utvalg." then do;
      call symput('min',min);
      call symput('max',max);
    end;
run;
%Let aldersspenn=in (&min:&max);
%mend;