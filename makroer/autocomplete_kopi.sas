/**** autocomplete.kmf ****/

/***** Nye ******/

/* Hash */
/* Loop */
/* Figur_til_bilde */
/* Rateprog_ny */
/* Figur_makro */
/* SQL */

/**********************************************/

/**+++++++ Anno +++++++**/
%let annokilde=Kilde: NPR/SSB; /* endre ved behov */
%let annokladd=UTKAST; /* la stå tom hvis ikke figur skal merkes med utkast */
%include "&filbane/stiler/anno_logo.sas";

/**+++++++ Array +++++++**/
data dsn_ut;
set dsn_inn;

array diagnose {*} Hdiag: Bdiag: ;
	do i=1 to dim(diagnose);
		if substr(diagnose{i},1,3) in ('N80')  then Endometriose=1;
        if diagnose{i} in: ('N80') then Endometriose=1; 
	end;

array prosedyre {*} NC:;
    do j=1 to dim(prosedyre); 
		if substr(prosedyre{j},1,5) in ('LCD00','LCD30','LCD31') then Endometriose_hyst_p=1;	
        if prosedyre{j} in: ('LCD00','LCD30','LCD31') then Endometriose_hyst_p=1;
	end;

drop i j;

run;

/**+++++++ Auto_Makro +++++++**/
%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
options sasautos=("&filbane/makroer" SASAUTOS);

%include "&filbane/formater/SKDE_somatikk.sas";
%include "&filbane/formater/NPR_somatikk.sas";
%include "&filbane/formater/bo.sas";
%include "&filbane/formater/beh.sas";

%include "&filbane/makroer/boomraader.sas";
%include "&filbane/makroer/forny_komnr.sas";

/**+++++++ CoMorbIndex +++++++**/
/*------------------------------------------------------------------------------------------------
Variable:
1. dsn_index - datasett med indexopphold
2. dsn_alle - datasett med alle opphold (døgn, dag og poli) for alle aktuelle pasienter
3. periode - hvor mange dager bakover vi leter (standard er 365 dager)
4. alle - lik 1 --> leter i både hoved- og bi-diagnoser (default), ulik 1 --> let kun i hdiag

Makroen produserer tre komorbiditetsindekser:
1. CCI - Charlson - kan endres ved å endre vekting
2. PRI - Pasient Register Index - kan endres ved å endre vekting
3. CoMorb - egendefinert index - kan endres ved å endre vekting

Diagnosekoder er hentet fra Quan 2005, Vekting er hentet fra Nilssen 2014
-------------------------------------------------------------------------------------------------*/
%include "&filbane/makroer/CoMorbIndex.sas";
%let CCI_Vekting=(c1*1)+(c2*1)+(c3*1)+(c4*1)+(c5*1)+(c6*1)+(c7*1)+(c8*1)+(c9*1)+(c10*1)
+(c11*2)+(c12*2)+(c13*2)+(c14*2)+(c15*3)+(c16*6)+(c17*6);
%let PRI_Vekting=(c1*1)+(c2*2)+(c3*1)+(c4*1)+(c5*2)+(c6*1)+(c7*0)+(c8*1)+(c9*2)+(c10*0)
+(c11*1)+(c12*1)+(c13*1)+(c14*2)+(c15*5)+(c16*6)+(c17*3);
%let Egen_Vekting=(c1*0)+(c2*2)+(c3*1)+(c4*1)+(c5*2)+(c6*1)+(c7*0)+(c8*1)+(c9*2)+(c10*0)
+(c11*1)+(c12*1)+(c13*1)+(c14*2)+(c15*5)+(c16*6)+(c17*3);
%CoMorbIndex(dsn_index=,dsn_alle=,periode=365,alle=1);

/**+++++++ Data_AvtSpes - fjernes +++++++**/
data avt_spes;
set
skde20.t20_avtspes_2015
skde20.t20_avtspes_2016
skde20.t20_avtspes_2017
skde20.t20_avtspes_2018
skde20.t20_avtspes_2019;
run;

/**+++++++ Data_Magnus - fjernes +++++++**/
/* Last først inn magnus_som (auto-complete-makro)*/
data utvalg;
set
skde20.t20_avd_2015 (keep = &magnus_som)
skde20.t20_avd_2016 (keep = &magnus_som)
skde20.t20_avd_2017 (keep = &magnus_som)
skde20.t20_avd_2018 (keep = &magnus_som)
skde20.t20_avd_2019 (keep = &magnus_som);
run;

/**+++++++ datalines +++++++**/
data test;
input pid inndato merke;
datalines;
1 1 .
1 2 1
1 3 .
2 1 .
2 2 1
2 3 .
2 4 1
3 1 1
3 2 .
3 3 1
3 4 .
4 1 1
4 2 1
4 3 1
4 4 1
4 5 .
5 1 .
5 2 .
5 3 .
;
run;

/**+++++++ datasett - fjernes +++++++**/
data ut;
set inn;
run;

/**+++++++ delete_data +++++++**/
proc datasets nolist;
delete B_A_:;
run;

/**+++++++ Dropliste - fjernes +++++++**/
Drop aggrshoppID ald_gr Ald_gr5 AnsienDato Behandlingsniva2 Behandlingsniva4 Behandlingsniva8 
BehHF_gammel BoHF_gammel bydel2 g_omsorgsniva inntilstand kjonn komNrHjem KomNrHjem2 omsorgsniva 
oppholdstype takst: TilSted TjenstenhetKode UtSkrKlarDager UtSkrKlarDato utTilstand VertskommHN;

/**+++++++ episode_of_care - fjernes +++++++**/
%Episode_of_care(
dsn=utvalg,
EoC_tid=28800,
forste_hastegrad = 1,
behold_datotid=0,
debug = 0,
nulle_liggedogn = 0,
inndeling = 0,
separer_ut_poli = 0
);

