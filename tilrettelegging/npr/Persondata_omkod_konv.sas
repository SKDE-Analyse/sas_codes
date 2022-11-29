%macro Persondata_omkod_konv (InnData=, UtData=);

/* Emigrert_dato og dodDato hentet ut fra Det sentrale folkeregister juni 2018 (19062018?) */ 

data &UtData;
set &InnData;

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

emigrertDato=Input(emigrertDato_DSF_190619,Anydtdte10.);
DodDato=Input(dodDato_DSF_190619,Anydtdte10.);
format emigrertDato dodDato Eurdfdd10.;
Drop emigrertDato_DSF_190619 dodDato_DSF_190619;

run;

%MEND Persondata_omkod_konv;