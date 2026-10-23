%macro tilrettelegging_radiologi(inndata=, aar=);
/*! 
### Beskrivelse

Makro for å tilrettelegge HELFO radiologi-data.

```
%tilrettelegging_radiologi(inndata=,aar=);
```

### Input 
      - Inndata: 
      - aar:

### Output 
      - Utdata med variablene:

### Endringslogg:
	- Opprettet mars 2026, Janice S: basert på den som ligger i tilrettelegging/radiologi, men oppdatert for de nye LAB_RAD_PAT dataene som vi fikk etter 2024, uttrekk fra HELFO. 
      OBS: ingen aggregering, trans_dup(som i atlaset) eller ekskludering av sekudærgranskninger.
 */


data radiologi_&aar.;
set &inndata;
where pid ne .;
run;

/* formater til radiologi */
 %include "&filbane/tilrettelegging/radiologi/formater_radiologi.sas";

data radiologi_&aar.;
set radiologi_&aar.;

	tid=0;
	/* omkode aldersgruppe til alder	  */
  	if aldersgruppe='0-9' then alder=0;
  	else alder=input(substr(aldersgruppe,1,2),best4.);

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


/*år, måned og inndato fra dato variabel*/
aar = year(dato);
inndato = dato;
format inndato eurdfdd10.;
drop dato;
run;

	/*Get komnr and bydel from tknr for:*/
	/*1. if the komnr is missing*/
	/*2. get bydel if the komnr is in  (301,4601,5001,1103)*/
	data radiologi_&aar._b4bydel(keep=pid tknr pasient_kom: kom:);
	set radiologi_&aar.;
	run;

	%include "&filbane/tilrettelegging/helfo/bydel_NAV_til_HDir.sas";

	data radiologi_&aar.;
	  set radiologi_&aar.;
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

	  format komnr bydel best6.;
	run;

/* fornye komnr/bydel */
/* bydelsnr er allerede omkodet -> trenger ikke kjøre makro bydeler etter fornying */
%include "&filbane/makroer/forny_komnr.sas";
%forny_komnr(inndata=radiologi_&aar., kommune_nr=komnr);

/* forny bydel : for those that have gotten new komnr, the komnr part of the bydel should also be changed */
data radiologi_&aar.;
set radiologi_&aar.;
  if floor(bydel/10**2) ne komnr then bydel=komnr*100+mod(bydel,10**2);
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
data hnana.ncrp_&aar._T3;
set radiologi_&aar;
run;
%mend tilrettelegging_radiologi;