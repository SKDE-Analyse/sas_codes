/*!
MACROER FOR Å KOBLINGS_ID 
*/

%macro KoblingsID(innDataSett=, utDataSett=, fil =);

/*!
Lager en unik id på hver rad, som siden kan brukes til å hente inn mottatte variabler til tilrettelagt data hvis behov.

### Input
- `innDataSett` 
- `utDataSett` 
- `fil`: kan være som`, `avtspes`  eller `rehab`
*/

/* 
Tove 31.03.2022: 
    Lager koblingsid på SOM-fil. Splitt til avd og sho skjer først når tilrettelegging er ferdig.
    Det gjøres ikke splitt til PARVUS lengre, slik at denne koblingen skal brukes til å hente inn originale variabler fra mottatte data hvis behov.
 */

%if %lowcase(&fil) = avtspes %then %do;
%let prenum = 1830000000000;
%end;
%if %lowcase(&fil) = rehab %then %do;
%let prenum = 1840000000000;
%end;
%if %lowcase(&fil) = som %then %do;
%let prenum = 1850000000000;
%end;

Data &Utdatasett(drop=i);
set &Inndatasett;

/* REWRITE TO BE MORE DYNAMIC SO THAT WE DON'T HAVE TO MANUALLY CHANGE EVERY YEAR */

If aar = 2022 then do;
i + 1;
KoblingsID = &prenum. + i + 2200000000;
end;

If aar = 2021 then do;
i + 1;
KoblingsID = &prenum. + i + 2100000000;
end;

If aar = 2020 then do;
i + 1;
KoblingsID = &prenum. + i + 2000000000;
end;

If aar = 2019 then do;
i + 1;
KoblingsID = &prenum. + i + 1900000000;
end;

If aar = 2018 then do;
i + 1;
KoblingsID = &prenum. + i + 1800000000;
end;

If aar = 2017 then do;
i + 1;
KoblingsID = &prenum. + i + 1700000000;
end;

format koblingsID 32.;

run;

%mend;

