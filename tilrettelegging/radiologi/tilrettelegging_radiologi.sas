%macro tilrettelegging_radiologi(inndata=, aar=);
/*! 
### Beskrivelse

Makro for å tilrettelegge radiologi-data (NCRP-filer).

```
%tilrettelegging_radiologi(inndata=,aar=);
```

### Input 
      - Inndata: 
      - aar:

### Output 
      - Utdata med variablene:

### Endringslogg:
    - Opprettet desember 2022, Tove J
 */


data radiologi_&aar.;
set &inndata;
run;

%include "&filbane/tilrettelegging/radiologi/trans_dup.sas";
%trans_dup(inndata=radiologi_&aar.);

/* formater til radiologi */
 %include "&filbane/tilrettelegging/radiologi/formater_radiologi.sas";

data radiologi_&aar.;
set radiologi_&aar.;

rename pasientlopenummer = pid
       pasient_alder = alder;

/*endre navn kontakttype, sette på format*/
kontakttype_rad = kontakttype;
drop kontakttype;
format kontakttype_rad kontakttype_rad.;

/* skille på offentlig og privat */
if fagomraade_kode eq "PO" then off = 1;
if fagomraade_kode eq "LR" then priv = 1;

/*omkode pasient_kjonn til ermann*/
     if pasient_kjonn eq 1     			then ermann=1; /* Mann */
     if pasient_kjonn eq 2     			then ermann=0; /* Kvinne */
     if pasient_kjonn not in  (1:2) 	      then ermann=.;
	 drop pasient_kjonn;
	 format ermann ermann.;

/*dele diagnose-variabel slik at en kode per celle*/
array diag {*} $ diagnose1-diagnose3;
	do l=1 to 3;
		diag{l}=scan(diagnoser,l,","); 
	end;
drop l diagnoser;

/*dele ncrpkode-variabel slik at en kode per celle*/
array ncrp {*} $ ncrpkode1-ncrpkode40;
	do i=1 to 40;
		ncrp{i}=scan(ncrpkode,i,"/ , ."); 
	end;
drop i ncrpkode;

/* radiologi - kodeverk og utvalgskoder */
%include "&filbane/tilrettelegging/radiologi/radiologi_utvalg.sas";
%radiologi_utvalg;
%include "&filbane/tilrettelegging/radiologi/radiologi_kodeverk.sas";
%radiologi_kodeverk;

/*år, måned og inndato fra dato variabel*/
aar = year(dato);
inndato = dato;
format inndato eurdfdd10.;
drop dato;
run;

/* omkode komnr og bydel -> omkodet komnr heter "komnr_mottatt" */
%include "&filbane/tilrettelegging/radiologi/omkoding_komnr_bydel.sas";
%omkoding_komnr_bydel(inndata=radiologi_&aar., pas_komnr=pasient_kommune);

/* fornye komnr/bydel */
/* bydelsnr er allerede omkodet -> trenger ikke kjøre makro bydeler etter fornying */
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=radiologi_&aar., kommune_nr=komnr_mottatt);

/* for å omkode behandler-komnr må komnr-bosted renames for å ikke overskrives */
data radiologi_&aar.;
set radiologi_&aar.;
rename komnr = komnr_bosted; 
drop nr komnr_inn komnr_mottatt;
run;

%forny_komnr(inndata=radiologi_&aar., kommune_nr=behandler_kommunenr);

data radiologi_&aar.;
set radiologi_&aar.;
rename komnr = komnr_behandler komnr_bosted=komnr;
drop nr komnr_inn behandler_kommunenr;
run;

/* boomraader */
%include "&filbane/makroer/boomraader.sas";
%boomraader(inndata=radiologi_&aar.);

data radiologi_&aar.;
retain 
pid 
aar 
inndato
ErMann
alder
komnr
bydel
bohf
borhf
boshhn
ncrpkode1-ncrpkode40;
set radiologi_&aar.;
/* sette på bo-formater */
format bohf bohf_fmt. borhf borhf_fmt. boshhn boshhn_fmt.;
run;

/* sortere */
proc sort data=radiologi_&aar.;
by pid inndato;
run;

/* lagre tilrettelagt datasett */
data skde20.ncrp_&aar._T23;
set radiologi_&aar;
run;
%mend tilrettelegging_radiologi;