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

%include "&filbane/tilrettelegging/radiologi/bydel_NAV_til_HDir.sas";

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

	 /* use tknr for bydel, six digits
	    use tknr for komnr also, but backfill with pasient_kommune_nr if missing info in tknr
	 */
	
	 %bydel_NAV_til_HDir; /* omkode kommunenr fra NAV til HDdir - likende kode som omkoding_komnr_bydel.sas */

 if tknr>10000 /*dvs: har bydel; dvs: kommuner (301,4601,5001,1103)*/ then do; 
	komnr=floor(tknr/10**2);
	bydel=tknr;
	if mod(tknr,10**2) eq 99 then bydel = .;
 end;
 else komnr=tknr;

	if komnr=. or komnr=0 or komnr ge 9000 
  then komnr=pasient_kommune_nr;

	format komnr  bydel best6.;

run;

/* fornye komnr */
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=&inndata., kommune_nr=komnr);

/* forny bydel : for those that have gotten new komnr, the komnr part of the bydel should also be changed */
data &inndata.;
set &inndata.;
  if floor(bydel/10**2) ne komnr then bydel=komnr*100+mod(bydel,10**2);
run;

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

title "&aar.";
proc freq data=&inndata.;
  format _numeric_ best20.;
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

