%global aldersspenn;
%macro alders_oppslag(utvalg=, datasett = helseatl.alders_oppslagstabell);
/* !
This macro makes a dataset with min and max age limits of the incoming file

The second edit.
*/
data _null_;
    set &datasett;

	if upcase(utvalg)=upcase("&utvalg.") then do;
      call symput('min',min);
      call symput('max',max);
    end;
run;
%Let aldersspenn=in (&min:&max);
%mend;