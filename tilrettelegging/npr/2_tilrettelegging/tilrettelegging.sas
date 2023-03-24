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
call symput ('sh_reg',varnum(dset,'sh_reg'));
call symput ('fag',varnum(dset,'fag'));
run;

%include "&filbane/formater/SKDE_somatikk.sas";
%include "&filbane/formater/NPR_somatikk.sas";

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
inn_sektor = compress(put(sektor,$3.));
drop sektor;

if inn_sektor = '1'   then ny_sektor = 1; /*TSB: Somatiske aktivitetsdata*/    
if inn_sektor = '2'   then ny_sektor = 2; /*VOP: Somatiske aktivitetsdata*/    
if inn_sektor = '3'   then ny_sektor = 3; /*BUP: Somatiske aktivitetsdata*/    
if inn_sektor = '4'   then ny_sektor = 4; /*Somatiske aktivitetsdata*/    
if inn_sektor = '5'   then ny_sektor = 5; /*Rehab*/
if inn_sektor = 'SOM' then ny_sektor = 6; /*Avtalespesialister, som*/
if inn_sektor = 'PHV' then ny_sektor = 7; /*Avtalespesialister, psyk*/

format ny_sektor fmt_sektor.;
rename ny_sektor = sektor;
drop inn_sektor; 
%end;  
run;

%if &sektor ne 0 %then %do;
proc sql noprint;
	select case when sektor in (6:7) then 1 end into: aspes
	from tmp_data;
quit;
%end;

/*---------*/
/* AVTSPES */
/*---------*/
data tmp_data;
set tmp_data;

%if &aspes eq 1 %then %do;
liggetid = 0;
hastegrad = 4;

%if &sh_reg ne 0 %then %do;
     if sh_reg=5 then AvtaleRHF=1; /*Helse Nord RHF*/     
else if sh_reg=4 then AvtaleRHF=2; /*Helse Midt-Norge RHF*/
else if sh_reg=3 then AvtaleRHF=3; /*Helse Vest RHF*/
else if sh_reg=7 then AvtaleRHF=4; /*Helse Sør-Øst-RHF*/
drop sh_reg;
%end;

%if &fag ne 0 %then %do;
    if Fag = 1 then Fag_SKDE = 1;
    if Fag = 2 then Fag_SKDE = 2;
    if Fag = 3 then Fag_SKDE = 3;
    if Fag = 4 then Fag_SKDE = 4;
    if Fag = 5 then Fag_SKDE = 5;
    if Fag in (6:10,24,25) then Fag_SKDE = 6;
    if Fag in (11:14) then Fag_SKDE = 11;
    if Fag = 15 then Fag_SKDE = 15;
    if Fag = 16 then Fag_SKDE = 16;
    if Fag = 17 then Fag_SKDE = 17;
    if Fag = 18 then Fag_SKDE = 18;
    if Fag = 19 then Fag_SKDE = 19;
    if Fag = 20 then Fag_SKDE = 20;
    if Fag = 21 then Fag_SKDE = 21;
    if Fag = 22 then Fag_SKDE = 22;
    if Fag = 23 then Fag_SKDE = 23;
    if Fag = 30 then Fag_SKDE = 30;
    if Fag = 31 then Fag_SKDE = 31;
drop fag;
%end;
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

%include "&filbane/tilrettelegging/npr/2_tilrettelegging/def_aspes_kontakt.sas";
%def_aspes_kontakt(inndata=tmp_data, utdata=tmp_data);
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

/* ------------------------ */
/* Length og label - LOL :D */
/* ------------------------ */

%include "&filbane/tilrettelegging/npr/2_tilrettelegging/length_label.sas";
%length_label(inndata=tmp_data)

/* -------------------------- */
/* Rekkefølge på variabler ut */
/* -------------------------- */
%include "&filbane/tilrettelegging/npr/2_tilrettelegging/var_rekkefolge.sas";
%if &aspes eq 1 %then %do;
%var_rekkefolge (innDataSett=tmp_data, utDataSett=tmp_data2, aspes=1);
%end;
%else %do;
%var_rekkefolge (innDataSett=tmp_data, utDataSett=tmp_data2, aspes=0);
%end;

%mend tilrettelegging;
