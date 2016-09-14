
/*
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Opprettet av: Linda Leivseth 
Opprettet dato: 26. mai 2016
Sist modifisert: 17.06.2016 av Linda Leivseth
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/*
Innhold i syntaxen:

Syntaksen gjelder for 2014 og 2015.

1. 	Genererer nye variabler	
	* BehSh
	* BehHF
	* BehRHF

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


/************************
*** Helse Finnmark HF ***
************************/;

%macro behandlingssted (data=, set=);

data &data;
set &set;


if aar=2014 then do;
		if behandlingssted2 in (9300, 9301, 9302) then behSh=10; 

		if behandlingssted2=9301 /*'Finnmarkssykehuset HF, Kirkenes'*/ then BehSh=11; 
		if behandlingssted2 in (9300 /*'Finnmarkssykehuset HF, Hammerfest'*/, 9302 /*Finnmarkssykehuset HF, Alta helsesenter*/) then BehSh=12;
	end;

if aar=2015 then do;
		if behandlingsstedKode2 in (974795930, 974795833, 978296296) then behSh=10; 

		if behandlingsstedKode2=974795930 /*'Finnmarkssykehuset HF, Kirkenes'*/ then BehSh=11; 
		if behandlingsstedKode2 in (974795833 /*'Finnmarkssykehuset HF, Hammerfest'*/, 978296296 /*Alta helsesenter*/) then BehSh=12;
	end;


/*************
*** UNN HF ***
*************/

if aar=2014 then do; 
		if behandlingssted2 in (9000, 9001, 9002) then behSh=20; 

		if behandlingssted2=9000 /*'UNN Tromsø'*/ then BehSh=21;
		if behandlingssted2=9001 /*'UNN Narvik'*/ then BehSh=23;
		if behandlingssted2=9002 /*'UNN Harstad'*/ then BehSh=22;
	end;

if aar=2015 then do;
		if behandlingsstedKode2 in (974795787, 974795639, 974795396) then behSh=20; 

		if behandlingsstedKode2=974795787 /*'UNN Tromsø'*/ then BehSh=21;
		if behandlingsstedKode2=974795396 /*'UNN Narvik'*/ then BehSh=23;
		if behandlingsstedKode2=974795639 /*'UNN Harstad'*/ then BehSh=22;
	end;


/**************
*** NLSH HF ***
**************/

if aar=2014 then do; 
		if behandlingssted2 in (9100, 9101, 9102, 9103) then behSh=30; 

		if behandlingssted2 in (9100 /*'Nordlandssykehuset - Bodø'*/, 9103  /*'Steigen fødestue'*/) then BehSh=33;
		if behandlingssted2=9101 /*'Nordlandssykehuset - Vesterålen'*/ then BehSh=31;
		if behandlingssted2=9102 /*'Nordlandssykehuset - Lofoten'*/ then BehSh=32;
	end;

if aar=2015 then do; 
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
	end;
 

/*****************************
*** Helgelandssykehuset HF ***
*****************************/

if aar=2014 then do; 
		if behandlingssted2 in  (9200, 9201, 9202) then BehSh=40;

		if behandlingssted2=9202 /*'Helgelandssh - Rana'*/ then BehSh=41;
		if behandlingssted2=9201 /*'Helgelandssh - Mosjøen'*/ then BehSh=42;
		if behandlingssted2=9200 /*'Helgelandssh - Sandnessjøen'*/ then BehSh=43;
	end;

if aar=2015 then do; 
	if behandlingsstedKode2 in (974795515 /*Helgelandssykehuset HF Mo i Rana*/,
								974795485 /*Helgelandssykehuset HF Mosjøen*/,
								974795477 /*Helgelandssykehuset HF Sandnessjøen*/) then BehSh=40;

	if behandlingsstedKode2=974795515 /*Helgelandssykehuset HF Mo i Rana */ then BehSh=41;
	if behandlingsstedKode2=974795485 /*Helgelandssykehuset HF Mosjøen*/ then BehSh=42;
	if behandlingsstedKode2=974795477 /*Helgelandssykehuset HF Sandnessjøen*/ then BehSh=43;
	end;


