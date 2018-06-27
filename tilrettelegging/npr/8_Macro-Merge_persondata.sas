%Macro Merge_persondata (innDataSett=, utDataSett=, pid=pid);
/*!
 Kobler først på variablene emigrert og dodDato fra egen fil 
 */

/* Merge med sql */


proc sql;
create table &utDataSett as
%if &avtspes ne 0 %then %do;
select &innDataSett..*, emigrertDato, dodDato, fodselsAar_ident19062018, fodt_mnd_ident19062018, kjonn_ident19062018
%end;
%if &somatikk ne 0 %then %do;
select &innDataSett..*, emigrertDato, dodDato
%end;
from &innDataSett left join NPR18.T18_persondata
on &innDataSett..&pid=T18_persondata.&pid;
quit; 

data &utDataSett;
set &innDataSett;
label emigrertDato='Emigrert dato - per 19062018 (NPR)';
label dodDato='Dødedato - per 19062018 (NPR)';
%if &avtspes ne 0 %then %do;
label fodselsAar_ident19062018='Fødselsår fra f.nr. ved siste kontakt med spes.helsetjenesten';
label fodt_mnd_ident19062018='Fødselsmåned fra f.nr. ved siste kontakt med spes.helsetjenesten';
label kjonn_ident19062018='Kjønn fra f.nr. ved siste kontakt med spes.helsetjenesten';
%end;
length dodDato emigrertDato 4;
run;

%Mend Merge_persondata;