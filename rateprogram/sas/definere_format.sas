%macro definere_format;

%global talltabformat;
%if &TallFormat=NLnum %then %do;
  %let talltabformat=NLnum12;
  %let talltabformat2=NLnum8;  
%end;

%else %if &TallFormat=Excel %then %do;
   %let talltabformat=12;
   %let talltabformat2=8;
%end;

%mend;