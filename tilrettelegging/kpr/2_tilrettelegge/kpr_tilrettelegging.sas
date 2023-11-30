%macro kpr_tilrettelegging;

    /* Lage makrovariabler som angir om variabel er tilstede i data som sendes inn */
    data _null_;
    dset=open("&inn");
    call symput ('aar_e',varnum(dset,'aar'));
    call symput ('kpr_lnr',varnum(dset,'kpr_lnr'));
    call symput ('enkeltregning_lnr',varnum(dset,'enkeltregning_lnr'));
    call symput ('dato',varnum(dset,'dato'));
    call symput ('kjonn',varnum(dset,'kjonn'));
    call symput ('fodselsar',varnum(dset,'fodselsar'));
    call symput ('kommuneNr',varnum(dset,'kommuneNr'));
    call symput ('bydel',varnum(dset,'bydel'));
    call symput ('tjenestetype',varnum(dset,'tjenestetype'));
    run;

	data _null_;
    dset_t=open("&inn_takst");
    call symput ('aar_t',varnum(dset_t,'aar'));
    call symput ('enkeltregning_lnr_t',varnum(dset_t,'enkeltregning_lnr'));
    run;

    data _null_;
    dset_d=open("&inn_diag");
    call symput ('aar_d',varnum(dset_d,'aar'));
    call symput ('enkeltregning_lnr_d',varnum(dset_d,'enkeltregning_lnr'));
    run;


/*************************************/
/* 1. Tilrettelegge hoved/regningsfil*/
/*************************************/

%let sektor = enkeltregning; /*hvilken fil skal tilrettelegges*/
data &sektor._copy;
  set 	&inn; 
run;

/* --------------------------*/
/* sletter rader uten kpr_lnr*/
/* --------------------------*/
/*slette_&aar brukes senere i diag og takst filer*/

data &sektor slette_&aar;
  set &sektor._copy;
  if kpr_lnr=. then output slette_&aar;
  else output &sektor;
run;

/* ----------- */
/* Kontakttype */
/* ----------- */
/* We used to receive kontakttype in the file up to 2021, now have to create this variable ourselves */
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_kontakttype.sas";
%kpr_kontakttype	(takst_fil=&inn_takst, 	regning_fil=&sektor);


/*--------------*/
/* konvertering */
/*--------------*/

/* lager nye numeriske variabler til kpr_lnr, bydel, kontakttype, refusjonutbetalt */
data &sektor;
  set &sektor;

  pid_kpr=KPR_lnr+0;
  bydel_kpr = bydel + 0;
  kontakttype_kpr = kontakttypeId +0;
  if kontakttype_kpr eq -1 then kontakttype_kpr = 0;
  refusjonutbetalt = 'refusjonutbetaltbeløp'n + 0;
  drop KPR_lnr bydel kontakttypenavn kontakttypeId 'refusjonutbetaltbeløp'n;
run;

/*-----------------------*/
/* kommunenummer / bydel */
/*-----------------------*/

/* lager 'kommunenr2', og hvor ugyldige komnr får missing*/
proc sql;
      create table &sektor as
      select *, case when kommuneNr in (select start from HNREF.fmtfil_komnr) then kommuneNr end as kommuneNr2
      from &sektor;
quit;

/* fornyer kun gyldige komnr*/
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr     	(inndata=&sektor, kommune_nr=kommunenr2); 

/* bydel*/
data &sektor(drop=bydel_tmp);
  set &sektor;

  bydel_tmp=bydel_kpr;

  /* Create variable 'bydel' for the kommune with bydel */
  if komnr in (301,4601,5001,1103) then do;
    if bydel_tmp <= 0 then bydel = komnr*100+99; /*hvis følgende komnr mangler bydel lage bydel udef, feks 30199*/
    else bydel=komnr*100+bydel_tmp;
  end;

  /* All other kommune get missing value for bydel */
  else bydel=.;

  /*drop variabler fra tilretteleggingen som ikke skal være med videre*/
  drop kommuneNr kommuneNr2 komnr_inn nr bydel_kpr;
run;


/*----------*/
/* boområde */
/*----------*/
/*de som ikke har gyldig komnr vil få missing her*/
%include "&filbane/makroer/boomraader.sas";
%boomraader      	(inndata=&sektor);

/*----------*/
/* avledede */
/*----------*/
/*inndato, inntid, ermann, tjenestetype_kpr*/
data &sektor;
  set &sektor;