/**+++++++ Flerniva_fixed_2niva - fjernes? +++++++**/
/*
HGLM - Hierarchical generalized linear models
Referanse se: https://support.sas.com/resources/papers/proceedings15/3430-2015.pdf
Outcome: Behandling (0,1) Binary/Dikotom
Individ-nivå:
i) Alder - numerisk, centering ifht snittalder totalt i utvalget
ii) Kjønn (0,1)
Kommune-nivå:
i) Utdanning - kategorisk, ordinal (Lav, Middels, Høy)
ii) Kommune_alder - gjennomsnittsalder i kommunen, centering av snittalder i hver kommune ifht snittalder totalt i utvalget

Spørsmål som ønskes besvart (med resultater fra eksemplet - datasett:frank.hglm):
1. Hva er andelen Behandling i en typisk kommune?
PP (predicted probability) for Behandling er 0.0600, se tab.1
PP=[e^n/(1+e^n)], hvor n=-2.75, (estimate intercept), e^n=0.0354 (henter n fra tabellen: Estimater for modellen)
2. Varierer andelen med Behandling mellom kommunene?
2,4% av variasjonen i Behandling skyldes kommunene, se tab.1 (ICC)
3. Hva er beste modell og hva er PP da?
Modell 3 er beste modell (se tab.2) og PP=0.0341
PP=[e^n/(1+e^n)], hvor n=-3.3442, (estimate intercept), e^n=0.0353 (se tab.3)
PP når alder er lik snittalder, kjønn lik snitt-kjønn, kommune med snittalder lik kommune-snitt-alder og kommunalt utdanningsnivå lik snitt
4. Hva er sammenhengen mellom pasientens alder og likelihood for Behandling når 
man kontrollerer for pasient- og kommunekarakteristika?
Jo, høyere alder jo lavere odds for Behandling (OR=0.951) (se tab.5)
5. Hva er sammenhengen mellom utdanningsnivå på kommunenivå og likelihood for Behandling 
når man kontrollerer for pasient- og kommunekarakteristika?
Og, hva er PP (predikted probability) for de ulike utdanningsnivåene (gitt alt annet lik snitt)
Jo, høyere utdanningsnivå jo høyere odds for Behandling (OR=1.077) (se tab.5).
P(kommune med lav utd)=0.034 , P=[e^n/(1+e^n)], hvor n=-3.34 (estimate intercept), e^n=0.0354 (se tab.3)
P(kommune med middels utd)=0.037 , P=[e^n/(1+e^n)], hvor n=-3.27 (estimate intercept+estimate kom_utd), e^n=0.0380
P(kommune med høy utd)=0.039 , P=[e^n/(1+e^n)], hvor n=-3.2 (estimate intercept+2*estimate kom_utd), e^n=0.0407
*/

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
%include "&filbane/makroer/flerniva_fixed_2niva.sas";

%let inndatasett=frank.hglm; /*Datasett analysen skal kjøres på*/
%let utkomme=Behandling; /*Outcome eller den avhengige variabelen*/
%let niva2=komnr; /*Nivå-variabel i datasettet*/
%let niva2_txt=kommune; /*Kun for å få fine overskrifter*/
/*Antall parametre i hver modell*/
%let mod1param=0; /*Modell 1, som egentlig er 0-modellen, kun den avhengige variabelen og niva2 som Class --> 0 parametre*/
%let mod2param=2; /*Modell 2, modell med parametre på individnivå - antall parametre skrives her*/ 
%let mod3param=4; /*Modell 3, både individ- og regionnivå - antall parametre totalt skrives inn her*/
/*Spesifisering av paremetrene i hver modell*/
%let mod2var=ermann alder_p; /*Parametrene i modell 2 spesifiseres her*/
%let mod3var=ermann alder_p alder_k kom_utd; /*Parametrene i modell 3 spesifiseres her*/

%flerniva_fixed_2niva;

/**+++++++ import_data +++++++**/
/*****************
* Import fra csv *
******************/

/* Sett på riktig encoding*/
filename csvfile "/sas_smb/skde_analyse/Prosjekter/ahs_dynamisk_tabellverk/csv_filer/fag.csv" encoding='wlatin1';
options missing='.';

/* komma-delt csv */
proc import datafile=csvfile
out=normdb dbms=dlm replace; delimiter=','; getnames=yes; guessingrows=max; run;


/*******************
* Import fra excel *
********************/

%let Sheet = GA36;
%let Regneark = Sepsis;
proc import
    out =&Regneark._&Sheet
    datafile = "/sas_smb/skde_analyse/Helseatlas/Nyfodt/Raadata/Importfiler/&Regneark."
    dbms = xlsx replace;
    sheet = "&Sheet.";
     getnames=yes;
run;

/**+++++++ include - fjernes +++++++**/
%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
%include "&filbane/formater/SKDE_somatikk.sas";
%include "&filbane/formater/NPR_somatikk.sas";
%include "&filbane/formater/bo.sas";
%include "&filbane/formater/beh.sas";

/**+++++++ lag_stat_string +++++++**/
/*eksempler Lag_string*/

data eks;
input pvalue stderr or lcl ucl;
datalines;
0.85555 1.4563 1.0012 0.8574 1.2546
0.00001 0.8978 1.2546 1.0125 1.4567
0.00500 1.2345 0.8745 0.6458 0.9879
;
run;

data eks;
set eks;
format stderr or lcl ucl 8.4 pvalue pvalue6.3;
run;

data eks;
set eks;
/*Estimat med CI i (), skilletegn - */
Est_CI=cat(strip(put(or,8.2)), " (", strip(put(lcl,8.2))," - ", strip(put(ucl,8.2)), ")");
/*Estimat med SE i [], 2 desimaler på estimat og 3 på SE */
Est_SE=cat(strip(put(or,8.2)), " [", strip(put(stderr,8.3)), "]");
/*Estimat med p-verdi i (), p-verdi med 2 desimaler og estimat med 3 */
Est_p=cat(strip(put(or,8.3)), " (", strip(put(pvalue,pvalue6.2)), ")");
/*Estimat med p-verdi i [] og CI i (), skilletegn to */
Est_p_CI=cat(strip(put(or,8.2)), " [", strip(put(pvalue,pvalue6.3)), "]"
, " (", strip(put(lcl,8.2))," to ", strip(put(ucl,8.2)), ")");
run;


/*Tilpasse p-verdi format*/
proc format;
value MyPVal
      low - 0.05 = '< 0.05'
      Other = [pvalue8.2];
run;

data eks;
set eks;
/*Estimat med p-verdi i (), p-verdi med 2 desimaler og <.05 */
Est2_p=cat(strip(put(or,8.3)), " (", strip(put(pvalue,mypval.)), ")");
run;

/**+++++++ Løkke_aar +++++++**/
data kont;
set kurs.kont_rate;
run;

data pas;
set kurs.pas_rate;
run;

%let start_aar=2019;
%let slutt_aar=2023;

