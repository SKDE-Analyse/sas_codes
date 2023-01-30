data test;
  set hnmot.som_2022_M22T1(obs=100000 keep=lopenr tilstand: nc: institusjonid sh_reg shfylke);
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


title 'Feil ncsp';
proc freq data=test order=freq;
  tables institusjonid sh_reg shfylke;
  where feilncsp=1;
run;

title 'Feil ncmp';
proc freq data=test order=freq;
  tables institusjonid sh_reg shfylke;
  where feilncmp=1;
run;

title 'Feil ncrp';
proc freq data=test order=freq;
  tables institusjonid sh_reg shfylke;
  where feilncrp=1;
run;


/* Print out results */
data feildiag;
  set test(keep=feildiag tilstand:);
  where feildiag=1;
run;

/* sjekk om det er data i tabell 'feildiag' - output i resultvindu */
%let dsid2=%sysfunc(open(feildiag));
%let nobs_feildiag=%sysfunc(attrn(&dsid2,any));
%let dsid2=%sysfunc(close(&dsid2)); 

%if &nobs_feildiag eq 1 %then %do;
title color= purple height=5 "7a: Diagnosekode: Linjer med ugyldige diagnosekoder";
proc print data=test(keep=feildiag tilstand:);
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