rename dato = inndato klokkeslett=inntid;

if kjonn eq 1 then ermann = 1; /*menn*/
if kjonn eq 2 then ermann = 0; /*kvinner*/
if kjonn eq . then ermann = .; /*missing*/

if tjenestetype eq "Fastlege"                       then tjenestetype_kpr = 1; 
if tjenestetype eq "Legevakt"                       then tjenestetype_kpr = 2; 

if tjenestetype eq "Fysioterapeut privat"           then tjenestetype_kpr = 3; 
if tjenestetype eq "Fysioterapeut kommunal"         then tjenestetype_kpr = 4; 
if tjenestetype eq "Kiropraktor"                    then tjenestetype_kpr = 5; 

if tjenestetype eq "Tannlege"                       then tjenestetype_kpr = 6; 
if tjenestetype eq "Kjeveortoped"                   then tjenestetype_kpr = 7; 
if tjenestetype eq "Tannpleier"                     then tjenestetype_kpr = 8; 

if tjenestetype eq "Helsestasjon"                   then tjenestetype_kpr = 9; 
if tjenestetype eq "Logoped"                        then tjenestetype_kpr = 10; 
if tjenestetype eq "Ridefysioterapi"                then tjenestetype_kpr = 11; 
if tjenestetype eq "Audiopedagog"                   then tjenestetype_kpr = 12; 
if tjenestetype eq "Ortoptist"                      then tjenestetype_kpr = 13; 

if tjenestetype eq "Ukjent" 
    or tjenestetype eq " "                          then tjenestetype_kpr = 14; 

drop kjonn kjonn_navn kjonnNavn kjonn_mot alder_mot kommuneNr_mot bydel_mot tjenestetype;
run;

/*----------*/
/* diagnose */
/*----------*/
/*hente hoveddiagnose fra diagnose-fil, + angi ant bidiagnoser*/

/* hente inn hoveddiagnose fra diagnosefilen */
proc sql;
	create table tmp_utdata as
	select a.*, b.diagnosekode as hdiag_kpr, 
					case 	when b.diagnosetabell eq "ICPC-2" 						then 1 
							when b.diagnosetabell eq "ICPC-2B" 						then 2 
					 		when b.diagnosetabell eq "ICD-10" 						then 3
							when b.diagnosetabell eq "ICD-DA-3"  					then 4
					 		when b.diagnosetabell eq "Akser i BUP-klassifikasjon"  	then 5
							when b.diagnosetabell eq " "                            then .					
					end as kodeverk_kpr
	from &sektor a
	left join &inn_diag b
	on a.enkeltregning_lnr=b.enkeltregning_lnr 
		and b.erhoveddiagnose eq 1; /*kun ta med hoveddiagnose*/
quit;

/* Telle antall rader med bidiagnose til det enkelte enkeltregning_lnr */
proc sql;
	create table ant_bdiag as
	select enkeltregning_lnr, count(*) as ant_b
	from &inn_diag 
	where erhoveddiagnose ne 1 /*ikke telle raden som er hoveddiagnose*/
	group by enkeltregning_lnr;
quit;

/* koble på antall bidiagnoser på fil som tilrettelegges */
proc sql;
	create table &sektor as
	select a.*, b.ant_b as ant_bdiag_kpr
	from tmp_utdata a
	left join ant_bdiag b
	on a.enkeltregning_lnr=b.enkeltregning_lnr;
quit;

/* slette tmp-data */
proc datasets nolist;
delete tmp_utdata ant_bdiag;
run;

/*-------*/
/* ICPC2 */
/*-------*/
/* Lage egen variabel som heter icpc2_hdiag, icpc2_kap, icpc2_type*/

%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_icpc2.sas";
%kpr_icpc2			(inndata=&sektor, 	utdata=&sektor);

/* ------- */
/* DØDDATO */
/* ------- */

proc sql;
  create table &sektor as
  select a.*, b.dodDato
  from &sektor a left join &doddata b
  on a.pid_kpr=b.lopeNr;
quit;

/* --------------------------------- */
/* Length, Label, Format, rekkefølge */
/* --------------------------------- */
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_lengde_variabler.sas";
%kpr_lengde_variabler(inndata=&sektor,	utdata=&sektor);
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_var_rekkefolge.sas";
%kpr_var_rekkefolge	(inndata=&sektor,	utdata=&sektor); 
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_lablerFormater.sas";
%kpr_lablerFormater	(inndata=&sektor, 	utdata=&sektor);