proc sql;
    create table ratedata as
    select a.bohf,
	%macro loop_years;
	    %do year = &start_aar %to &slutt_aar;
	        a.rate&year., 
	        a.ant&year., 
	        a.pop&year.,
	        b.rate&year as pasrate&year.,
	        b.ant&year. as pas&year.,
	        a.rate&year./b.rate&year. as pr_pas_just&year.,
	        a.ant&year./b.ant&year. as pr_pas_ujust&year.,
	    %end;
	%mend loop_years;
        %loop_years
        a.ratesnitt,
        a.antsnitt,
        a.popsnitt,
        b.ratesnitt as pasratesnitt,
        b.antsnitt as passnitt,
        a.ratesnitt/b.ratesnitt as pr_pas_justsnitt,
        a.antsnitt/b.antsnitt as pr_pas_ujustsnitt
    from kont a
    left join pas b on a.bohf=b.bohf;
quit;

%macro loope_aar;
proc sql;
    create table ratedata2 as
    select a.bohf,
	    %do year = &start_aar %to &slutt_aar;
	        a.rate&year., 
	        a.ant&year., 
	        a.pop&year.,
	        b.rate&year as pasrate&year.,
	        b.ant&year. as pas&year.,
	        a.rate&year./b.rate&year. as pr_pas_just&year.,
	        a.ant&year./b.ant&year. as pr_pas_ujust&year.,
	    %end;
        a.ratesnitt,
        a.antsnitt,
        a.popsnitt,
        b.ratesnitt as pasratesnitt,
        b.antsnitt as passnitt,
        a.ratesnitt/b.ratesnitt as pr_pas_justsnitt,
        a.antsnitt/b.antsnitt as pr_pas_ujustsnitt
    from kont a
    left join pas b on a.bohf=b.bohf;
quit;
%mend;

%loope_aar;

/**+++++++ magnus_aspes - fjernes +++++++**/
%let magnus_aspes=
pid
aar
inndato
utdato
ErMann
alder
komnr
bydel
bohf
borhf
boshhn
Fylke
NPRId_reg
fodselsar
dodDato
institusjonId
debitor
Episodefag
hastegrad
ICD10Kap
hdiag
hdiag2
hdiag3tegn
hf
bdiag1-bdiag9
ncmp1-ncmp10
ncsp1-ncsp10
fag_skde
Normaltariff1-Normaltariff15
Tdiag1-Tdiag5 /* Vil mangle for alle år, bortsett fra 2014. */
AvtaleRHF
SpesialistKomHN
Komplett
AvtSpes
;

/**+++++++ magnus_som - fjernes +++++++**/
%let magnus_som=
pid
aar
inndato
utdato
ErMann
alder
komnr
bydel
bohf
borhf
boshhn
Fylke
NPRId_reg
fodselsar
dodDato
institusjonId
debitor
Episodefag
hastegrad
ICD10Kap
hdiag
hdiag2
hdiag3tegn
hf
bdiag1-bdiag19
ncmp1-ncmp20
ncsp1-ncsp20
ncrp1-ncrp20
InnTid
UtTid
aktivitetskategori3
behandlingsstedkode
BehHF
BehRHF
behSh
drg
drg_type
HDG
liggetid
polUtforende_1
utTilstand 
niva
;

/**+++++++ Options_locale +++++++**/
options locale=NB_no;

/**+++++++ Options_makro +++++++**/
Options spool symbolgen mlogic mprint;
Options compress=yes  errors=2;

/**+++++++ pdf_figur +++++++**/
ods graphics on / imagemap reset=All imagename="Age_ablation" imagefmt=pdf  border=off width=20.0cm height=12.0cm;
ODS Listing Image_dpi=1500 
GPATH="/sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer";
ods pdf gtitle;
/*figuren*/
proc sgplot data=alder noborder;
series x=age5 y=mean / group=gender smoothconnect;
xaxis values=(25 to 85 by 5) offsetmax=0.05 offsetmin=0.05;
yaxis values=(0 to 0.4 by 0.1) offsetmax=0.05 offsetmin=0.05 label="Proportion with ablation";
keylegend / noborder title="" location=inside position=top across=2;
run;
ods listing close;
ods graphics off;

/**+++++++ ratefigur_todelt +++++++**/
%let bildesti = /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;
%include "&filbane/rateprogram/ratefigur_todelt.sas";

/*Kortversjon (kjøres med default verdier for resten) - kan ha opptil 3 kolonner i Y-axis table*/
%ratefigur_todelt(dsn=, var1= ,var2= ,
	label1= ,label2= ,
	tabvar1= ,tabvar2= ,
	tablabel1= ,tablabel2= ,
	fmt_tabvar1= ,fmt_tabvar2= ,
	figurnavn= ,xlabel= );

/* Eksempel: Datasett må klargjøres på forhånd - kan ha opptil 3 kolonner på y-axis
%ratefigur_todelt(dsn=dinedata, var1= off_rate ,var2= priv_rate,
	label1= Offentlig,label2= Privat,
	tabvar1= andel1,tabvar2= kont_pr_pas,
	tablabel1= Andel offentlig,tablabel2= Kontakter pr pasient,
	fmt_tabvar1= Nlpct8.0,fmt_tabvar2=Nlnum8.2 ,
	figurnavn= off_priv,xlabel= Rate pr xx );
*/

%ratefigur_todelt(
    dsn=, /*tilrettelagt datasett*/
    var1=, /*variabel første del av søylen*/
    var2=, /*Variabel andre del av søylen*/
    label1=, /*Legendnavn første del */
    label2=, /*Legendnavn andre del*/
    /*Y-axsis table*/
    ant_kol= 2, /* Antall kolonner i y-axsis table (1,2,3), uten tabell hvis blank */
    tabvar1=, /* Variabel til Første kolonne i Y-axis table*/
    tabvar2=, /* Variabel til Andre kolonne i Y-axis table*/
    tabvar3=, /* Variabel til Tredje kolonne i Y-axis table*/
    tablabel1=, /* Overskrift til Første kolonne i Y-axis table*/
    tablabel2=, /* Overskrift til Andre kolonne i Y-axis table*/
    tablabel3=, /* Overskrift til Tredje kolonne i Y-axis table*/
    fmt_tabvar1=, /* Format til variabel Første kolonne i Y-axis table*/
    fmt_tabvar2=, /* Format til variabel Andre kolonne i Y-axis table*/
    fmt_tabvar3=, /* Format til variabel Tredje kolonne i Y-axis table*/
    sprak=no /*=en*/, /*Norsk eller engelsk tekst i figur, default satt til norsk*/
    bo=bohf /*=borhf eller =boshhn*/,  /*Opptaksområder, default satt til bohf*/
    bildeformat=png, /*Bildeformat, default satt til png*/
    skala=, /*Bestemmes av data når ikke angitt*/
    figurnavn = , /*Første del av figurnavn*/
    xlabel =  /*Tekst under x-aksen*/
);

