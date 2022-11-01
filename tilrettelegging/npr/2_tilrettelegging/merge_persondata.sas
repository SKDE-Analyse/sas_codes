%Macro Merge_persondata (innDataSett=, persondata=, utDataSett=);
/*!
 Kobler først på variablene emigrert og dodDato fra egen fil 
 */


/* Emigrert_dato og dodDato hentet ut fra Det sentrale folkeregister */ 

data persondata;
set &persondata (rename=(emigrertDato_DSF=emigrertDato_DSF_org dodDato_DSF=dodDato_DSF_org));

/*
********************************************************
1.1 Omkoding av stringer med tall til numeriske variable
********************************************************
*/

PID=LNr+0;
Drop LNr;

/*
*******************************************************
1.2 Konvertering av stringer til dato- og tidsvariable
*******************************************************
*/

/*Datoer*/

emigrertDato_DSF=Input(emigrertDato_DSF_org, Anydtdte10.);
DodDato_DSF=Input(dodDato_DSF_org,Anydtdte10.);
fodtAar_DSF=fodselsAar_DSF;
format emigrertDato_DSF dodDato_DSF Eurdfdd10.;
Drop emigrertDato_DSF_org dodDato_DSF_org;

run;


/* Merge med sql */

proc sql;
create table &utDataSett as
select a.*, b.*
from &innDataSett a left join persondata b
on a.pid=b.pid;
quit; 


%Mend Merge_persondata;