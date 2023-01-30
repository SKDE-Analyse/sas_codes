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

/* ----------------------- */
/* tilstand -> hdiag/bdiag */
/* ----------------------- */

%if &tilstand_1_1 ne 0 or &tilstand_1_2 ne 0 or &tilstand_2_1 ne 0 %then %do;
array tilstand(*) $ tilstand:;
do i = 1 to dim(tilstand);
  tilstand(i)=upcase(compress(tilstand(i),"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890","ki")); /*The modifier "ki" means Keep the characters in the list and Ignore the case of the characters */
end;

%if &tilstand_1_1 ne 0 %then %do;
hdiag=tilstand_1_1;
/* ICCD10 */
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/icd10.sas";
%icd;
%end;

%if &tilstand_1_2 ne 0 %then %do;
hdiag2=tilstand_1_2;
%end;

%if &tilstand_2_1 ne 0 %then %do;
array bdiag{*} $ bdiag1-bdiag19 ;
array bTilstand{*} $ tilstand_2_1 -- tilstand_20_1;
do i=1 to dim(bTilstand);
    bdiag{i}=(bTilstand{i});
end;
%end; 

drop tilstand_: i;
%end;

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