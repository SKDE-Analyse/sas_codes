%macro forny_komnr(datasett = , aar = 2018);

/*!
Skriv om kommunenummer til siste kommunestruktur
pr. 1 januar 2018

### Input

- `datasett`: input/output-datasettet
- `aar`: Hvilket år kommunestrukturen skal hentes fra. Satt til 2018.

*/

data &datasett;
set &datasett;
/*******
 1988
*******/
%if &aar ge 1988 %then %do;
if komnr = 717 then komnr = 701; /* Borre -> Borre */
if komnr = 703 then komnr = 701; /* Horten -> Borre */
if komnr = 721 then komnr = 704; /* Sem -> Tønsberg */
if komnr = 705 then komnr = 704; /* Tønsberg -> Tønsberg */
if komnr = 727 then komnr = 709; /* Hedrum -> Larvik */
if komnr = 726 then komnr = 709; /* Brunlanes -> Larvik */
if komnr = 725 then komnr = 709; /* Tjølling -> Larvik */
if komnr = 708 then komnr = 709; /* Stavern -> Larvik */
if komnr = 707 then komnr = 709; /* Larvik -> Larvik */
%end;
/*******
 1992
*******/
%if &aar ge 1992 %then %do;
if komnr = 130 then komnr = 105; /* Tune -> Sarpsborg */
if komnr = 115 then komnr = 105; /* Skjeberg -> Sarpsborg */
if komnr = 114 then komnr = 105; /* Varteig -> Sarpsborg */
if komnr = 102 then komnr = 105; /* Sarpsborg -> Sarpsborg */
if komnr = 414 then komnr = 403; /* Vang -> Hamar */
if komnr = 401 then komnr = 403; /* Hamar -> Hamar */
if komnr = 922 then komnr = 906; /* Hisøy -> Arendal */
if komnr = 921 then komnr = 906; /* Tromøy -> Arendal */
if komnr = 920 then komnr = 906; /* Øyestad -> Arendal */
if komnr = 918 then komnr = 906; /* Moland -> Arendal */
if komnr = 903 then komnr = 906; /* Arendal -> Arendal */
if komnr = 2016 then komnr = 2004; /* Sørøysund -> Hammerfest */
if komnr = 2001 then komnr = 2004; /* Hammerfest -> Hammerfest */
%end;
/*******
 1994
*******/
%if &aar ge 1994 %then %do;
if komnr = 134 then komnr = 106; /* Onsøy -> Fredrikstad */
if komnr = 133 then komnr = 106; /* Kråkerøy -> Fredrikstad */
if komnr = 131 then komnr = 106; /* Rolvsøy -> Fredrikstad */
if komnr = 113 then komnr = 106; /* Borge -> Fredrikstad */
if komnr = 103 then komnr = 106; /* Fredrikstad -> Fredrikstad */
%end;
/*******
 2002
*******/
%if &aar ge 2002 %then %do;
if komnr = 718 then komnr = 716; /* Ramnes -> Re */
/*if komnr = 716 then komnr = 716;*/ /* Våle -> Re */
%end;
/*******
 2005
*******/
%if &aar ge 2005 %then %do;
if komnr = 1842 then komnr = 1804; /* Skjerstad lagt under Bodø */
/*if komnr = 1804 then komnr = 1804;*/
%end;
/*******
 2006
*******/
%if &aar ge 2006 %then %do;
if komnr = 1572 then komnr = 1576; /* Tustna -> Aure */
if komnr = 1569 then komnr = 1576; /* Aure -> Aure */
if komnr = 1159 then komnr = 1160; /* Ølen -> Vindafjord */
if komnr = 1154 then komnr = 1160; /* Vindafjord -> Vindafjord */
%end;
/*******
 2008
*******/
%if &aar ge 2008 %then %do;
if komnr = 1556 then komnr = 1505; /* Frei -> Kristiansund */
if komnr = 1503 then komnr = 1505; /* Kristiansund -> Kristiansund */
%end;
/*******
 2012
*******/
%if &aar ge 2012 %then %do;
  if KomNr in (1723/*Mosvik*/,1729 /*Inderøy*/) then KomNr=1756 /*Inderøy */;
