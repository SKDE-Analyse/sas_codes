/*
Dataene fra SSB hentes gjennom deres API med R (enklest slik)
Koden for å hente data fra SSB ligger på Data/R/SSB-api
*/
%include "&filbane/formater/SSB.sas";
/*
Les csv-file lagd i R 
*/
%let r_mappe=/sas_smb/skde_analyse/Data/R/SSB-api;
%let csvfile = beffremskriv_2022.csv; /* Må endres når nye data hentes inn */

proc import datafile = "&r_mappe/&csvfile"
out = tmp dbms=csv replace;
delimiter=';';
run;

/* Lagre på GRID */

data innbygg.beffremskriv_2022;
set tmp;
format alternativ alternativ.;
run;

