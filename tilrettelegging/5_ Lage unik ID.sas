/***********************************************************************************************
************************************************************************************************
MACRO FOR Å KOBLINGS_ID 

************************************************************************************************
***********************************************************************************************/

/***********************
*** Avdelingsopphold ***
***********************/

%macro KoblingsID_avd (innDataSett=, utDataSett=);

proc sort data=&innDataSett;
by PID inndato utdato;
run;

data &utDataSett;
set &innDataSett;
by PID InnDato Utdato;

If aar = 2015 then do;
count +1;
KoblingsID = count + 11500000000;
end;

If aar = 2014 then do;
count +1;
KoblingsID = count + 11400000000;
end;


If aar = 2013 then do;
count +1;
KoblingsID = count + 11300000000;
end;

If aar = 2012 then do;
count +1;
KoblingsID = count + 11200000000;
end;

If aar = 2011 then do;
count +1;
KoblingsID = count + 11100000000;
end;

run;

%mend KoblingsID_avd;

/*********************
*** Sykehusopphold ***
*********************/

%macro KoblingsID_sho (innDataSett=, utDataSett=);

proc sort data=&innDataSett;
by PID inndato utdato;
run;

data &utDataSett;
set &innDataSett;
by PID InnDato Utdato;

If aar = 2015 then do;
count +1;
KoblingsID = count + 21500000000;
end;

If aar = 2014 then do;
count +1;
KoblingsID = count + 21400000000;
end;


If aar = 2013 then do;
count +1;
KoblingsID = count + 21300000000;
end;

If aar = 2012 then do;
count +1;
KoblingsID = count + 21200000000;
end;

If aar = 2011 then do;
count +1;
KoblingsID = count + 21100000000;
end;

run;

%mend KoblingsID_sho;

