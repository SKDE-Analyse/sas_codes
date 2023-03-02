%macro kontroll_liggetid(inndata=);
data tmpdata;
  set &inndata(keep=lopenr liggetid inndato utdato);
  skde_liggetid=utdato-inndato;
  diff=skde_liggetid-liggetid;
run;
data diff_liggetid;
  set tmpdata;
  if skde_liggetid ne liggetid then output;
run;

%let dsid_diff=%sysfunc(open(diff_liggetid));
%let nobs_diff=%sysfunc(attrn(&dsid_diff,nlobs));
%let dsid_diff=%sysfunc(close(&dsid_diff)); 

%if &nobs_diff ne 0 %then %do;
title color= purple height=5 "8: &nobs_diff linjer med ulike liggetid";
proc freq data=tmpdata;
  tables diff;
run;
title;
%end;

%else %do;
title color= darkblue height=5  "8: liggetid - all is good!";
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