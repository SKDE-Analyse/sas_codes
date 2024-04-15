/* sjekk mottatte variabler mot liste med vanlig type og verdi for variablene */

%macro kontroll_type(inndata=);

proc contents data=&inndata. noprint out=varlist (keep=name type); run;
data varlist; set varlist;	name=lowcase(name);run;

proc sql;
	create table xyz_vars as
	select a.name as mottatt_var, a.type as mottatt_type,
								 b.type as ref_type,
			case when a.name ne b.name then 1 end as ikke_i_ref_liste,
			case when a.type ne b.type and b.type ne . then 1 end as ulik_type,
			b.kommentar
	from varlist a
	left join hnref.variabler_type_mottatt b
	on a.name=b.name;
quit;

proc sql;
	create table xyz_vars_ulik as
    select *
    from xyz_vars
    where ikke_i_ref_liste eq 1 or ulik_type eq 1;
quit;

%let dsid=%sysfunc(open(xyz_vars_ulik));
%let nobs3=%sysfunc(attrn(&dsid,any));
%let dsid=%sysfunc(close(&dsid));  

%if &nobs3 eq 0 %then %do;
title color=darkblue height=5 "4: variabler, type. Alle er lik referanseliste";
proc print data=xyz_vars; run;
%end;

%if &nobs3 ne 0 %then %do;
title color=purple height=5 "4: variabler, type. Se kommentarer for variabler med ulik_type = 1. Noen fikses i tilretteleggingen, andre må fikses manuelt. Hvis variabel ikke i referanseliste -> spør en venn!";
proc print data=xyz_vars; where ikke_i_ref_liste eq 1 or ulik_type eq 1;run;
%end;

proc datasets nolist; delete varlist xyz_vars xyz_vars_ulik ; run;
%mend kontroll_type;