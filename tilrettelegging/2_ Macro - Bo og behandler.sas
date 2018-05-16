
/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Opprettet av: Linda Leivseth 
Opprettet dato: 06. juni 2015
Sist modifisert: 04.10.2016 av Linda Leivseth og Petter Otterdal
Sist modifisert: 05.01.2017 av Linda Leivseth (lagt til missigverdi 99 for manglende info om bydel2)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


/***********************************************************************************************
************************************************************************************************
MACRO FOR BOSTED OG BEHANDLER

Innhold i syntaxen:
Bområder og behandlingssteder
2.1		Numerisk kommunenummer og bydel (for Oslo)
2.2 	BoShHN - Opptaksområder for lokalsykehusene i Helse Nord
2.3		BoHF - Opptaksområder for helseforetakene
2.4		BoRHF - Opptaksområder for RHF'ene
2.5		Fylke
2.6		Vertskommuner i Helse Nord
2.7 	Behandlingssteder
2.8		BehSh - Behandlende sykehus
2.9		BehHF - Behandlende helseforetak
2.10	BehRHF - Behandlende regionalt helseforetak
2.11    SpesialistKomHN og vertskommuner (Vertskommuner Helse Nord)
2.12    Spesialistenes avtale-RHF 
************************************************************************************************
***********************************************************************************************/

%Macro Bobehandler (innDataSett=, utDataSett=);
Data &Utdatasett;
Set &Inndatasett;

%if &somatikk ne 0 %then %do;
/*
Skille Glittre og Feiring i behandlingsstedKode2  da dette ikke er gjort fra NPR.
Begge rapporterer på org.nr til Feiring (973144383) fra og med 2015.
*/
if behandlingsstedKode2 in (973144383, 974116561) and tjenesteenhetKode=3200 then behandlingsstedKode2=974116561;
%end;

/*
*******************************************************************************
2.1 Numerisk kommunenummer og bydel (for Oslo, Stavanger, Bergen og Trondheim)
*******************************************************************************
*/

bydel2_num=.;
bydel2_num=bydel2+0;
bydel=.;
/* Oslo */
if komNr=0301 and bydel2_num=01 then bydel=030101; /* Gamle Oslo */
if komNr=0301 and bydel2_num=02 then bydel=030102; /* Grünerløkka */
if komNr=0301 and bydel2_num=03 then bydel=030103; /* Sagene */
if komNr=0301 and bydel2_num=04 then bydel=030104; /* St. Hanshaugen */
if komNr=0301 and bydel2_num=05 then bydel=030105; /* Frogner */
if komNr=0301 and bydel2_num=06 then bydel=030106; /* Ullern */
if komNr=0301 and bydel2_num=07 then bydel=030107; /* Vestre Aker */
if komNr=0301 and bydel2_num=08 then bydel=030108; /* Nordre Aker */
if komNr=0301 and bydel2_num=09 then bydel=030109; /* Bjerke */
if komNr=0301 and bydel2_num=10 then bydel=030110; /* Grorud */
if komNr=0301 and bydel2_num=11 then bydel=030111; /* Stovner */
if komNr=0301 and bydel2_num=12 then bydel=030112; /* Alna */
if komNr=0301 and bydel2_num=13 then bydel=030113; /* Østensjø */
if komNr=0301 and bydel2_num=14 then bydel=030114; /* Nordstrand */
if komNr=0301 and bydel2_num=15 then bydel=030115; /* Søndre Nordstrand */
if komNr=0301 and bydel2_num=16 then bydel=030116; /* Sentrum */
if komNr=0301 and bydel2_num=17 then bydel=030117; /* Marka */
if komNr=0301 and bydel2_num=. then bydel=030199; /* Uoppgitt bydel Oslo */
if komNr=0301 and bydel2_num=99 then bydel=030199; /* Uoppgitt bydel Oslo */


/* Stavanger */
if komNr=1103 and bydel2_num=01 then bydel=110301; /* Hundvåg */
if komNr=1103 and bydel2_num=02 then bydel=110302; /* Tasta */
if komNr=1103 and bydel2_num=03 then bydel=110303; /* Eiganes/Våland */
if komNr=1103 and bydel2_num=04 then bydel=110304; /* Madla */
if komNr=1103 and bydel2_num=05 then bydel=110305; /* Storhaug */
if komNr=1103 and bydel2_num=06 then bydel=110306; /* Hillevåg */
if komNr=1103 and bydel2_num=07 then bydel=110307; /* Hinna */
if komNr=1103 and bydel2_num=. then bydel=110399; /* Uoppgitt bydel Stavanger */
if komNr=1103 and bydel2_num=99 then bydel=110399; /* Uoppgitt bydel Stavanger */


/* Bergen */
if komNr=1201 and bydel2_num=01 then bydel=120101; /* Arna */
if komNr=1201 and bydel2_num=02 then bydel=120102; /* Bergenhus */
if komNr=1201 and bydel2_num=03 then bydel=120103; /* Fana */
if komNr=1201 and bydel2_num=04 then bydel=120104; /* Fyllingsdalen */
if komNr=1201 and bydel2_num=05 then bydel=120105; /* Laksevåg */
if komNr=1201 and bydel2_num=06 then bydel=120106; /* Ytrebygda */
if komNr=1201 and bydel2_num=07 then bydel=120107; /* Årstad */
if komNr=1201 and bydel2_num=08 then bydel=120108; /* Åsane */
if komNr=1201 and bydel2_num=. then bydel=120199; /* Uoppgitt bydel Bergen */
if komNr=1201 and bydel2_num=99 then bydel=120199; /* Uoppgitt bydel Bergen */

/* Trondheim */
if komNr=1601 and bydel2_num=01 then bydel=160101; /* Midtbyen */
if komNr=1601 and bydel2_num=02 then bydel=160102; /* Østbyen */
if komNr=1601 and bydel2_num=03 then bydel=160103; /* Lerkendal */
if komNr=1601 and bydel2_num=04 then bydel=160104; /* Heimdal */
if komNr=1601 and bydel2_num=. then bydel=160199; /* Uoppgitt bydel Trondheim */
if komNr=1601 and bydel2_num=99 then bydel=160199; /* Uoppgitt bydel Trondheim */

if KomNr in (1901/*Harstad*/,1915 /*Bjarkøy*/) then KomNr=1903 /*Harstad: Gjelder fra 1. januar 2013, kodes for alle år*/; 
if KomNr in (1723/*Mosvik*/,1729 /*Inderøy*/) then KomNr=1756 /*Inderøy:Gjelder fra 1. januar 2012, kodes for alle år*/; 

