%macro splitt_avtspes(innData =, phvData =, enkelData=, spesData= );

/*!
Ta ut konsultasjoner der kontakt er ulik 4 eller 5 og legg i egen fil,
siden vi normalt ikke skal analysere på disse kontaktene
*/


data &phvData &enkelData &spesData;
set &innData;

    If sektor=4 /*PHV*/ then output &phvData;
    else if kontakt in ('0', '1', '2', '3') then output &enkelData;
    else if kontakt in ('4', '5') then output &spesData;

    format kontakt kontakt.;
run;

%mend;
