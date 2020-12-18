%Macro Merge_persondata (innDataSett=, utDataSett=, pid=pid);
/*!
 Kobler først på variablene emigrert og dodDato fra egen fil 
 */


/* Merge med sql */


proc sql;
create table &utDataSett as
select &innDataSett..*, emigrertDato, dodDato, fodtAar_DSF_190619, fodtMnd_DSF_190619, kjonn_DSF_190619
from &innDataSett left join SKDE19.T19_persondata
on &innDataSett..&pid=T19_persondata.&pid;
quit; 

data &utDataSett;
set &utDataSett;
label emigrertDato='Emigrert dato - per 19062019 (NPR)';
label dodDato='Dødedato - per 19062019 (NPR)';
label fodtAar_DSF_190619='Fødselsår fra f.nr. ved siste kontakt med spes.helsetjenesten';
label fodtMnd_DSF_190619='Fødselsmåned fra f.nr. ved siste kontakt med spes.helsetjenesten';
label kjonn_DSF_190619='Kjønn fra f.nr. ved siste kontakt med spes.helsetjenesten';
length dodDato emigrertDato 4;
run;

%Mend Merge_persondata;