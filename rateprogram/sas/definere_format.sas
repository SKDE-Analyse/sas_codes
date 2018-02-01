%macro definere_format;

%global talltabformat;
%if TallFormat=NLnum %then %let talltabformat=NLnum12;
%else %if TallFormat=Excel %then %let talltabformat=12;

%mend;