/*! 
### Beskrivelse

Makro for å lage trodelt søylefigur.

```
### Input
- Ett tilpasset datasett fra rateprogram
- Ett let-statement for å angi &bildesti (%let bildesti =/sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;)
- Ett include-statement for angi &anno
- Ett include-statement for å angi sti til makro (%include "&filbane/rateprogram/ratefigur_todelt.sas";)

### Output
- bildefil med valgt format lagres på angitt bildesti
- datasettet som lages i makroen

### Endringslogg:
- februar 2022 opprettet, Frank
*/

/**+++++++ ratefigur_tredelt +++++++**/
%let bildesti = /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;
%include "&filbane/rateprogram/ratefigur_tredelt.sas";

/*Kortversjon (kjøres med default verdier for resten) - kan ha opptil 3 kolonner i Y-axis table*/
%ratefigur_tredelt(dsn= , var1= , var2= , var3= ,
	label1= ,label2= , label3= ,
	tabvar1= ,tabvar2= ,  
	tablabel1= ,tablabel2= ,   
	fmt_tabvar1= ,fmt_tabvar2= ,
	figurnavn= ,xlabel=  );

/* Eksempel. 
%ratefigur_tredelt(dsn=dinedata, var1=prim_rate, var2=overlapp_rate, var3=spes_rate,
	label1=primær,label2=overlapp, label3=spesialist,
	tabvar1=andel_1,tabvar2=kont_pr_pas,
	tablabel1=Andel primnær,tablabel2=Kontakter pr pasient,
	fmt_tabvar1=nlpct8.0,fmt_tabvar2=nlnum8.2,
	figurnavn=fototest,xlabel=sfass rater );
*/

%ratefigur_tredelt(
    dsn=, /*tilrettelagt datasett*/
    /* Søylene */
    var1=, /*variabel første del av søylen*/
    var2=, /*Variabel andre del av søylen*/
    var3=, /*Variabel tredje del av søylen*/
    label1=, /*Legendnavn første del */
    label2=, /*Legendnavn andre del*/
    label3=, /*Legendnavn tredje del*/
    /* Y-axsis table */
    ant_kol= 2, /* Antall kolonner i y-axsis table (1,2,3), uten tabell hvis blank */
    tabvar1=, /* Variabel til Første kolonne i Y-axis table*/
    tabvar2=, /* Variabel til Andre kolonne i Y-axis table*/
    tabvar3=, /* Variabel til Tredje kolonne i Y-axis table*/
    tablabel1=, /* Overskrift til Første kolonne i Y-axis table*/
    tablabel2=, /* Overskrift til Andre kolonne i Y-axis table*/
    tablabel3=, /* Overskrift til Tredje kolonne i Y-axis table*/
    fmt_tabvar1=, /* Format til variabel Første kolonne i Y-axis table*/
    fmt_tabvar2=, /* Format til variabel Andre kolonne i Y-axis table*/
    fmt_tabvar3=, /* Format til variabel Tredje kolonne i Y-axis table*/
    sprak=no /*=en*/, /*Norsk eller engelsk tekst i figur, default satt til norsk*/
    bo=bohf /*=borhf eller =boshhn*/,  /*Opptaksområder, default satt til bohf*/
    bildeformat=png, /*Bildeformat, default satt til png*/
    skala=, /*Bestemmes av data når ikke angitt*/
    figurnavn = , /*Første del av figurnavn*/
    xlabel =  /*Tekst under x-aksen*/
);

/*! 
### Beskrivelse

Makro for å lage tredelt søylefigur.
Dersom ant_kol er tom --> uten y-axis table

```
### Input
- Ett tilpasset datasett fra rateprogram
- Ett let-statement for å angi &bildesti (%let bildesti =  /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;)
- Ett include-statement for angi &anno
- Ett include-statement for å angi sti til makro (%include "&filbane/rateprogram/ratefigur_tredelt.sas";)

### Output
- bildefil med valgt format lagres på angitt bildesti
- datasettet som lages i makroen

### Endringslogg:
- februar 2022 opprettet, Tove
*/

/**+++++++ ratefigur_tredelt +++++++**/
%let bildesti = /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;
%include "&filbane/rateprogram/ratefigur_tredelt.sas";

/*Kortversjon (kjøres med default verdier for resten) - kan ha opptil 3 kolonner i Y-axis table*/
%ratefigur_tredelt(dsn= , var1= , var2= , var3= ,
	label1= ,label2= , label3= ,
	tabvar1= ,tabvar2= ,  
	tablabel1= ,tablabel2= ,   
	fmt_tabvar1= ,fmt_tabvar2= ,
	figurnavn= ,xlabel=  );

/* Eksempel. 
%ratefigur_tredelt(dsn=dinedata, var1=prim_rate, var2=overlapp_rate, var3=spes_rate,
	label1=primær,label2=overlapp, label3=spesialist,
	tabvar1=andel_1,tabvar2=kont_pr_pas,
	tablabel1=Andel primnær,tablabel2=Kontakter pr pasient,
	fmt_tabvar1=nlpct8.0,fmt_tabvar2=nlnum8.2,
	figurnavn=fototest,xlabel=sfass rater );
*/

%ratefigur_tredelt(
    dsn=, /*tilrettelagt datasett*/
    /* Søylene */
    var1=, /*variabel første del av søylen*/
    var2=, /*Variabel andre del av søylen*/
    var3=, /*Variabel tredje del av søylen*/
    label1=, /*Legendnavn første del */
    label2=, /*Legendnavn andre del*/
    label3=, /*Legendnavn tredje del*/
    /* Y-axsis table */
    ant_kol= 2, /* Antall kolonner i y-axsis table (1,2,3), uten tabell hvis blank */
    tabvar1=, /* Variabel til Første kolonne i Y-axis table*/
    tabvar2=, /* Variabel til Andre kolonne i Y-axis table*/
    tabvar3=, /* Variabel til Tredje kolonne i Y-axis table*/
    tablabel1=, /* Overskrift til Første kolonne i Y-axis table*/
    tablabel2=, /* Overskrift til Andre kolonne i Y-axis table*/
    tablabel3=, /* Overskrift til Tredje kolonne i Y-axis table*/
    fmt_tabvar1=, /* Format til variabel Første kolonne i Y-axis table*/
    fmt_tabvar2=, /* Format til variabel Andre kolonne i Y-axis table*/
    fmt_tabvar3=, /* Format til variabel Tredje kolonne i Y-axis table*/
    sprak=no /*=en*/, /*Norsk eller engelsk tekst i figur, default satt til norsk*/
    bo=bohf /*=borhf eller =boshhn*/,  /*Opptaksområder, default satt til bohf*/
    bildeformat=png, /*Bildeformat, default satt til png*/
    skala=, /*Bestemmes av data når ikke angitt*/
    figurnavn = , /*Første del av figurnavn*/
    xlabel =  /*Tekst under x-aksen*/
);

