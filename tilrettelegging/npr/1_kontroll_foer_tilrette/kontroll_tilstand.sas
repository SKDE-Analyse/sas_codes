%macro kontroll_tilstand(inndata=);
data tmpdata;
  set &inndata(keep=lopenr tilstand:);
run;


data tmpdata;
  set tmpdata;

/*  Diagnosekoder */
  array diag(*) $ tilstand:;
  feildiag=0;
  do i= 1 to dim(diag);

    * codes that start with these combination of alpha in position 1 and 3 are valid;
    if substr(diag(i),1,1) in ('T','Y','W','X','V') and substr(diag(i),3,1) in ('n','s','t') then leave;

	else do;

      * flag lines with no hdiag;
  	  if tilstand_1_1 =' ' then misshdiag=1;

      * most diag are alpha-num-num format in the first 3 position;
      * if not, then flag and leave the loop, no need to check further;
      if diag(i) not in (' ') then feildiag=not(anyalpha(substr(diag(i),1,1)));
	    if feildiag=1 then leave;

      if diag(i) not in (' ') then feildiag=not(anydigit(substr(diag(i),2,1)));
	    if feildiag=1 then leave;

      if diag(i) not in (' ') then feildiag=not(anydigit(substr(diag(i),3,1)));
	    if feildiag=1 then leave;
	end;
  end;

run;


/* Print out results for diagnosekoder */
data feildiag misshdiag;
  set tmpdata;
  if feildiag=1 then output feildiag;
  if misshdiag=1 then output misshdiag;
run;

* sjekk antall linjer med missing Hdiag - output i resultvindu ;
%let dsid2=%sysfunc(open(misshdiag));
%let nobs_misshdiag=%sysfunc(attrn(&dsid2,nlobs));
%let dsid2=%sysfunc(close(&dsid2)); 

%if &nobs_misshdiag ne 0 %then %do;
title color= purple height=5 "7a: Diagnosekode: &nobs_misshdiag linjer med missing hoveddiagnosekoder";
proc sql;
   create table m (note char(12));
   insert into  m values('WARNING!');
   select * from m;
quit;
title;
%end;

%if &nobs_misshdiag eq 0 %then %do;
title color= darkblue height=5  "7a: Diagnosekode: Alle linjer har hoveddiagnosekoder";
proc sql;
   create table m
       (note char(12));
   insert into m
      values('All is good!');
   select * 
	from m;
quit;
title;
%end;


* sjekk om det er data i tabell 'feildiag' - output i resultvindu ;
%let dsid1=%sysfunc(open(feildiag));
%let nobs_feildiag=%sysfunc(attrn(&dsid1,nlobs));
%let dsid1=%sysfunc(close(&dsid1)); 

%if &nobs_feildiag ne 0 %then %do;
title color= purple height=5 "7a: Diagnosekode: &nobs_feildiag linjer med ugyldige diagnosekoder";
proc print data=tmpdata(keep= lopenr feildiag tilstand:);
  where feildiag=1;
 run;
title;
%end;

%if &nobs_feildiag eq 0 %then %do;
title color= darkblue height=5  "7a: Diagnosekode: Alle linjer med gyldige diagnosekoder";
proc sql;
   create table m
       (note char(12));
   insert into m
      values('All is good!');
   select * 
	from m;
quit;
title;
%end;

proc datasets nolist; delete tmpdata feildiag m ; run;

%mend;