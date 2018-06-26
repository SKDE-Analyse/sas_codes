%macro Persondata_omkod_konv (InnData=, UtData=);

/* Emigrert_dato og dodDato hentet ut fra Det sentrale folkeregister 20170425 */ 

data &UtData;
set &InnData;

/*
********************************************************
1.1 Omkoding av stringer med tall til numeriske variable
********************************************************
*/

PID=lopenr+0;
Drop lopenr;

/*
*******************************************************
1.2 Konvertering av stringer til dato- og tidsvariable
*******************************************************
*/

/*Datoer*/

emigrertDato=Input(emigrertdato19062018,Anydtdte10.);
DodDato=Input(doddato19062018,Anydtdte10.);
format emigrertDato dodDato Eurdfdd10.;
Drop emigrertdato19062018 doddato19062018;

run;

%MEND Persondata_omkod_konv;