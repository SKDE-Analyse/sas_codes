
/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Opprettet av: Linda Leivseth 
Opprettet dato: 06. juni 2015
Sist modifisert: 04.10.2016 av Linda Leivseth og Petter Otterdal
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


/***********************************************************************************************
************************************************************************************************
MACRO FOR BOSTED OG BEHANDLER

Innhold i syntaxen:
Bomr�der og behandlingssteder
2.1		Numerisk kommunenummer og bydel (for Oslo)
2.2 	BoShHN - Opptaksomr�der for lokalsykehusene i Helse Nord
2.3		BoHF - Opptaksomr�der for helseforetakene
2.4		BoRHF - Opptaksomr�der for RHF'ene
2.5		Fylke
2.6		Vertskommuner i Helse Nord
2.7 	Behandlingssteder
2.8		BehSh - Behandlende sykehus
2.9		BehHF - Behandlende helseforetak
2.10	BehRHF - Behandlende regionalt helseforetak

************************************************************************************************
***********************************************************************************************/

/* Fjerne dette hvis behandlingsstedKode2 er riktig for Glittre og Feiring */

/* NB! Sjekk om Glittre og Feiring er skilt i behandlingsstedKode2 i data fra og med 2015 */
/* Syntaks for sjekk og eventuell korrigering:*/
/*PROC TABULATE*/
/*DATA=GLITTRE_FEIRING;*/
/*	WHERE (behandlingsstedKode2 in (973144383, 974116561));*/
/*	CLASS aar /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS tjenesteenhetKode /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS tjenesteenhetLokal /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS behandlingsstedKode2 /	ORDER=UNFORMATTED MISSING;*/
/*	TABLE */
/*behandlingsstedKode2*tjenesteenhetKode*tjenesteenhetLokal*ALL={LABEL="Total"},*/
/*N*aar;*/
/*RUN;*/
/**/
/*data GLITTRE_FEIRING_korr;*/
/*set GLITTRE_FEIRING;*/
/*if behandlingsstedKode2 in (973144383, 974116561) and tjenesteenhetKode=3200 then behandlingsstedKode2=974116561;*/
/*run;*/
/**/
/*PROC TABULATE*/
/*DATA=GLITTRE_FEIRING_korr;*/
/*	WHERE (behandlingsstedKode2 in (973144383, 974116561));*/
/*	CLASS aar /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS tjenesteenhetKode /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS tjenesteenhetLokal /	ORDER=UNFORMATTED MISSING;*/
/*	CLASS behandlingsstedKode2 /	ORDER=UNFORMATTED MISSING;*/
/*	TABLE */
/*behandlingsstedKode2*tjenesteenhetKode*tjenesteenhetLokal*ALL={LABEL="Total"},*/
/*N*aar;*/
/*RUN; */

/*****************************************************************************************************/

%Macro Bobehandler (innDataSett=, utDataSett=);
Data &Utdatasett;
Set &Inndatasett;

/*
Skille Glittre og Feiring i behandlingsstedKode2  da dette ikke er gjort fra NPR.
Begge rapporterer p� org.nr til Feiring (973144383) fra og med 2015.
*/

if behandlingsstedKode2 in (973144383, 974116561) and tjenesteenhetKode=3200 then behandlingsstedKode2=974116561;

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
if komNr=0301 and bydel2_num=02 then bydel=030102; /* Gr�nerl�kka */
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
if komNr=0301 and bydel2_num=13 then bydel=030113; /* �stensj� */
if komNr=0301 and bydel2_num=14 then bydel=030114; /* Nordstrand */
if komNr=0301 and bydel2_num=15 then bydel=030115; /* S�ndre Nordstrand */
if komNr=0301 and bydel2_num=16 then bydel=030116; /* Sentrum */
if komNr=0301 and bydel2_num=17 then bydel=030117; /* Marka */
if komNr=0301 and bydel2_num=. then bydel=030199; /* Uoppgitt bydel Oslo */