%end;
/*******
 2013
*******/
%if &aar ge 2013 %then %do;
  if KomNr in (1901/*Harstad*/,1915 /*Bjarkøy*/) then KomNr=1903 /*Harstad*/;
%end;
/*******
 2017
*******/
%if &aar ge 2017 %then %do;
  if komnr in (706 /*Sandefjord*/, 719 /*Andebu*/, 720 /*Stokke*/) then komnr = 710; /*Sandefjord*/
%end;
/*******
 2018
*******/
%if &aar ge 2018 %then %do;
if komnr = 709 then komnr = 712; /* Larvik -> Larvik */
if komnr = 728 then komnr = 712; /* Lardal -> Larvik */
if komnr = 702 then komnr = 715; /* Holmestrand -> Holmestrand */
if komnr = 714 then komnr = 715; /* Hof -> Holmestrand */
if komnr = 722 then komnr = 729; /* Nøtterøy -> Færder */
if komnr = 723 then komnr = 729; /* Tjøme -> Færder */
if komnr = 1624 then komnr = 5054; /* Rissa -> Indre Fosen */
if komnr = 1718 then komnr = 5054; /* Leksvik -> Indre Fosen */
/*
Kun bytte av kommunenummer pga fylkessammenslåing (Trøndelag)
*/
if komnr = 1601 then komnr = 5001;
if bydel = 160101 then bydel = 500101; /* Midtbyen */
if bydel = 160102 then bydel = 500102; /* Østbyen */
if bydel = 160103 then bydel = 500103; /* Lerkendal */
if bydel = 160104 then bydel = 500104; /* Heimdal */
if bydel = 160199 then bydel = 500199; /* Uoppgitt bydel Trondheim */
if komnr = 1702 then komnr = 5004;
if komnr = 1703 then komnr = 5005;
if komnr = 1612 then komnr = 5011;
if komnr = 1613 then komnr = 5012;
if komnr = 1617 then komnr = 5013;
if komnr = 1620 then komnr = 5014;
if komnr = 1621 then komnr = 5015;
if komnr = 1622 then komnr = 5016;
if komnr = 1627 then komnr = 5017;
if komnr = 1630 then komnr = 5018;
if komnr = 1632 then komnr = 5019;
if komnr = 1633 then komnr = 5020;
if komnr = 1634 then komnr = 5021;
if komnr = 1635 then komnr = 5022;
if komnr = 1636 then komnr = 5023;
if komnr = 1638 then komnr = 5024;
if komnr = 1640 then komnr = 5025;
if komnr = 1644 then komnr = 5026;
if komnr = 1648 then komnr = 5027;
if komnr = 1653 then komnr = 5028;
if komnr = 1657 then komnr = 5029;
if komnr = 1662 then komnr = 5030;
if komnr = 1663 then komnr = 5031;
if komnr = 1664 then komnr = 5032;
if komnr = 1665 then komnr = 5033;
if komnr = 1711 then komnr = 5034;
if komnr = 1714 then komnr = 5035;
if komnr = 1717 then komnr = 5036;
if komnr = 1719 then komnr = 5037;
if komnr = 1721 then komnr = 5038;
if komnr = 1724 then komnr = 5039;
if komnr = 1725 then komnr = 5040;
if komnr = 1736 then komnr = 5041;
if komnr = 1738 then komnr = 5042;
if komnr = 1739 then komnr = 5043;
if komnr = 1740 then komnr = 5044;
if komnr = 1742 then komnr = 5045;
if komnr = 1743 then komnr = 5046;
if komnr = 1744 then komnr = 5047;
if komnr = 1748 then komnr = 5048;
if komnr = 1749 then komnr = 5049;
if komnr = 1750 then komnr = 5050;
if komnr = 1751 then komnr = 5051;
if komnr = 1755 then komnr = 5052;
if komnr = 1756 then komnr = 5053;
%end;

run;

%mend;
