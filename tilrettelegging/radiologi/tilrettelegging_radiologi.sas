%macro tilrettelegging_radiologi(inndata=, aar=, atlas=1);
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
	- Endret mars 2026, Janice S: Oppdatert for å tilrettelegge de nye LAB_RAD_PAT dataene som vi fikk etter 2024. For de eldre dataene (som vi fikk for atlas i 2023/2024) kjører man med denne makroen også, men med atlas=1.
 */


data radiologi_&aar.;
set &inndata;
where pid ne .;
run;

%if &atlas = 1 %then %do;
%include "&filbane/tilrettelegging/radiologi/trans_dup.sas";
%trans_dup(inndata=radiologi_&aar.);
%end;

/* formater til radiologi */
 %include "&filbane/tilrettelegging/radiologi/formater_radiologi.sas";

data radiologi_&aar.;
set radiologi_&aar.;

%if &atlas = 1 %then %do; 
	rename pasientlopenummer = pid;

	/*endre navn kontakttype, sette på format*/
	kontakttype_rad = kontakttype;
	drop kontakttype pasient_alder;
	format kontakttype_rad kontakttype_rad.;

	/* skille på offentlig og privat */
	if fagomraade_kode eq "PO" then off = 1;
	if fagomraade_kode eq "LR" then priv = 1;

	/*dele diagnose-variabel slik at en kode per celle*/
	array diag {*} $ diagnose1-diagnose3;
		do l=1 to 3;
			diag{l}=scan(diagnoser,l,","); 
		end;
	drop l diagnoser;
	rename ncrpkode=ncrp_kode;
%end;
%else %do;
	tid=0;
	/* omkode aldersgruppe til alder	  */
  	if aldersgruppe='0-9' then alder=0;
  	else alder=input(substr(aldersgruppe,1,2),best4.);
%end;

/*omkode pasient_kjonn til ermann*/
     if pasient_kjonn eq 1     			then ermann=1; /* Mann */
     if pasient_kjonn eq 2     			then ermann=0; /* Kvinne */
     if pasient_kjonn not in  (1:2) 	      then ermann=.;
	 drop pasient_kjonn;
	 format ermann ermann.;


/*dele ncrpkode-variabel slik at en kode per celle*/
array ncrp {*} $ ncrpkode1-ncrpkode40;
	do i=1 to 40;
		ncrp{i}=scan(ncrp_kode,i,"/ , ."); 
	end;
drop i ncrp_kode;

/* radiologi - kodeverk og utvalgskoder */
%if &atlas = 1 %then %do; 
	%include "&filbane/tilrettelegging/radiologi/radiologi_utvalg.sas";
	%radiologi_utvalg;
	%include "&filbane/tilrettelegging/radiologi/radiologi_kodeverk.sas";
	%radiologi_kodeverk;
%end;

/*år, måned og inndato fra dato variabel*/
aar = year(dato);
inndato = dato;
format inndato eurdfdd10.;
drop dato;
run;

%if &atlas = 1 %then %do;
	/* omkode komnr og bydel -> omkodet komnr heter "komnr_mottatt" */
	%include "&filbane/tilrettelegging/radiologi/omkoding_komnr_bydel.sas";
	%omkoding_komnr_bydel(inndata=radiologi_&aar., pas_komnr=pasient_kommune);
%end;

%else %do;
	/*Get komnr and bydel from tknr for:*/
	/*1. if the komnr is missing*/
	/*2. get bydel if the komnr is in  (301,4601,5001,1103)*/
	data radiologi_&aar._b4bydel(keep=pid tknr pasient_kom: kom:);
	set radiologi_&aar.;
	run;

	%include "&filbane/tilrettelegging/radiologi/bydel_NAV_til_HDir.sas";

	data radiologi_&aar.;
	  set radiologi_&aar.;
	 /* use tknr for bydel, six digits
	    data after 2022, use tknr for komnr also, but backfill with pasient_kommune_nr if missing info in tknr
		data before 2022, use pasient_kommune_nr as komnr. */
	
	 %bydel_NAV_til_HDir;
	 if tknr>10000 /*dvs: har bydel; dvs: kommuner (301,4601,5001,1103)*/ then do; 
		komnr=floor(tknr/10**2);
		bydel=tknr;
		if mod(tknr,10**2) eq 99 then bydel = .;
	  end;
	  else komnr=tknr;

	  if komnr=. or komnr=0 or komnr ge 9000 
	  then komnr=pasient_kommune_nr;

	  format komnr bydel best6.;
	run;
%end;
	data radiologi_&aar._b4forny(keep=pid tknr pasient_kom: kom: bydel);
	set radiologi_&aar.;
	run;
/* fornye komnr/bydel */
/* bydelsnr er allerede omkodet -> trenger ikke kjøre makro bydeler etter fornying */
%include "&filbane/makroer/forny_komnr.sas";
%if &atlas = 1 %then %do;
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


%end;

%else %do;
	%forny_komnr(inndata=radiologi_&aar., kommune_nr=komnr);

	/* forny bydel : for those that have gotten new komnr, the komnr part of the bydel should also be changed */
	data radiologi_&aar.;
	set radiologi_&aar.;
	  if floor(bydel/10**2) ne komnr then bydel=komnr*100+mod(bydel,10**2);
	run;
	data radiologi_&aar._after_forny(keep=pid tknr pasient_kom: kom: bydel);
	set radiologi_&aar.;
	run;
%end;

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
data hnana.ncrp_&aar._T3;
set radiologi_&aar;
run;
%mend tilrettelegging_radiologi;