/* -----------------*/
/* skriver til HNANA*/
/* -----------------*/
proc sort data=&sektor  out=HNANA.lege_&sektor._&aar._&suffixout; 
by pid_kpr inndato inntid;
run;

/* slette datasett */
proc datasets nolist;
	delete &sektor &sektor._copy;
run;


/*******************************/
/*******************************/
/* 2. Tilrettelegge diagnosefil*/
/*******************************/
/*******************************/

%let sektor = diagnose;

data &sektor._copy;
  set &inn_diag; 
run;

/* --------------------------------------*/
/* sletter enkeltregning_lnr uten kpr_lnr*/
/* --------------------------------------*/
/* datasett slette_&aar. er fra første delen når vi tilrettelegge enkeltregningsfilen */
proc sql;
	create table &sektor as
	select *
	from &sektor._copy
	where enkeltregning_lnr not in (select enkeltregning_lnr from slette_&aar.);
quit;

/* -------------*/
/* konvertering */
/* -------------*/
/* diag_kpr, erhdiag_kpr, kodeverkkpr */
data &sektor;
  set &sektor;

	rename diagnoseKode = diag_kpr;
	erhdiag_kpr = erhoveddiagnose +0;
	drop erhoveddiagnose;

	if diagnosetabell eq "ICPC-2"                          then kodeverk_kpr = 1;
	if diagnosetabell eq "ICPC-2B"                         then kodeverk_kpr = 2;
	if diagnosetabell eq "ICD-10"                          then kodeverk_kpr = 3;
	if diagnosetabell eq "ICD-DA-3"                        then kodeverk_kpr = 4;
	if diagnosetabell eq "Akser i BUP-klassifikasjon"      then kodeverk_kpr = 5;
	if diagnosetabell eq " "                               then kodeverk_kpr = .;
	drop diagnosetabell;
run;

/* ----- */
/* ICPC2 */
/* ----- */
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_icpc2.sas";
%kpr_icpc2			(inndata=&sektor, 	utdata=&sektor);

/*---------------------------------*/
/*Length, label, format, rekkefølge*/
/*---------------------------------*/
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_lengde_variabler.sas";
%kpr_lengde_variabler(inndata=&sektor,	utdata=&sektor);
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_var_rekkefolge.sas";
%kpr_var_rekkefolge	(inndata=&sektor,	utdata=&sektor); 
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_lablerFormater.sas";
%kpr_lablerFormater	(inndata=&sektor, 	utdata=&sektor);

/*------------------*/
/* Skriver til HNANA*/
/*------------------*/
proc sort data= &sektor out=HNANA.lege_&sektor._&aar._&suffixout;
  by enkeltregning_lnr;
run;

/* slette datasett */
proc datasets nolist;
	delete &sektor &sektor._copy;
run;




/****************************/
/****************************/
/* 3. Tilrettelegge takstfil*/
/****************************/
/****************************/
%let sektor=takst;

data &sektor._copy;
  set &inn_takst; 
run;

/* --------------------------------------*/
/* sletter enkeltregning_lnr uten kpr_lnr*/
/* --------------------------------------*/
/* datasett slette_&aar. er fra første delen når vi tilrettelegge enkeltregningsfilen */
proc sql;
	create table &sektor as
	select *
	from &sektor._copy
	where enkeltregning_lnr not in (select enkeltregning_lnr from slette_&aar.);
quit;

/*---------------------------------*/
/*Length, label, format, rekkefølge*/
/*---------------------------------*/

%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_lengde_variabler.sas";
%kpr_lengde_variabler(inndata=&sektor,	utdata=&sektor);
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_var_rekkefolge.sas";
%kpr_var_rekkefolge	(inndata=&sektor,	utdata=&sektor); 
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_lablerFormater.sas";
%kpr_lablerFormater	(inndata=&sektor, 	utdata=&sektor);


/*------------------*/
/* Skriver til HNANA*/
/*------------------*/
proc sort data= &sektor out=HNANA.lege_&sektor._&aar._&suffixout;
  by enkeltregning_lnr;
run;

/* slette datasett */
proc datasets nolist;
	delete &sektor &sektor._copy slette_&aar.;
run;

%mend kpr_tilrettelegging;

