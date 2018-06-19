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
if komnr = 717 then komnr = 701;
if komnr = 703 then komnr = 701;
if komnr = 721 then komnr = 704;
if komnr = 705 then komnr = 704;
if komnr = 727 then komnr = 709;
if komnr = 726 then komnr = 709;
if komnr = 725 then komnr = 709;
if komnr = 708 then komnr = 709;
if komnr = 707 then komnr = 709;
%end;
/*******
 1992 
*******/
%if &aar ge 1992 %then %do;
if komnr = 130 then komnr = 105;
if komnr = 115 then komnr = 105;
if komnr = 114 then komnr = 105;
if komnr = 102 then komnr = 105;
if komnr = 414 then komnr = 403;
if komnr = 401 then komnr = 403;
if komnr = 922 then komnr = 906;
if komnr = 921 then komnr = 906;
if komnr = 920 then komnr = 906;
if komnr = 918 then komnr = 906;
if komnr = 903 then komnr = 906;
if komnr = 2016 then komnr = 2004;
if komnr = 2001 then komnr = 2004;
%end;
/*******
 1994 
*******/
%if &aar ge 1994 %then %do;
if komnr = 134 then komnr = 106;
if komnr = 133 then komnr = 106;
if komnr = 131 then komnr = 106;
if komnr = 113 then komnr = 106;
if komnr = 103 then komnr = 106;
%end;
/*******
 2002 
*******/
%if &aar ge 2002 %then %do;
if komnr = 718 then komnr = 716;
if komnr = 716 then komnr = 716;
%end;
/*******
 2005 
*******/
%if &aar ge 2005 %then %do;
if komnr = 1842 then komnr = 1804;
if komnr = 1804 then komnr = 1804;
%end;
/*******
 2006 
*******/
%if &aar ge 2006 %then %do;
if komnr = 1572 then komnr = 1576;
if komnr = 1569 then komnr = 1576;
if komnr = 1159 then komnr = 1160;
if komnr = 1154 then komnr = 1160;
%end;
/*******
 2008 
*******/
%if &aar ge 2008 %then %do;
if komnr = 1556 then komnr = 1505;
if komnr = 1503 then komnr = 1505;
%end;
/*******
 2012 
*******/
%if &aar ge 2012 %then %do;
if komnr = 1729 then komnr = 1756;
if komnr = 1723 then komnr = 1756;
%end;
/*******
 2013 
*******/
%if &aar ge 2013 %then %do;
if komnr = 1915 then komnr = 1903;
if komnr = 1901 then komnr = 1903;
%end;
/*******
 2017 
*******/
%if &aar ge 2017 %then %do;
if komnr = 720 then komnr = 710;
if komnr = 719 then komnr = 710;
if komnr = 706 then komnr = 710;
%end;
/*******
 2018 
*******/
%if &aar ge 2018 %then %do;
if komnr = 709 then komnr = 712;
if komnr = 728 then komnr = 712;
if komnr = 702 then komnr = 715;
if komnr = 714 then komnr = 715;
if komnr = 722 then komnr = 729;
if komnr = 723 then komnr = 729;
/*
Trøndelag
*/
if komnr = 1601  then komnr = 5001;
if bydel = 160101 then bydel = 500101; /* Midtbyen */
if bydel = 160102 then bydel = 500102; /* Østbyen */
if bydel = 160103 then bydel = 500103; /* Lerkendal */
if bydel = 160104 then bydel = 500104; /* Heimdal */
if bydel = 160199 then bydel = 500199; /* Uoppgitt bydel Trondheim */
if komnr = 1702  then komnr = 5004;
if komnr = 1703  then komnr = 5005;
if komnr = 1612  then komnr = 5011;
if komnr = 1613  then komnr = 5012;
if komnr = 1617  then komnr = 5013;
if komnr = 1620  then komnr = 5014;
if komnr = 1621  then komnr = 5015;
if komnr = 1622  then komnr = 5016;
if komnr = 1627  then komnr = 5017;
if komnr = 1630  then komnr = 5018;
if komnr = 1632  then komnr = 5019;
if komnr = 1633  then komnr = 5020;
if komnr = 1634  then komnr = 5021;
if komnr = 1635  then komnr = 5022;
if komnr = 1636  then komnr = 5023;
if komnr = 1638  then komnr = 5024;
if komnr = 1640  then komnr = 5025;
if komnr = 1644  then komnr = 5026;
if komnr = 1648  then komnr = 5027;
if komnr = 1653  then komnr = 5028;
if komnr = 1657  then komnr = 5029;
if komnr = 1662  then komnr = 5030;
if komnr = 1663  then komnr = 5031;
if komnr = 1664  then komnr = 5032;
if komnr = 1665  then komnr = 5033;
if komnr = 1711  then komnr = 5034;
if komnr = 1714  then komnr = 5035;
if komnr = 1717  then komnr = 5036;
if komnr = 1719  then komnr = 5037;
if komnr = 1721  then komnr = 5038;
if komnr = 1724  then komnr = 5039;
if komnr = 1725  then komnr = 5040;
if komnr = 1736  then komnr = 5041;
if komnr = 1738  then komnr = 5042;
if komnr = 1739  then komnr = 5043;
if komnr = 1740  then komnr = 5044;
if komnr = 1742  then komnr = 5045;
if komnr = 1743  then komnr = 5046;
if komnr = 1744  then komnr = 5047;
if komnr = 1748  then komnr = 5048;
if komnr = 1749  then komnr = 5049;
if komnr = 1750  then komnr = 5050;
if komnr = 1751  then komnr = 5051;
if komnr = 1755  then komnr = 5052;
if komnr = 1756  then komnr = 5053;
if komnr = 1624  then komnr = 5054; /* Rissa -> Indre Fosen */
if komnr = 1718  then komnr = 5054; /* Leksvik -> Indre Fosen */
%end;

run;

%mend;