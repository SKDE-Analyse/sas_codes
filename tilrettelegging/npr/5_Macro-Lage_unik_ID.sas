/*!
MACROER FOR � KOBLINGS_ID 
*/

%macro KoblingsID(innDataSett=, utDataSett=, fil =);

/*!
Lager en unik id p� hvert opphold, som siden brukes n�r vi splitter datasettet i to.

### Input
- `innDataSett` 
- `utDataSett` 
- `fil`: kan v�re `avd`, `sho` eller `avtspes`
*/

%if &fil = avd %then %do;
%let prenum = 1810000000000;
%end;
%if &fil = sho %then %do;
%let prenum = 1820000000000;
%end;
%if &fil = avtspes %then %do;
%let prenum = 1830000000000;
%end;

If aar = 2017 then do;
count +1;
KoblingsID = &prenum. + count + 1700000000;
end;

If aar = 2016 then do;
count +1;
KoblingsID = &prenum. + count + 1600000000;
end;

If aar = 2015 then do;
count +1;
KoblingsID = &prenum. + count + 1500000000;
end;

If aar = 2014 then do;
count +1;
KoblingsID = &prenum. + count + 1400000000;
end;

If aar = 2013 then do;
count +1;
KoblingsID = &prenum. + count + 1300000000;
end;

If aar = 2012 then do;
count +1;
KoblingsID = &prenum. + count + 1200000000;
end;

format koblingsID 32.;
run;

%mend;

