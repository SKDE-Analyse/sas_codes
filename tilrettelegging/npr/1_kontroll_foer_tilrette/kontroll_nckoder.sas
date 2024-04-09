%macro kontroll_nckoder(inndata=, kode=);
data tmpdata;
  set &inndata(keep=lopenr &kode.:);
run;

data tmpdata;
  set tmpdata;
  array kode (*) $ &kode.:;
  feilkode=0;
  do i= 1 to dim(kode);

	/* flag codes that are not length 5 or 6; */
	if length(kode(i)) not in (1,5,6) then do;
      feilkode=1;
	  leave;
	end;

	/* codes that are 5 or 6, check they are only alpahnum; */
	else if kode(i) not in ('') then do;
	  do j = 1 to length(kode(i));

        /*first 2 digits of any nc codes should be character*/
	    if j in (1,2) then do; 
	    	feilkode=not(anyalpha(substr(kode(i),j,1)));
			if feilkode=1 then leave;
	    end;

        /* the rest can be alphanumeric*/
		else do; 
	    	feilkode=not(anyalnum(substr(kode(i),j,1)));
			if feilkode=1 then leave;
		end;
	  end;
	end;
  end;

  drop i j;
run;

/* For those with invalid Prosedyrekoder, flag if they are ATC or Særkoder */
data tmpdata;
  set tmpdata;
  tmp=0;
  if feilkode then do; /* if */

  array pros (*) $ &kode.:;
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


/* Results for Prosedyrekoder */
data feilpros;
  set tmpdata;
  where feilkode;
run;

data atc saer err;
  set feilpros;
  if atckode  then output atc;
  if saerkode then output saer;
  if atckode=. and saerkode=. then output err;
run;


%let dsid_feil=%sysfunc(open(feilpros));
%let nobs_feil=%sysfunc(attrn(&dsid_feil,nlobs));
%let dsid_feil=%sysfunc(close(&dsid_feil)); 

%let dsid_atc=%sysfunc(open(atc));
%let nobs_atc=%sysfunc(attrn(&dsid_atc,nlobs));
%let dsid_atc=%sysfunc(close(&dsid_atc)); 

%let dsid_saer=%sysfunc(open(saer));
%let nobs_saer=%sysfunc(attrn(&dsid_saer,nlobs));
%let dsid_saer=%sysfunc(close(&dsid_saer)); 

%let dsid_err=%sysfunc(open(err));
%let nobs_err=%sysfunc(attrn(&dsid_err,nlobs));
%let dsid_err=%sysfunc(close(&dsid_err)); 

%if &nobs_feil ne 0 %then %do;
title color= purple height=5 "7b: &nobs_feil linjer med ugyldige %upcase(&kode.) koder --
     &nobs_atc linjer med ATCkoder, &nobs_saer linjer med saerkoder, &nobs_err linjer med feil koder";
proc freq data=tmpdata;
  tables atckode saerkode/missing;
run;
%end;

%if &nobs_err ne 0 %then %do;
title color=red height=5 "Feil %upcase(&kode.) koder - Se datasett %upcase(<ugyldige_&kode.>)";
data ugyldige_&kode.;
  set tmpdata(keep= lopenr nc: atckode saerkode feilkode);
  where feilkode=1 and atckode=. and saerkode=. ;
run;
proc sql;
  create table m
      (note char(16));
  insert into m
     values("SJEKK DATASETT!!");
  select * 
 from m;
quit;
title;
%end;

%if &nobs_feil eq 0 %then %do;
title color= darkblue height=5  "7b: Prosedyrekode: Alle linjer med gyldige &kode. koder";
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

proc datasets nolist; delete tmpdata m ; run;

%mend;