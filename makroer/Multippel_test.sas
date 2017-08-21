%macro multippel_test(dsn1=,Nobs=,Ntot=,Gruppe=,rate_pr=,tittel=,gr1=,gr2=,print_log=);

/*!
multippel_test Makro - Opprettet 29/3-17 av Frank Olsen
endret 3/5-17 - Frank Olsen
For � teste om noen boomr�ders rater er forskjellige fra den totale raten for alle de aktuelle omr�dene
multippel_test(dsn1=,Nobs=,Ntot=,Gruppe=,rate_pr=,tittel=,gr1=,gr2=,print_log=)
Parametre:
1. dsn1: datasett man utf�rer analysen p� - som regel ett aggregert sett fra Rateprogrammet
2. Nobs: ratevariabelen - som regel vil det v�re "RateSnitt"
3. Ntot: Teller i raten, som regel vil dette v�re "Innbyggere"
4. Gruppe: Boomr�dene, dvs BOHF, BoShHN, BoRHF osv.
5. rate_pr: Fra innstillinger i Rateprogrammet, 1000, 10000 eller 100000 f.eks
6. tittel: Legg gjerne p� tittel (kommer i BOX i tabellen)
7. gr1 og gr2: Dersom du �nsker spesifikk test mellom to omr�der - skriv inn gr1=5 og gr2=7 f.eks
8. print_log: Settes lik 1 dersom man �nsker resultater fra den logistiske regresjonen
Resultat: tabell med 4 kolonner med p-verdier
Kolonne 1: Boomr�dene
Kolonne 2: R�-verdier: p-verdier for hvert omr�de ifht til totalen uten � justere for multippel testing
Kolonne 3: Bonferroni: p-verdier for hvert omr�de ifht til totalen justert for multippel testing vha Bonferroni (strengeste metode)
Kolonne 4: FDR: p-verdier for hvert omr�de ifht til totalen justert for multippel testing vha FDR - False Discovery Rate (vanligste metode)

[Info om metoden](http://support.sas.com/kb/22/571.html)
*/

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