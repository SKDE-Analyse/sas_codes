/*
This file contains 3 macros: rate_pr_year, rate_all_year, and indirekterate.

rate_pr_year aggregates files to calculate the indirect rates for each year on the file
rate_all_year aggregates files to calculate the indirect rates for all years combined
indirekterate is the main macro that uses the 2 above mentioned macors.

INPUT FILES:  &ratefil is the aggregated file (for example: helseatl.k_u_hysterektomi_dp)
              &innbyggerfil is the SBS file (for example: Innbygg.innb_2004_2017_bydel_allebyer)

OTHER INPUT:  &rate_pr (for example: 100 000)

MACRO USES:   %boomraader

OUTPUT FILE:  &dsn_ut is the name of the output dataset.  This is to be defined before calling the macro.

*/


%macro rate_pr_year;

* aggregate file to calculate the indirect adjusted rates;
proc sql;
  create table tmp as
  select aar, bohf, ermann, alder, sum(innbyggere) as innbyggere, sum(&RV_variabelnavn) as &RV_variabelnavn/*, borhf, boshHN, fylke*/
  from utvalgx
  group by aar, bohf, ermann, alder
  order by aar, bohf, ermann, alder;
quit;


* adjust each group (e.g. alder) to the same rate_pr (e.g. 10 000);
data tmp;
  set tmp(rename=(&RV_variabelnavn.=&RV_variabelnavn._orig));
  &RV_variabelnavn.=(&RV_variabelnavn._orig/innbyggere)*&rate_pr.;
  where aar>=&ratestart and alder ne .;
run;

* calculate indirect adjusted rate;
proc sql;
  create table norge as
  select aar, ermann, alder, sum(innbyggere) as innb_norge, sum(&RV_variabelnavn._orig) as &RV_variabelnavn._norge
  from tmp
  group by aar, ermann, alder
  order by aar, ermann, alder;
quit;


proc sql;
  create table tmp2 as
  select distinct a.*, b.innb_norge, b.&RV_variabelnavn._norge
  from tmp a, norge b
  where a.aar=b.aar
    and a.ermann=b.ermann
	and a.alder=b.alder;
quit;

data tmp2;
  set tmp2;
  norge_rate=&RV_variabelnavn._norge/innb_norge;
  expected_rate=innbyggere*norge_rate;
run;

* aggregate to annual rate to calculate the factor;
proc sql;
  create table aar as
  select aar, sum(&RV_variabelnavn._norge)/sum(innb_norge) as avg_norge_rate
  from tmp2
  group by aar
  order by aar;
quit;

proc sql;
  create table expected as
  select aar, bohf, sum(innbyggere) as innb, sum(&RV_variabelnavn._orig) as raw_rate, sum(expected_rate) as expected_rate
  from tmp2
  group by aar, bohf
  order by aar;
 quit;

data bohf;
  merge aar expected;
  by aar;
  factor=raw_rate/expected_rate;
  indirekt_justrate=factor*avg_norge_rate*&rate_pr.;
  ujust=(raw_rate/innb)*&rate_pr.;
run;

%mend;

%macro rate_all_year;

%let flagg=allyr;
* aggregate file to calculate the indirect adjusted rates;
proc sql;
  create table tmp_&flagg as
  select bohf, ermann, alder, sum(innbyggere) as innbyggere, sum(&RV_variabelnavn) as &RV_variabelnavn/*, borhf, boshHN, fylke*/
  from utvalgx
  group by bohf, ermann, alder
  order by bohf, ermann, alder;
quit;


* adjust each group (e.g. alder) to the same rate_pr (e.g. 10 000);
data tmp_&flagg;
  set tmp_&flagg(rename=(&RV_variabelnavn.=&RV_variabelnavn._orig));
  &RV_variabelnavn.=(&RV_variabelnavn._orig/innbyggere)*&rate_pr.;
run;

* calculate indirect adjusted rate;
proc sql;
  create table norge_&flagg as
  select ermann, alder, sum(innbyggere) as innb_norge, sum(&RV_variabelnavn._orig) as &RV_variabelnavn._norge
  from tmp_&flagg
  group by  ermann, alder
  order by  ermann, alder;
quit;

proc sql;
  create table tmp2_&flagg as
  select distinct a.*, b.innb_norge, b.&RV_variabelnavn._norge
  from tmp_&flagg a, norge_&flagg b
  where a.ermann=b.ermann
	and a.alder=b.alder;
quit;

data tmp2_&flagg;
  set tmp2_&flagg;
  norge_rate=&RV_variabelnavn._norge/innb_norge;
  expected_rate=innbyggere*norge_rate;