/* Stavanger */
if komNr=1103 and bydel2_num=01 then bydel=110301; /* Hundv�g */
if komNr=1103 and bydel2_num=02 then bydel=110302; /* Tasta */
if komNr=1103 and bydel2_num=03 then bydel=110303; /* Eiganes/V�land */
if komNr=1103 and bydel2_num=04 then bydel=110304; /* Madla */
if komNr=1103 and bydel2_num=05 then bydel=110305; /* Storhaug */
if komNr=1103 and bydel2_num=06 then bydel=110306; /* Hillev�g */
if komNr=1103 and bydel2_num=07 then bydel=110307; /* Hinna */
if komNr=1103 and bydel2_num=. then bydel=110399; /* Uoppgitt bydel Stavanger */


/* Bergen */
if komNr=1201 and bydel2_num=01 then bydel=120101; /* Arna */
if komNr=1201 and bydel2_num=02 then bydel=120102; /* Bergenhus */
if komNr=1201 and bydel2_num=03 then bydel=120103; /* Fana */
if komNr=1201 and bydel2_num=04 then bydel=120104; /* Fyllingsdalen */
if komNr=1201 and bydel2_num=05 then bydel=120105; /* Laksev�g */
if komNr=1201 and bydel2_num=06 then bydel=120106; /* Ytrebygda */
if komNr=1201 and bydel2_num=07 then bydel=120107; /* �rstad */
if komNr=1201 and bydel2_num=08 then bydel=120108; /* �sane */
if komNr=1201 and bydel2_num=. then bydel=120199; /* Uoppgitt bydel Bergen */

/* Trondheim */
if komNr=1601 and bydel2_num=01 then bydel=160101; /* Midtbyen */
if komNr=1601 and bydel2_num=02 then bydel=160102; /* �stbyen */
if komNr=1601 and bydel2_num=03 then bydel=160103; /* Lerkendal */
if komNr=1601 and bydel2_num=04 then bydel=160104; /* Heimdal */
if komNr=1601 and bydel2_num=. then bydel=160199; /* Uoppgitt bydel Trondheim */

/* 
**************************************************/
/*IKKE KODET OPP, MEN AKTUELT SENERE?:*/
/*Bosykehus Helse Bergen
 - Venter p� tilbakemelding fra Lars R�nningen i SAMDATA/FIOA som skal ha en ny runde med Helse Vest RHF ang�ende opptaksomr�der i Bergen (per 04.10.2016)
**************************************************/
/*GEOGRAFISK SEKTORISERING AV BERGEN LOKALSYKEHUSOMR�DE. SEKTORISERING INDREMEDISIN IVERKSETTES 1. JANUAR 1999
F�lgende sektorisering er vedtatt:

Haraldsplass Diakonale sykehus (HDS);
**********************************************
Bergen kommune, bydelene: Sentrum, Sandviken, Eidsv�g-Salhus, �sane, Arna (gammel informasjon)
Kommunene: Lind�s, Meland, Rad�y, Austrheim, Fedje, Masfjorden, Samnanger, Oster�y (gammel informasjon)

Informasjon fra Haraldsplass Diakonale Sykehus ved P�l Asle Reiersgaars 29.09.2106:
Basert p� de ulike avtaler som foreligger er HDS sitt geografiske �H-opptaksomr�de som f�lger:
 
-          Nordhordland:   Lind�s, Meland, Oster�y, Rad�y, Austrheim, Modalen, Fedje, Masfjorden 
-          Gulen (offisielt fra 01.09.2016)
-          Samnanger: kommunen betaler HDS for drift av en �HD-seng
-          Bergen kommune: bydelene Arna. Bergenhus  og �sane
 
N�r det gjelder kirurgi og ortopedi har vi en �H-avtale med HUS/HBE. Den fungere slik:
 
-          FCF (l�rhalsbrudd): hver 3. til HDS
-          5 f�rste kirurgiske og/eller ortopedisk �H g�r til HDS
-          �n ekstra operasjonsklar ortopedisk pasient mottas daglig ved HDS etter innleggelse
og klarering ved HUS. En av disse pasientene per uke kan v�re FCF (l�rhalsbrudd)

Linda: "Fram til n� har vi gruppert alle bosatte i f�lgende kommuner til Helse Bergen HF: 1201,1233,1234,1235,1238,1241,1242,1243,1244,1245,1246,
1247,1251,1252,1253,1256,1259,1260,1263,1264,1265,1266. Ut ifra det du skriver under kan det h�res ut som at dette ikke er helt riktig. 
Hva mener du?" 
P�l: "Ja dette blir feil, vi har en klar fordeling i Bergen p� hvilke kommuner og bydeler som h�rer til de to sykehusene." 



Haukeland Universitetssykehus (HUS);
************************************
Bergen kommune, bydelene: Land�s, L�vstakken, Fana, Ytrebygda, Fyllingsdalen, Loddefjord, laksev�g
Kommunene: Os, Fusa, Sund, Fjell, �ygarden og Ask�y*/