/******************************
*** Helse Nord-Trøndelag HF ***
******************************/

if aar=2014 then do; 
		if behandlingssted2 in (7200, 7201) then BehSh=50;

		if behandlingssted2=7201 /*'Sykehuset Namsos'*/ then BehSh=51;
		if behandlingssted2=7200 /*'Sykehuset Levanger'*/  then BehSh=52;
	end;

if aar=2015 then do; 
		if behandlingsstedKode2 in (974753898 /*Helse Nord-Trøndelag HF -  Namsos*/,
								994974270 /*Helse Nord-Trøndelag, Namsos rehabilitering*/,
								 974754118 /*Helse Nord-Trøndelag HF -  Levanger*/,
							       994958682/*Helse Nord-Trøndelag, Levanger rehabilitering*/) then BehSh=50;

		if behandlingsstedKode2 in (974753898 /*Helse Nord-Trøndelag HF -  Namsos*/, 994974270 /*Helse Nord-Trøndelag, Namsos rehabilitering*/) then BehSh=51;
		if behandlingsstedKode2 in (974754118 /*Helse Nord-Trøndelag HF -  Levanger*/, 994958682/*Helse Nord-Trøndelag, Levanger rehabilitering*/) then BehSh=52;
	end;


/****************************
*** St. Olavs hospital HF ***
****************************/

if aar=2014 then do; 
		if behandlingssted2 in (7000, 7001) then behSh=60;
		if behandlingssted2=7000 /*St Olavs hospital - Trondheim*/ then BehSh=61;
		if behandlingssted2=7001 /*St Olavs hospital - Orkdal*/  then BehSh=62;
	end;


if aar=2015 then do; 
		if behandlingsstedKode2 in (913461223 /*St Olavs hospital, Fysikalsk medisin Øya*/,
      								973254782 /*St Olavs hospital, Trondsletten habiliteringssenter */, 
									974749025 /*St Olavs Hospital, Trondheim*/,
      								974749815 /*St Olavs hospital, Fysikalsk medisin Lian*/,
  								    995413388 /*St Olavs hospital, Hysnes helsefort*/, 
      								974329506 /*St Olavs hospital, Orkdal*/,
				     				974749505 /*St Olavs hospital, Røros*/) then behSh=60;

 		if behandlingsstedKode2 in (913461223 /*St Olavs hospital, Fysikalsk medisin Øya*/,
      								973254782 /*St Olavs hospital, Trondsletten habiliteringssenter */, 
									974749025 /*St Olavs Hospital, Trondheim*/,
      								974749815 /*St Olavs hospital, Fysikalsk medisin Lian*/) then BehSh=61;
		if behandlingsstedKode2 in (974329506 /*St Olavs hospital, Orkdal*/) then BehSh=62;
		if behandlingsstedKode2 in (974749505 /*St Olavs hospital, Røros*/) then BehSh=63;
		if behandlingsstedKode2 in (995413388 /*St Olavs hospital, Hysnes helsefort*/) then BehSh=64;
	end;


/*******************************
*** Helse Møre og Romsdal HF ***
*******************************/

if aar=2014 then do; 
		if behandlingssted2 in (7101 /*'Molde'*/,
								7102 /*'Kristiansund'*/, 
								7100 /*'Ålesund'*/, 
								7103 /*'Volda sjukehus'*/, 
								7104 /*'Mork rehabiliteringssenter'*/,
								7105 /*'Nevrohjemmet rehabiliteringssenter'*/) then BehSh=70;

		if behandlingssted2=7101 /*'Molde'*/  then BehSh=71;
		if behandlingssted2=7102 /*'Kristiansund'*/ then BehSh=72;
		if behandlingssted2=7100 /*'Ålesund'*/  then BehSh=73;
		if behandlingssted2=7103 /*'Volda sjukehus'*/ then BehSh=74;
		if behandlingssted2=7104 /*'Mork rehabiliteringssenter'*/  then BehSh=75;
		if behandlingssted2=7105 /*'Nevrohjemmet rehabiliteringssenter'*/ then BehSh=76;
	end;


