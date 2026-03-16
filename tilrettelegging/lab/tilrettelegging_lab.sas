/*! 
### Beskrivelse

Makro for å tilrettelegge lab-data (LAB_PAT_RAD_OFF* og LAB_PAT_RAD_PRIV*).

```
%tilrettelegging_lab(inndata=,aar=);
```

### Input 
      - Inndata: 
      - aar:

### Output 
      - Utdata med variablene:

### Endringslogg:
    - Opprettet mars 2026, Janice S
 */


%macro tilrettelegging_lab(inndata=, aar=);

data &inndata.;
  set &inndata.;

  if aldersgruppe='0-9' then alder=0;
  else alder=input(substr(aldersgruppe,1,2),best4.);

  /*omkode pasient_kjonn til ermann*/
     if pasient_kjonn eq 1     			then ermann=1; /* Mann */
     if pasient_kjonn eq 2     			then ermann=0; /* Kvinne */
     if pasient_kjonn not in  (1:2) 	      then ermann=.;
	 drop pasient_kjonn;
	 format ermann ermann.;

  /*år, måned og inndato fra dato variabel*/
  aar = year(dato);
  inndato = dato;
  format inndato eurdfdd10.;

 /*hent ut to siste siffer for å lage bydel slik vi vanligvis mottar den*/
 /* dette for å kunne bruke makroer som krever bydelsnr som to siffer */
 if tknr>10000 /*dvs: har bydel; dvs: kommuner (301,4601,5001,1103)*/ then do; 
	bydel=tknr;
	if mod(tknr,10**2) eq 99 then bydel = .;
	komnr2=floor(tknr/10**2);
	format komnr komnr2 bydel best6.;
  end;
  else komnr2=tknr;

  if komnr=. or komnr=0 or komnr ge 9000 then komnr=komnr2;
  if komnr ne komnr2 then bydel=.;

run;

/* fornye komnr/bydel */
/* bydelsnr er allerede omkodet -> trenger ikke kjøre makro bydeler etter fornying */
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=&inndata., kommune_nr=komnr);

/* boomraader */
%include "&filbane/makroer/boomraader.sas";
%boomraader(inndata=&inndata.);

/*lab fagomårder*/
/*Look up nlkkode from the kodeverk and attached the corresponding fagområde to the input file */
DATA lab_kodeverk_23112025;
  SET klindash.lab_kodeverk_23112025;

  rename kode=NLK_KODE 'Primært fagområde'n=lab_fag;
run;

data &inndata. (drop=r);
  retain lab_fag ;
  length nlk_kode $10 lab_fag $28; /* Declare variables used in hash */
   if _N_ = 1 then do;
      declare hash flags(dataset: "lab_kodeverk_23112025");
      flags.defineKey("nlk_kode");
      flags.defineData("nlk_kode","lab_fag");
      flags.defineDone();
   end;

   set &inndata.;

   r=flags.find(); 
run;

proc freq data=&inndata.;
  tables lab_fag / missing;
run;


data &inndata.;
retain 
pid 
aar 
inndato
enkeltregning
ErMann
alder
komnr
bydel
bohf
borhf
bosh
boshhn
offpriv
nlk_kode
nlk_fag
nlkrefusjon;
set &inndata.;
/* sette på bo-formater */
format bohf bohf_fmt. borhf borhf_fmt. boshhn boshhn_fmt. bosh bosh_fmt. bodps bodps_fmt.;
run;

/* sortere */
proc sort data=&inndata. out=hnana.nlk_&aar._T3;
by pid inndato;
run;

%mend;

