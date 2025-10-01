/* sjekk mottatte variabler mot liste med vanlig type, lengde, format (tlf) og verdi for variablene */

%macro kpr_type_lengde_format;

proc contents data=&inn. noprint out=varlist (keep=name type length format); run;
data varlist; set varlist;	name=lowcase(name);run;


proc sort data=varlist;  by name; run;
proc sort data=hnref.var_tlf_mot_kpr_enkreg; by name;

data xyz_vars;
  merge varlist(in=a rename=(type=type_mot length=length_mot format=format_mot)) 
        hnref.var_tlf_mot_kpr_enkreg(in=b rename=(type=type_ref length=length_ref format=format_ref));
  by name;
  if a;
  if a and not b then ikke_i_ref_liste=1;
  if type_mot ne type_ref then ulik_type=1;
  if length_mot ne length_ref then ulik_lengde=1;
  if format_mot ne format_ref then ulik_format=1;
run;
proc sql;
	create table xyz_vars_ulik as
    select *
    from xyz_vars
    where ikke_i_ref_liste eq 1 or ulik_type eq 1 or ulik_lengde eq 1 or ulik_format eq 1;
quit;

%let dsid=%sysfunc(open(xyz_vars_ulik));
%let nobs3=%sysfunc(attrn(&dsid,any));
%let dsid=%sysfunc(close(&dsid));  

%if &nobs3 eq 0 %then %do;
title color=darkblue height=5 "8: variabler, type. Alle er lik referanseliste";
proc print data=xyz_vars; run;
%end;

%if &nobs3 ne 0 %then %do;
title color=purple height=5 "8: variabler, type. Sjekk opp de som ikke er i ref.liste eller som har ulik type.";
proc print data=xyz_vars; 
  where ikke_i_ref_liste eq 1 or ulik_type eq 1 or ulik_lengde eq 1 or ulik_format eq 1;
run;
%end;

proc datasets nolist; delete varlist xyz_vars xyz_vars_ulik ; run; 
%mend kpr_type_lengde_format;