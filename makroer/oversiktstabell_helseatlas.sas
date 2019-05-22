
%macro oversiktstabell_helseatlas(justering=&just);
* Calculate average age;

data tmp_aldersfig;
  set tmp_aldersfig;
  tot_alder=alder*rv;
run;

proc sql;
  create table snittAlder as
  select sum(tot_alder)/sum(rv) as snittAlder
  from tmp_aldersfig;
quit;

* Decide which rate file to use depending on the adjustment method (direct, indirect, unadjusted);

%if &just=just %then %do;
data forbruksmal_bohf;
  set &forbruksmal._bohf;
  antall=&forbruksmal;
run;
%end;
%else %if &just=ijust %then %do;
data forbruksmal_bohf;
  set &forbruksmal._ijust_bohf;
  antall=&forbruksmal;
run;
%end;
%else %if &just=ujust %then %do;
data forbruksmal_bohf;
  set &forbruksmal._ujust_bohf;
  antall=&forbruksmal;
run;
%end;

* Extract the total number of consultation / persons;

data antall(keep=antall innbyggere FT FT2);
  set forbruksmal_bohf;
  where BoHF=8888;
  antall=&forbruksmal;
run;


* Extract lowest and highest rates;

proc sort data=forbruksmal_bohf out=forbruksmal_bohf_tmp;
  by rateSnitt;
  where antall ge &nkrav; /*nkrav is a global macro variables in the Settings for figurer*/
run;

data highest(keep=HighRate HighOmrade);
  set forbruksmal_bohf_tmp;
  by FT;
  if last.ft=1 then output;
  rename rateSnitt=HighRate BoHF=HighOmrade;
run;

data lowest(keep=LowRate LowOmrade);
  set forbruksmal_bohf_tmp;
  by ft;
  if first.ft=1 then output;
  rename rateSnitt=LowRate BoHF=LowOmrade;
run;

* put all info together;

data tabell_&forbruksmal;
  set snittAlder;
  set antall;
  set highest;
  set lowest;
  length beskrivelse $50;
  beskrivelse="&forbruksmal";
run;

proc delete data=snittAlder antall highest lowest forbruksmal_bohf_tmp; run;

%mend;