if aar=2015 then do; 
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
	end;


/*********************
*** Helse Førde HF ***
*********************/

if aar=2014 then do; 
		if Behandlingssted2 in (5200 /*'Førde'*/
								5201 /*'Nordfjord'*/
								5202 /*'Lærdal'*/ 
								5203 /*'Florø'*/ ) then BehSh=90;

		if Behandlingssted2=5200 /*'Førde'*/ then BehSh=91;
		if Behandlingssted2=5201 /*'Nordfjord'*/ then BehSh=92;
		if Behandlingssted2=5202 /*'Lærdal'*/ then BehSh=93;
		if Behandlingssted2=5203 /*'Florø'*/ then BehSh=94;
	end;

if aar=2015 then do; 
		if behandlingsstedKode2 in (983974732 /*Helse Førde HF*/, 
									974743914 /*Helse Førde, Florø*/,
									974744570 /*Helse Førde, Førde*/, 
									974745089 /*Helse Førde, Lærdal*/,
      								974745364 /*Helse Førde, Nordfjord*/) then BehSh=90;

		if behandlingsstedKode2 in (974744570 /*Helse Førde, Førde*/) then BehSh=91;
		if behandlingsstedKode2 in (974745364 /*Helse Førde, Nordfjord*/) then BehSh=92;
		if behandlingsstedKode2 in (974745089 /*Helse Førde, Lærdal*/) then BehSh=93;
		if behandlingsstedKode2 in (974743914 /*Helse Førde, Florø*/) then BehSh=91;
	end;


/**********************
*** Helse Bergen HF ***
**********************/

if aar=2014 then do; 
		if Behandlingssted2 in (5000 /*'Haukeland'*/, 
								5001 /*'Hagevik'*/,
								5002 /*'Voss'*/,
								5700 /*'Bergen legevakt'*/) then BehSh=100; 
		
		if behandlingssted2 in (5000 /*'Haukeland'*/) then BehSh=101; 
		if behandlingssted2=5001 /*'Hagevik'*/ or BehandlingsstedKode=874743372 /*Kysthospitalet i Hagevik*/ then BehSh=102; 
		if behandlingssted2 in (5002 /*'Voss'*/)  then BehSh=103;
		if behandlingssted2=5700 /*'Bergen legevakt'*/ then BehSh=104; 
	end;


if aar=2015 then do; 
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
	end;


/*********************
*** Helse Fonna HF ***
*********************/

if aar=2014 then do; 
		if Behandlingssted2 in (5100 /*Haugesund sjukehus*/, 
								5101 /*Odda sjukehus*/, 
								5102 /*Stord sjukehus*/) then BehSh=110;

		if BehandlingsstedKode in (974743086 /*Odda sjukehus*/, 
									974742985 /*Stord sjukehus*/) then BehSh=110;

		if behandlingssted2 = 5101 /*Odda sjukehus*/ or BehandlingsstedKode = 974743086 then BehSh=111; 
		if behandlingssted2 = 5102 /*Stord sjukehus*/ or BehandlingsstedKode = 974742985 then BehSh=112; 
		if behandlingssted2 = 5100 /*Haugesund sjukehus*/ then BehSh=113; 
	end;


if aar=2015 then do; 
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
	end;


/*************************
*** Helse Stavanger HF ***
*************************/

if aar=2014 then do; 
		if Behandlingssted2=5300 /*'Stavanger'*/ then BehSh=120;
	end;


