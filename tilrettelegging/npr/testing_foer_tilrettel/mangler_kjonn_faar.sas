%macro mangler_kjonn_faar(rot=);

data &rot._kjonnfaar_missing;
set &rot._merged;
where missing(kjonn) or missing(fodselsar);
if missing(kjonn) then Kjonn_mangler=1;
if missing(fodselsar) then Fodselsar_mangler=1;
run;

title "&rot";
proc tabulate data=&rot._kjonnfaar_missing;
var Kjonn_mangler Fodselsar_mangler;
table 
Kjonn_mangler={LABEL="Mangler kjønn"} 
Fodselsar_mangler={LABEL="Mangler fødselsår"},
Sum={LABEL="Antall"};
;
run;
title;

%mend mangler_kjonn_faar;