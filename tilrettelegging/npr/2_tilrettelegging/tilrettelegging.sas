%macro tilrettelegging(inndata=);

/* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
data _null_;
dset=open("&inndata");
call symput ('komnrhjem2',varnum(dset,'komnrhjem2'));
call symput ('bydel2',varnum(dset,'bydel2'));
call symput ('ncmp_1',varnum(dset,'ncmp_1'));;
call symput ('ncsp_1',varnum(dset,'ncsp_1'));;
call symput ('ncrp_1',varnum(dset,'ncrp_1'));;
call symput ('tilstand_1_1',varnum(dset,'tilstand_1_1'));
call symput ('tilstand_1_2',varnum(dset,'tilstand_1_2'));
call symput ('tilstand_2_1',varnum(dset,'tilstand_2_1'));
run;

data tmp_data;
set &inndata;
run;

%if &tilstand_1_1 ne 0 %then %do;
/* hdiag */
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/tilstandskoder.sas";
%tilstandskoder(inndata=tmp_data, hoved=1);
/* ICD10 */
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/icd10.sas";
%ICD(inndata=tmp_data);
%end;

%if &tilstand_1_2 ne 0 %then %do;
/* hdiag2 */
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/tilstandskoder.sas";
%tilstandskoder(inndata=tmp_data, hoved=2);
%end;

%if &tilstand_2_1 ne 0 %then %do;
/* bdiag */
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/tilstandskoder.sas";
%tilstandskoder(inndata=tmp_data, hoved=0);
%end; 

/* drop tilstandskoder fra tilrettelagte data */
data tmp_data;
set tmp_data;
drop tilstand_:;
run;

/* ----------- */
/* Forny-komnr */
/* ----------- */
%if &komnrhjem2 ne 0 %then %do;
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=tmp_data, kommune_nr=komnrhjem2);
%end;

/* ---------- */
/* Lage bydel */
/* ---------- */
%if &bydel2 ne 0 %then %do;
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/bydel.sas";
%bydel(inndata=tmp_data, bydel=bydel2);
%end;

/* ---------- */
/* Boomraader */
/* ---------- */
%if &komnrhjem2 ne 0 and &bydel2 ne 0 %then %do;
%include "&filbane/makroer/boomraader.sas";
%boomraader(inndata=tmp_data, indreOslo = 0, bydel = 1);
%end;

/* -------- */
/* NC-koder */
/* -------- */
%if &ncsp_1 ne 0 %then %do; 
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/nc_koder.sas";
%nc_koder(inndata=tmp_data, xp=sp);
%end;
%if &ncmp_1 ne 0 %then %do; 
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/nc_koder.sas";
%nc_koder(inndata=tmp_data, xp=mp);
%end;
%if &ncrp_1 ne 0 %then %do; 
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/nc_koder.sas";
%nc_koder(inndata=tmp_data, xp=rp);
%end;



%mend tilrettelegging;