if aar=2015 then do; 
		if behandlingsstedKode2 in (873862122 /*Helse Stavanger, Rehabilitering*/, 
		      						974624680 /*Helse Stavanger, HABU*/, 
			        				974703300 /*Helse Stavanger, Stavanger universitetssjukehus*/,
      								974703327 /*Helse Stavanger, Egersund*/) then BehSh=120;

		if behandlingsstedKode2 in (873862122 /*Helse Stavanger, Rehabilitering*/, 
		      						974624680 /*Helse Stavanger, HABU*/, 
			        				974703300 /*Helse Stavanger, Stavanger universitetssjukehus*/) then BehSh=121;
		if behandlingsstedKode2 in (974703327 /*Helse Stavanger, Egersund*/) then BehSh=122;
	end;


/********************************
*** Resterende Helse Vest RHF ***
********************************/

if aar=2014 then do; 
		if Behandlingssted2 in (5600 /*'Betanien Hordaland'*/, 
								5400 /*'Haugesund san. for. revmatismesh'*/, 
								5500 /*'Haraldsplass'*/) then BehSh=130; 

		if behandlingssted2 = 5600 /*'Betanien Hordaland'*/ then BehSh=131;
		if behandlingssted2 = 5400 /*'Haugesund san. for. revmatismesh'*/ then BehSh=132;
		if behandlingssted2 = 5500 /*'Haraldsplass'*/ then BehSh=133;
	end;

if aar=2015 then do; 
		if behandlingsstedKode2 in (974737779 /*Betanien spesialistpoliklinikk*/, 
									986106839 /*Haugesund sanitetsforenings revmatismesykehus*/,
									974316285 /*Haraldsplass diakonale sykehus AS*/) then BehSh=130;

		if behandlingsstedKode2 in (974737779 /*Betanien spesialistpoliklinikk*/) then BehSh=131;
		if behandlingsstedKode2 in (986106839 /*Haugesund sanitetsforenings revmatismesykehus*/) then BehSh=132; 
		if behandlingsstedKode2 in (974316285 /*Haraldsplass diakonale sykehus AS*/) then BehSh=133;
		/* Bergen legevakt ligger under Helse Bergen HF siden den delen av Bergen legevakt som rapporterer data til NPR 
		er spesialisthelsetjeneste. Dette er Akuttposten ved Mottaksklinikken ved Haukeland universitetssykehus.  
		Se http://www.helse-bergen.no/no/OmOss/Avdelinger/mottaksklinikken/Sider/akuttpost.aspx. */
	end;


/**********************
*** Vestre Viken HF ***
**********************/

if aar=2014 then do; 
		if Behandlingssted2 in (1100 /*'Drammen/Buskerud'*/, 
								1101 /*'Bærum/Asker og Bærum'*/, 
								1103 /*'Ringerike'*/, 
								1102 /*'Kongsberg'*/) then behSh=140; /*'Vestre Viken HF'*/ 

		if behandlingssted2=1100 /*'Drammen/Buskerud'*/ then BehSh=141;
		if behandlingssted2=1101 /*'Bærum/Asker og Bærum'*/ then BehSh=142;
		if behandlingssted2=1103 /*'Ringerike'*/ then BehSh=143;
		if behandlingssted2=1102 /*'Kongsberg'*/ then BehSh=144;
	end;


if aar=2015 then do; 
		if behandlingsstedKode2 in (874606162 /*Vestre Viken, Hallingdal sjukestugu*/, 
									974631326 /*Vestre Viken, Drammen*/,   
      								974631385 /*Vestre Viken, Kongsberg*/,  
      								974631407 /*Vestre Viken, Ringerike*/,  
      								974705788 /*Vestre Viken, Bærum*/) then behSh=140; /*'Vestre Viken HF'*/ 
 
		if behandlingsstedKode2 in (974631326 /*Vestre Viken, Drammen*/) then behSh=141;
		if behandlingsstedKode2 in (974631385 /*Vestre Viken, Kongsberg*/) then behSh=144;
		if behandlingsstedKode2 in (974631407 /*Vestre Viken, Ringerike*/, 874606162 /*Vestre Viken, Hallingdal sjukestugu*/) then behSh=143;
		if behandlingsstedKode2 in (974705788 /*Vestre Viken, Bærum*/) then behSh=142;
 	end;


/****************************
*** Sykehuset Telemark HF ***
****************************/

