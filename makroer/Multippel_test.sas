%macro multippel_test(dsn1=,Nobs=,Ntot=,Gruppe=,rate_pr=,tittel=,gr1=,gr2=,print_log=);
data dsn1;
set &dsn1;
where &gruppe ne 8888;
Npos=&Nobs*&Ntot/&rate_pr;
rename &Ntot=Ntotal;
keep &Nobs &Ntot &Gruppe Npos modell Ntotal;
run;

%if &print_log=1 %then %do;
proc logistic data=dsn1;
class &Gruppe / param=glm;
model Npos/Ntotal = &Gruppe;
lsmeans &Gruppe / ilink diff=anom adjust=bon;
lsmeans &Gruppe / ilink diff=all;
ods output Diffs=dsn1p;
run;
%end;

%if &print_log ne 1 %then %do;
ods selct none;
proc logistic data=dsn1;
class &Gruppe / param=glm;
model Npos/Ntotal = &Gruppe;
lsmeans &Gruppe / ilink diff=anom adjust=bon;
lsmeans &Gruppe / ilink diff=all;
ods output Diffs=dsn1p;
run;
ods select all;
%end;

data dsn1p;
set dsn1p;
 rename Probz=Raw;
tittel="Multippel testing, p-verdier";
run;

proc multtest inpvalues(Raw)=dsn1p bon fdr out=dsn1MT noprint;
class &gruppe;
run;

PROC TABULATE DATA=dsn1MT;
where anomdiff="Yes";	
	VAR Raw bon_p fdr_p;
	CLASS &gruppe /	ORDER=UNFORMATTED MISSING; 
	class tittel;
	TABLE  &gruppe={LABEL=""}, tittel={LABEL=""}*(
		Raw={LABEL="R�-verdier" s={just=c}}*Sum={LABEL=""}*{s={just=c cellwidth=80}}*F=pvalue7.4 
		bon_p={LABEL="Bonferroni" s={just=c}}*Sum={LABEL=""}*{s={just=c cellwidth=80}}*F=pvalue7.4 
		fdr_p={LABEL="FDR" s={just=c}}*Sum={LABEL=""}*{s={just=c cellwidth=80}}*F=pvalue7.4)
/ BOX={LABEL="&tittel" STYLE={JUST=LEFT}} ;
RUN;

%if &gr1>0 %then %do;
PROC TABULATE DATA=dsn1MT;
	WHERE((&gruppe = &gr1 AND _&gruppe = &gr2) or (&gruppe = &gr2 AND _&gruppe = &gr1));	
	VAR Raw bon_p fdr_p;
	CLASS &gruppe /	ORDER=UNFORMATTED MISSING;
	CLASS _&gruppe /	ORDER=UNFORMATTED MISSING;
	class tittel;
	TABLE &gruppe={LABEL=""}*_&gruppe={LABEL=""}, tittel={LABEL=""}*(
		Raw={LABEL="R�-verdier" s={just=c}}*Sum={LABEL=""}*{s={just=c cellwidth=80}}*F=pvalue7.4 
		bon_p={LABEL="Bonferroni" s={just=c}}*Sum={LABEL=""}*{s={just=c cellwidth=80}}*F=pvalue7.4 
		fdr_p={LABEL="FDR" s={just=c}}*Sum={LABEL=""}*{s={just=c cellwidth=80}}*F=pvalue7.4)
/ BOX={LABEL="&tittel, &gruppe vs &gruppe" STYLE={JUST=LEFT}} ;
RUN;
%end;

proc datasets nolist;
delete dsn1:;
run; 
%mend multippel_test;