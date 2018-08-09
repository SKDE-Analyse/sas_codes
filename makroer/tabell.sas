
%macro tabell;
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


* Extract the total number of consultation / persons;

data antall(keep=antall FT FT2);
  set &forbruksmal._bohf;
  where BoHF=8888;
  rename &forbruksmal=antall;
run;


* Extract lowest and highest rates;

proc sort data=&forbruksmal._bohf;
  by rateSnitt;
run;

data highest(keep=HighRate HighOmrade);
  set &forbruksmal._bohf;
  by FT;
  if last.ft=1 then output;
  rename rateSnitt=HighRate BoHF=HighOmrade;
run;

data lowest(keep=LowRate LowOmrade);
  set &forbruksmal._bohf;
  by ft;
  if first.ft=1 then output;
  rename rateSnitt=LowRate BoHF=LowOmrade;
run;

* put all info together;

data KA_t_&forbruksmal;
  set snittAlder;
  set antall;
  set highest;
  set lowest;
  length beskrivelse $50;
  beskrivelse="&forbruksmal";
run;

%mend;