/*Ukjente kommunenummer*/
if KomNr in (0,8888,9999) then KomNr=9999; 

/*
********************************************************
2.2 BoShHN - Opptaksområder for lokalsykehusene i Helse Nord
********************************************************

*********************************************************
2.3 BoHF - Opptaksområder for helseforetakene
*********************************************************

*****************************************************
2.4 BoRHF - Opptaksområder for RHF'ene
*****************************************************

******************************************************
2.5 Fylke
******************************************************

*****************************************************
2.6 VertskommHN (Vertskommuner Helse Nord)
*****************************************************
*/

%boomraader();

%if &somatikk ne 0 %then %do;
/*
********************************************************
2.7 Behandlende sykehus
********************************************************
*/

 

	  


/************************
*** Helse Finnmark HF ***
************************/

		if behandlingsstedKode2 in (974795930, 974795833, 978296296,974285959,979873190,983974880) then behSh=10; 

		if behandlingsstedKode2=974795930 /*'Finnmarkssykehuset HF, Kirkenes'*/ then BehSh=11; 
		if behandlingsstedKode2 in (974795833 /*'Finnmarkssykehuset HF, Hammerfest'*/, 978296296 /*Alta helsesenter*/,
			974285959 /*Finnmarkssykehuset, Karasjok*/,979873190 /*'Finnmarkssykehuset, Alta*/) then BehSh=12;



/*************
*** UNN HF ***
*************/

		if behandlingsstedKode2 in (974795787, 974795639, 974795396) then behSh=20; 

		if behandlingsstedKode2=974795787 /*'UNN Tromsø'*/ then BehSh=21;
		if behandlingsstedKode2=974795396 /*'UNN Narvik'*/ then BehSh=23;
		if behandlingsstedKode2=974795639 /*'UNN Harstad'*/ then BehSh=22;



/**************
*** NLSH HF ***
***************/

		if behandlingsstedKode2 in (983974910 /*Nordlandssykehuset*/, 
									    974795574 /*Nordlandssykehuset Vesterålen*/,
										974795558 /*Nordlandssykehuset Lofoten*/,
										974795361 /*Nordlandssykehuset Bodø*/
										993562718 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Bodø*/, 
										993573159 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Gravdal*/, 
										974049767 /*Steigen fødestue*/, 
										996722201 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Stokmarknes*/) then behSh=30; 
		if behandlingsstedKode2 in (974795361 /*Nordlandssykehuset Bodø*/, 
									993562718 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Bodø*/, 
									974049767  /*'Steigen fødestue'*/) then BehSh=33;
		if behandlingsstedKode2 in (974795574 /*Nordlandssykehuset Vesterålen*/, 
								996722201 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Stokmarknes*/) then BehSh=31;
		if behandlingsstedKode2 in (974795558 /*Nordlandssykehuset Lofoten*/,
								993573159 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Gravdal*/) then BehSh=32;

 

/*****************************
*** Helgelandssykehuset HF ***
*****************************/

	if behandlingsstedKode2 in (974795515 /*Helgelandssykehuset HF Mo i Rana*/,
								974795485 /*Helgelandssykehuset HF Mosjøen*/,
								974795477 /*Helgelandssykehuset HF Sandnessjøen*/
								874044342 /*Helgelandssykehuset HF Brønnøysund fødestue*/,
								983974929 /*'Helgelandssykehuset HF*/) then BehSh=40;

	if behandlingsstedKode2=974795515 /*Helgelandssykehuset HF Mo i Rana */ then BehSh=41;
	if behandlingsstedKode2=974795485 /*Helgelandssykehuset HF Mosjøen*/ then BehSh=42;
	if behandlingsstedKode2 in (974795477 /*Helgelandssykehuset HF Sandnessjøen*/,
							   874044342 /*Helgelandssykehuset HF Brønnøysund fødestue*/) then BehSh=43;



/******************************
*** Helse Nord-Trøndelag HF ***
******************************/


		if behandlingsstedKode2 in (974753898 /*Helse Nord-Trøndelag HF -  Namsos*/,
								994974270 /*Helse Nord-Trøndelag, Namsos rehabilitering*/,
								 974754118 /*Helse Nord-Trøndelag HF -  Levanger*/,
							       994958682/*Helse Nord-Trøndelag, Levanger rehabilitering*/) then BehSh=50;

		if behandlingsstedKode2 in (974753898 /*Helse Nord-Trøndelag HF -  Namsos*/, 994974270 /*Helse Nord-Trøndelag, Namsos rehabilitering*/) then BehSh=51;
		if behandlingsstedKode2 in (974754118 /*Helse Nord-Trøndelag HF -  Levanger*/, 994958682/*Helse Nord-Trøndelag, Levanger rehabilitering*/) then BehSh=52;



/****************************
*** St. Olavs hospital HF ***
****************************/

		if behandlingsstedKode2 in (913461223 /*St Olavs hospital, Fysikalsk medisin Øya*/,
      								973254782 /*St Olavs hospital, Trondsletten habiliteringssenter */, 
									974749025 /*St Olavs Hospital, Trondheim*/,
      								974749815 /*St Olavs hospital, Fysikalsk medisin Lian*/,
  								    995413388 /*St Olavs hospital, Hysnes helsefort*/, 
      								974329506 /*St Olavs hospital, Orkdal*/,
				     				974749505 /*St Olavs hospital, Røros*/,
									915621457 /*St Olavs hospital, Ørland*/) then behSh=60; /*St Olav Ørland er bare skrevet til behSh lik 60, ingen spesifisering av lokalisasjon under*/

 		if behandlingsstedKode2 in (913461223 /*St Olavs hospital, Fysikalsk medisin Øya*/,
      								973254782 /*St Olavs hospital, Trondsletten habiliteringssenter */, 
									974749025 /*St Olavs Hospital, Trondheim*/,
      								974749815 /*St Olavs hospital, Fysikalsk medisin Lian*/) then BehSh=61;
		if behandlingsstedKode2 in (974329506 /*St Olavs hospital, Orkdal*/) then BehSh=62;
		if behandlingsstedKode2 in (974749505 /*St Olavs hospital, Røros*/) then BehSh=63;
		if behandlingsstedKode2 in (995413388 /*St Olavs hospital, Hysnes helsefort*/) then BehSh=64;