run;

* aggregate to annual rate to calculate the factor;
proc sql;
  create table aar_&flagg as
  select sum(&RV_variabelnavn._orig) as raw_rate, sum(innbyggere) as innb, sum(&RV_variabelnavn._orig)/sum(innbyggere) as avg_norge_rate
  from tmp2_&flagg
;
quit;

data _null_;
  set aar_&flagg;
  call symput('avg_norge_rate',trim(left(put(avg_norge_rate,8.5))));
run;


proc sql;
  create table expected_&flagg as
  select bohf, sum(innbyggere) as innb, sum(&RV_variabelnavn._orig) as raw_rate, sum(expected_rate) as expected_rate
  from tmp2_&flagg
  group by bohf;
 quit;

data bohf_&flagg(drop=avg_norge_rate);
  set expected_&flagg aar_&flagg(in=b);
  factor=raw_rate/expected_rate;
  indirekt_justratesnitt=factor*&avg_norge_rate.*&rate_pr.;
  ujust_ratesnitt=(raw_rate/innb)*&rate_pr.;
  if b then do;
    bohf=8888;
    indirekt_justratesnitt=&avg_norge_rate.*&rate_pr.;
  end;
run;

%mend;


%macro indirekterate;
%let flagg=allyr;

proc sql;
  create table utvalgx as
  select distinct a.*, b.innbyggere
  from &ratefil a, &innbyggerfil b
  where a.aar=b.aar
    and a.KomNr=b.KomNr
	and a.Alder=b.Alder
	and a.bydel=b.bydel
	and a.ErMann=b.ErMann
  order by aar, KomNr, Alder, bydel, ErMann;
quit;

* convert komnr to bohf;
data utvalgx;
  set utvalgx;
    %boomraader(boaar=2018);
	if bohf=99 then delete;
    where aar>=&ratestart and alder ne .;
run;


%rate_pr_year;
%rate_all_year;


proc sort data=bohf(keep=aar bohf ujust indirekt_justrate innb) out=bohf_sorted;
  by bohf;
run;

proc transpose data=bohf_sorted prefix=ujust out=ujust(drop=_name_);
  by BoHF;
  var ujust;
  id aar;
run;

proc transpose data=bohf_sorted prefix=indirjust out=indirekt (drop=_name_);
  by BoHF;
  var indirekt_justrate;
  id aar;
run;

*norge 8888 indirekt just pr aar;
proc transpose data=aar prefix=indirjust out=indirekt_norge (drop=_name_);
  var avg_norge_rate;
  id aar;
run;

data indirekt_norge;
  set indirekt_norge;
  indirjust2015=indirjust2015*&rate_pr.;
  indirjust2016=indirjust2016*&rate_pr.;
  indirjust2017=indirjust2017*&rate_pr.;
  bohf=8888;
run;

*norge 8888 ujust pr aar;
proc means data=norge noprint nway;
  class aar;
  var innb_norge &RV_variabelnavn._norge;
  where aar >=&ratestart ;
  output out=norge_uj sum=innb raw_rate;
run;

data norge_uj;
  set norge_uj;
  ujust=(raw_rate/innb)*&rate_pr.;
  bohf=8888;
run;

proc transpose data=norge_uj prefix=ujust out=ujust_norge (drop=_name_);
  var ujust;
  id aar;
run;

data ujust_norge;
  set ujust_norge;
  bohf=8888;
run;


* merge all rate files together;
data &dsn_ut(drop= raw_rate_3aar innb_3aar );
  merge ujust indirekt 
        ujust_norge indirekt_norge 
        bohf_&flagg(keep=bohf indirekt_justratesnitt ujust_ratesnitt innb raw_rate rename=(innb=innb_3aar raw_rate=raw_rate_3aar));
  by BoHF;
 * if ujust2017>0;

  RateSnitt=indirekt_justratesnitt;
  RateSnitt2=RateSnitt;
  if bohf=8888 then SnittRate=RateSnitt;

  rate2015=indirjust2015;
  rate2016=indirjust2016;
  rate2017=indirjust2017;
  min=min(rate2015,rate2016,rate2017);
  max=max(rate2015,rate2016,rate2017);

  &forbruksmal=raw_rate_3aar/3;
  innbyggere=innb_3aar/3;


  format bohf bohf_kort.;
/*  format ujust: indirekt_justrate: 8.5 ;*/
run;

proc sort data=&dsn_ut;
  by descending ratesnitt;
  where bohf ne 99;
run;

%mend;