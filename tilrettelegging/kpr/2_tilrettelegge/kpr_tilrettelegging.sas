%macro kpr_tilrettelegging;

/**********************************************************************************/
/* Kontroller at alle nødvendige variabler er tilstede før tilrettelegging gjøres */
/**********************************************************************************/

/* Kontroll takstfilen */
data _null_;
        dset_t = open("&inn_takst");
        vars_t = 'aar enkeltregning_lnr takstkode'; /*variabler som må være tilstede i filen*/ 
        length missing_t $200;
        do i = 1 to countw(vars_t, ' ');
            varname_t = scan(vars_t, i, ' ');
            vnum_t = varnum(dset_t, varname_t);
            call symputx(cats(varname_t, '_t'), vnum_t);
            if vnum_t = 0 then missing_t = catx(' ', missing_t, varname_t);
        end;
        call symputx('missing_vars_t', missing_t);
    run;

    /* Kontroll diagnosefilen */
    data _null_;
        dset_d = open("&inn_diag");
        vars_d = 'aar enkeltregning_lnr diagnoseKode diagnoseTabell erHoveddiagnose'; /*variabler som må være tilstede i filen*/ 
        length missing_d $200;
        do i = 1 to countw(vars_d, ' ');
            varname_d = scan(vars_d, i, ' ');
            vnum_d = varnum(dset_d, varname_d);
            call symputx(cats(varname_d, '_d'), vnum_d);
            if vnum_d = 0 then missing_d = catx(' ', missing_d, varname_d);
        end;
        call symputx('missing_vars_d', missing_d);
    run;

    /* Kontroll regningsfilen/hovedfilen */
    data _null_;
        dset = open("&inn");
        vars = 'aar kpr_lnr enkeltregning_lnr dato kjonn kjonnK alder fodselsaar kommuneNr bydel kommunenrPB tjenestetype praksiskommune'; /*variabler som må være tilstede i filen*/ 
        length missing $200;
        do i = 1 to countw(vars, ' ');
            varname = scan(vars, i, ' ');
            vnum = varnum(dset, varname);
            call symputx(varname, vnum);
            if vnum = 0 then missing = catx(' ', missing, varname);
        end;
        call symputx('missing_vars', missing);
    run;

/* Print warnings if any variables are missing */
    %if "&missing_vars" ne "" %then %do;
        title color=purple height=5 "MANGLER VARIABLE(R) I HOVEDFILEN: &missing_vars";
        proc sql;
            create table m (note char(50));
            insert into m values ("Mangler variabler i hovedfilen: &missing_vars");
            select * from m;
        quit;
    %end;

    %if "&missing_vars_t" ne "" %then %do;
        title color=purple height=5 "MANGLER VARIABLE(R) I TAKSTFILEN: &missing_vars_t";
        proc sql;
            create table m_t (note char(50));
            insert into m_t values ("Mangler variabler i takstfilen: &missing_vars_t");
            select * from m_t;
        quit;
    %end;

    %if "&missing_vars_d" ne "" %then %do;
        title color=purple height=5 "MANGLER VARIABLE(R) I DIAGNOSEFILEN: &missing_vars_d";
        proc sql;
            create table m_d (note char(50));
            insert into m_d values ("Mangler variabler i diagnosefilen: &missing_vars_d");
            select * from m_d;
        quit;
    %end;

    /* Only continue if all required variables are present */
    %if "&missing_vars" = "" and "&missing_vars_t" = "" and "&missing_vars_d" = "" %then %do;

/*lager makrovariabel som angir årstall - brukes til navning av data senere*/
data _null_;
  set &inn.;
  call symputx("aar",aar);
run;

%include "&filbane/formater/SKDE_somatikk.sas";
%include "&filbane/formater/KPR_Lege.sas";

/*************************************/
/* 1. Tilrettelegge hoved/regningsfil*/
/*************************************/

%let sektor = enkeltregning; /*hvilken fil skal tilrettelegges*/
data &sektor._copy;
  set 	&inn; 
drop doddato; /*tas ut - oppdatert døddato kobles på av den enkelte ved behov*/
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
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_kontakttype.sas";
%kpr_kontakttype	(takst_fil=&inn_takst, 	regning_fil=&sektor);

/*--------------*/
/* konvertering */
/*--------------*/

/* lager nye numeriske variabler til kpr_lnr, bydel, refusjonutbetalt */
data &sektor;
  set &sektor;

  pid_kpr=KPR_lnr+0;
  bydel_kpr = bydel+0;
  refusjonutbetalt = 'refusjonutbetaltbeløp'n + 0;
  drop KPR_lnr bydel 'refusjonutbetaltbeløp'n;
run;

/*-----------------------*/
/* kommunenummer / bydel */
/*-----------------------*/

/* lager 'kommunenr2', og hvor ugyldige komnr får missing*/
/* TJ 09/12-2025:
ny variabel (kommunenrPB) utleveres som i noen tilfeller har informasjon om kommunenr når kommuneNr mangler info.
*/