/*******************************
*** Helse Møre og Romsdal HF ***
*******************************/

		if behandlingsstedKode2 in (974745569 /*Helse Møre og Romsdal HF Molde sjukehus*/,   
      								974746948 /*Helse Møre og Romsdal HF Kristiansund sjukehus*/,  
      								974747138 /*Helse Møre og Romsdal HF Ålesund sjukehus*/,   
      								974747545 /*Helse Møre og Romsdal HF Volda sjukehus*/, 
      								974576929 /*Helse Møre og Romsdal HF, Nevrohjemmet*/, 
      								974577054 /*Helse Møre og Romsdal HF, Aure rehabiliteringssenter*/,  
      								974577216 /*Helse Møre og Romsdal HF, Klinikk for Rehabilitering (Mork)*/,
								    984038135 /*Helse Møre og Romsdal HF, Voksenhabilitering Molde*/) then BehSh=70;

 		if behandlingsstedKode2 in (974745569 /*Helse Møre og Romsdal HF Molde sjukehus*/, 984038135 /*Helse Møre og Romsdal HF, Voksenhabilitering Molde*/) then BehSh=71;
		if behandlingsstedKode2 in (974746948 /*Helse Møre og Romsdal HF Kristiansund sjukehus*/) then BehSh=72;
		if behandlingsstedKode2 in (974747138 /*Helse Møre og Romsdal HF Ålesund sjukehus*/) then BehSh=73;
		if behandlingsstedKode2 in (974747545 /*Helse Møre og Romsdal HF Volda sjukehus*/) then BehSh=74;
		if behandlingsstedKode2 in (974576929 /*Helse Møre og Romsdal HF, Nevrohjemmet*/) then BehSh=76;
		if behandlingsstedKode2 in (974577054 /*Helse Møre og Romsdal HF, Aure rehabiliteringssenter*/) then BehSh=77;
		if behandlingsstedKode2 in (974577216 /*Helse Møre og Romsdal HF, Klinikk for Rehabilitering (Mork)*/) then BehSh=75;

/*********************
*** Helse Førde HF ***
*********************/
		if behandlingsstedKode2 in (983974732 /*Helse Førde HF*/, 
									974743914 /*Helse Førde, Florø*/,
									974744570 /*Helse Førde, Førde*/, 
									974745089 /*Helse Førde, Lærdal*/,
      								974745364 /*Helse Førde, Nordfjord*/) then BehSh=90;

		if behandlingsstedKode2 in (974744570 /*Helse Førde, Førde*/) then BehSh=91;
		if behandlingsstedKode2 in (974745364 /*Helse Førde, Nordfjord*/) then BehSh=92;
		if behandlingsstedKode2 in (974745089 /*Helse Førde, Lærdal*/) then BehSh=93;
		if behandlingsstedKode2 in (974743914 /*Helse Førde, Florø*/) then BehSh=91;

/**********************
*** Helse Bergen HF ***
**********************/

		if behandlingsstedKode2 in (874743372 /*Helse Bergen, Kysthospitalet i Hagevik*/,   
	      							973923811 /*Helse Bergen, Habilitering Voksne*/, 
 									973925032 /*Bergen legevakt*/, 
      								974557169 /*Helse Bergen, Rehabilitering*/,  
     								974557746 /*Helse Bergen, Haukeland*/,  
      								974743272 /*Helse Bergen, Voss*/, 
	  								996663191 /*Helse Bergen, Laboratorie og røntgen Haukeland*/) then BehSh=100;

		if behandlingsstedKode2 in (973923811 /*Helse Bergen, Habilitering Voksne*/, 
      								974557169 /*Helse Bergen, Rehabilitering*/,  
     								974557746 /*Helse Bergen, Haukeland*/,  
      								996663191 /*Helse Bergen, Laboratorie og røntgen Haukeland*/) then BehSh=101;
		if behandlingsstedKode2 in (874743372 /*Helse Bergen, Kysthospitalet i Hagevik*/) then BehSh=102;
		if behandlingsstedKode2 in (974743272 /*Helse Bergen, Voss*/) then BehSh=103;
		if behandlingsstedKode2 in (973925032 /*Bergen legevakt*/) then BehSh=104;

/*********************
*** Helse Fonna HF ***
*********************/
		if behandlingsstedKode2 in (974724774 /*Helse Fonna, Haugesund*/,   
      								974742985 /*Helse Fonna, Stord*/,
								    974743086 /*Helse Fonna, Odda*/,  
      								974829029 /*Helse Fonna, Sauda*/,  
      								976248570 /*Helse Fonna, Haugesund Rehabilitering*/, 
      								996328112 /*Helse Fonna, Stord Rehabilitering*/) then BehSh=110;

		if behandlingsstedKode2 in (974743086 /*Helse Fonna, Odda*/) then BehSh=111;
		if behandlingsstedKode2 in (974742985 /*Helse Fonna, Stord*/, 996328112 /*Helse Fonna, Stord Rehabilitering*/) then BehSh=112;
		if behandlingsstedKode2 in (974724774 /*Helse Fonna, Haugesund*/,   
     								976248570 /*Helse Fonna, Haugesund Rehabilitering*/) then BehSh=113;
		if behandlingsstedKode2 in (974829029 /*Helse Fonna, Sauda*/) then BehSh=114;

/*************************
*** Helse Stavanger HF ***
*************************/
		if behandlingsstedKode2 in (873862122 /*Helse Stavanger, Rehabilitering*/, 
		      						974624680 /*Helse Stavanger, HABU*/, 
			        				974703300 /*Helse Stavanger, Stavanger universitetssjukehus*/,
      								974703327 /*Helse Stavanger, Egersund*/) then BehSh=120;

		if behandlingsstedKode2 in (873862122 /*Helse Stavanger, Rehabilitering*/, 
		      						974624680 /*Helse Stavanger, HABU*/, 
			        				974703300 /*Helse Stavanger, Stavanger universitetssjukehus*/) then BehSh=121;
		if behandlingsstedKode2 in (974703327 /*Helse Stavanger, Egersund*/) then BehSh=122;


/*************************************
*** Haraldsplass diakonale sykehus ***
*************************************/

if behandlingsstedKode2 = 974316285 /*Haraldsplass diakonale sykehus */ then BehSh=260;
/*Haraldsplass diakonale sykehus har eget opptaksområde og er lokalsykehus for bydelene Åsane, Arna, og Bergenhus, 
samt Samnanger og kommunene i Nordhordland.*/


