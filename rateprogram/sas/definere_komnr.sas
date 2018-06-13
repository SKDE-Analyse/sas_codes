%macro definere_komnr(datasett =);

/*!
Makro for å definere komnr og bydel, hvis dette mangler men bohf er definert.

Denne makroen kjøres hvis man legger inn `%let manglerKomnr = 1;` i rateprogramfilen,
og vil definere komnr og bydel som en av kommunene/bydelene som sogner til allerede 
definert bohf.
*/

data &datasett;
set &datasett;

bydel = .;
komnr = .;
if bohf = 1 then komnr = 2002; /* Finnmark */
if bohf = 2 then komnr = 1902; /* UNN */
if bohf = 3 then komnr = 1866; /* Nordland */
if bohf = 4 then komnr = 1828; /* Helgeland */
if bohf = 6 then komnr = 1702; /* Nord-Trøndelag */
if bohf = 7 then komnr = 1640; /* St. Olavs */
if bohf = 8 then komnr = 1502; /* Møre og Romsdal */
if bohf = 9 then komnr = 1252; /* Haraldsplass */
if bohf = 10 then komnr = 1401; /* Førde */
if bohf = 11 then komnr = 1233; /* Bergen */
if bohf = 12 then komnr = 1106; /* Fonna */
if bohf = 13 then komnr = 1101; /* Stavanger */
if bohf = 14 then komnr = 101; /* Østfold */
if bohf = 15 then komnr = 121; /* Akershus */
if bohf = 16 then do; /* OUS */
    komnr = 301;
    bydel = 030108;
end;

if bohf = 17 then do; /* Lovisenberg */
    komnr = 301;
    bydel = 030101;
end;

if bohf = 18 then do; /* Diakonhjemmet */
    komnr = 301;
    bydel = 030105;
end;

if bohf = 19 then komnr = 236; /* Innlandet */
if bohf = 20 then komnr = 602; /* Vestre Viken */
if bohf = 21 then komnr = 701; /* Vestfold */
if bohf = 22 then komnr = 805; /* Telemark */
if bohf = 23 then komnr = 926; /* Sørlandet */
if bohf = 24 then komnr = 9000; /* Utlandet/Svalbard */
if bohf = 30 then komnr = 301; /* Oslo */
if bohf = 31 then do; /* Indre Oslo */
    komnr = 301;
    bydel = 030101;
end;
if bohf = 32 then do; /* Groruddalen */
    komnr = 301;
    bydel = 030110;
end;
if bohf = 33 then komnr = 219; /* Asker og Bærum */
if bohf = 99 then komnr = 9999; /* Ukjent kommunenummer */

run;

%mend;