/*! 
### Beskrivelse

Makro for å lage tredelt søylefigur.
Dersom ant_kol er tom --> uten y-axis table

```
### Input
- Ett tilpasset datasett fra rateprogram
- Ett let-statement for å angi &bildesti (%let bildesti =  /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;)
- Ett include-statement for angi &anno
- Ett include-statement for å angi sti til makro (%include "&filbane/rateprogram/ratefigur_tredelt.sas";)

### Output
- bildefil med valgt format lagres på angitt bildesti
- datasettet som lages i makroen

### Endringslogg:
- februar 2022 opprettet, Tove
*/

/**+++++++ ratefigur_aarsvar +++++++**/
%let bildesti = /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;
options locale=NB_no;
%include "&filbane/rateprogram/ratefigur_aarsvar.sas";
%ratefigur_aarsvar(dsn=, start=, slutt=, figurnavn=);

%macro ratefigur_aarsvar(
    dsn=, /*Grunnlagsdatsettet for figur, som regel utdata fra rateprogram*/
    yvariabel1=antsnitt, /*Variabel 1 til Y-axis table, antsnitt som default*/
    yvariabel2=popsnitt, /*Variabel 2 til Y-axis table, popsnitt som default*/
    ylabel1=Antall, /*Label til Y-axis table, variabel 1, , Antall som default*/
    ylabel2=Innbyggere, /*Label til Y-axis table, variabel 2, Innbyggere som default*/
    yvarformat1=Nlnum8.0, /*Format på Y-axis table variabel 1, Nlnum8.0 som default 1*/
    yvarformat2=NLnum8.0, /*Format på Y-axis table variabel 2, Nlnum8.0 som default*/
    bo=bohf, /*BoHf, BoRHF eller BoShHN, BoHF som default*/
    start=, /* Startår */
    slutt=, /* Sluttår */
    soyle=1, /*1 dersom man ønsker Norge som søyle, tom dersom Norge som ref linje, 1 som default */
    skala=, /* Skala på x-aksen på figurene - eks: values=(0 to 0.8 by 0.2), ikke angitt som default */
    lagre=1, /*lik 1 dersom lagring av bildefil, 1 som default*/
    figurnavn=, /*navn på bildefil - filnavn blir: &figurnavn._&bo._aarsvar*/
    bildeformat=png, /*Format, png som default*/
    xlabel =  /*Tekst under x-aksen*/
);

/*! 
### Beskrivelse

Makro for å lage ratefigur med årsvariasjon. To kolonner i y-axis table

```
kortversjon (kjøres med default verdier for resten)
%ratefigur_aarsvar(dsn=, start=, slutt=, figurnavn=);
```
### Input
- datasett/output fra rateprogram
- datasett må inneholde alle rate-variabelene og nrate

- følgende let-statement:
    - bildesti (%let bildesti = /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;)
-følgende include-statement
    - anno (%include "&filbane/stiler/Anno_logo_kilde_NPR_SSB.sas";)

### Output
- bildefil med valgt format lagres på angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
*/

/**+++++++ ratefigur_aarsvar_eng +++++++**/
%let bildesti = /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;
%include "&filbane/rateprogram/ratefigur_aarsvar_eng.sas";
%ratefigur_aarsvar_eng(dsn=, yvariabel1=, yvariabel2=, start=, slutt=, figurnavn=);

%ratefigur_aarsvar_eng(
    dsn=, /*Grunnlagsdatsettet for figur, som regel utdata fra rateprogram*/
    /*dsn må inneholde variablene rate: og nrate*/
    yvariabel1=, /*Variabel 1 til Y-axis table*/
    yvariabel2=, /*Variabel 2 til Y-axis table*/
    ylabel1=Patients, /*Label til Y-axis table, variabel 1, , Patients som default*/
    ylabel2=Inhabitants, /*Label til Y-axis table, variabel 2, Inhabitants som default*/
    yvarformat1=8.0, /*Format på Y-axis table variabel 1, 8.0 som default 1*/
    yvarformat2=8.0, /*Format på Y-axis table variabel 2, 8.0 som default*/
    bo=bohf, /*BoHf, BoRHF eller BoShHN, BoHF som default*/
    start=, /* Startår */
    slutt=, /* Sluttår */
    soyle=1, /*1 dersom man ønsker Norge som søyle, tom dersom Norge som ref linje, 1 som default */
    skala=, /* Skala på x-aksen på figurene - eks: values=(0 to 0.8 by 0.2), ikke angitt som default */
    lagre=1, /*lik 1 dersom lagring av bildefil, 1 som default*/
    figurnavn=, /*navn på bildefil*/
    bildeformat=png, /*Format, png som default*/
    xlabel= /*tekst under x-aksen*/
);

/*! 
### Beskrivelse

Makro for å lage ratefigur med årsvariasjon.

```
kortversjon (kjøres med default-verdier for resten)
%ratefigur_aarsvar_eng(dsn=, yvariabel1=, yvariabel2=, start=, slutt=, figurnavn=);
```
### Input
- datasett/output fra rateprogram
- datasett må inneholde alle rate-variabelene og nrate

- følgende let-statement:
    - bildesti (%let bildesti = /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer)
-følgende include-statement
    anno (%include "&filbane/stiler/Anno_logo_kilde_NPR_SSB_eng.sas";)

### Output
- bildefil med valgt format lagres på angitt bildesti

### Endringslogg:
- februar 2022 opprettet, Frank
*/

/**+++++++ Rateprogram +++++++**/
%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
options sasautos=("&filbane/makroer" SASAUTOS);

%include "&filbane/formater/bo.sas";