/********************************
*** Resterende Helse Vest RHF ***
********************************/
		if behandlingsstedKode2 in (974737779 /*Betanien spesialistpoliklinikk*/, 
									986106839 /*Haugesund sanitetsforenings revmatismesykehus*/) then BehSh=130;

		if behandlingsstedKode2 in (974737779 /*Betanien spesialistpoliklinikk*/) then BehSh=131;
		if behandlingsstedKode2 in (986106839 /*Haugesund sanitetsforenings revmatismesykehus*/) then BehSh=132; 
		/* Bergen legevakt ligger under Helse Bergen HF siden den delen av Bergen legevakt som rapporterer data til NPR 
		er spesialisthelsetjeneste. Dette er Akuttposten ved Mottaksklinikken ved Haukeland universitetssykehus.  
		Se http://www.helse-bergen.no/no/OmOss/Avdelinger/mottaksklinikken/Sider/akuttpost.aspx. */


/**********************
*** Vestre Viken HF ***
**********************/
		if behandlingsstedKode2 in (874606162 /*Vestre Viken, Hallingdal sjukestugu*/, 
									974631326 /*Vestre Viken, Drammen*/,   
      								974631385 /*Vestre Viken, Kongsberg*/,  
      								974631407 /*Vestre Viken, Ringerike*/,  
      								974705788 /*Vestre Viken, Bærum*/) then behSh=140; /*'Vestre Viken HF'*/ 
 
		if behandlingsstedKode2 in (974631326 /*Vestre Viken, Drammen*/) then behSh=141;
		if behandlingsstedKode2 in (974631385 /*Vestre Viken, Kongsberg*/) then behSh=144;
		if behandlingsstedKode2 in (974631407 /*Vestre Viken, Ringerike*/, 874606162 /*Vestre Viken, Hallingdal sjukestugu*/) then behSh=143;
		if behandlingsstedKode2 in (974705788 /*Vestre Viken, Bærum*/) then behSh=142;


/****************************
*** Sykehuset Telemark HF ***
****************************/
		if behandlingsstedKode2 in (974568209 /*Sykehuset Telemark, Habilitering barn og unge*/,   
      								974568225 /*Sykehuset Telemark, Nordagutu*/,  
      								974633159 /*Sykehuset Telemark, Notodden*/,  
      								974633191 /*Sykehuset Telemark, Skien/Porsgrunn*/,  
      								974798379 /*Sykehuset Telemark, Rjukan*/,  
      								983974155 /*Sykehuset Telemark, Kragerø*/) then BehSh=150; /*'Sykehuset Telemark HF'*/

 		if behandlingsstedKode2 in (974633159 /*Sykehuset Telemark, Notodden*/) then BehSh=153;
		if behandlingsstedKode2 in (974633191 /*Sykehuset Telemark, Skien/Porsgrunn*/, 
									974568209 /*Sykehuset Telemark, Habilitering barn og unge*/	) then BehSh=151;
		if behandlingsstedKode2 in (974798379 /*Sykehuset Telemark, Rjukan*/) then BehSh=154;
		if behandlingsstedKode2 in (983974155 /*Sykehuset Telemark, Kragerø*/) then BehSh=152;
		if behandlingsstedKode2 in (974568225 /*Sykehuset Telemark, Nordagutu*/) then BehSh=155;

/**************************************
*** Akershus universitetssykehus HF ***
**************************************/

		if behandlingsstedKode2=974706490 /*Akershus universitetssykehus*/ then BehSh=160;


/*******************
*** Innlandet HF ***
*******************/
		if behandlingsstedKode2 in (874631752 /*Sykehuset Innlandet, Ottestad*/,   
      								874632562 /*Sykehuset Innlandet, Lillehammer*/,  
									974116650 /*Sykehuset Innlandet, Habiliteringstjenesten i Hedmark, Furnes*/,  
      								974631768 /*Sykehuset Innlandet, Elverum*/,  
      								974631776 /*Sykehuset Innlandet, Kongsvinger*/,  
      								974632535 /*Sykehuset Innlandet, Gjøvik*/,  
      								974632543 /*Sykehuset Innlandet, Granheim lungesykehus*/,  
      								974724960 /*Sykehuset Innlandet, Hamar*/,  
      								974725215 /*Sykehuset Innlandet, Tynset*/,
      								975326136 /*Sykehuset Innlandet, Habiliteringstjenesten i Oppland, Lillehammer*/) then BehSh=170;

		if behandlingsstedKode2 in (874631752 /*Sykehuset Innlandet, Ottestad*/	) then BehSh=177;
		if behandlingsstedKode2 in (874632562 /*Sykehuset Innlandet, Lillehammer*/,  
									975326136 /*Sykehuset Innlandet, Habiliteringstjenesten i Oppland, Lillehammer*/) then BehSh=173;
		if behandlingsstedKode2 in (974631768 /*Sykehuset Innlandet, Elverum*/) then BehSh=171;
		if behandlingsstedKode2 in (974631776 /*Sykehuset Innlandet, Kongsvinger*/) then BehSh=174;
		if behandlingsstedKode2 in (974632535 /*Sykehuset Innlandet, Gjøvik*/) then BehSh=172;
		if behandlingsstedKode2 in (974632543 /*Sykehuset Innlandet, Granheim lungesykehus*/) then BehSh=176;
		if behandlingsstedKode2 in (974725215 /*Sykehuset Innlandet, Tynset*/) then BehSh=175;
		if behandlingsstedKode2 in (974724960 /*Sykehuset Innlandet, Hamar*/) then BehSh=178;
		if behandlingsstedKode2 in (974116650 /*Sykehuset Innlandet, Habiliteringstjenesten i Hedmark, Furnes*/) then BehSh=179; 


/**********************************
*** Oslo universitetssykehus HF ***
**********************************/
		if behandlingsstedKode2 in (874716782 /*OUS, Rikshospitalet*/,   
      								974588951 /*OUS, Aker*/,   
      								974589087 /*OUS, Oslo legevakt*/,   
      								974589095 /*OUS, Ullevål*/,   
      								974705761 /*OUS, Spesialsykehuset for epilepsi*/,  
      								974707152 /*OUS, Radiumhospitalet*/,  
      								974728230 /*OUS, Geilomo barnesykehus*/,        
									974798263 /*OUS, Voksentoppen*/, 
      								975298744 /*OUS, Olafiaklinikken*/,       
									993467049 /*OUS HF*/) then BehSh=180/*Oslo universitetssykehus HF*/;

		if behandlingsstedKode2 in (874716782 /*OUS, Rikshospitalet*/) then BehSh=181;
		if behandlingsstedKode2 in (974588951 /*OUS, Aker*/) then BehSh=182;
		if behandlingsstedKode2 in (974589087 /*OUS, Oslo legevakt*/) then BehSh=183;
		if behandlingsstedKode2 in (974589095 /*OUS, Ullevål*/) then BehSh=184;
		if behandlingsstedKode2 in (974705761 /*OUS, Spesialsykehuset for epilepsi*/) then BehSh=185;
		if behandlingsstedKode2 in (974707152 /*OUS, Radiumhospitalet*/) then BehSh=186;
		if behandlingsstedKode2 in (974728230 /*OUS, Geilomo barnesykehus*/) then BehSh=187;
		if behandlingsstedKode2 in (974798263 /*OUS, Voksentoppen*/) then BehSh=188;
		if behandlingsstedKode2 in (975298744 /*OUS, Olafiaklinikken*/) then BehSh=189;

  