if aar=2014 then do; 
		if Behandlingssted2 in (1200 /*'Skien/Porsgrunn'*/, 
								1201 /*'Kragerø'*/, 
								1202 /*'Notodden'*/,
								1203 /*'Rjukan'*/) then BehSh=150; /*'Sykehuset Telemark HF'*/

		if behandlingssted2=1200 /*'Skien/Porsgrunn'*/ then BehSh=151;
		if behandlingssted2=1201 /*'Kragerø'*/ then BehSh=152;
		if behandlingssted2=1202 /*'Notodden'*/ then BehSh=153;
		if behandlingssted2=1203 /*'Rjukan'*/ then BehSh=154;
		if behandlingssted2=1204 /*'Nordagutu'*/ then BehSh=155; 
	end;


if aar=2015 then do; 
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
	end;


/**************************************
*** Akershus universitetssykehus HF ***
**************************************/

if aar=2014 then do; 
		if Behandlingssted2=1400 /*'Akershus'*/ then BehSh=160/*Akershus universitetssykehus HF*/;
	end;

if aar=2015 then do; 
		if behandlingsstedKode2=974706490 /*Akershus universitetssykehus*/ then BehSh=160;
	end;


/*******************
*** Innlandet HF ***
*******************/

if aar=2014 then do; 
	if behandlingssted2 in (1000 /*'Sykehuset Innlandet - Elverum/Hamar'*/, 
							1001 /*'Sykehuset Innlandet - Kongsvinger'*/, 
							1002 /*'Sykehuset Innlandet - Tynset'*/, 
							1003 /*'Sykehuset Innlandet - Gjøvik'*/, 
							1004 /*'Sykehuset Innlandet - Lillehammer'*/, 
							1005 /*'Sykehuset Innlandet - Granheim'*/, 
							1006 /*'Sykehuset Innlandet - Ottestad'*/) then BehSh=170;

		if behandlingssted2=1000 /*'Sykehuset Innlandet - Elverum/Hamar'*/ then BehSh=171 /*Elverum/Hamar*/;
		if behandlingssted2=1001 /*'Sykehuset Innlandet - Kongsvinger'*/ then BehSh=174 /*Kongsvinger*/;
		if behandlingssted2=1002 /*'Sykehuset Innlandet - Tynset'*/ then BehSh=175/*Tynset*/;
		if behandlingssted2=1003 /*'Sykehuset Innlandet - Gjøvik'*/ then BehSh=172 /*Gjøvik*/;
 		if behandlingssted2=1004 /*'Sykehuset Innlandet - Lillehammer'*/ then BehSh=173/*Lillehammer*/;
		if behandlingssted2=1005 /*'Sykehuset Innlandet - Granheim'*/ then BehSh=176;
		if behandlingssted2=1006 /*'Sykehuset Innlandet - Ottestad'*/ then BehSh=177;
	end;


if aar=2015 then do; 
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
	end;


/**********************************
*** Oslo universitetssykehus HF ***
**********************************/

if aar=2014 then do; 
	if behandlingssted2 in (1500 /*'OUS (kan ikke splittes)'*/ ,
							1504 /*'OUS Aker'*/,
							1501 /*'Ullevål'*/,
							1502 /*'Rikshospitalet'*/,
							1503 /*'Radiumhospitalet'*/,
							1505 /*'Olafiaklinikken'*/) then BehSh=180/*Oslo universitetssykehus HF*/;
	end;


if aar=2015 then do; 
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
	end;


/******************************
*** Oslo kommunale legevakt ***
******************************/

if aar=2014 then do; 
	if behandlingssted2=2400 /*Oslo kommunale legevakt*/ then behSh=236 /*Oslo kommunale legevakt, Opservasjonsposten*/;
	end;

if aar=2015 then do; 
		if behandlingsstedKode2=984630492 /*Oslo kommunale legevakt*/ then behSh=236 /*Oslo kommunale legevakt, Opservasjonsposten*/;  
	end;


/*************************
*** Sunnaas sykehus HF ***
*************************/

