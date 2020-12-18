options minoperator mindelimiter=',';

%macro ugyldige_koder_icd_nc(mappe=NPR18., datasett=, aar=);
/* Lage én tabell som inneholder frekvens over ALLE NCMP-koder, NCSP-koder, ICD-10-koder o.l. */;

data FullAvd_&aar._long;
set &mappe.&datasett;
EpisodeId=_N_;
run;

/*ICD-10 */
proc transpose data=FullAvd_&aar._long
out=icd (drop=_NAME_ rename=(COL1=tilstand));
var tilstand:;
by EpisodeId;
run;

data icd;
set icd;
format tilstand $icd_&aar.F.;
Run;
 
PROC FREQ DATA=icd
     ORDER=INTERNAL;
     TABLES tilstand /  SCORES=TABLE;
RUN;

proc datasets nolist;
delete icd;
run;

/*NCSP */
proc transpose data=FullAvd_&aar._long
out=NCSP (drop=_NAME_ rename=(COL1=ncsp));
var ncsp:;
by EpisodeId;
run;

data NCSP;
set NCSP;
format ncsp $ncsp_&aar.F.; 
Run;
 
PROC FREQ DATA=NCSP
     ORDER=INTERNAL;
     TABLES ncsp /  SCORES=TABLE;
RUN;

proc datasets nolist;
delete ncsp;
run;

/*NCMP */
proc transpose data=FullAvd_&aar._long
out=NCMP (drop=_NAME_ rename=(COL1=ncmp));
var ncmp:;
by EpisodeId;
run;

data NCMP;
set NCMP;
format ncmp $ncmp_&aar.F.; 
Run;
 
PROC FREQ DATA=NCMP
     ORDER=INTERNAL;
     TABLES ncmp /  SCORES=TABLE;
RUN;

proc datasets nolist;
delete ncmp;
run;

%if &aar in (2016,2017) %then %do;
/*NCRP */
proc transpose data=FullAvd_&aar._long
out=NCRP (drop=_NAME_ rename=(COL1=ncrp));
var ncrp:;
by EpisodeId;
run;

data NCRP;
set NCRP;
format ncrp $ncrp_&aar.F.; 
Run;
 
PROC FREQ DATA=NCRP
     ORDER=INTERNAL;
     TABLES ncrp /  SCORES=TABLE;
RUN;


proc datasets nolist;
delete ncrp;
run;

%end;

%mend ugyldige_koder_icd_nc;