/*************************
*** Sunnaas sykehus HF ***
*************************/

		if behandlingsstedKode2=974589214 /*Sunnaas sykehus*/ then BehSh=190/*Sunnaas sykehus*/;


/***************************
*** Sykehuset Østfold HF ***
***************************/
	/* Lokalisasjoner: Kalnes, Fredrikstad, Moss, Sarpsborg, Halden, Askim og Eidsberg. */

		if behandlingsstedKode2 in (974633698 /*Sykehuset Østfold, Moss*/,
									974633752 /*Sykehuset Østfold*/,   
      								974634052 /*Sykehuset Østfold, Fysioterapi*/, 
      								974703734 /*Sykehuset Østfold, Sarpsborg*/) then BehSh=200/*Sykehuset Østfold HF*/;

 		if behandlingsstedKode2 in (974633698 /*Sykehuset Østfold, Moss*/, 974634052 /*Sykehuset Østfold, Fysioterapi*/) then BehSh=201;
		if behandlingsstedKode2 in (974703734 /*Sykehuset Østfold, Sarpsborg*/) then BehSh=202;

/***************************
*** Sørlandet sykehus HF ***
***************************/

		if behandlingsstedKode2 in (974595214 /*Sørlandet sykehus, Flekkefjord*/,
							      	974595230 /*Sørlandet sykehus, Rehabilitering Kongsgård*/,
									974631091 /*Sørlandet sykehus, Arendal*/,
									974733013 /*Sørlandet sykehus, Kristiansand*/, 
	        						983975240 /*Sørlandet sykehus HF*/) then BehSh=210;

		if behandlingsstedKode2 in (974595214 /*Sørlandet sykehus, Flekkefjord*/) then BehSh=213;
		if behandlingsstedKode2 in (974631091 /*Sørlandet sykehus, Arendal*/) then BehSh=212;
		if behandlingsstedKode2 in (974733013 /*Sørlandet sykehus, Kristiansand*/, 974595230 /*Sørlandet sykehus, Rehabilitering Kongsgård*/) then BehSh=211;

/******************************
*** Sykehuset i Vestfold HF ***
******************************/

		if behandlingsstedKode2 in (974575396 /*Sykehuset i Vestfold, Rehabilitering Stavern*/, 
								 	974633574 /*Sykehuset i Vestfold*/) then BehSh=220;

		if behandlingsstedKode2 in (974633574 /*Sykehuset i Vestfold, Tønsberg*/) then BehSh=221 ;
		if behandlingsstedKode2 in (974575396 /*Sykehuset i Vestfold, Rehabilitering Kysthospitalet Stavern*/) then BehSh=222 ;

/***********************************
*** Diakonhjemmet sykehus ***
***********************************/
		if behandlingsstedKode2 in (974116804 /*Diakonhjemmet sykehus*/) then BehSh=230;

/***********************************
*** Lovisenberg diakonale sykehus **
***********************************/
		if behandlingsstedKode2 in (974207532 /*Lovisenberg diakonale sykehus*/) then BehSh=240;

/***********************************
*** Resterende Helse Sør-Øst RHF ***
***********************************/
		if behandlingsstedKode2 in (985962170 /*Martina Hansens Hospital*/,
									981275721 /*Betanien hospital*/,
									985773238 /*Revmatismesykehuset AS, Lillehammer*/, 
									984630492 /*Oslo kommunale legevakt*/) then BehSh=250;

		if behandlingsstedKode2 in (985962170 /*Martina Hansens Hospital*/) then BehSh=251;
		if behandlingsstedKode2 in (981275721 /*Betanien hospital*/) then BehSh=252;
		if behandlingsstedKode2 in (985773238 /*Revmatismesykehuset AS, Lillehammer*/) then BehSh=253;
		if behandlingsstedKode2=984630492 /*Oslo kommunale legevakt*/ then behSh=254 /*Oslo kommunale legevakt, Observasjonsposten*/;

		/* Oslo legevakt ligger under OUS HF siden den delen av Oslo legevakt som rapporterer data til NPR 
		er spesialisthelsetjeneste. Dette er Oslo skadelegevakt som er en avdeling ved OUS som mottar pasienter med akutte skader.   
		Se http://www.oslo-universitetssykehus.no/omoss_/avdelinger_/skadelegevakt_. */


/**********************
*** Private sykehus ***
**********************/

		if behandlingsstedKode2 in (813381192 /*Aleris Helse AS Stavanger*/,
									879595762 /*Teres Drammen*/,
									879790522 /*Aleris Helse AS Bergen*/,
									897351102 /*Akademikliniken Oslo AS*/,
									914751934 /*Privathospitalet AS*/,
									941455077 /*Medi 3 AS*/,
									971049456 /*Mjøskirurgene*/,
									971937548 /*EEG Labora*/,
									972140295 /*NIMI AS Avd. Mini Ullevål*/,
									972149519 /*Teres Rosenborg*/,
									973129856 /*Volvat medisinske senter AS Oslo*/,
									973144383 /*LHL-klinikkene Feiring*/,
									973156829 /*Haugesund sanitetsforenings revmatismesykehus*/,
									974116561 /*LHL-klinikkene Glittre*/,
									974504863 /*Aleris Helse AS Trondheim*/,
									974518821 /*Teres Bergen*/,
									974917459 /*Norsk diabetikersenter*/,
									975787419 /*Aleris Helse AS Oslo*/,
									975933210 /*FysMed-klinkken AS*/,
									975984168 /*Friskvernklinikken AS*/,
									977208734 /*Privatsykehuset Haugesund AS*/,
									980693732 /*Ringvoll klinikken AS*/,
									980859754 /*Privathospitalet AS*/,
									981096363 /*Teres Sørlandsparken*/,
									981541499 /*Teres Colosseum*/,
									982755999 /*Volvat Stokkan*/,
									983084478 /*Volvat Tromsø*/,
									983896383 /*Teres Colosseum Stavanger*/,
									985766924 /*Bergen Spine Center*/,
									987954167 /*IbsenSykehuset AS*/,
									991811869 /*Kolibri Medical AS*/,
									993240184 /*Aleris Helse AS Tromsø*/,
									995590794 /*SVC Norge AS*/,
									995818728 /*Teres Klinikken Bodø*/,
									996860884 /*Somni Søvnsenter og Spesialisthelsetjenester AS*/,
									/*PO: Supplert med nye behandlingssteder for 2016*/
									912817318 /*Somni AS*/,
									914480752 /*Moloklinikken AS*/,
									915411223 /*Kalbakkenklinikken AS*/,
									916269331 /*A-Medi AS*/,  
      								916588224 /*Preventia AS*/,  
     								998558271 /*Oslo medisinske senter*/,  
      								999230008 /*Ifocus øyeklinikk AS*/) then BehSh=300;	