%include "&filbane/stiler/stil_figur.sas";
%include "&filbane/stiler/Anno_logo_kilde_NPR_SSB.sas";

%include "&filbane/rateprogram/proc_stdrate.sas";
%proc_stdrate(dsn=, rate_var=, standardaar=, start=, slutt=, utdata=);

%proc_stdrate(
    dsn=, /*Grunnlagsdatsettet det skal beregnes rater fra*/
    rate_var=, /*Ratevariabel, kan være aggregert (verdier større enn en) eller dikotom (0,1)*/
    bo=bohf, /*BoHf, BoRHF eller BoShHN, BoHf er default*/
    alder_min=0, /*Laveste alder i utvalget, 0 er default*/
    alder_max=105, /*Høyeste alder i utvalget, 105 er default*/
    rmult=1000, /*Ratemultiplikator, dvs rate pr, 1000 er default*/
    indirekte=, /*Settes lik 1 dersom indirekte, ellers direkte metode, direkte er default*/
    standardaar=, /*Standardiseringsår*/
    start=, /*Startår*/
    slutt=, /*Sluttår*/
    utdata=, /*Navn på utdatasett, utdatasettet er på "wide" form*/
    long=, /*if long=1 --> skriv ut "langt" datasett, ikke aktivert er default*/
    innbygg_dsn=innbygg.INNB_SKDE_BYDEL, /*Innbyggerdatasett: innbygg.INNB_SKDE_BYDEL, innbygg.INNB_SKDE_BYDEL er default*/
    /*Til boområde-makroen: Standard er:(inndata=pop, indreOslo = 0, bydel = 1);*/
    bodef_indreoslo=0, /*0 er standard, 0 er default*/
    bodef_bydel=1 /*1 er standard, 1 er default*/
);

/*! 
### Beskrivelse

Makro for å beregne rater

```
kortversjon (kjøres med default verdier for resten)
%proc_stdrate(dsn=, rate_var=, standardaar=, start=, slutt=, utdata=);
```
### Input
- datasett med variabel det skal beregnes rater på, 
	- kan være 0,1 variabel eller aggregert
	- må innheolde bo-nivået det skal kjøres rater på

### Output
- &utdata + evt. long_&utdata

### Endringslogg:
- februar 2022 opprettet, Frank
*/

/**+++++++ rateprogram_og_figurer_eksempel +++++++**/
/******* Eksempel - Rateprogram og figurer *******/
/*

Rateprogram og figurmakroer hentes via autocomplete

1. Hente inn et fiktivt datasett - grunnlag for rateberegninger
2. Kjør rateprogrammet (5 ganger)
	2a. Slå sammen og fix datasett til årsvariasjonsfigur
	2b. Slå sammen og fix datasett til to- og tredelte figurer
3. Lag årsvariasjonsfigur 
	3a. Med antall kontakter pr pasient i y-axis table
4. Lag figur med todelt søyle
	4a. Med en kolonne på y-axis
	4c. Med tre kolonner på y-axis
5. Lag figur med tredelt søyle
	5a. Med en kolonne på y-axis
	5c. Med tre kolonner på y-axis
	5c. Uten y-axis
*/

/*** 1. Hente inn et fiktivt datasett - grunnlag for rateberegninger ***/
data ratesett;
set frank.eks_rategrunnlag_agg;
run;

/*** 2. Kjør rateprogrammet (5 ganger) ***/
/* Automakro: RATEPROGRAM */

%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
options sasautos=("&filbane/makroer" SASAUTOS);
%include "&filbane/formater/bo.sas";
%include "&filbane/stiler/stil_figur.sas";
%include "&filbane/stiler/Anno_logo_kilde_NPR_SSB.sas";
options locale=NB_no;

%include "&filbane/rateprogram/proc_stdrate.sas";
%proc_stdrate(dsn=ratesett, rate_var=pasienter, standardaar=2019, start=2018, slutt=2020, utdata=pasientrate);
%proc_stdrate(dsn=ratesett, rate_var=kontakter, standardaar=2019, start=2018, slutt=2020, utdata=kontaktrate);
%proc_stdrate(dsn=ratesett, rate_var=prim, standardaar=2019, start=2018, slutt=2020, utdata=primrate);
%proc_stdrate(dsn=ratesett, rate_var=spes, standardaar=2019, start=2018, slutt=2020, utdata=spesrate);
%proc_stdrate(dsn=ratesett, rate_var=overlapp, standardaar=2019, start=2018, slutt=2020, utdata=overlapprate);

/**+++++++2a. Slå sammen og fix datasett til årsvariasjonsfigur +++++++**/
/* Skal lage variabel: kontakter pr pasient - til y-axis table */
%let bo=bohf;
proc sql;
create table pasientrate2 as
select a.*, 
		/*kontakter pr pasient*/
		b.antsnitt as kontakter,
		kontakter / a.antsnitt as kont_pr_pas
from pasientrate as a 
	left join kontaktrate as b on a.&bo=b.&bo;
quit;

/**+++++++2b. Slå sammen og fix datasett til to- og tredelte figurer +++++++**/
/* Automakro: SQL_MERGE_FRA_RATER */
/* Skal ha med antall pasienter, antall kontakter og 
pasientrate, kontaktrate, primærrate, spesialistrate, overlapprate */
%let bo=bohf;
proc sql;
create table samlet as
select a.&bo, a.popsnitt as innbyggere,
		/*f.eks kontakter pr pasient*/
		a.antsnitt as pasienter, b.antsnitt as kontakter,
		kontakter / pasienter as kont_pr_pas,
		/*rater*/
		a.ratesnitt as pas_rate, 
		b.ratesnitt as kont_rate, 
		c.ratesnitt as prim_rate,
		d.ratesnitt as spes_rate,
		e.ratesnitt as overlapp_rate,	
		/*til f.eks to-delt figur*/
		sum(spes_rate,prim_rate) as spesprim_tot,
		spes_rate / calculated spesprim_tot as andel_spes,
		prim_rate / calculated spesprim_tot as andel_prim,
		/*til f.eks tre-delt figur*/
		sum(spes_rate,prim_rate,overlapp_rate) as spesprimolapp_tot,
		spes_rate / calculated spesprimolapp_tot as andel3_spes,
		prim_rate / calculated spesprimolapp_tot as andel3_prim,
		overlapp_rate / calculated spesprimolapp_tot as andel3_olapp
from pasientrate as a 
	left join kontaktrate as b on a.&bo=b.&bo
	left join primrate as c on a.&bo=c.&bo
	left join spesrate as d on a.&bo=d.&bo
	left join overlapprate as e on a.&bo=e.&bo;
