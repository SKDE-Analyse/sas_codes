/* sjekk mottatte variabler mot liste med vanlig type og verdi for variablene */

%macro kontroll_type_lengde(inndata=);

proc contents data=&inndata. noprint out=varlist (keep=name type length); run;
data varlist; set varlist;	name=lowcase(name);run;

proc sql;
	create table xyz_vars as
	select a.name as tilrette_var, a.type as tilrette_type, a.length as tilrette_lengde, 
								 b.type as ref_type, b.length as ref_lengde,
			case when a.name ne b.name then 1 end as ikke_i_ref_liste,
			case when a.type ne b.type and b.type ne . then 1 end as ulik_type,
			case when a.length ne b.length and b.length ne . then 1 end as ulik_lengde
	from varlist a
	left join hnref.variabler_type_lengde_tilrette b
	on a.name=b.name;
quit;

proc sql;
	create table xyz_vars_ulik as
    select *
    from xyz_vars
    where ikke_i_ref_liste eq 1 or ulik_type eq 1 or ulik_lengde eq 1;
quit;

%let dsid=%sysfunc(open(xyz_vars_ulik));
%let nobs3=%sysfunc(attrn(&dsid,any));
%let dsid=%sysfunc(close(&dsid));  

%if &nobs3 eq 0 %then %do;
title color=darkblue height=5 "Variabler, type og lengde. Alle er lik referanseliste";
proc print data=xyz_vars; run;
%end;

%if &nobs3 ne 0 %then %do;
title color=purple height=5 "Variabler, type og lengde. Sjekk opp de som ikke er i ref.liste, har ulik type eller lengde.";
proc print data=xyz_vars; where ikke_i_ref_liste eq 1 or ulik_type eq 1 or ulik_lengde eq 1;run;
%end;

proc datasets nolist; delete varlist xyz_vars xyz_vars_ulik ; run;
%mend kontroll_type_lengde;