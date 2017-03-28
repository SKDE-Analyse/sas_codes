%macro Boomraader(haraldsplass = 0, indreOslo = 0, bydel = 1);

/*
Endring Arnfinn 27. feb. 2017

Hvis haraldsplass ne 0: del Bergen i Haraldsplass og Haukeland
Hvis indreOslo ne 0: Slå sammen Diakonhjemmet og Lovisenberg
Hvis bydel = 0: Vi mangler bydel og må bruke gammel boomr.-struktur (bydel 10, 11, 12 går ikke til Ahus men til Oslo)
Standardverdier: kjører som før
*/

/*
***********************
0. Nulle ut variabler
***********************
*/

BoShHN=.;
VertskommHN=.;
BoHF=.;
BoRHF=.;
Fylke=.;


/*
********************************************************
1. BoShHN - Opptaksområder for lokalsykehusene i Helse Nord
********************************************************
*/

if KomNr in (2002,2003,2023,2024,2025,2027,2028,2030) then BoShHN=1;
else if KomNr in (2004,2011,2012,2014,2015,2017,2018,2019,2020,2021,2022) then BoShHN=2;
else if KomNr in (1902,1922,1924,1925,1926,1927,1928,1929,1931,1933,1936,1938,1939,1940,1941,1942,1943) then BoShHN=3;
else if KomNr in (1851,1852,1903,1911,1913,1917) then BoShHN=4;
else if KomNr in (1805,1853,1854,1919,1920,1923) then BoShHN=5;
else if KomNr in (1866,1867,1868,1870,1871) then BoShHN=6;
else if KomNr in (1859,1860,1865,1874) then BoShHN=7;
else if KomNr in (1804,1837,1838,1839,1840,1841,1845,1848,1849,1850,1856,1857) then BoShHN=8;
else if KomNr in (1828,1832,1833,1836) then BoShHN=9;
else if KomNr in (1824,1825,1826) then BoShHN=10;
else if KomNr in (1811,1812,1813,1815,1816,1818,1820,1822,1827,1834,1835) then BoShHN=11;

/*
*********************************************************
2. BoHF - Opptaksområder for helseforetakene
*********************************************************
*/

If BoShHN in (1,2) then BoHF=1;
else if BoShHN in (3,4,5) then BoHF=2;
else if BoShHN in (6,7,8) then BoHF=3;
else if BoShHN in (9,10,11,12) then BoHF=4;

if KomNr in (1632,1633,1702,1703,1711,1714,1717,1718,1719,1721,1724,1725,1736,1738,1739,1740,1742,1743,1744,1748,1749,1750,1751,1755,1756) then BoHF=6;
else if KomNr in (1567,1612,1613,1617,1620,1621,1622,1624,1627,1630,1634,1635,1636,1638,1640,1644,1648,1653,1657,1662,1663,1664,1665) then BoHF=7;
else if KomNr in (1601) then do;
%if &bydel = 0 %then %do;
   BoHF = 7;
%end;
%else %do;
   if Bydel in (160101:160199) then BoHF=7; /*Trondheim - endres ved behov*/
%end;
end;
else if KomNr in (1502,1504,1505,1511,1514,1515,1516,1517,1519,1520,1523,1524,1525,1526,1528,1529,1531,1532,1534,1535,1539,1543,1545,1546,1547,1548,1551,
1554,1557,1560,1563,1566,1571,1573,1576) then BoHF=8;
else if KomNr in (1401,1411,1412,1413,1416,1417,1418,1419,1420,1421,1422,1424,1426,1428,1429,1430,1431,1432,1433,1438,1439,1441,1443,1444,1445,1449) then BoHF=10; /*1411 Gulen skal f.o.m 1/1-16 høre til Haraldsplass*/

%if &haraldsplass = 0 %then %do; /* Bergen splittes ikke i Haukeland og Haraldsplass*/
else if KomNr in (1233,1234,1235,1238,1241,1242,1243,1244,1245,1246,1247,1251,1252,1253,1256,1259,1260,1263,1264,1265,1266) then BoHF=11;
else if KomNr in (1201) then do;
   %if &bydel = 0 %then %do;
      BoHF = 11;
   %end;
   %else %do;
      if Bydel in (120101:120199) then BoHF=11; /*Bergen - endres ved behov*/
   %end;
end;
%end;
%else %do;
else if KomNr in (1233,1234,1235,1238,1241,1243,1244,1245,1246,1247,1251,1259) then BoHF=11; /*Haukeland*/
else if KomNr in (1242,1252,1253,1256,1260,1263,1264,1265,1266) then BoHF=9; /*Haraldsplass*/ /*1242 Samnanger??*/
else if KomNr in (1201) then do;
	if Bydel in (120103,120104,120105,120106,120107,120199) then BoHF=11;
	if Bydel in (120101,120102,120108) then BoHF=9;
end;
%end;

else if KomNr in (1106,1134,1135,1145,1146,1149,1151,1160,1211,1216,1219,1221,1222,1223,1224,1227,1228,1231,1232) then BoHF=12;
else if KomNr in (1101,1102,1111,1112,1114,1119,1120,1121,1122,1124,1127,1129,1130,1133,1141,1142,1144) then BoHF=13;
else if komnr in (1103) then do; 
%if &bydel = 0 %then %do;
   BoHF = 13;
%end;
%else %do;
	if Bydel in (110301:110399) then BoHF=13; /*Stavanger - endres ved behov*/