if KomNr in (1901/*Harstad*/,1915 /*Bjark�y*/) then KomNr=1903 /*Harstad: Gjelder fra 1. januar 2013, kodes for alle �r*/; 
if KomNr in (1723/*Mosvik*/,1729 /*Inder�y*/) then KomNr=1756 /*Inder�y:Gjelder fra 1. januar 2012, kodes for alle �r*/; 

/*Ukjente kommunenummer*/
if KomNr in (0,8888,9999) then KomNr=9999; 

/*
********************************************************
2.2 BoShHN - Opptaksomr�der for lokalsykehusene i Helse Nord
********************************************************

*********************************************************
2.3 BoHF - Opptaksomr�der for helseforetakene
*********************************************************

*****************************************************
2.4 BoRHF - Opptaksomr�der for RHF'ene
*****************************************************

******************************************************
2.5 Fylke
******************************************************

*****************************************************
2.6 VertskommHN (Vertskommuner Helse Nord)
*****************************************************
*/

%boomraader();

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

		if behandlingsstedKode2=974795787 /*'UNN Troms�'*/ then BehSh=21;
		if behandlingsstedKode2=974795396 /*'UNN Narvik'*/ then BehSh=23;
		if behandlingsstedKode2=974795639 /*'UNN Harstad'*/ then BehSh=22;



/**************
*** NLSH HF ***
***************/

		if behandlingsstedKode2 in (983974910 /*Nordlandssykehuset*/, 
									    974795574 /*Nordlandssykehuset Vester�len*/,
										974795558 /*Nordlandssykehuset Lofoten*/,
										974795361 /*Nordlandssykehuset Bod�*/
										993562718 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Bod�*/, 
										993573159 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Gravdal*/, 
										974049767 /*Steigen f�destue*/, 
										996722201 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Stokmarknes*/) then behSh=30; 
		if behandlingsstedKode2 in (974795361 /*Nordlandssykehuset Bod�*/, 
									993562718 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Bod�*/, 
									974049767  /*'Steigen f�destue'*/) then BehSh=33;
		if behandlingsstedKode2 in (974795574 /*Nordlandssykehuset Vester�len*/, 
								996722201 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Stokmarknes*/) then BehSh=31;
		if behandlingsstedKode2 in (974795558 /*Nordlandssykehuset Lofoten*/,
								993573159 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Gravdal*/) then BehSh=32;

 

/*****************************
*** Helgelandssykehuset HF ***
*****************************/

	if behandlingsstedKode2 in (974795515 /*Helgelandssykehuset HF Mo i Rana*/,
								974795485 /*Helgelandssykehuset HF Mosj�en*/,
								974795477 /*Helgelandssykehuset HF Sandnessj�en*/
								874044342 /*Helgelandssykehuset HF Br�nn�ysund f�destue*/,
								983974929 /*'Helgelandssykehuset HF*/) then BehSh=40;

	if behandlingsstedKode2=974795515 /*Helgelandssykehuset HF Mo i Rana */ then BehSh=41;
	if behandlingsstedKode2=974795485 /*Helgelandssykehuset HF Mosj�en*/ then BehSh=42;
	if behandlingsstedKode2 in (974795477 /*Helgelandssykehuset HF Sandnessj�en*/,
							   874044342 /*Helgelandssykehuset HF Br�nn�ysund f�destue*/) then BehSh=43;