quit;


/*** 3. Lag årsvariasjonsfigur ***/
/* Automakro: RATEFIGUR_AARSVAR */
%let bildesti = /sas_smb/skde_analyse/prosjekter/eksempelmappe/figurer;
options locale=NB_no;
%include "&filbane/rateprogram/ratefigur_aarsvar.sas";
%ratefigur_aarsvar(dsn=pasientrate, start=2018, slutt=2020, figurnavn=fopasrate);

/**+++++++3a. Med antall kontakter pr pasient og pasienter i y-axis table +++++++**/
%ratefigur_aarsvar(dsn=pasientrate2, start=2018, slutt=2020,
yvariabel1=kont_pr_pas,ylabel1=Kontaker pr pasient,yvarformat1=Nlnum8.2,
yvariabel2=antsnitt,ylabel2=Pasienter,yvarformat2=Nlnum8.0,
xlabel=Pasientrate pr 1000 innbygger,figurnavn=fopasrate2);

/*** 4. Lag figur med todelt søyle ***/
/* Automakro: RATEFIGUR_TODELT */
%include "&filbane/rateprogram/ratefigur_todelt.sas";
%ratefigur_todelt(dsn=samlet, var1= prim_rate,var2= spes_rate,
	label1= Primær,label2= Spesialist,
	tabvar1= pasienter,tabvar2= innbyggere,
	tablabel1= Pasienter,tablabel2= Innbyggere,
	fmt_tabvar1= nlnum8.0,fmt_tabvar2= nlnum8.0,
	figurnavn= fotodelt,xlabel= Rate pr 1000 innbygger);


/**+++++++4a. Med en kolonne på y-axis - 2 kolonner er default +++++++**/
%ratefigur_todelt(dsn=samlet, var1= prim_rate,var2= spes_rate,
label1= primær,label2= Spesialist,
ant_kol= 1,
tabvar1= andel_spes,
tablabel1= Andel primær,
fmt_tabvar1= nlpct8.1,
figurnavn= fotodelt1,xlabel= Rate pr 1000 innbygger);

/**+++++++4b. Med tre kolonner på y-axis +++++++**/
%ratefigur_todelt(dsn=samlet, var1= prim_rate,var2= spes_rate,
label1= Primær,label2= Spesialist,
ant_kol= 3,
tabvar1= pasienter,tabvar2= innbyggere, tabvar3=andel_spes,
tablabel1= Pasienter,tablabel2= Innbyggere, tablabel3=Andel spesialist,
fmt_tabvar1= nlnum8.0,fmt_tabvar2= nlnum8.0, fmt_tabvar3= nlpct8.1,
figurnavn= fotodelt3,xlabel= Rate pr 1000 innbygger);

/*** 5. Lag figur med tredelt søyle ***/
/* Automakro: RATEFIGUR_TREDELT */
%include "&filbane/rateprogram/ratefigur_tredelt.sas";
%ratefigur_tredelt(dsn=samlet, var1=prim_rate, var2=overlapp_rate, var3=spes_rate,
	label1=Primær ,label2=Overlapp , label3= Spesialist,
	ant_kol=2,
	tabvar1= andel3_spes,tabvar2= innbyggere,  
	tablabel1= Andel spesialist,tablabel2= Innbyggere,   
	fmt_tabvar1=nlpct8.1 ,fmt_tabvar2= nlnum8.0,
	figurnavn=fotredelt ,xlabel=Rate pr 1000 innbygger );

/**+++++++5a. Med en kolonne på y-axis - 2 kolonner er default +++++++**/
%ratefigur_tredelt(dsn=samlet, var1=prim_rate, var2=overlapp_rate, var3=spes_rate,
label1=Primær ,label2=Overlapp , label3= Spesialist,
ant_kol=1,
tabvar1= andel3_spes,tabvar2= innbyggere,  
tablabel1= Andel spesialist,tablabel2= Innbyggere,   
fmt_tabvar1=nlpct8.1 ,fmt_tabvar2= nlnum8.0,
figurnavn=fotredelt1 ,xlabel=Rate pr 1000 innbygger );

/**+++++++5b. Med tre kolonner på y-axis +++++++**/
%ratefigur_tredelt(dsn=samlet, var1=prim_rate, var2=overlapp_rate, var3=spes_rate,
label1=Primær ,label2=Overlapp , label3= Spesialist,
ant_kol=3,
tabvar1= andel3_spes,tabvar2= innbyggere, tabvar3= kont_rate, 
tablabel1= Andel spesialist,tablabel2= Innbyggere, tablabel3=Rate antall kontakter,  
fmt_tabvar1=nlpct8.1 ,fmt_tabvar2= nlnum8.0, fmt_tabvar3= nlnum8.1,
figurnavn=fotredelt3 ,xlabel=Rate pr 1000 innbygger );

/**+++++++5b. Uten y-axis +++++++**/
/*
Denne gir en feil hvis den kjøres samtidig som den forrige
ERROR: ZIP entry duplicate name: xl/media/fotredelt3_bohf_tredelt.png.
*/
/*
%ratefigur_tredelt(dsn=samlet, var1=prim_rate, var2=overlapp_rate, var3=spes_rate,
label1=Primær ,label2=Overlapp , label3= Spesialist,
ant_kol=,figurnavn=fotredelt3 ,xlabel=Rate pr 1000 innbygger );
*/

/**+++++++ Slett_datasett +++++++**/
/*Slett alle datasett fra prosessflyten*/
Proc datasets nolist;
delete _ALL_;
run;
/*Slett alle datasett fra prosessflyt og Work*/
proc datasets lib=work kill nolist memtype=data;
quit;

/**+++++++ sql_aggreger - fjernes +++++++**/
proc sql;
   create table dsn1 as 
   select distinct aar, ermann, alder, komnr, bydel, SUM(poli) as poli
   from dsn
   group by aar, ermann, alder, komnr, bydel;
quit;

/**+++++++ sql_beregning +++++++**/
/* proc sql Beregning*/
Title 'Beregning';
proc sql;
select ermann, mean(alder) as Gjennomsnittsalder
from kols
where kols_merke=1
group by ermann;
quit; title;

Title 'Beregning2';
proc sql;
select boshhn, ermann, mean(alder) as Gjennomsnittsalder,
max(alder) as Maksimumsalder, min(alder) as Minimumsalder,
count(*) as Antall
from kols
where kols_merke=1
group by boshhn, ermann;
quit; title;