%end;
end;
else if KomNr in (101,104,105,106,111,118,119,122,123,124,125,127,128,135,136,137,138) then BoHF=14;
else if KomNr in (121,211,213,214,215,216,217,221,226,227,228,229,230,231,233,234,235,237,238,239) then BoHF=15;
else if KomNr in (301) then do;
%if &bydel = 0 %then %do;
   BoHF = 30;
%end;
%else %do;
	if bydel in (030110,030111,030112) then BoHF=15;/*AHUS*/
	* f.o.m 2015: 030103 Sagene flyttet fra Lovisenberg til OUS;
	else if bydel in (030103,030108,030109,030113,030114,030115,030117,030199) then BoHF=16;/*OUS*/
   %if &indreOslo = 0 %then %do;
      else if bydel in (030101,030102,030104,030116) then BoHF=17;/*Lovisenberg*/
      else if bydel in (030105,030106,030107) then BoHF=18;/*Diakonhjemmet*/
   %end;
   %else %do;
      *slå sammen Lovisenberg og Diakonhjemmet til Indre Oslo (BoHF = 31);
      else if bydel in (030101,030102,030104,030116) then BoHF=31;/*Lovisenberg*/
      else if bydel in (030105,030106,030107) then BoHF=31;/*Diakonhjemmet*/
   %end; 
%end;
end;
else if KomNr in (236,402,403,412,415,417,418,419,420,423,425,426,427,428,429,430,432,434,436,437,438,439,441,501,502,511,512,513,514,515,516,517,519,520,521,
522,528,529,533,534,536,538,540,541,542,543,544,545) then BoHF=19;
else if KomNr in (219,220,532,602,604,605,612,615,616,617,618,619,620,621,622,623,624,625,626,627,628,631,632,633,711,713) then BoHF=20;
else if KomNr in (701,702,704,706,709,710,714,716,719,720,722,723,728) then BoHF=21;
else if KomNr in (805,806,807,811,814,815,817,819,821,822,826,827,828,829,830,831,833,834) then BoHF=22;
else if KomNr in (901,904,906,911,912,914,919,926,928,929,935,937,938,940,941,1001,1002,1003,1004,1014,1017,1018,1021,1026,1027,1029,1032,1034,1037,1046) then BoHF=23;
else if komNr in (9000,9900,2100,2111,2121,2131,2211,2311,2321) then BoHF=24;
else if komNr=9999 then BoHF=99;

/*
*****************************************************
3. BoRHF - Opptaksområder for RHF'ene
*****************************************************
*/

If BoHF in (1:4) then BoRHF=1;
else If BoHF in (6:8) then BoRHF=2;
else If BoHF in (9:13) then BoRHF=3;
else If BoHF in (14:23) then BoRHF=4;
else if BOHF in (24) then BoRHF=24;
else If BoHF in (30) then BoRHF=4;
else If BoHF in (31) then BoRHF=4;
else if BoHF in (99) then BoRHF=99;

/*
******************************************************
4. Fylke
******************************************************
*/

if 101<=komnr<=138 then Fylke=1;
else if 211<=komnr<=239 then Fylke=2;
else if komnr=301 then Fylke=3;
else if 402<=komnr<=441 then Fylke=4;
else if 501<=komnr<=545 then Fylke=5;
else if 602<=komnr<=633 then Fylke=6;
else if 701<=komnr<=728 then Fylke=7;
else if 805<=komnr<=834 then Fylke=8;
else if 901<=komnr<=941 then Fylke=9;
else if 1001<=komnr<=1046 then Fylke=10;
else if 1101<=komnr<=1160 then Fylke=11;
else if 1201<=komnr<=1266 then Fylke=12;
else if 1401<=komnr<=1449 then Fylke=14;
else if 1502<=komnr<=1576 then Fylke=15;
else if 1601<=komnr<=1665 then Fylke=16;
else if 1702<=komnr<=1756 then Fylke=17;
else if 1804<=komnr<=1874 then Fylke=18;
else if 1901<=komnr<=1943 then Fylke=19;
else if 2002<=komnr<=2030 then Fylke=20;
else if KomNr in (2100,2111,2121,2131,2211,2311,2321,9000,9900) then Fylke=24; /*24='Boomr utlandet/Svalbard' */
else if KomNr in(., 0000,8888,9999) then Fylke=99; /*99='Ukjent/ugyldig kommunenr'*/

/*
*****************************************************
5. VertskommHN (Vertskommuner Helse Nord)
*****************************************************
*/

if KomNr in (1804 /*Bodø*/
             1805 /*Narvik*/
		     1820 /*Alstahaug*/ 
			 1824 /*Vefsn*/ 
			 1833 /*Rana*/ 
			 1860 /*Vestvågøy*/ 
			 1866 /*Hadsel*/ 
			 1903 /*Harstad*/
			 1902 /*Tromsø*/
			 2004 /*Hammerfest*/ 
			 2030 /*Sør-Varanger*/) then VertskommHN=1;
else if KomNr in (1811,1812,1813,1815,1818,1822,1825,1826,1827,1828,1832,1834,1836,1837,1838,1839,1840,1841,1845,1848,1849,1850,1851,1852,1853,1854,1856,1857,1859,1865,1867,1868,1870,1871,1874,1911,1913,1917,1919,1920,1922,1923,1924,1925,1926,1927,1928,1929,1931,1933,1936,1938,1939,1940,1941,1942,1943,2002,2003,2011,2012,2014,2015,2017,2018,2019,2020,2021,2022,2023,2024,2025,2027,2028) then VertskommHN=0;

%mend Boomraader;