/*
*****************************************************************
2.8 BehHF - Behandlende helseforetak
*****************************************************************
*/

if 10<=BehSh<=19 then BehHF=1/*Finnmarkssykehuset HF*/;
if 20<=BehSh<=29 then BehHF=2/*UNN HF*/;
if 30<=BehSh<=39 then BehHF=3/*NLSH HF*/;
if 40<=BehSh<49 then BehHF=4/*Helgelandssykehuset HF*/;
if 50<=BehSh<=59 then BehHF=5/*Helse Nord-Trøndelag HF*/;
if 60<= BehSh<=69 then BehHF=6/*St. Olavs Hospital HF*/;
if 70<= BehSh<=79 then BehHF=7; /*Helse Møre og Romsdal HF*/
if 90<= BehSh<=99 then BehHF=9/*Helse Førde HF*/;
if 100<= BehSh<=109 then BehHF=10/*Helse Bergen HF*/;
if 110<= BehSh<=119 then BehHF=11/*Helse Fonna HF*/;
if 120<= BehSh<=129 then BehHF=12/*Helse Stavanger HF*/;
if 130<= BehSh<=139 then BehHF=13/*Resterende Helse Vest RHF*/;
if 140<=BehSh<=149 then BehHF=14/*Vestre Viken HF*/;
if 150<=BehSh<=159 then BehHF=15/*Sykehuset Telemark HF*/;
if 160<=BehSh<=169 then BehHF=16 /*Akershus univ.sh HF*/;
if 170<=BehSh<=179 then BehHF=17/*Sykehuset Innlandet HF*/;
if 180<=BehSh<=189 then BehHF=18/*Oslo universitetssykehus HF*/;
if 190<=BehSh<=199 then BehHF=19/*Sunnaas sykehus HF*/;
if 200<=BehSh<=209 then BehHF=20/*Sykehuset Østfold HF*/;
if 210<=BehSh<=219 then BehHF=21/*Sørlandet sykehus HF*/;
if 220<=BehSh<=229 then BehHF=22/*Sykehuset i Vestfold HF*/;
if BehSh=230 then behHF=23;/*Diakonhjemmet sykehus*/
if BehSh=240 then behHF=24;/*Lovisenberg diakonale sykehus*/;
if 251<=BehSh<=254 then BehHF=25/*Resterende Helse Sør-Øst RHF*/;
if BehSh=260 then BehHF=26;/*Haraldsplass diakonale sykehus*/
if BehSh=300 then BehHF=27/*Private sykehus*/;

/*
*****************************************************************
2.9 BehRHF - Behandlende regionalt helseforetak
*****************************************************************
*/

if BehHF in (1,2,3,4) then BehRHF=1;/* Helse Nord RHF */
if BehHF in (5,6,7) then BehRHF=2;/* Helse Midt-Norge RHF */
if BehHF in (9,10,11,12,13,26)then BehRHF=3;/* Helse Vest RHF */
if BehHF in (14:25) then BehRHF=4;/* Helse Sør-Øst RHF */
if BehHF=27 then BehRHF=5;/* Private sykehus */;
%end;

%if &avtspes ne 0 %then %do;
/*
**************************************************************************
2.11 Definerer SpesialistKomHN og vertskommuner (Vertskommuner Helse Nord)
**************************************************************************
*/


