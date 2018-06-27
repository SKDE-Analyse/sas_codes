
%macro ugyldige_koder_icd_nc(mappe=NPR18., datasett=, aar=);
/* Lage én tabell som inneholder frekvens over ALLE NCMP-koder, NCSP-koder, ICD-10-koder o.l. */;

data FullAvd_&aar_long;
set &mappe.&datasett;
EpisodeId=_N_;
run;

/*ICD-10 */
proc transpose data=FullAvd_2015_long
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


/*NCSP */
proc transpose data=FullAvd_&aar_long;
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

/*NCMP */
proc transpose data=FullAvd_&aar_long;
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

/*NCRP */
proc transpose data=FullAvd_&aar_long;
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
%mend ugyldige_koder_icd_nc;