%Macro Merge_persondata (innDataSett=, utDataSett=, pid=pid);
/*!
 Kobler først på variablene emigrert og dodDato fra egen fil 
 */

/* Merge med sql */


proc sql;
create table &utDataSett as
select &innDataSett..*, emigrertDato, dodDato, fodselsAar_ident19062018, fodt_mnd_ident19062018, kjonn_ident19062018
from &innDataSett left join SKDE18.T18_persondata
on &innDataSett..&pid=T18_persondata.&pid;
quit; 

data &utDataSett;
set &utDataSett;
label emigrertDato='Emigrert dato - per 19062018 (NPR)';
label dodDato='Dødedato - per 19062018 (NPR)';
label fodselsAar_ident19062018='Fødselsår fra f.nr. ved siste kontakt med spes.helsetjenesten';
label fodt_mnd_ident19062018='Fødselsmåned fra f.nr. ved siste kontakt med spes.helsetjenesten';
label kjonn_ident19062018='Kjønn fra f.nr. ved siste kontakt med spes.helsetjenesten';
length dodDato emigrertDato 4;
run;

%Mend Merge_persondata;