data &sektor.;
  set &sektor.;
/* lag ny variabel */
komnr_fix=.;
/* behold mottatt kommuneNR */
kommuneNr_mot=kommuneNR;
/* fix hvis kommuneNr er -1 eller missing, den er normalt satt til -1 når det ikke er kjent verdi */
if kommuneNr in (-1,.) then komnr_fix=kommunenrPB;
else komnr_fix=kommuneNr;
/* overskrive kommuneNr med komnr_fix */
kommuneNr=komnr_fix;
drop komnr_fix;
run;

proc sql;
      create table &sektor as
      select *, case when kommuneNr in (select start from HNREF.fmtfil_komnr) then kommuneNr end as kommuneNr2
      from &sektor;
quit;

/* fornyer kun gyldige komnr*/
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr     	(inndata=&sektor, kommune_nr=kommunenr2); 

/* bydel*/
data &sektor;
  set &sektor;

  bydel_tmp=bydel_kpr;

if komnr = 5001 and bydel_tmp not in (01:04) then bydel_tmp = 0;
if komnr = 4601 and bydel_tmp not in (01:08) then bydel_tmp = 0;
if komnr = 1103 and bydel_tmp not in (01:09) then bydel_tmp = 0;
if komnr = 301  and bydel_tmp not in (01:17) then bydel_tmp = 0;

  /* Create variable 'bydel' for the kommune with bydel */
  if komnr in (301,4601,5001,1103) then do;
    if bydel_tmp <= 0 then bydel = komnr*100+99; /*hvis følgende komnr mangler bydel lage bydel udef, feks 30199*/
    else bydel=komnr*100+bydel_tmp;
  end;

  /* All other kommune get missing value for bydel */
  else bydel=.;

  /*drop variabler fra tilretteleggingen som ikke skal være med videre*/
  drop kommuneNr kommuneNr2 kommunenrPB bydel_kpr bydel_tmp;
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

rename dato=inndato klokkeslett=inntid;

/* TJ 10/12-2025: FHI utleverer variabel kjonnK som er en fix av rader som utleveres med kjonn=-1 */
if kjonn eq -1 then do;
  if kjonnK in (1,2) then kjonn = kjonnK;
  else kjonn = .;
end;
/* lag variabel ermann */
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

/*ta vare på rapportert alder*/
alder_mot = alder;
/*null ut alder*/
alder = .;
/* hvis oppgitt fødselsår beregnes alder ut fra det */
if fodselsaar ne . then do;
alder_ny = aar - fodselsaar;
end;
/* hvis fødselsår mangler så brukes den rapporterte alderen hvis gyldig verdi */
else if fodselsaar eq . and alder_mot ge 0 then alder_ny = alder_mot;
/*alder_ny gjøres om til alder*/
alder = alder_ny;
drop kjonn kjonnK kjonnNavn tjenestetype alder_ny;
run;

/*----------*/
/* diagnose */
/*----------*/
/*hente hoveddiagnose fra diagnose-fil, + angi ant bidiagnoser*/

/* splitte filen i hoved- og bidiagnoser */
data hoveddiag bidiag;
  set &inn_diag.;
  if erHoveddiagnose eq 1 then output hoveddiag;
  else output bidiag;
run;

/* Step 2: Join and create kodeverk_kpr */
proc sql;
    create table tmp_utdata as
    select a.*,
           b.diagnosekode as hdiag_kpr,
           case
               when strip(upcase(b.diagnosetabell)) = "ICPC-2" then 1
               when strip(upcase(b.diagnosetabell)) = "ICPC-2B" then 2
               when strip(upcase(b.diagnosetabell)) = "ICD-10" then 3
               when strip(upcase(b.diagnosetabell)) = "ICD-DA-3" then 4
               when strip(upcase(b.diagnosetabell)) = "AKSER I BUP-KLASSIFIKASJON" then 5
               when strip(b.diagnosetabell) = "" then .
           end as kodeverk_kpr
    from &sektor a
    left join hoveddiag b
      on a.enkeltregning_lnr = b.enkeltregning_lnr;
quit;

/* Telle antall rader med bidiagnose til det enkelte enkeltregning_lnr */
proc sql;
	create table ant_bdiag as
	select enkeltregning_lnr, count(*) as ant_b
	from bidiag 
	group by 1;
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
delete tmp_utdata ant_bdiag hoveddiag bidiag alder_diff_data;
run;

/*-------*/
/* ICPC2 */
/*-------*/
/* Lage egen variabel som heter icpc2_hdiag, icpc2_kap, icpc2_type*/
%include "&filbane/tilrettelegging/kpr/2_tilrettelegge/kpr_icpc2.sas";
%kpr_icpc2			(inndata=&sektor, 	utdata=&sektor);


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
	if diagnosetabell eq "ICD-DA-2"                        then kodeverk_kpr = 6;
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

%end;

%mend kpr_tilrettelegging;

