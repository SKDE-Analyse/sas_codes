%macro trans_dup(inndata=);
/* Transpose the following scenarios to the same line:
   	- same org#/day/time
	- same org#/day, but different time and different codes*/

data bildediag sekgransk;
  set &inndata;
  if index(ncrpkode,'ZTX0BC')>0 then output sekgransk;
  else output bildediag;
run;

/*----*/
/*FLAG*/
/*----*/

/*flag if dup with same time or diff time*/
/*create id for the lines to be combined*/
proc sort data=bildediag;
  by PASIENTLOPENUMMER BEHANDLER_IDENTIFIKASJON DATO TID;
run;

data bildediag;
  set bildediag;
  retain nbr current_pid;
  by PASIENTLOPENUMMER BEHANDLER_IDENTIFIKASJON DATO TID;
  if first.tid=0 or last.tid=0 then sametime_dup=1;
  if (first.dato=0 or last.dato=0) and first.tid=1 and last.tid=1 then difftime_dup=1;
  if sametime_dup or difftime_dup then dup=1;

  if first.PASIENTLOPENUMMER then current_pid=PASIENTLOPENUMMER;
  if current_pid=PASIENTLOPENUMMER and first.DATO then nbr+1; 
run;

/*when dup with different time, check if one code contains in the other*/
proc sort data=bildediag;
  by nbr dato dup;
run;

data bildediag;
  set bildediag;
  retain prevkode;
  by nbr dato dup;
  if first.dup then prevkode=ncrpkode;
  else if sametime_dup then prevkode=catx("/",prevkode,ncrpkode);
  else if difftime_dup then substring=sum(index(prevkode,strip(ncrpkode)),index(ncrpkode,strip(prevkode)));
run;

/*nbr to be transposed*/
proc sort data=bildediag(keep=nbr sametime_dup difftime_dup substring) nodupkey out=keepnbr(keep=nbr);
  by nbr;
  where sametime_dup or (difftime_dup and substring=0 /*different codes*/);
run;

data bildediag;
  merge bildediag(in=a) keepnbr(in=b);
  by nbr;
  if a;
  if b and (sametime_dup>0 or difftime_dup>0) then candidate=1;
run;

/*---------*/
/*TRANSPOSE*/
/*---------*/

/*code to transpose multiple lines of ncrpkoder into the same line*/

proc transpose data=bildediag out=results(drop=_name_) ;
  where candidate=1;
  by nbr;
  var ncrpkode;
run;

data results;
  length allncrp $ 240;
  set results;

  allncrp="";
  array col  {*}  col: ;
	do i=1 to dim(col);
  	  allncrp=catx("/",allncrp,col{i});
	end;
run;

/*----------*/
/*OTHER VARS*/
/*----------*/

proc sort data=bildediag out=candidate;
  where candidate=1;
  by nbr;
run;

/*sum up refusjon*/
proc sql;
  create table candidate_trans as
  select a.*, 
         sum(a.refusjon) as refusjon_sum, 
         b.allncrp
  from candidate a, results b
  where a.nbr=b.nbr
  group by a.nbr
  order by a.nbr, a.tid;   
quit;

/* keep other info from the earliest row entry */
proc sort data=candidate_trans(drop=ncrpkode refusjon rename=(allncrp=ncrpkode refusjon_sum=refusjon)) nodupkey;
  by nbr;
run;

/*-------------*/
/*COMBINE FILES*/
/*-------------*/

data unchanged;
  length ncrpkode $240.;
  set bildediag;
  where candidate=.;
run;

data &inndata(drop=nbr--candiate);
  set unchanged candidate_trans sekgransk;
run;

proc sort data=&inndata;
  by PASIENTLOPENUMMER BEHANDLER_IDENTIFIKASJON DATO TID;
run;

/*-------------*/
/* FIX ALDER   */
/*-------------*/

proc sql;
  create table pid_alder as
  select PASIENTLOPENUMMER, max(PASIENT_ALDER) as alder
  from &inndata
  group by PASIENTLOPENUMMER;
run;

proc sql;
  create table &inndata as
  select a.*, b.alder
  from &inndata a, pid_alder b
  where a.PASIENTLOPENUMMER=b.PASIENTLOPENUMMER;
quit;

%mend trans_dup;