/**+++++++ sql_makro - fjernes +++++++**/
proc sql noprint;
select count(distinct aar), count(*)
into :ant_aar, :n_obs
from dsn where aar ne 9999;
quit;

/**+++++++ sql_merge - fjerne +++++++**/
/* Merge med sql */

Title 'Merge inn døddato';
proc sql;
create table kols_dod as
select kols2.*,doddato
from kols2 left join tarzan.dod_dato_pr_19062015
on kols2.pid=dod_dato_pr_19062015.pid;
quit; title;

/*hent inn innbyggertall */
Title 'Merge inn døddato';
proc sql;
create table kols_dod_innb as
select *
from kols_dod left join innbygg.innb_1989_2014
on kols_dod.komnr=innb_1989_2014.komnr and kols_dod.ermann=innb_1989_2014.ermann and
kols_dod.aar=innb_1989_2014.aar and kols_dod.alder=innb_1989_2014.alder;
quit; title;

/**+++++++ SQL_merge_fra_rater +++++++**/
/*** Hent data fra mange datasett (fra rateprogram)****/
/* Her blir det hentet data fra 5 forskjellige datasett (output fra rateprogram-kjøringer):
1=a: primerrate 
2=b: spesialistrate
3=c: overlapprate
4=d: pasientrate
5=e: kontaktrate
*/

%let bo=bohf;
proc sql;
create table rateinfo as
select a.&bo, a.ratesnitt as del1rate, a.antsnitt as del1ant,
		b.ratesnitt as del2rate, b.antsnitt as del2ant,		
		/*til f.eks to-delt figur*/
		sum(del1rate,del2rate) as rate2_tot,
		del1rate / calculated rate2_tot as andel1,
		del2rate / calculated rate2_tot as andel2,
		/*til f.eks tre-delt figur*/
		c.ratesnitt as del3rate, c.antsnitt as del3ant,
		sum(del1rate,del2rate,del3rate) as rate3_tot,
		del1rate / calculated rate3_tot as andel_1,
		del2rate / calculated rate3_tot as andel_2,
		del3rate / calculated rate3_tot as andel_3,
		/*f.eks kontakter pr pasient*/
		d.antsnitt as pasienter, e.antsnitt as kontakter,
		kontakter / pasienter as kont_pr_pas
from primerrate as a 
	left join spesialistrate as b on a.&bo=b.&bo
	left join overlapprate as c on a.&bo=c.&bo
	left join pasientrate as d on a.&bo=d.&bo
	left join kontaktrate as e on a.&bo=e.&bo;
quit;

/**+++++++ sql_triks - fjernes +++++++**/
/* proc sql */

Title 'Beregning';
proc sql;
select ermann, mean(alder) as Gjennomsnittsalder
from kols
where kols_merke=1
group by ermann;
quit; title;

Title 'Beregning2';
proc sql;
select boshhn, ermann, mean(alder) as Gjennomsnittsalder,
max(alder) as Maksimumsalder, min(alder) as Minimumsalder,
count(*) as Antall
from kols
where kols_merke=1
group by boshhn, ermann;
quit; title;

data kols2;
set kols;
keep pid aar Inndato KOLS_merke ErMann Alder BoShHN KomNr;
where kols_merke=1;
run;

/* Merge med sql */

Title 'Merge inn døddato';
proc sql;
create table kols_dod as
select kols2.*,doddato
from kols2 left join tarzan.dod_dato_pr_19062015
on kols2.pid=dod_dato_pr_19062015.pid;
quit; title;

/*hent inn innbyggertall */
Title 'Merge inn døddato';
proc sql;
create table kols_dod_innb as
select *
from kols_dod left join innbygg.innb_1989_2014
on kols_dod.komnr=innb_1989_2014.komnr and kols_dod.ermann=innb_1989_2014.ermann and
kols_dod.aar=innb_1989_2014.aar and kols_dod.alder=innb_1989_2014.alder;
quit; title;

/**+++++++ surv_fo_eks - fjerne +++++++**/
proc format;
value level_fmt
1="Low"
2="Medium"
3="High";
value BoRHF_fmt
1="North"
2="Central"
3="West"
4="South-East";
value gender_fmt
1="Male"
0="Female";
value age_gr_fmt
1="<50"
2="50-59"
3="60-69"
4=">=70";
run;

data survival;
set kurs.fo_surv_eks;
format borhf borhf_fmt. gender gender_fmt. income edu level_fmt. age_gr age_gr_fmt.;
run;

/* Cox-regression - Overlevelsesanalyse med age som tidsvariabel og Pros(0) som sensur */
/* Eksplorerende fase: Hva har betydning og er effektene like på tvers av kjønn og aldersgrupper? */
/* Kjøre univariate analyser for de aktuelle covariatene, stratifisert på kjønn og aldersgrupper */
/* Covariates: Education, Income, BoRHF, Years (to event) */
/* Dvs. 2*4 analyser pr covariat --> 2*4*4 = 32 analyser */
/* Formål: Tabell med HazardRatios og 95% CI for dette */


/* 1. PROC PHREG */
ods graphics on;
proc phreg data=survival plots(overlay=row)=S;
model age*pros(0)=;
strata gender;
run;
ods graphics off; 

ods graphics on;
proc phreg data=survival plots(overlay=row)=S;
class edu(ref="Low") ;
model age*pros(0)=edu;
run;
ods graphics off; 


/* 2. ODS TRACE */


/* 3. ODS OUTPUT */


/* 4. PROC TRANSPOSE */

/**+++++++ test - fjerne +++++++**/
%let branch = main;
%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/&branch;
%include "&filbane/tests/tests.sas";
%test(branch = &branch);

/**+++++++ utvalg - fjerne +++++++**/
data utvalg;
set skde20.t20_avd_2015 (keep= aar alder ermann bohf komnr bydel ncmp: ncsp: Hdiag hdiag2 bdiag:);
Array Prosedyre {*} NC:;
do i=1 to dim(Prosedyre);
   if substr(Prosedyre{i},1,3) in ('JDC','JDD') then Hendelse=1;
end;
array Diagnose {*} Hdiag hdiag2 bdiag:; 
do j=1 to dim(Diagnose);
	if substr(diagnose{j},1,3) in ('C18','C19','D') then Kreft=1;
end;
if hendelse=1 or Kreft=1;
drop nc: i Hdiag hdiag2 bdiag: j;
run;