if InstitusjonID in (707149) then SpesialistKomHN='1902';
else if  InstitusjonID in (706001) then SpesialistKomHN='2012';
else if  InstitusjonID in (113674) then SpesialistKomHN='1804';
else if  InstitusjonID in (113743) then SpesialistKomHN='1804';
else if  InstitusjonID in (113769) then SpesialistKomHN='1804';
else if  InstitusjonID in (113794) then SpesialistKomHN='1804';
else if  InstitusjonID in (113832) then SpesialistKomHN='1902';
else if  InstitusjonID in (113330) then SpesialistKomHN='1902';
else if  InstitusjonID in (113659) then SpesialistKomHN='1804';
else if  InstitusjonID in (113678) then SpesialistKomHN='1833';
else if  InstitusjonID in (706003) then SpesialistKomHN='2021';
else if  InstitusjonID in (113327) then SpesialistKomHN='1902';
else if  InstitusjonID in (113605) then SpesialistKomHN='1902';
else if  InstitusjonID in (113866) then SpesialistKomHN='2021';
else if  InstitusjonID in (113682) then SpesialistKomHN='1902';
else if  InstitusjonID in (113740) then SpesialistKomHN='1804';
else if  InstitusjonID in (113440) then SpesialistKomHN='1903';
else if  InstitusjonID in (113572) then SpesialistKomHN='1804';
else if  InstitusjonID in (113588) then SpesialistKomHN='1805';
else if  InstitusjonID in (113630) then SpesialistKomHN='1804';
else if  InstitusjonID in (113192) then SpesialistKomHN='1805';
else if  InstitusjonID in (113400) then SpesialistKomHN='1902';
else if  InstitusjonID in (113463) then SpesialistKomHN='1820';
else if  InstitusjonID in (113477) then SpesialistKomHN='1868';
else if  InstitusjonID in (4201135) then SpesialistKomHN='1804';
else if  InstitusjonID in (113594) then SpesialistKomHN='1868';
else if  InstitusjonID in (113744) then SpesialistKomHN='2012';
else if  InstitusjonID in (113784) then SpesialistKomHN='1902';
else if  InstitusjonID in (113908) then SpesialistKomHN='1868';
else if  InstitusjonID in (113223) then SpesialistKomHN='1804';
else if  InstitusjonID in (113306) then SpesialistKomHN='1902';
else if  InstitusjonID in (113366) then SpesialistKomHN='1902';
else if  InstitusjonID in (113542) then SpesialistKomHN='1805';
else if  InstitusjonID in (113587) then SpesialistKomHN='1804';
else if  InstitusjonID in (113597) then SpesialistKomHN='1902';
/* else if  InstitusjonID in (706002) then SpesialistKomHN='2012';*/
else if  InstitusjonID in (706002) then SpesialistKomHN='1902';/* Arnfinn 3/4-2018: Marco Filipponi holder til i Tromsø...*/
else if  InstitusjonID in (113653) then SpesialistKomHN='1813';
else if  InstitusjonID in (113656) then SpesialistKomHN='1902';
else if  InstitusjonID in (113701) then SpesialistKomHN='1833';
else if  InstitusjonID in (113756) then SpesialistKomHN='1804';
else if  InstitusjonID in (113761) then SpesialistKomHN='1804';
else if  InstitusjonID in (113785) then SpesialistKomHN='2020';
else if  InstitusjonID in (113792) then SpesialistKomHN='1841';
else if  InstitusjonID in (113799) then SpesialistKomHN='1902';
else if  InstitusjonID in (113857) then SpesialistKomHN='1824';
else if  InstitusjonID in (113862) then SpesialistKomHN='1870';
else if  InstitusjonID in (113863) then SpesialistKomHN='1860';
else if  InstitusjonID in (113890) then SpesialistKomHN='1902';
else if  InstitusjonID in (4208625) then SpesialistKomHN='1902';
else if  InstitusjonID in (4208629) then SpesialistKomHN='1804';
else if  InstitusjonID in (4208630) then SpesialistKomHN='1931';
else if  InstitusjonID in (4208690) then SpesialistKomHN='1870';
else if  InstitusjonID in (4209020) then SpesialistKomHN='2012';
else if  InstitusjonID in (4209420) then SpesialistKomHN='1841';
/*Supplert av PO 9/3 2017*/
else if  InstitusjonID in (4209470) then SpesialistKomHN='1804';
else if  InstitusjonID in (4208007) then SpesialistKomHN='1804';
else if  InstitusjonID in (4205450) then SpesialistKomHN='1902';
else if  InstitusjonID in (4205982) then SpesialistKomHN='2012';
else if  InstitusjonID in (113810) then SpesialistKomHN='1804';
else if  InstitusjonID in (113249) then SpesialistKomHN='1804';
else if  InstitusjonID in (113672) then SpesialistKomHN='1805';
else if  InstitusjonID in (113834) then SpesialistKomHN='2012';
/*Supplert av PO 7/7 2017*/
else if  InstitusjonID in (4211315) then SpesialistKomHN='1902'; /*Sandvik, Johan*/ /*Det ser ut til at han også jobber fra Bodø*/
else if  InstitusjonID in (4211824) then SpesialistKomHN='1833'; /*Stoll, Richard*/
else if  InstitusjonID in (4212778) then SpesialistKomHN='1902'; /*Stenklev, Niels Christian*/
else if  InstitusjonID in (4212875) then SpesialistKomHN='1902'; /*Bjarghov, Steinar*/
/*Supplert av Arnfinn 27/3 2018*/
else if  InstitusjonID in (4208245) then SpesialistKomHN='1902'; /* Henrik Tjälve */
else if  InstitusjonID in (4210478) then SpesialistKomHN='1805'; /* Trond Børvik (gitt som Trond Børlie fra NPR)*/

SpesKomHN = SpesialistKomHN +0;
Drop SpesialistKomHN;
Rename SpesKomHN=SpesialistKomHN;


If KomNr=SpesialistKomHN then AvtSpesKomHN=1;
else AvtSpesKomHN = .;



/*
************************************************************************************************
2.12 Spesialistenes avtale-RHF 
************************************************************************************************
*/
/*Egen numerisk variabel for avtaleRHF*/
If InstitusjonID in (113447,113672,113834,113298,113316,113330,113674,
113743,113769,113794,113832,706001,113659,113678,113327,113440,113605,113682,706003,
113740,113866,113572,113630,113588,113192,113249,113400,113463,113477,113594,113744,
113784,113810,113908,4201135,113223,113306,113366,113542,113587,113597,113653,113656,
113701,113756,113761,113785,113792,113799,113857,113862,113863,113890,706002,707149,
4205982,4205450,4208007,4208625,4208629,4208630,4208690,4209020,4209420,4209470,4212778,4212875,4211824,4211315) 
then AvtaleRHF=1;/* Helse Nord RHF*/

Else if institusjonID in (113239,113783,4201406,4204404,707150,113365,113767,4204399,
113333,113399,113926,4201240,4204111,4204397,4204398,4204400,113406,113420,113513,
113676,114504,113194,113531,113649,113776,113917,4201239,113788,113467,113581,113821,
113830,113898,706011,113266,113454,113495,113613,113758,113846,113867,113183,113260,
113474,113549,114431,113764,113706,114503,113638,113736,113259,113282,113612,706010,
113777,113212,113331,113351,113428,113498,113551,113553,113557,113680,113687,113698,
113884,113905,114436,706012,113157,113204,113221,113224,113296,113309,113332,113376,
113408,113419,113475,113518,113530,113543,113611,113689,113723,113840,113872,114432,
114433,114434,114435,4201238,113550,4204078,4204404,4204494,4208473,4208617,4208618,
4208886,4209007,4209071,4209427,4209475,4209476,4204495,4207590,4204399,
113926,4204111,4204397,4204398,4207591,4209530,4210005,4210250,4211897,4212297,4212812,4213021) 
Then AvtaleRHF=2;/*Helse Midt-Norge RHF*/


Else if institusjonID in (113574,113802,113912,4204368,4204369,4204370,4204372,113349,
4204219,4204490,4204371,4204373,4201202,114441,4204486,113808,4201203,4204367,113621,
113364,113324,113515,113196,113211,113228,113242,113297,113305,113424,113483,113585,
113669,113684,113729,113770,113778,113839,113923,114439,706000,113270,113441,113456,
113578,113628,113655,113722,113919,113173,113177,113182,113186,113199,113202,113227,
113236,113253,113303,113320,113340,113360,113375,113391,113397,113407,113414,113484,
113496,113527,113579,113702,113719,113725,113817,113847,113882,113886,113911,113913,
705990,113409,113685,113854,113861,113381,113523,113591,113705,113860,113907,114440,
113401,113321,113482,113679,113892,113274,113361,113377,113389,113478,113504,113512,
113519,113546,113554,113562,113568,113576,113595,113614,113634,113660,113683,113731,
113775,113793,113805,113826,113831,113859,113869,707139,113160,113161,113171,113176,
113275,113280,113343,113344,113379,113403,113415,113417,113437,113448,113453,113466,
113471,113476,113590,113618,113640,113641,113647,113681,113691,113694,113700,113750,
113765,113803,113811,113856,113891,114437,114438,705996,705997,707138,4201201,4204368,
4204369,4204370,4204372,4204490,4207801,4204485,4207418,4204371,4204373,4201202,4204219,
114441,4204486,4201203,4204367,4207370,4208550,4208589,4208632,4209005,4209395,4209399,
4209404,4209406,4209407,4209409,4209425,4209537,4209536,4210003,4210484,4212328,4212482,
4212844,4212850,4211306,4211802,4211805) then AvtaleRHF=3;/*Helse Vest RHF*/

