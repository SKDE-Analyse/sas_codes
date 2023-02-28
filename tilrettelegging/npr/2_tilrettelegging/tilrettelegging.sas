﻿%macro tilrettelegging(inndata=);

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
call symput ('lopenr',varnum(dset,'lopenr'));
call symput ('drg',varnum(dset,'drg'));
call symput ('drg_type',varnum(dset,'drg_type'));
call symput ('innmateHast',varnum(dset,'innmateHast'));
call symput ('episodefag',varnum(dset,'episodefag'));
call symput ('aar',varnum(dset,'aar'));
call symput ('fodselsar',varnum(dset,'fodselsar'));
call symput ('kjonn',varnum(dset,'kjonn'));
call symput ('alderidager',varnum(dset,'alderidager'));
call symput ('behandlingsstedkode',varnum(dset,'behandlingsstedkode'));
call symput ('institusjonid',varnum(dset,'institusjonid'));
call symput ('sektor',varnum(dset,'sektor'));
call symput ('takst_1',varnum(dset,'takst_1'));
run;

%include "&filbane/formater/SKDE_somatikk.sas";

data tmp_data;
set &inndata;

/*-----*/
/* PID */
/*-----*/
%if &lopenr ne 0 %then %do;
pid=lopenr;
drop lopenr;
%end;

/*-----*/
/* DRG */
/*-----*/
%if &drg ne 0 %then %do;
	drg=upcase(compress(drg));
%end;

/*-----------*/
/* HASTEGRAD */
/*-----------*/
%if &innmateHast ne 0 %then %do;
    if innmateHast in (1,2,3)   then hastegrad=1; /*Akutt*/
    if innmateHast=4            then hastegrad=4; /*Planlagt*/
    if innmateHast=5            then hastegrad=5; /*Tilbakeføring av pasient fra annet sykehus (gjelder fra 2016)*/
    format hastegrad hastegrad.;

    %if &drg_type ne 0 %then %do;
             if drg_type='M' and hastegrad=4 /*Planlagt*/   then drgtypehastegrad=1;
        else if drg_type='M' and hastegrad=1 /*Akutt*/      then drgtypehastegrad=2;
        else if drg_type='K' and hastegrad=4 /*Planlagt*/   then drgtypehastegrad=3;
        else if drg_type='K' and hastegrad=1 /*Akutt*/      then drgtypehastegrad=4;
        if drg_type=' ' then drgtypehastegrad=9;
        if hastegrad=.  then drgtypehastegrad=9;
        format drgtypehastegrad drgtypehastegrad.; 
    %end;
     drop innmateHast;
%end;

/*------------*/
/* EPISODEFAG */
/*------------*/
%if &episodefag ne 0 %then %do;
    episodefag_ny=put(episodefag,3.);
		if lengthn(compress(episodefag)) = 2 then episodefag_ny = compress("0"||episodefag);
		if episodefag_ny in ("0","950") then episodefag_ny="999";
	drop episodefag;
    rename episodefag_ny=episodefag;
%end;

/*--------------------*/
/* FØDSELSÅR OG ALDER */
/*--------------------*/
%if &fodselsar ne 0 and &aar ne 0 %then %do;
/*If year and month from persondata (DSF) is available and valid, then use it as primary source */
tmp_alder=aar-fodtAar_DSF;
if fodtAar_DSF > 1900 and 0 <= tmp_alder <= 110 then fodselsar=fodtAar_DSF;
/* if fødselsår is still invalid */
if fodselsar > aar or fodselsar=. then fodselsar=9999;
if aar-fodselsar > 110 then fodselsar=9999;
/*Definerer Alder basert på Fodselsår*/
alder=aar-fodselsar;
if fodselsar=9999 then alder=.; 
drop tmp_alder fodtAar_DSF;
%end;

/*--------*/
/* ERMANN */
/*--------*/
%if &kjonn ne 0 %then %do;
    if kjonn eq 1     then ermann=1; /* Mann */
    if kjonn eq 2     then ermann=0; /* Kvinne */
    if kjonn in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ermann=.;

    if kjonn_dsf in (1,2) then do; /*hvis kjonn_dsf bruke den i stedet for kjonn*/
	if kjonn_dsf = 1 then ermann = 1;
	if kjonn_dsf = 2 then ermann = 0;
    end;
drop kjonn kjonn_dsf;
format ermann ermann.;
%end;

/*-------------*/
/* ALDERIDAGER */
/*-------------*/
%if &alderidager ne 0 %then %do;
if alderidager < 0 then alderidager=.;
%end;

/*-------------*/
/* SEKTOR      */
/*-------------*/

%if &sektor ne 0 %then %do;
rename sektor=inn_sektor;
if inn_sektor = 4     then sektor = 1; /*Somatiske aktivitetsdata*/    
if inn_sektor = 5     then sektor = 1; /*Rehab*/
if inn_sektor = 'SOM' then sektor = 5; /*Avtalespesialister, som*/
if inn_sektor = 'PHV' then sektor = 4; /*Avtalespesialister, psyk*/

if sektor in (4,5) then do;
%let aspes=1;
end;

drop inn_sektor; 
format sektor sektor.;
%end;  

run;

/*---------------*/
/* Tilstandkoder */
/*---------------*/

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

/* -------- */
/* Takst    */
/* -------- */
%if &takst_1 ne 0 and &aspes=1 %then %do; 
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/takst.sas";
%takst(inndata=tmp_data);
%end;

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

/* --------- */
/* Behandler */
/* --------- */
%if &behandlingsstedkode ne 0 and &institusjonid ne 0 %then %do;
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/behandler.sas";
%behandler(inndata=tmp_data , beh=behandlingsstedkode);
%end;

%mend tilrettelegging;