/*macro for å tilrettelege pers id ventesiste - før kjøre denne macro det er lurt å skjekke hvis alle behandlingssted
er registrert i behandler tabellen - kode for dette her: */

/*%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
%include "&filbane/tilrettelegging/npr/1_kontroll_foer_tilrette/kontroll_behandlingssted.sas";

data cont_vent;
set HNMOT.VENTELISTE_2024_11;

behandlingsstedkode_n = input(behandlingsstedkode, best9.);
format behandlingsstedkode_n best9.;
drop behandlingsstedkode;
rename behandlingsstedkode_n = behandlingsstedkode;
run;

%kontroll_behandlingssted(inndata=cont_vent, beh=behandlingsstedkode)
*/

%macro tilrettelegging_vent(inndata=, utdata=,periode=);



%include "&filbane/formater/SKDE_somatikk.sas";
%include "&filbane/formater/NPR_somatikk.sas";

/*strip variables fra NULL som string og erstatte med sas missing*/
data temp1;
  set &inndata;
  array c _character_;
  do over c;
    if not missing(c) then do;
      if upcase(strip(c)) in ('NULL','(NULL)','<NULL>') then call missing(c);
    end;
  end;
run;

data temp2;
set temp1;

/* Convert behandlingsstedkode (char → num) */
behandlingsstedkode_n = input(behandlingsstedkode, best9.);
format behandlingsstedkode_n best9.;
drop behandlingsstedkode;
rename behandlingsstedkode_n = behandlingsstedkode;


komnrhjem2=komm_nr;

format bydel2 best9.;
bydel2 = bydel_DSF;
if bydel2 = . then bydel2=0;

drop  komnr komm_nr komNrHjem_DSF bydel_DSF bydel ;

run;

/* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
data _null_;
dset=open("temp2");
call symput ('komnrhjem2',varnum(dset,'komnrhjem2'));
call symput ('bydel2',varnum(dset,'bydel2'));
call symput ('lopenr',varnum(dset,'lopenr'));
call symput ('aar',varnum(dset,'aar'));
call symput ('fodselsAar_ident',varnum(dset,'fodselsAar_ident'));
call symput ('kjonn_kode',varnum(dset,'kjonn_kode'));
call symput ('behandlingsstedkode',varnum(dset,'behandlingsstedkode'));
call symput ('institusjonid',varnum(dset,'institusjonid'));
call symput ('fagenhetkode',varnum(dset,'fagenhetkode'));
call symput ('fagomr_kode',varnum(dset,'fagomr_kode'));

run;

%let length_list_4 =
  ANS_DATO AVVIKL_DATO DATOEPISODE1 DATOEPISODE2 DATOEPISODE3 DATOEPISODE4
  DATOEPISODE5 DATOEPISODE6 DATOEPISODE21 DATOEPISODE22 HENV_DATO NYHENV_DATO
  UTSETTDATO1 UTSETTDATO3 UTSETTDATO4 UTSETTDATO5 UTSETTDATO6
  UTSETTDATO21 UTSETTDATO22 VURD_DATO datoFormidlet dodDato_ident FRISTSTARTBEHANDLING ;

%let length_list_8 = 
 ALDER AVD_KODE AVVIKL_KODE AV_IKKE_ORD AV_KODE AV_KODE_UTSATT BEHANDLINGSSTEDKODE BYDEL
FORTSATT_KODE FORTSATT_KODE_UTSATT FRISTBRUDD HENVFRAHPR
HENVFRAINSTITUSJONID HENVFRATJENESTE HENVTILHPR HENVTILINSTITUSJONID HENVTILTJENESTE
HENV_TYPE INST_NR Intern_ventetid KJONN_KODE
KOMM_NR NY_HENVIST NY_KODE OMSNIVAA_KODE PASIENT_NR RAPPORTERTRETTTILHELSEHJELP RHF
SLETTE_KODE TERTIAL UTSETTKODE1 UTSETTKODE3 UTSETTKODE4 UTSETTKODE5 UTSETTKODE6 UTSETTKODE21
UTSETTKODE22 VENTETID Ventetid_median avdelingReshID bydel_DSF debitor debitorHenvisning
emigrert_DSF fagenhetReshID aar fodselsAar_ident hf institusjonID kjonn_ident komNrHjem_DSF
lopenr mnd tjenesteenhetReshID varslingHelfo;

/* Convert character to numeric variables */
%macro char_dates_to_numeric(ds, vars, informat=, format=, out=);
  %local lib mem clean i item inlist;

  /* Resolve lib/mem and OUT */
  %if %index(&ds,.) %then %do;
    %let lib=%upcase(%scan(&ds,1,.));
    %let mem=%upcase(%scan(&ds,2,.));
  %end;
  %else %do;
    %let lib=WORK; %let mem=%upcase(&ds);
  %end;
  %if %superq(out)= %then %let out=&ds;

  /* Clean the incoming list: remove quotes/commas, collapse spaces */
  %let clean=%sysfunc(compbl(%sysfunc(compress(&vars,%str(%',)))));
  /* Build an IN(...) list of uppercased names: "A","B","C" */
  %let i=1; %let inlist=;
  %do %while(%length(%scan(&clean,&i,%str( ))));
    %let item=%upcase(%scan(&clean,&i,%str( )));
    %let inlist=&inlist%sysfunc(ifc(%length(&inlist),%str(, ),));
    %let inlist=&inlist"%superq(item)";
    %let i=%eval(&i+1);
  %end;

  /* Keep only variables that actually exist and are character */
  proc sql noprint;
    select name into :_todo separated by ' '
    from dictionary.columns
    where libname="&lib" and memname="&mem" and type='char'
      %if %length(&inlist) %then %do; and upcase(name) in (&inlist) %end;
  ;
  quit;

  %if %superq(_todo)= %then %do;
    %put NOTE: No matching character variables to convert in &ds..;
    %return;
  %end;

  /* Convert in one pass; invalid dates -> missing (?? suppresses notes) */
  data &out;
    set &ds;
    %let i=1;
    %do %while(%length(%scan(&_todo,&i,%str( ))));
      %let item=%scan(&_todo,&i,%str( ));
	length __cdtn_&item 8;
	__cdtn_&item = input(&item, ?? &informat);
	format __cdtn_&item &format;   /* <= apply to the numeric temp */
	drop &item;
	rename __cdtn_&item = &item;               /* e.g., YYMMDD10. */
      %let i=%eval(&i+1);
    %end;
  run;
%mend;



%char_dates_to_numeric(
  ds=temp2,
  vars=&length_list_4,
  informat=yymmdd10.,
  format=YYMMDD10.,
  out=temp3
);



%char_dates_to_numeric(
  ds=temp3,
  vars=&length_list_8,
  informat=best32.,
  format=BEST12.,
  out=temp4
);


data tmp_data;
set temp4;

/*-----*/
/* PID */
/*-----*/
%if &lopenr ne 0 %then %do;
pid=lopenr;
drop lopenr;
%end;


/*--------------*/
/* FAGENHETKODE */
/*--------------*/
%if &fagenhetkode ne 0 %then %do;
    fagenhetkode_ny=put(fagenhetkode,5.);
		if lengthn(compress(fagenhetkode)) = 2 then fagenhetkode_ny = compress("0"||fagenhetkode);
		drop fagenhetkode;
   rename fagenhetkode_ny=fagenhetkode;
%end;

/*-----------*/
/* FAGOMRADE */
/*-----------*/
%if &fagomr_kode ne 0 %then %do;
    fagomrade=put(fagomr_kode,3.);
		if lengthn(compress(fagomrade)) = 2 then fagomrade = compress("0"||fagomrade);
		drop fagomr_kode; 
%end;



/*--------------------*/
/* FØDSELSÅR OG ALDER */
/*--------------------*/
%if &fodselsAar_ident ne 0 and &aar ne 0 %then %do;
/*data har original alder variabel som er beregnet av noen...*/
/*If year and month from persondata (DSF) is available and valid, then use it as primary source or give those values to alder */
tmp_alder=aar-fodselsAar_ident;
if fodselsAar_ident > 1900 and 0 <= tmp_alder <= 110 then alder=aar-fodselsAar_ident;
drop tmp_alder fodselsAar_ident;
%end;



/*--------*/
/* ERMANN */
/*--------*/
%if &kjonn_kode ne 0 %then %do;
    if kjonn_kode eq 1     then ermann=1; /* Mann */
    if kjonn_kode eq 2     then ermann=0; /* Kvinne */
    if kjonn_kode in (0, 9) /* 0='Ikke kjent', 9='Ikke spesifisert'*/ then ermann=.;

    if kjonn_ident in (1,2) then do; /*hvis kjonn_dsf bruke den i stedet for kjonn*/
	if kjonn_ident = 1 then ermann = 1;
	if kjonn_ident = 2 then ermann = 0;
    end;
drop kjonn_kode kjonn_ident;
format ermann ermann.;
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


/*lage labels*/
data &utdata; set tmp_data;
label aar = 'År';
label ans_dato = "Ansiennitetsdato";
label INSTITUSJONID = "InstitusjonId";
label HENVFRAINSTITUSJONID ='Henvist fra institusjon (NPK)';
label henvtilinstitusjonID ='Henvist til institusjon (NPK)';
label HENVFRATJENESTE = 'Henvist fra tjeneste (NPR-melding)';
label HENVTILTJENESTE = 'Henvist til tjeneste (NPR-melding)';
label BEHANDLINGSSTEDKODE ='Behandlingssted kode (NPR-melding)';
label avd_kode = 'RESH-id Avdeling';
label henv_type ='Henvisningstype';
label OMSNIVAA_KODE = 'Omsorgsnivå';
label fagomrade = 'Fagområde';
label fagenhetkode = 'Fagenhetkode';
label RAPPORTERTRETTTILHELSEHJELP = 'Rett til helsehjelp';
label debitor = 'Debitor';
label nyhenv_dato ='Mottaksdato';
label Vurd_dato = 'Vurderingsdato';
label UTSETTDATO1 = 'UTSETTDATO1. Utsettelsen av kapasitetsgrunner';
label UTSETTDATO3 = 'UTSETTDATO3. Pasienten har ikke møtt opp';
label UTSETTDATO4 = 'UTSETTDATO4. Pasientbestemt utsettelsen av velferdsgrunner';
label UTSETTDATO5 = 'UTSETTDATO5. Medisinske årsaker hos pasienten til utsettelsen';
label UTSETTDATO6 = 'UTSETTDATO6. Manglende kapasitet ved påfølgende behandlingssted';
label UTSETTDATO21 = 'UTSETTDATO21. Pasienten har takket nei til tilbud fra HF';
label UTSETTDATO22 = 'UTSETTDATO22. Pasienten har takket nei til tilbud fra Helfo';
label UTSETTKODE1 = 'UTSETTKODE1. Utsettelsen av kapasitetsgrunner';
label UTSETTKODE3 = 'UTSETTKODE3. Pasienten har ikke møtt opp';
label UTSETTKODE4 = 'UTSETTKODE4. Pasientbestemt utsettelsen av velferdsgrunner';
label UTSETTKODE5 = 'UTSETTKODE5. Medisinske årsaker hos pasienten til utsettelsen';
label UTSETTKODE6 = 'UTSETTKODE6. Manglende kapasitet ved påfølgende behandlingssted';
label UTSETTKODE21 = 'UTSETTKODE21. Pasienten har takket nei til tilbud fra HF';
label UTSETTKODE22 = 'UTSETTKODE21. Pasienten har takket nei til tilbud fra Helfo';
label henv_dato = 'Henvisningsdato';
label avvikl_dato = 'Ventetid sluttdato';
label avvikl_kode ='Ventetid sluttkode';
label fristStartBehandling = 'Frist for nødvendig helsehjelp';
label fristbrudd = 'fristbrudd' ;
label AV_KODE = 'Antall påbegynt helsehjelp';
label AV_IKKE_ORD ='Antall påbegynt helsehjelp ikke ordinært';
label BoHF ='BoHF';
label BoRHF ='BoRHF';
label Bosh ='Bosh';
label BehHF ='BehHF';
label BehRHF ='BehRHF';
label fortsatt_kode = 'Antall ventende';
label ny_henvist = 'Antall nyhenviste';
label VENTETID = 'Ventetid påbegynt helsehjelp'; 
label Intern_ventetid = 'Intern ventetid';
label SLETTE_KODE = 'Slettekode';
label AV_KODE_UTSATT = 'Antall avviklet med utsettelseskode';
label FORTSATT_KODE_UTSATT = 'Ventende med utsettelsekode';

rename OMSNIVAA_KODE = OMSORGSNIVA;

periode=&periode;
format periode YYMMDD10.;

run;

%mend tilrettelegging_vent;