Else if InstitusjonID in (4204492,113436,113721,113833,4204512,113175,113461,113563,
113665,113666,113885,4201197,4204356,113425,113816,113901,4201229,113451,113536,113870,
113560,113181,113818,113820,113243,113264,113537,113763,113800,113293,113607,4204160,
113234,113254,113313,113380,113433,113458,113468,113487,113490,113555,113623,113639,
113709,113728,113787,113804,113881,706532,113165,113188,113216,113257,113258,113272,113278,113372,
113385,113387,113410,113443,113470,113532,113552,113657,113686,113720,113737,113738,
113766,113801,113865,113879,113925,114409,706553,706554,707140,113213,113405,113533,
113753,113159,113167,113168,113172,113191,113200,113214,113217,113247,113248,113250,
113281,113301,113307,113312,113314,113317,113325,113350,113374,113383,113393,113396,
113398,113421,113422,113426,113429,113445,113459,113462,113508,113514,113520,113524,
113589,113592,113603,113604,113610,113631,113643,113664,113668,113692,113704,113708,
113712,113717,113745,113747,113754,113759,113771,113781,113815,113838,113853,113864,
113897,113910,113916,705976,705980,705982,706547,707143,707147,4201243,4201245,113178,
113179,113190,113209,113220,113262,113268,113277,113291,113295,113337,113352,113363,
113402,113423,113431,113446,113492,113502,113505,113522,113539,113540,113545,113548,
113558,113564,113599,113601,113635,113636,113637,113670,113695,113696,113715,113724,
113734,113806,113809,113836,113845,113883,113903,113918,113921,114411,114426,114427,
707142,707145,707159,4201236,113510,113197,113208,113222,113244,113290,113356,113394,
113469,113479,113480,113485,113526,113584,113828,113849,113851,113878,113888,113900,
114412,114423,705979,705985,705986,113231,113285,113506,113673,113850,706558,113358,
113411,113449,113499,113535,113606,113651,113699,113707,113742,113812,113813,113835,
113871,113880,113924,113156,113302,113315,113486,113538,113602,113757,113791,113894,
113909,114425,705987,113198,113261,113357,113412,113516,113571,113629,113633,113697,
113823,113896,114422,705988,707144,113184,113201,113347,113353,113521,113642,113762,
113844,113902,4201198,113914,113342,113439,113893,113166,113255,113288,113444,705983,
4201234,113162,113189,113215,113226,113229,113273,113279,113511,113556,113569,113617,
113626,113627,113650,113714,113726,113774,114408,4201230,4201231,113163,113354,113434,
113507,113547,113566,113648,113654,113658,113497,113768,113790,113164,113210,113218,
113319,113341,113517,113529,113615,113843,113876,114421,707141,113203,113225,113246,
113252,113263,113267,113269,113276,113284,113287,113289,113300,113311,113326,113328,
113329,113335,113345,113348,113362,113367,113368,113384,113388,113392,113413,113416,
113427,113450,113481,113493,113500,113503,113528,113534,113541,113561,113565,113570,
113575,113580,113586,113593,113596,113598,113600,113616,113619,113620,113622,113644,
113652,113671,113690,113703,113713,113727,113751,113752,113760,113773,113780,113786,
113796,113797,113798,113819,113825,113827,113855,113906,113915,113920,113922,114413,
114424,115014,705977,705984,707148,4201247,113158,113169,113170,113174,113180,113185,
113187,113205,113206,113207,113219,113230,113235,113237,113238,113240,113241,113245,
113251,113265,113271,113283,113286,113292,113294,113304,113310,113322,113323,113334,
113338,113339,113346,113355,113369,113370,113371,113373,113378,113382,113386,113390,
113395,113404,113430,113432,113438,113442,113452,113455,113460,113464,113465,113472,
113473,113488,113489,113491,113501,113509,113525,113559,113567,113573,113577,113582,
113608,113609,113624,113632,113645,113646,113661,113662,113663,113667,113675,113677,
113688,113693,113710,113711,113732,113733,113735,113739,113741,113746,113748,113755,
113772,113779,113782,113789,113795,113814,113822,113824,113829,113837,113841,113842,
113848,113852,113858,113868,113874,113875,113877,113887,113889,113895,114410,705978,
705981,707146,4201235,4201237,4201241,4201315,4207536,4201200,4201371,4204438,4207442,
4207841,4201246,4201233,4201406,4204119,4207428,4205054,4204354,4204355,4204437,
4207830,4201244,4204353,4201232,4201337,4201396,4201398,4204487,4204493,4207405,
4207829,4207840,4207906,4208003,706544,4201366,4204374,4207899,4208096,4208210,4208500,
4208593,4208594,4208595,4208596,4208597,4208598,4208599,4208600,4208601,4208659,4208660,
4208662,4208663,4208678,4208686,4208689,4208692,4208713,4208748,4208764,4208798,4208982,
4209002,4209003,4209004,4209070,4209396,4209397,4209398,4209400,4209402,4209403,4209411,
4209414,4209416,4209417,4209418,4209421,4209422,4209423,4209428,4209429,4209430,4209433,
4209442,4209444,4209503,4209504,4209505,4209506,4209507,4209526,4210128,4210130,4210131,
4210132,4210163,4210219,4210249,4210376,4210549,4210550,4210551,4210552,4210584,4210591,
4211931,4212202,4212206,4212207,4212208,4212209,4212286,4212298,4212425,4212440,4212595,
4212828,4212925,4212985,4210960,4211307,4211803,4211804,4211806,4211826) then AVtaleRHF=4; /*Helse Sør-Øst-RHF*/

Format Avtalerhf Borhf.;
%end;

run;

%Mend Bobehandler;