/******************************
*** Helse Nord-Tr�ndelag HF ***
******************************/


		if behandlingsstedKode2 in (974753898 /*Helse Nord-Tr�ndelag HF -  Namsos*/,
								994974270 /*Helse Nord-Tr�ndelag, Namsos rehabilitering*/,
								 974754118 /*Helse Nord-Tr�ndelag HF -  Levanger*/,
							       994958682/*Helse Nord-Tr�ndelag, Levanger rehabilitering*/) then BehSh=50;

		if behandlingsstedKode2 in (974753898 /*Helse Nord-Tr�ndelag HF -  Namsos*/, 994974270 /*Helse Nord-Tr�ndelag, Namsos rehabilitering*/) then BehSh=51;
		if behandlingsstedKode2 in (974754118 /*Helse Nord-Tr�ndelag HF -  Levanger*/, 994958682/*Helse Nord-Tr�ndelag, Levanger rehabilitering*/) then BehSh=52;



/****************************
*** St. Olavs hospital HF ***
****************************/

		if behandlingsstedKode2 in (913461223 /*St Olavs hospital, Fysikalsk medisin �ya*/,
      								973254782 /*St Olavs hospital, Trondsletten habiliteringssenter */, 
									974749025 /*St Olavs Hospital, Trondheim*/,
      								974749815 /*St Olavs hospital, Fysikalsk medisin Lian*/,
  								    995413388 /*St Olavs hospital, Hysnes helsefort*/, 
      								974329506 /*St Olavs hospital, Orkdal*/,
				     				974749505 /*St Olavs hospital, R�ros*/,
									915621457 /*St Olavs hospital, �rland*/) then behSh=60; /*St Olav �rland er bare skrevet til behSh lik 60, ingen spesifisering av lokalisasjon under*/

 		if behandlingsstedKode2 in (913461223 /*St Olavs hospital, Fysikalsk medisin �ya*/,
      								973254782 /*St Olavs hospital, Trondsletten habiliteringssenter */, 
									974749025 /*St Olavs Hospital, Trondheim*/,
      								974749815 /*St Olavs hospital, Fysikalsk medisin Lian*/) then BehSh=61;
		if behandlingsstedKode2 in (974329506 /*St Olavs hospital, Orkdal*/) then BehSh=62;
		if behandlingsstedKode2 in (974749505 /*St Olavs hospital, R�ros*/) then BehSh=63;
		if behandlingsstedKode2 in (995413388 /*St Olavs hospital, Hysnes helsefort*/) then BehSh=64;


/*******************************
*** Helse M�re og Romsdal HF ***
*******************************/

		if behandlingsstedKode2 in (974745569 /*Helse M�re og Romsdal HF Molde sjukehus*/,   
      								974746948 /*Helse M�re og Romsdal HF Kristiansund sjukehus*/,  
      								974747138 /*Helse M�re og Romsdal HF �lesund sjukehus*/,   
      								974747545 /*Helse M�re og Romsdal HF Volda sjukehus*/, 
      								974576929 /*Helse M�re og Romsdal HF, Nevrohjemmet*/, 
      								974577054 /*Helse M�re og Romsdal HF, Aure rehabiliteringssenter*/,  
      								974577216 /*Helse M�re og Romsdal HF, Klinikk for Rehabilitering (Mork)*/,
								    984038135 /*Helse M�re og Romsdal HF, Voksenhabilitering Molde*/) then BehSh=70;

 		if behandlingsstedKode2 in (974745569 /*Helse M�re og Romsdal HF Molde sjukehus*/, 984038135 /*Helse M�re og Romsdal HF, Voksenhabilitering Molde*/) then BehSh=71;
		if behandlingsstedKode2 in (974746948 /*Helse M�re og Romsdal HF Kristiansund sjukehus*/) then BehSh=72;
		if behandlingsstedKode2 in (974747138 /*Helse M�re og Romsdal HF �lesund sjukehus*/) then BehSh=73;
		if behandlingsstedKode2 in (974747545 /*Helse M�re og Romsdal HF Volda sjukehus*/) then BehSh=74;
		if behandlingsstedKode2 in (974576929 /*Helse M�re og Romsdal HF, Nevrohjemmet*/) then BehSh=76;
		if behandlingsstedKode2 in (974577054 /*Helse M�re og Romsdal HF, Aure rehabiliteringssenter*/) then BehSh=77;
		if behandlingsstedKode2 in (974577216 /*Helse M�re og Romsdal HF, Klinikk for Rehabilitering (Mork)*/) then BehSh=75;

