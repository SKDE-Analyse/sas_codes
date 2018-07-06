%macro splitt_avtspes(datasett =, utsett = );

/*!
Ta ut konsultasjoner der kontakt er ulik 4 eller 5 og legg i egen fil,
siden vi normalt ikke skal analysere på disse kontaktene
*/

%if &avtspes ne 0 %then %do;

data &utsett;
set &datasett;
where kontakt in ('0', '1', '2', '3');
run;

data &datasett;
set &datasett;
where kontakt in ('4', '5');
run;

%end;

%mend;