if aar=2014 then do; 
	if behandlingssted2=1800 /*'Sunnaas'*/ then BehSh=190/*Sunnaas sykehus*/;
	end;


if aar=2015 then do; 
		if behandlingsstedKode2=974589214 /*Sunnaas sykehus*/ then BehSh=190/*Sunnaas sykehus*/;
	end;


/***************************
*** Sykehuset Østfold HF ***
***************************/
	/* Lokalisasjoner: Kalnes, Fredrikstad, Moss, Sarpsborg, Halden, Askim og Eidsberg. */

if aar=2014 then do; 
	if behandlingssted2=1300 /*'Sykehuset Østfold'*/ then BehSh=200/*Sykehuset Østfold HF*/;
	end;


if aar=2015 then do; 
		if behandlingsstedKode2 in (974633698 /*Sykehuset Østfold, Moss*/,
									974633752 /*Sykehuset Østfold*/,   
      								974634052 /*Sykehuset Østfold, Fysioterapi*/, 
      								974703734 /*Sykehuset Østfold, Sarpsborg*/) then BehSh=200/*Sykehuset Østfold HF*/;

 		if behandlingsstedKode2 in (974633698 /*Sykehuset Østfold, Moss*/, 974634052 /*Sykehuset Østfold, Fysioterapi*/) then BehSh=201;
		if behandlingsstedKode2 in (974703734 /*Sykehuset Østfold, Sarpsborg*/) then BehSh=202;
	end;


/***************************
*** Sørlandet sykehus HF ***
***************************/

if aar=2014 then do; 
		if behandlingssted2 in (1600 /*'Kristiansand'*/,
								1603 /*'Spesialsykehuset for rehabilitering, Kristiansand'*/,
								1601 /*'Arendal'*/,
								1602 /*'Flekkefjord'*/) then BehSh=210;

		if behandlingssted2 in (1600 /*'Kristiansand'*/, 1603 /*'Spesialsykehuset for rehabilitering, Kristiansand'*/) then behsh=211 /*'Sørlandet sh, Kristiansand'*/;
		if behandlingssted2=1601 /*'Arendal'*/ then behsh=212 /*'Sørlandet sh, Arendal'*/;
		if behandlingssted2=1602 /*'Flekkefjord'*/ then behsh=213 /*'Sørlandet sh, Flekkefjord'*/;
	end;


if aar=2015 then do; 
		if behandlingsstedKode2 in (974595214 /*Sørlandet sykehus, Flekkefjord*/,
							      	974595230 /*Sørlandet sykehus, Rehabilitering Kongsgård*/,
									974631091 /*Sørlandet sykehus, Arendal*/,
									974733013 /*Sørlandet sykehus, Kristiansand*/, 
	        						983975240 /*Sørlandet sykehus HF*/) then BehSh=210;

		if behandlingsstedKode2 in (974595214 /*Sørlandet sykehus, Flekkefjord*/) then BehSh=213;
		if behandlingsstedKode2 in (974631091 /*Sørlandet sykehus, Arendal*/) then BehSh=212;
		if behandlingsstedKode2 in (974733013 /*Sørlandet sykehus, Kristiansand*/, 974595230 /*Sørlandet sykehus, Rehabilitering Kongsgård*/) then BehSh=211;
	end;


/******************************
*** Sykehuset i Vestfold HF ***
******************************/

if aar=2014 then do; 
		if behandlingssted2 in (1700 /*'Sykehuset i Vestfold (kan ikke splittes)'*/,
								1701 /*'Spesialsykehuset for rehabilitering, Stavern'*/ /*Kun splittet for 2010-11*/) then BehSh=220;
	end;


if aar=2015 then do; 
		if behandlingsstedKode2 in (974575396 /*Sykehuset i Vestfold, Rehabilitering Stavern*/, 
								 	974633574 /*Sykehuset i Vestfold*/) then BehSh=220;

		if behandlingsstedKode2 in (974633574 /*Sykehuset i Vestfold, Tønsberg*/) then BehSh=221 ;
		if behandlingsstedKode2 in (974575396 /*Sykehuset i Vestfold, Rehabilitering Kysthospitalet Stavern*/) then BehSh=222 ;
	end;


