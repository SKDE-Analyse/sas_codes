%macro tilrettelegging_pasutvalg(inndata=, aar=);
	/*! 
	### Beskrivelse
	
	Makro for å tilrettelegge pasientutvalgsfiler tilknyttet radiologiatlas.
	
	```
	%tilrettelegging_pasutvalg(inndata=,aar=);
	```
	
	### Input 
		  - Inndata: 
		  - aar:
	
	### Output 
		  - Utdata med variablene:
	
	### Endringslogg:
		- Opprettet desember 2022, Tove J
	 */
	data pasutvalg_&aar.;
	set &inndata;
	
	rename pasientlopenummer = pid
		   kontakttype = kontakttype_pasutv /*anta at kontakttype her er det samme som utlevert i KPR-data?*/
		   '(SELECTMAX(KODEVERK)FROMODB_PROS'n = prosedyrekodeverk;
	
	/*omkode pasient_kjonn til ermann*/
		 if pasient_kjonn eq 1     			then ermann=1; /* Mann */
		 if pasient_kjonn eq 2     			then ermann=0; /* Kvinne */
		 if pasient_kjonn not in  (1:2) 	then ermann=.;
		 drop pasient_kjonn;
		 format ermann ermann.;
	
	/*dele diagnose-variabel slik at en kode per celle*/
	array diag {*} $ diagnose1-diagnose26;
	
		do l=1 to 26;
			diag{l}=scan(diagnoser,l,","); 
		end;
	
		if diagnosekodeverk="ICPC-2B" then do;
			do j=1 to 26;
				len=length(compress(diag{j}));
				if len>6 then
				diag{j}= substr(compress(diag{j}),1,len-4); /*ta vekk de siste 4 siffer for å gjøre det om til ICPC-2*/
			end;
		end;
	drop l diagnoser;
	
	/*dele takst-variabel slik at en kode per celle*/
	/* ta vekk info som angir hvor mange ganger takst er brukt */
	array deletakst {*} $ takst1-takst21;
		do i=1 to 21;
			deletakst{i}=scan(takster,i,","); /*dele variabel "takster" i 26 variabler*/
			deletakst{i} = scan(deletakst{i},1,"x"); /*fjerne info om antall ggr (tar vekk det som starter med "x".*/
		end;
	drop i takster;
	
	/* dele prosedyrekoder-variabel slik at en kode per celle */
	array pros {*} $ prosedyre1-prosedyre20;
		do j=1 to 20;
			pros{j}=scan(prosedyrekoder,j,","); 
		end;
	drop j prosedyrekoder len;
	
	/*år, måned og inndato fra dato variabel*/
	aar = year(dato);
	inndato = dato;
	format inndato eurdfdd10.;
	drop dato;
	
	alder = aar-født;
	drop født;
	run;
	
	/* omkode komnr og bydel -> omkodet komnr heter "komnr_mottatt" */
	%include "&filbane/tilrettelegging/radiologi/omkoding_komnr_bydel.sas";
	%omkoding_komnr_bydel(inndata=pasutvalg_&aar., pas_komnr=pasientkommune);
	
	/* fornye komnr/bydel */
	/* bydelsnr er allerede omkodet -> trenger ikke kjøre makro bydeler etter fornying */
	%include "&filbane/makroer/forny_komnr.sas";
	%forny_komnr(inndata=pasutvalg_&aar., kommune_nr=komnr_mottatt);
	
	/* for å omkode behandler-komnr må komnr-bosted renames for å ikke overskrives */
	data pasutvalg_&aar.;
	set pasutvalg_&aar.;
	rename komnr = komnr_bosted; 
	drop nr komnr_inn komnr_mottatt;
	run;
	
	%forny_komnr(inndata=pasutvalg_&aar., kommune_nr=behandler_kommunenr);
	
	data pasutvalg_&aar.;
	set pasutvalg_&aar.;
	rename komnr = komnr_behandler komnr_bosted=komnr;
	drop nr komnr_inn behandler_kommunenr;
	run;
	
	/* boomraader */
	%include "&filbane/makroer/boomraader.sas";
	%boomraader(inndata=pasutvalg_&aar.);
	
	%include "&filbane/formater/kpr_lege.sas";
	%include "&filbane/formater/bo.sas";
	
	data pasutvalg_&aar.;
		retain 
		pid 
		aar 
		inndato
		tid
		ErMann
		alder
		komnr
		bydel
		fylke
		bohf
		borhf
		boshhn
		komnr_behandler
		FAGOMRAADE_KODE
		PRAKSISTYPE
		kontakttype_pasutv
		diagnosekodeverk
		diagnose1-diagnose26
		prosedyrekodeverk
		prosedyre1-prosedyre20
		takst1-takst21;
		
		set pasutvalg_&aar.;
		format kontakttype_pasutv kontakttype_kpr. ermann ermann. bohf bohf_fmt. borhf borhf_fmt.;
	run;
	
	/* sortere */
	proc sort data=pasutvalg_&aar.;
	by pid inndato;
	run;
	
	data skde20.pasutvalg_&aar._T23;
	set pasutvalg_&aar;
	run;
	 %mend tilrettelegging_pasutvalg;