/*********************
*** Helse F�rde HF ***
*********************/
		if behandlingsstedKode2 in (983974732 /*Helse F�rde HF*/, 
									974743914 /*Helse F�rde, Flor�*/,
									974744570 /*Helse F�rde, F�rde*/, 
									974745089 /*Helse F�rde, L�rdal*/,
      								974745364 /*Helse F�rde, Nordfjord*/) then BehSh=90;

		if behandlingsstedKode2 in (974744570 /*Helse F�rde, F�rde*/) then BehSh=91;
		if behandlingsstedKode2 in (974745364 /*Helse F�rde, Nordfjord*/) then BehSh=92;
		if behandlingsstedKode2 in (974745089 /*Helse F�rde, L�rdal*/) then BehSh=93;
		if behandlingsstedKode2 in (974743914 /*Helse F�rde, Flor�*/) then BehSh=91;

/**********************
*** Helse Bergen HF ***
**********************/

		if behandlingsstedKode2 in (874743372 /*Helse Bergen, Kysthospitalet i Hagevik*/,   
	      							973923811 /*Helse Bergen, Habilitering Voksne*/, 
 									973925032 /*Bergen legevakt*/, 
      								974557169 /*Helse Bergen, Rehabilitering*/,  
     								974557746 /*Helse Bergen, Haukeland*/,  
      								974743272 /*Helse Bergen, Voss*/, 
	  								996663191 /*Helse Bergen, Laboratorie og r�ntgen Haukeland*/) then BehSh=100;

		if behandlingsstedKode2 in (973923811 /*Helse Bergen, Habilitering Voksne*/, 
      								974557169 /*Helse Bergen, Rehabilitering*/,  
     								974557746 /*Helse Bergen, Haukeland*/,  
      								996663191 /*Helse Bergen, Laboratorie og r�ntgen Haukeland*/) then BehSh=101;
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
/*Haraldsplass diakonale sykehus har eget opptaksomr�de og er lokalsykehus for bydelene �sane, Arna, og Bergenhus, 
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
      								974705788 /*Vestre Viken, B�rum*/) then behSh=140; /*'Vestre Viken HF'*/ 
 
		if behandlingsstedKode2 in (974631326 /*Vestre Viken, Drammen*/) then behSh=141;
		if behandlingsstedKode2 in (974631385 /*Vestre Viken, Kongsberg*/) then behSh=144;
		if behandlingsstedKode2 in (974631407 /*Vestre Viken, Ringerike*/, 874606162 /*Vestre Viken, Hallingdal sjukestugu*/) then behSh=143;
		if behandlingsstedKode2 in (974705788 /*Vestre Viken, B�rum*/) then behSh=142;