/***********************************
*** Resterende Helse Sør-Øst RHF ***
***********************************/

if aar=2014 then do; 
		if behandlingssted2 in (2100 /*'Diakonhjemmet'*/, 
								2000 /*'Lovisenberg'*/, 
								1900 /*'Martina Hansens hospital'*/, 
								2300 /*'Betanien Telemark'*/, 
								2200 /*'Revmatismesykehust Lillehammer'*/, 
								2400 /*'Oslo kommunale legevakt'*/) then BehSh=230;

		if behandlingssted2=2100 /*'Diakonhjemmet'*/  then BehSh=231;
		if behandlingssted2=2000 /*'Lovisenberg'*/  then BehSh=232;
		if behandlingssted2=1900 /*'Martina Hansens hospital'*/  then BehSh=233;
		if behandlingssted2=2300 /*'Betanien Telemark'*/  then BehSh=234;
		if behandlingssted2=2200 /*'Revmatismesykehust Lillehammer'*/  then BehSh=235;
		if behandlingssted2=2400 /*'Oslo kommunale legevakt'*/ then BehSh=236;
	end;


if aar=2015 then do; 
		if behandlingsstedKode2 in (974116804 /*Diakonhjemmet sykehus*/, 
									974207532 /*Lovisenberg diakonale sykehus*/,
									985962170 /*Martina Hansens Hospital*/,
									981275721 /*Betanien hospital*/,
									985773238 /*Revmatismesykehuset AS, Lillehammer*/) then BehSh=230;

		if behandlingsstedKode2 in (974116804 /*Diakonhjemmet sykehus*/) then BehSh=231;
		if behandlingsstedKode2 in (974207532 /*Lovisenberg diakonale sykehus*/) then BehSh=232;
		if behandlingsstedKode2 in (985962170 /*Martina Hansens Hospital*/) then BehSh=233;
		if behandlingsstedKode2 in (981275721 /*Betanien hospital*/) then BehSh=234;
		if behandlingsstedKode2 in (985773238 /*Revmatismesykehuset AS, Lillehammer*/) then BehSh=235;

		/* Oslo legevakt ligger under OUS HF siden den delen av Oslo legevakt som rapporterer data til NPR 
		er spesialisthelsetjeneste. Dette er Oslo skadelegevakt som er en avdeling ved OUS som mottar pasienter med akutte skader.   
		Se http://www.oslo-universitetssykehus.no/omoss_/avdelinger_/skadelegevakt_. */
	end;


/**********************
*** Private sykehus ***
**********************/

if aar=2014 then do; 
		if behandlingssted2>=10000 then BehSh=240;	
	end;


if aar=2015 then do; 
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
									996860884 /*Somni Søvnsenter og Spesialisthelsetjenester AS*/) then BehSh=240;	
 	end;
   

/********************************
*** Definerer BehHF og BehRHF ***
********************************/

/*BehHF*/
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
if BehSh=231 then behHF=23;/*Diakonhjemmet sykehus*/
if BehSh=232 then behHF=24;/*Lovisenberg diakonale sykehus*/;
if 233<=BehSh<=239 then BehHF=25/*Resterende Helse Sør-Øst RHF*/;
if BehSh=240 then BehHF=26/*Private sykehus*/;


/*Avleder BehRHF fra BehHF*/
if BehHF in (1,2,3,4) then BehRHF=1;/* Helse Nord RHF */
if BehHF in (5,6,7) then BehRHF=2;/* Helse Midt-Norge RHF */
if BehHF in (9,10,11,12,13)then BehRHF=3;/* Helse Vest RHF */
if BehHF in (14:25) then BehRHF=4;/* Helse Sør-Øst RHF */
if BehHF=26 then BehRHF=5;/* Private sykehus */

run;

%mend behandlingssted;


