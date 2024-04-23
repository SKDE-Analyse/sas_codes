%macro kontroll_tilstand(inndata=);
data tmpdata;
  set &inndata(keep=lopenr tilstand:);
run;


data ugyldige_diag misshdiag;
  set tmpdata;
  length feildiag $10;
  
  * flag lines with no hdiag;
  if tilstand_1_1 =' ' then output misshdiag;

  /*  Diagnosekoder */
  array diag[*] $ tilstand: ;
  feildiag=" ";
  do i=1 to dim(diag);
    if diag[i] ^= " " then do;
      if not prxmatch("/^([TYWXV]\d[nst])|([A-Z]\d\d)/", diag[i]) then do;
         /* Matching against a regular expression for ICD-10 codes */
         feildiag = diag[i];
         output ugyldige_diag;
      end;
    end;
	end;
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
   select * from m;
quit;
title;
%end;


* sjekk om det er data i tabell 'ugyldige_diag' - output i resultvindu ;
%let dsid1=%sysfunc(open(ugyldige_diag));
%let nobs_feildiag=%sysfunc(attrn(&dsid1,nlobs));
%let dsid1=%sysfunc(close(&dsid1)); 

%if &nobs_feildiag ne 0 %then %do;
title color= red height=5 "7a: Diagnosekode: &nobs_feildiag ugyldige diagnosekoder - Se datasett <ugyldige_diag> ";
proc freq data=ugyldige_diag order=freq;
  table feildiag / nocum;
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

proc datasets nolist; delete tmpdata m ; run;

%mend;