/****************************
*** Sykehuset Telemark HF ***
****************************/
		if behandlingsstedKode2 in (974568209 /*Sykehuset Telemark, Habilitering barn og unge*/,   
      								974568225 /*Sykehuset Telemark, Nordagutu*/,  
      								974633159 /*Sykehuset Telemark, Notodden*/,  
      								974633191 /*Sykehuset Telemark, Skien/Porsgrunn*/,  
      								974798379 /*Sykehuset Telemark, Rjukan*/,  
      								983974155 /*Sykehuset Telemark, Krager�*/) then BehSh=150; /*'Sykehuset Telemark HF'*/

 		if behandlingsstedKode2 in (974633159 /*Sykehuset Telemark, Notodden*/) then BehSh=153;
		if behandlingsstedKode2 in (974633191 /*Sykehuset Telemark, Skien/Porsgrunn*/, 
									974568209 /*Sykehuset Telemark, Habilitering barn og unge*/	) then BehSh=151;
		if behandlingsstedKode2 in (974798379 /*Sykehuset Telemark, Rjukan*/) then BehSh=154;
		if behandlingsstedKode2 in (983974155 /*Sykehuset Telemark, Krager�*/) then BehSh=152;
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
      								974632535 /*Sykehuset Innlandet, Gj�vik*/,  
      								974632543 /*Sykehuset Innlandet, Granheim lungesykehus*/,  
      								974724960 /*Sykehuset Innlandet, Hamar*/,  
      								974725215 /*Sykehuset Innlandet, Tynset*/,
      								975326136 /*Sykehuset Innlandet, Habiliteringstjenesten i Oppland, Lillehammer*/) then BehSh=170;

		if behandlingsstedKode2 in (874631752 /*Sykehuset Innlandet, Ottestad*/	) then BehSh=177;
		if behandlingsstedKode2 in (874632562 /*Sykehuset Innlandet, Lillehammer*/,  
									975326136 /*Sykehuset Innlandet, Habiliteringstjenesten i Oppland, Lillehammer*/) then BehSh=173;
		if behandlingsstedKode2 in (974631768 /*Sykehuset Innlandet, Elverum*/) then BehSh=171;
		if behandlingsstedKode2 in (974631776 /*Sykehuset Innlandet, Kongsvinger*/) then BehSh=174;
		if behandlingsstedKode2 in (974632535 /*Sykehuset Innlandet, Gj�vik*/) then BehSh=172;
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
      								974589095 /*OUS, Ullev�l*/,   
      								974705761 /*OUS, Spesialsykehuset for epilepsi*/,  
      								974707152 /*OUS, Radiumhospitalet*/,  
      								974728230 /*OUS, Geilomo barnesykehus*/,        
									974798263 /*OUS, Voksentoppen*/, 
      								975298744 /*OUS, Olafiaklinikken*/,       
									993467049 /*OUS HF*/) then BehSh=180/*Oslo universitetssykehus HF*/;

		if behandlingsstedKode2 in (874716782 /*OUS, Rikshospitalet*/) then BehSh=181;
		if behandlingsstedKode2 in (974588951 /*OUS, Aker*/) then BehSh=182;
		if behandlingsstedKode2 in (974589087 /*OUS, Oslo legevakt*/) then BehSh=183;
		if behandlingsstedKode2 in (974589095 /*OUS, Ullev�l*/) then BehSh=184;
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
*** Sykehuset �stfold HF ***
***************************/
	/* Lokalisasjoner: Kalnes, Fredrikstad, Moss, Sarpsborg, Halden, Askim og Eidsberg. */

		if behandlingsstedKode2 in (974633698 /*Sykehuset �stfold, Moss*/,
									974633752 /*Sykehuset �stfold*/,   
      								974634052 /*Sykehuset �stfold, Fysioterapi*/, 
      								974703734 /*Sykehuset �stfold, Sarpsborg*/) then BehSh=200/*Sykehuset �stfold HF*/;

 		if behandlingsstedKode2 in (974633698 /*Sykehuset �stfold, Moss*/, 974634052 /*Sykehuset �stfold, Fysioterapi*/) then BehSh=201;
		if behandlingsstedKode2 in (974703734 /*Sykehuset �stfold, Sarpsborg*/) then BehSh=202;

