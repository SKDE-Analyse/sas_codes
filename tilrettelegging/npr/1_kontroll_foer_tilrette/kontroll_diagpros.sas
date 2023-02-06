%macro kontroll_diagpros(inndata=);
data test;
  set &inndata(keep=lopenr tilstand: nc:);
run;

%macro gyldig_kode(kode=);
  array &kode (*) $ &kode.:;
  feil&kode=0;
  do i= 1 to dim(&kode);

    len=length(&kode(i));

	* flag codes that are not length 5 or 6;
	if len not in (1,5,6) then do;
      feil&kode=1;
	  leave;
	end;

	* codes that are 5 or 6, check they are only alpahnum;
	else if &kode(i) not in ('') then do;
	  do j = 1 to len;
	    if j in (1,2) then do; *first 2 digits of any nc codes should be character;
	    	feil&kode=not(anyalpha(substr(&kode(i),j,1)));
			  if feil&kode=1 then leave;
		  end;
		  else do; * the rest can be alphanumeric;
	    	feil&kode=not(anyalnum(substr(&kode(i),j,1)));
			  if feil&kode=1 then leave;
		  end;
	  end;
	end;
  end;

  drop i j len;
%mend;

data test;
  set test;

/*  Diagnosekoder */
  array diag(*) $ tilstand:;
  feildiag=0;
  do i= 1 to dim(diag);

    * codes that start with these combination of alpha in position 1 and 3 are valid;
    if substr(diag(i),1,1) in ('T','Y','W','X','V') and substr(diag(i),3,1) in ('n','s','t') then leave;

	else do;
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

/*  Prosedyrekoder */
  %gyldig_kode(kode=ncsp);
  %gyldig_kode(kode=ncmp);
  %gyldig_kode(kode=ncrp);
run;

/* For those with invalid Prosedyrekoder, flag if they are ATC or Særkoder */
data test;
  set test;
  tmp=0;
  if feilncsp or feilncmp or feilncrp then do; /* if */

  array pros (*) $ nc:;
  do i= 1 to dim(pros); /* do loop */

    * flag ATC - alpha-num-num-alpha;
    if anyalpha(substr(pros(i),1,1)) and 
       anydigit(substr(pros(i),2,1)) and
       anydigit(substr(pros(i),3,1)) and
       anyalpha(substr(pros(i),4,1)) 
    then atckode=1;

  * flag særkoder - 5 dig, alphanum; 
    else if length(pros(i))=5 then do;
    tmp=0;
    do j=1 to 5;
      if anyalnum(substr(pros(i),j,1)) then tmp + 1;
    end;
    /* 5 digit alphanum code with at num in 1 and/or 2 position */
    if tmp=5 and (anydigit(substr(pros(i),1,1)) or anydigit(substr(pros(i),2,1)))
    then saerkode=1;
  end;

  end; /* do loop */
  end; /* if */

  drop i j tmp;
run;


/* Print out results for diagnosekoder */
data feildiag;
  set test;
  where feildiag=1;
run;

* sjekk om det er data i tabell 'feildiag' - output i resultvindu ;
%let dsid1=%sysfunc(open(feildiag));
%let nobs_feildiag=%sysfunc(attrn(&dsid1,nlobs));
%let dsid1=%sysfunc(close(&dsid1)); 

%if &nobs_feildiag ne 0 %then %do;
title color= purple height=5 "7a: Diagnosekode: &nobs_feildiag linjer med ugyldige diagnosekoder";
proc print data=test(keep= lopenr feildiag tilstand:);
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



/* Results for Prosedyrekoder */
data feilpros;
  set test;
  where feilncmp or feilncsp or feilncrp;
run;

data atc saer err;
  set feilpros;
  if atckode  then output atc;
  if saerkode then output saer;
  if atckode=. and saerkode=. then output err;
run;


%let dsid2=%sysfunc(open(feilpros));
%let nobs_feilpros=%sysfunc(attrn(&dsid2,nlobs));
%let dsid2=%sysfunc(close(&dsid2)); 

%let dsid_atc=%sysfunc(open(atc));
%let nobs_atc=%sysfunc(attrn(&dsid_atc,nlobs));
%let dsid_atc=%sysfunc(close(&dsid_atc)); 

%let dsid_saer=%sysfunc(open(saer));
%let nobs_saer=%sysfunc(attrn(&dsid_saer,nlobs));
%let dsid_saer=%sysfunc(close(&dsid_saer)); 

%let dsid_err=%sysfunc(open(err));
%let nobs_err=%sysfunc(attrn(&dsid_err,nlobs));
%let dsid_err=%sysfunc(close(&dsid_err)); 

%if &nobs_feilpros ne 0 %then %do;
title1 color= purple height=5 "7b: Prosedyrekode: &nobs_err linjer med ugyldige prosedyrekoder, &nobs_atc linjer med ATCkoder, &nobs_saer linjer med Saerkoder";
proc print data=feilpros(keep= lopenr nc: atckode saerkode);
  where atckode=. and saerkode=. ;
run;
proc freq data=feilpros;
  tables atckode saerkode/missing;
run;
title;
%end;

%if &nobs_feilpros eq 0 %then %do;
title color= darkblue height=5  "7b: Prosedyrekode: Alle linjer med gyldige prosedyrekoder";
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

proc datasets nolist; delete test m ; run;

%mend;