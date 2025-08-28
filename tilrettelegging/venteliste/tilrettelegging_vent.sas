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

/* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
data _null_;
dset=open("&inndata");
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

format komnrhjem2 best9.;
komnrhjem2=komNrHjem_DSF;

format bydel2 best9.;
bydel2 = bydel_DSF;

drop  komnr komm_nr komNrHjem_DSF bydel_DSF bydel ;

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
HENV_DATO HENV_TYPE INST_NR Intern_ventetid KJONN_KODE
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

    if kjonn_ident in ('1','2') then do; /*hvis kjonn_dsf bruke den i stedet for kjonn*/
	if kjonn_ident = '1' then ermann = 1;
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
label aar = 'Året ventelistegrunnlaget ble innrapportert';
label ans_dato = "Den første mottaksdato for en henvisning i kjeden av mottaksdatoer i offentlig spesialisthelsetjeneste";
label INSTITUSJONID = "InstitusjonId identifiserer rapporteringsenheten";
label HENVFRAINSTITUSJONID ='Den instans, helseinstitusjon eller enkeltlege som har utstedt henvisningen: INSTITUSJONID';
label henvtilinstitusjonID ='Den instans, helseinstitusjon eller enkeltlege som mottar henvisningen ved utskrivning, viderehenvisning eller overføring';
label HENVFRATJENESTE = 'Grov klassifisering av institusjoner innen helsevesenet og andre institusjoner i samfunnet som har henvist pasient';
label HENVTILTJENESTE = 'Grov klassifisering av institusjoner innen helsevesenet og andre institusjoner i samfunnet som mottar henvisningen ved utskrivning, viderehenvisning eller overføring';
label BEHANDLINGSSTEDKODE ='Behandlingssted skal rapporteres med informasjon om organisasjonsnummer tilsvarende bedrift (bedriftsnummer) slik det fremkommer i Enhetsregisteret i Brønnøysund';
label avd_kode = 'Avdeling rapporteres med reshID og avdelingskode: 3 sifer ';
label henv_type ='Henvisningens type';
label OMSNIVAA_KODE = 'Grov kategorisering av ressursinnsats som anses som nødvendig';
label fagomrade = 'Konklusjon på vurdering av hvilket fag som er nødvendig';
label fagenhetkode = 'Fagenhet har det faglige ansvaret for pasientbehandlingen';
label RAPPORTERTRETTTILHELSEHJELP = 'Angir om pasienten har rett til nødvendig helsehjelp eller ikke';
label debitor = 'Klassifikasjon/identifikasjon av finansieringsordninger med videre';
label nyhenv_dato ='Dato for mottak av henvisning/søknad ved helseforetaket - mottaksdato';
label Vurderingsdato = 'Den dato vurderingsinstansen vurderte henvisningen';
label UTSETTDATO1 = 'Dato. Institusjonen/sykehuset har bestemt utsettelsen av kapasitetsgrunner';
label UTSETTDATO3 = 'Dato. Pasienten har ikke møtt opp';
label UTSETTDATO4 = 'Dato. Pasienten har selv bestemt utsettelsen av velferdsgrunner';
label UTSETTDATO5 = 'Dato. Medisinske årsaker hos pasienten til utsettelsen';
label UTSETTDATO6 = 'Dato. Oppstart av helsehjelp er utsatt grunnet manglende kapasitet ved påfølgende behandlingssted';
label UTSETTDATO21 = 'Dato. Pasienten har takket nei til tilbud fra HF om helsehjelp ved annet behandlingssted enn sitt primære ønske';
label UTSETTDATO22 = 'Dato. Pasienten har takket nei til tilbud fra Helfo om helsehjelp ved annet behandlingssted enn sitt primære ønske';
label UTSETTKODE1 = 'Institusjonen/sykehuset har bestemt utsettelsen av kapasitetsgrunner';
label UTSETTKODE3 = 'Pasienten har ikke møtt opp';
label UTSETTKODE4 = 'Pasienten har selv bestemt utsettelsen av velferdsgrunner';
label UTSETTKODE5 = 'Medisinske årsaker hos pasienten til utsettelsen';
label UTSETTKODE6 = 'Oppstart av helsehjelp er utsatt grunnet manglende kapasitet ved påfølgende behandlingssted';
label UTSETTKODE21 = 'Pasienten har takket nei til tilbud fra HF om helsehjelp ved annet behandlingssted enn sitt primære ønske';
label UTSETTKODE22 = 'Pasienten har takket nei til tilbud fra Helfo om helsehjelp ved annet behandlingssted enn sitt primære ønske';
label henv_dato = 'Tilsvarer ansiennitetsdato der ansiennitetsdato kommer før eller er lik mottaksdato. Mottaksdato der ansiennitetsdato mangler eller er etter mottaksdato';
label avvikl_dato = 'Dato for ventetid slutt. Må sees i sammenheng med avvikl_kode';
label avvikl_kode ='Klassifisering av hvordan ventelisteplass er blitt avviklet (søknadsavvikling)- ventetid sluttkode';
label fristStartBehandling = 'Seneste dato for forsvarlig start på nødvendig helsehjelp';
label fristbrudd = 'Et fristbrudd - for å skille mellom avviklede og ventende bruk av_kode=1 og fortsatt_kode=1' ;
label AV_KODE = 'Henvisninger som er ordinært avviklet fra ventelisten i rapporteringsperioden';
label fortsatt_kode = 'Henvisninger som venter på helsehjelp på ett gitt tidspunkt';
label ny_henvist = 'Henvisningen er vurdert i perioden';
label VENTETID = 'Antall kalenderdager mellom ventetid startdato (henv_dato) og ventetid sluttdato (avvikl_dato) eller rapporteringsperiodens sluttdato'; 
label Intern_ventetid = 'Antall dager mellom mottaksdato (nyhenv_dato) og ventetid sluttdato (avvikl_dato)eller rapporteringsperiodens sluttdato'
label SLETTE_KODE = 'Slette kode - ulike grunn for hvorfor person bør ikke tas i beregninger. Må være missing eller 0';

rename OMSNIVAA_KODE = OMSORGSNIVA;
rename henv_type = henvtype; /*rename because there are formates available*/
periode=&periode;
format periode YYMMDD10.;

run;

%mend tilrettelegging_vent;