/***************************
*** S�rlandet sykehus HF ***
***************************/

		if behandlingsstedKode2 in (974595214 /*S�rlandet sykehus, Flekkefjord*/,
							      	974595230 /*S�rlandet sykehus, Rehabilitering Kongsg�rd*/,
									974631091 /*S�rlandet sykehus, Arendal*/,
									974733013 /*S�rlandet sykehus, Kristiansand*/, 
	        						983975240 /*S�rlandet sykehus HF*/) then BehSh=210;

		if behandlingsstedKode2 in (974595214 /*S�rlandet sykehus, Flekkefjord*/) then BehSh=213;
		if behandlingsstedKode2 in (974631091 /*S�rlandet sykehus, Arendal*/) then BehSh=212;
		if behandlingsstedKode2 in (974733013 /*S�rlandet sykehus, Kristiansand*/, 974595230 /*S�rlandet sykehus, Rehabilitering Kongsg�rd*/) then BehSh=211;

/******************************
*** Sykehuset i Vestfold HF ***
******************************/

		if behandlingsstedKode2 in (974575396 /*Sykehuset i Vestfold, Rehabilitering Stavern*/, 
								 	974633574 /*Sykehuset i Vestfold*/) then BehSh=220;

		if behandlingsstedKode2 in (974633574 /*Sykehuset i Vestfold, T�nsberg*/) then BehSh=221 ;
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
*** Resterende Helse S�r-�st RHF ***
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
									971049456 /*Mj�skirurgene*/,
									971937548 /*EEG Labora*/,
									972140295 /*NIMI AS Avd. Mini Ullev�l*/,
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
									981096363 /*Teres S�rlandsparken*/,
									981541499 /*Teres Colosseum*/,
									982755999 /*Volvat Stokkan*/,
									983084478 /*Volvat Troms�*/,
									983896383 /*Teres Colosseum Stavanger*/,
									985766924 /*Bergen Spine Center*/,
									987954167 /*IbsenSykehuset AS*/,
									991811869 /*Kolibri Medical AS*/,
									993240184 /*Aleris Helse AS Troms�*/,
									995590794 /*SVC Norge AS*/,
									995818728 /*Teres Klinikken Bod�*/,
									996860884 /*Somni S�vnsenter og Spesialisthelsetjenester AS*/,
									/*PO: Supplert med nye behandlingssteder for 2016*/
									912817318 /*Somni AS*/,
									914480752 /*Moloklinikken AS*/,
									915411223 /*Kalbakkenklinikken AS*/,
									916269331 /*A-Medi AS*/,  
      								916588224 /*Preventia AS*/,  
     								998558271 /*Oslo medisinske senter*/,  
      								999230008 /*Ifocus �yeklinikk AS*/) then BehSh=300;	

/*
*****************************************************************
2.8 BehHF - Behandlende helseforetak
*****************************************************************
*/

if 10<=BehSh<=19 then BehHF=1/*Finnmarkssykehuset HF*/;
if 20<=BehSh<=29 then BehHF=2/*UNN HF*/;
if 30<=BehSh<=39 then BehHF=3/*NLSH HF*/;
if 40<=BehSh<49 then BehHF=4/*Helgelandssykehuset HF*/;
if 50<=BehSh<=59 then BehHF=5/*Helse Nord-Tr�ndelag HF*/;
if 60<= BehSh<=69 then BehHF=6/*St. Olavs Hospital HF*/;
if 70<= BehSh<=79 then BehHF=7; /*Helse M�re og Romsdal HF*/
if 90<= BehSh<=99 then BehHF=9/*Helse F�rde HF*/;
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
if 200<=BehSh<=209 then BehHF=20/*Sykehuset �stfold HF*/;
if 210<=BehSh<=219 then BehHF=21/*S�rlandet sykehus HF*/;
if 220<=BehSh<=229 then BehHF=22/*Sykehuset i Vestfold HF*/;
if BehSh=230 then behHF=23;/*Diakonhjemmet sykehus*/
if BehSh=240 then behHF=24;/*Lovisenberg diakonale sykehus*/;
if 251<=BehSh<=254 then BehHF=25/*Resterende Helse S�r-�st RHF*/;
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
if BehHF in (14:25) then BehRHF=4;/* Helse S�r-�st RHF */
if BehHF=27 then BehRHF=5;/* Private sykehus */;
run;

%Mend Bobehandler;