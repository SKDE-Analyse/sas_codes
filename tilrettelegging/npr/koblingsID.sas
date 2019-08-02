/*!
MACROER FOR Å KOBLINGS_ID 
*/

%macro KoblingsID(innDataSett=, utDataSett=, fil =);

/*!
Lager en unik id på hvert opphold, som siden brukes når vi splitter datasettet i to.

### Input
- `innDataSett` 
- `utDataSett` 
- `fil`: kan være `avd`, `sho` eller `avtspes`
*/

%if %lowcase(&fil) = avd %then %do;
%let prenum = 1810000000000;
%end;
%if %lowcase(&fil) = sho %then %do;
%let prenum = 1820000000000;
%end;
%if %lowcase(&fil) = avtspes %then %do;
%let prenum = 1830000000000;
%end;

Data &Utdatasett;
set &Inndatasett;

If aar = 2018 then do;
i + 1;
KoblingsID = &prenum. + i + 1800000000;
end;

If aar = 2017 then do;
i + 1;
KoblingsID = &prenum. + i + 1700000000;
end;

If aar = 2016 then do;
i + 1;
KoblingsID = &prenum. + i + 1600000000;
end;

If aar = 2015 then do;
i + 1;
KoblingsID = &prenum. + i + 1500000000;
end;

If aar = 2014 then do;
i + 1;
KoblingsID = &prenum. + i + 1400000000;
end;

If aar = 2013 then do;
i + 1;
KoblingsID = &prenum. + i + 1300000000;
end;

If aar = 2012 then do;
i + 1;
KoblingsID = &prenum. + i + 1200000000;
end;

format koblingsID 32.;

run;

%mend;

