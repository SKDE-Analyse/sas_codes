%macro definere_format;
/*!
Definere format for tall i tabeller.
*/

%global talltabformat talltabformat2;
%if %upcase(&TallFormat) = NLNUM %then %do;
  %let talltabformat=NLnum12;
  %let talltabformat2=NLnum8;  
%end;

%else %if %upcase(&TallFormat) = EXCEL %then %do;
   %let talltabformat=NumX12;
   %let talltabformat2=NumX8;
%end;

%mend;
