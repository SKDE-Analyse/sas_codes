%macro behandler(innDataSett=, utDataSett=);

/*!
Makro for � definere behandler (`behSh`, `BehHF` og `BehRHF`) i
sykehusoppholdsfilene, basert p� variablen `behandlingssted2`.

*/

data &utdatasett;
set &inndatasett;


  /*
  - Definere `behsh` - behandlende sykehus
  */

  /************************
  *** Helse Finnmark HF ***
  ************************/

  		if behandlingssted2 in (974795930, 974795833, 978296296,974285959,979873190,983974880) then behSh=10;

  		if behandlingssted2=974795930 /*'Finnmarkssykehuset HF, Kirkenes'*/ then BehSh=11;
  		if behandlingssted2 in (974795833 /*'Finnmarkssykehuset HF, Hammerfest'*/, 978296296 /*Alta helsesenter*/,
  			974285959 /*Finnmarkssykehuset, Karasjok*/,979873190 /*'Finnmarkssykehuset, Alta*/) then BehSh=12;



  /*************
  *** UNN HF ***
  *************/

  		if behandlingssted2 in (983974899, 974795787, 974795639, 974795396) then behSh=20;
  /* 983974899 brukes for innleggelser i 2016 */
  		if behandlingssted2=974795787 /*'UNN Troms�'*/ then BehSh=21;
  		if behandlingssted2=974795396 /*'UNN Narvik'*/ then BehSh=23;
  		if behandlingssted2=974795639 /*'UNN Harstad'*/ then BehSh=22;



  /**************
  *** NLSH HF ***
  ***************/

  		if behandlingssted2 in (983974910 /*Nordlandssykehuset*/,
  									    974795574 /*Nordlandssykehuset Vester�len*/,
  										974795558 /*Nordlandssykehuset Lofoten*/,
  										974795361 /*Nordlandssykehuset Bod�*/
  										993562718 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Bod�*/,
  										993573159 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Gravdal*/,
  										974049767 /*Steigen f�destue*/,
  										996722201 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Stokmarknes*/) then behSh=30;
  		if behandlingssted2 in (974795361 /*Nordlandssykehuset Bod�*/,
  									993562718 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Bod�*/,
  									974049767  /*'Steigen f�destue'*/) then BehSh=33;
  		if behandlingssted2 in (974795574 /*Nordlandssykehuset Vester�len*/,
  								996722201 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Stokmarknes*/) then BehSh=31;
  		if behandlingssted2 in (974795558 /*Nordlandssykehuset Lofoten*/,
  								993573159 /*Nordlandssykehuset HF, Habilitering/rehabilitering, Gravdal*/) then BehSh=32;



  /*****************************
  *** Helgelandssykehuset HF ***
  *****************************/

  	if behandlingssted2 in (974795515 /*Helgelandssykehuset HF Mo i Rana*/,
  								974795485 /*Helgelandssykehuset HF Mosj�en*/,
  								974795477 /*Helgelandssykehuset HF Sandnessj�en*/
  								874044342 /*Helgelandssykehuset HF Br�nn�ysund f�destue*/,
  								983974929 /*'Helgelandssykehuset HF*/) then BehSh=40;

  	if behandlingssted2=974795515 /*Helgelandssykehuset HF Mo i Rana */ then BehSh=41;
  	if behandlingssted2=974795485 /*Helgelandssykehuset HF Mosj�en*/ then BehSh=42;
  	if behandlingssted2 in (974795477 /*Helgelandssykehuset HF Sandnessj�en*/,
  							   874044342 /*Helgelandssykehuset HF Br�nn�ysund f�destue*/) then BehSh=43;



  /******************************
  *** Helse Nord-Tr�ndelag HF ***
  ******************************/


  		if behandlingssted2 in (974753898 /*Helse Nord-Tr�ndelag HF -  Namsos*/,
  								994974270 /*Helse Nord-Tr�ndelag, Namsos rehabilitering*/,
  								 974754118 /*Helse Nord-Tr�ndelag HF -  Levanger*/,
  							       994958682/*Helse Nord-Tr�ndelag, Levanger rehabilitering*/) then BehSh=50;

  		if behandlingssted2 in (974753898 /*Helse Nord-Tr�ndelag HF -  Namsos*/, 994974270 /*Helse Nord-Tr�ndelag, Namsos rehabilitering*/) then BehSh=51;
  		if behandlingssted2 in (974754118 /*Helse Nord-Tr�ndelag HF -  Levanger*/, 994958682/*Helse Nord-Tr�ndelag, Levanger rehabilitering*/) then BehSh=52;



  /****************************
  *** St. Olavs hospital HF ***
  ****************************/

  		if behandlingssted2 in (913461223 /*St Olavs hospital, Fysikalsk medisin �ya*/,
        								973254782 /*St Olavs hospital, Trondsletten habiliteringssenter */,
  									974749025 /*St Olavs Hospital, Trondheim*/,
        								974749815 /*St Olavs hospital, Fysikalsk medisin Lian*/,
    								    995413388 /*St Olavs hospital, Hysnes helsefort*/,
        								974329506 /*St Olavs hospital, Orkdal*/,
  				     				974749505 /*St Olavs hospital, R�ros*/,
  									915621457 /*St Olavs hospital, �rland*/) then behSh=60; /*St Olav �rland er bare skrevet til behSh lik 60, ingen spesifisering av lokalisasjon under*/

   		if behandlingssted2 in (913461223 /*St Olavs hospital, Fysikalsk medisin �ya*/,
        								973254782 /*St Olavs hospital, Trondsletten habiliteringssenter */,
  									974749025 /*St Olavs Hospital, Trondheim*/,
        								974749815 /*St Olavs hospital, Fysikalsk medisin Lian*/) then BehSh=61;
  		if behandlingssted2 in (974329506 /*St Olavs hospital, Orkdal*/) then BehSh=62;
  		if behandlingssted2 in (974749505 /*St Olavs hospital, R�ros*/) then BehSh=63;
  		if behandlingssted2 in (995413388 /*St Olavs hospital, Hysnes helsefort*/) then BehSh=64;


  /*******************************
  *** Helse M�re og Romsdal HF ***
  *******************************/

  		if behandlingssted2 in (974745569 /*Helse M�re og Romsdal HF Molde sjukehus*/,
        								974746948 /*Helse M�re og Romsdal HF Kristiansund sjukehus*/,
        								974747138 /*Helse M�re og Romsdal HF �lesund sjukehus*/,
        								974747545 /*Helse M�re og Romsdal HF Volda sjukehus*/,
        								974576929 /*Helse M�re og Romsdal HF, Nevrohjemmet*/,
        								974577054 /*Helse M�re og Romsdal HF, Aure rehabiliteringssenter*/,
        								974577216 /*Helse M�re og Romsdal HF, Klinikk for Rehabilitering (Mork)*/,
  								    984038135 /*Helse M�re og Romsdal HF, Voksenhabilitering Molde*/) then BehSh=70;

   		if behandlingssted2 in (974745569 /*Helse M�re og Romsdal HF Molde sjukehus*/, 984038135 /*Helse M�re og Romsdal HF, Voksenhabilitering Molde*/) then BehSh=71;
  		if behandlingssted2 in (974746948 /*Helse M�re og Romsdal HF Kristiansund sjukehus*/) then BehSh=72;
  		if behandlingssted2 in (974747138 /*Helse M�re og Romsdal HF �lesund sjukehus*/) then BehSh=73;
  		if behandlingssted2 in (974747545 /*Helse M�re og Romsdal HF Volda sjukehus*/) then BehSh=74;
  		if behandlingssted2 in (974576929 /*Helse M�re og Romsdal HF, Nevrohjemmet*/) then BehSh=76;
  		if behandlingssted2 in (974577054 /*Helse M�re og Romsdal HF, Aure rehabiliteringssenter*/) then BehSh=77;
  		if behandlingssted2 in (974577216 /*Helse M�re og Romsdal HF, Klinikk for Rehabilitering (Mork)*/) then BehSh=75;

  /*********************
  *** Helse F�rde HF ***
  *********************/
  		if behandlingssted2 in (983974732 /*Helse F�rde HF*/,
  									974743914 /*Helse F�rde, Flor�*/,
  									974744570 /*Helse F�rde, F�rde*/,
  									974745089 /*Helse F�rde, L�rdal*/,
        								974745364 /*Helse F�rde, Nordfjord*/) then BehSh=90;

  		if behandlingssted2 in (974744570 /*Helse F�rde, F�rde*/) then BehSh=91;
  		if behandlingssted2 in (974745364 /*Helse F�rde, Nordfjord*/) then BehSh=92;
  		if behandlingssted2 in (974745089 /*Helse F�rde, L�rdal*/) then BehSh=93;
  		if behandlingssted2 in (974743914 /*Helse F�rde, Flor�*/) then BehSh=91;

  /**********************
  *** Helse Bergen HF ***
  **********************/

  		if behandlingssted2 in (874743372 /*Helse Bergen, Kysthospitalet i Hagevik*/,
  	      							973923811 /*Helse Bergen, Habilitering Voksne*/,
   									973925032 /*Bergen legevakt*/,
        								974557169 /*Helse Bergen, Rehabilitering*/,
       								974557746 /*Helse Bergen, Haukeland*/,
        								974743272 /*Helse Bergen, Voss*/,
  	  								996663191 /*Helse Bergen, Laboratorie og r�ntgen Haukeland*/) then BehSh=100;

  		if behandlingssted2 in (973923811 /*Helse Bergen, Habilitering Voksne*/,
        								974557169 /*Helse Bergen, Rehabilitering*/,
       								974557746 /*Helse Bergen, Haukeland*/,
        								996663191 /*Helse Bergen, Laboratorie og r�ntgen Haukeland*/) then BehSh=101;
  		if behandlingssted2 in (874743372 /*Helse Bergen, Kysthospitalet i Hagevik*/) then BehSh=102;
  		if behandlingssted2 in (974743272 /*Helse Bergen, Voss*/) then BehSh=103;
  		if behandlingssted2 in (973925032 /*Bergen legevakt*/) then BehSh=104;

  /*********************
  *** Helse Fonna HF ***
  *********************/
  		if behandlingssted2 in (983974694 /* Helse Fonna HF */,
                                  974724774 /* Helse Fonna, Haugesund*/,
        								974742985 /*Helse Fonna, Stord*/,
  								    974743086 /*Helse Fonna, Odda*/,
        								974829029 /*Helse Fonna, Sauda*/,
        								976248570 /*Helse Fonna, Haugesund Rehabilitering*/,
        								996328112 /*Helse Fonna, Stord Rehabilitering*/) then BehSh=110;

  		if behandlingssted2 in (974743086 /*Helse Fonna, Odda*/) then BehSh=111;
  		if behandlingssted2 in (974742985 /*Helse Fonna, Stord*/, 996328112 /*Helse Fonna, Stord Rehabilitering*/) then BehSh=112;
  		if behandlingssted2 in (974724774 /*Helse Fonna, Haugesund*/,
       								976248570 /*Helse Fonna, Haugesund Rehabilitering*/) then BehSh=113;
  		if behandlingssted2 in (974829029 /*Helse Fonna, Sauda*/) then BehSh=114;

  /*************************
  *** Helse Stavanger HF ***
  *************************/
  		if behandlingssted2 in (873862122 /*Helse Stavanger, Rehabilitering*/,
  		      						974624680 /*Helse Stavanger, HABU*/,
  			        				974703300 /*Helse Stavanger, Stavanger universitetssjukehus*/,
        								974703327 /*Helse Stavanger, Egersund*/) then BehSh=120;

  		if behandlingssted2 in (873862122 /*Helse Stavanger, Rehabilitering*/,
  		      						974624680 /*Helse Stavanger, HABU*/,
  			        				974703300 /*Helse Stavanger, Stavanger universitetssjukehus*/) then BehSh=121;
  		if behandlingssted2 in (974703327 /*Helse Stavanger, Egersund*/) then BehSh=122;


  /*************************************
  *** Haraldsplass diakonale sykehus ***
  *************************************/

  if behandlingssted2 = 974316285 /*Haraldsplass diakonale sykehus */ then BehSh=260;
  /*Haraldsplass diakonale sykehus har eget opptaksomr�de og er lokalsykehus for bydelene �sane, Arna, og Bergenhus,
  samt Samnanger og kommunene i Nordhordland.*/


  /********************************
  *** Resterende Helse Vest RHF ***
  ********************************/
  		if behandlingssted2 in (974737779 /*Betanien spesialistpoliklinikk*/,
  									986106839 /*Haugesund sanitetsforenings revmatismesykehus*/) then BehSh=130;

  		if behandlingssted2 in (974737779 /*Betanien spesialistpoliklinikk*/) then BehSh=131;
  		if behandlingssted2 in (986106839 /*Haugesund sanitetsforenings revmatismesykehus*/) then BehSh=132;
  		/* Bergen legevakt ligger under Helse Bergen HF siden den delen av Bergen legevakt som rapporterer data til NPR
  		er spesialisthelsetjeneste. Dette er Akuttposten ved Mottaksklinikken ved Haukeland universitetssykehus.
  		Se http://www.helse-bergen.no/no/OmOss/Avdelinger/mottaksklinikken/Sider/akuttpost.aspx. */


  /**********************
  *** Vestre Viken HF ***
  **********************/
  		if behandlingssted2 in (874606162 /*Vestre Viken, Hallingdal sjukestugu*/,
  									974631326 /*Vestre Viken, Drammen*/,
        								974631385 /*Vestre Viken, Kongsberg*/,
        								974631407 /*Vestre Viken, Ringerike*/,
        								974705788 /*Vestre Viken, B�rum*/,
                                      974606305 /*Vestre Viken, Habiliteringssenteret Drammen*/) then behSh=140; /*'Vestre Viken HF'*/

  		if behandlingssted2 in (974631326, 974606305 /*Vestre Viken, Drammen*/) then behSh=141;
  		if behandlingssted2 in (974631385 /*Vestre Viken, Kongsberg*/) then behSh=144;
  		if behandlingssted2 in (974631407 /*Vestre Viken, Ringerike*/, 874606162 /*Vestre Viken, Hallingdal sjukestugu*/) then behSh=143;
  		if behandlingssted2 in (974705788 /*Vestre Viken, B�rum*/) then behSh=142;


  /****************************
  *** Sykehuset Telemark HF ***
  ****************************/
  		if behandlingssted2 in (983975267 /*Sykehuset Telemark HF (innleggelser i 2016)*/,
                                      974568209 /*Sykehuset Telemark, Habilitering barn og unge*/,
        								974568225 /*Sykehuset Telemark, Nordagutu*/,
        								974633159 /*Sykehuset Telemark, Notodden*/,
        								974633191 /*Sykehuset Telemark, Skien/Porsgrunn*/,
        								974798379 /*Sykehuset Telemark, Rjukan*/,
        								983974155 /*Sykehuset Telemark, Krager�*/) then BehSh=150; /*'Sykehuset Telemark HF'*/

   		if behandlingssted2 in (974633159 /*Sykehuset Telemark, Notodden*/) then BehSh=153;
  		if behandlingssted2 in (974633191 /*Sykehuset Telemark, Skien/Porsgrunn*/,
  									974568209 /*Sykehuset Telemark, Habilitering barn og unge*/	) then BehSh=151;
  		if behandlingssted2 in (974798379 /*Sykehuset Telemark, Rjukan*/) then BehSh=154;
  		if behandlingssted2 in (983974155 /*Sykehuset Telemark, Krager�*/) then BehSh=152;
  		if behandlingssted2 in (974568225 /*Sykehuset Telemark, Nordagutu*/) then BehSh=155;

  /**************************************
  *** Akershus universitetssykehus HF ***
  **************************************/

  		if behandlingssted2 in (974706490 /*Akershus universitetssykehus*/,
                                  974705192 /*Akershus universitetssykehus, Ski*/,
                                  983971636 /*Akershus universitetssykehus HF*/) then BehSh=160;


  /*******************
  *** Innlandet HF ***
  *******************/
  		if behandlingssted2 in (874631752 /*Sykehuset Innlandet, Ottestad*/,
        								874632562 /*Sykehuset Innlandet, Lillehammer*/,
  									974116650 /*Sykehuset Innlandet, Habiliteringstjenesten i Hedmark, Furnes*/,
        								974631768 /*Sykehuset Innlandet, Elverum*/,
        								974631776 /*Sykehuset Innlandet, Kongsvinger*/,
        								974632535 /*Sykehuset Innlandet, Gj�vik*/,
        								974632543 /*Sykehuset Innlandet, Granheim lungesykehus*/,
        								974724960 /*Sykehuset Innlandet, Hamar*/,
        								974725215 /*Sykehuset Innlandet, Tynset*/,
        								975326136 /*Sykehuset Innlandet, Habiliteringstjenesten i Oppland, Lillehammer*/) then BehSh=170;

  		if behandlingssted2 in (874631752 /*Sykehuset Innlandet, Ottestad*/	) then BehSh=177;
  		if behandlingssted2 in (874632562 /*Sykehuset Innlandet, Lillehammer*/,
  									975326136 /*Sykehuset Innlandet, Habiliteringstjenesten i Oppland, Lillehammer*/) then BehSh=173;
  		if behandlingssted2 in (974631768 /*Sykehuset Innlandet, Elverum*/) then BehSh=171;
  		if behandlingssted2 in (974631776 /*Sykehuset Innlandet, Kongsvinger*/) then BehSh=174;
  		if behandlingssted2 in (974632535 /*Sykehuset Innlandet, Gj�vik*/) then BehSh=172;
  		if behandlingssted2 in (974632543 /*Sykehuset Innlandet, Granheim lungesykehus*/) then BehSh=176;
  		if behandlingssted2 in (974725215 /*Sykehuset Innlandet, Tynset*/) then BehSh=175;
  		if behandlingssted2 in (974724960 /*Sykehuset Innlandet, Hamar*/) then BehSh=178;
  		if behandlingssted2 in (974116650 /*Sykehuset Innlandet, Habiliteringstjenesten i Hedmark, Furnes*/) then BehSh=179;


  /**********************************
  *** Oslo universitetssykehus HF ***
  **********************************/
  		if behandlingssted2 in (874716782 /*OUS, Rikshospitalet*/,
        								974588951 /*OUS, Aker*/,
        								974589087 /*OUS, Oslo legevakt*/,
        								974589095 /*OUS, Ullev�l*/,
        								974705761 /*OUS, Spesialsykehuset for epilepsi*/,
        								974707152 /*OUS, Radiumhospitalet*/,
        								974728230 /*OUS, Geilomo barnesykehus*/,
  									974798263 /*OUS, Voksentoppen*/,
        								975298744 /*OUS, Olafiaklinikken*/,
  									993467049 /*OUS HF*/) then BehSh=180/*Oslo universitetssykehus HF*/;

  		if behandlingssted2 in (874716782 /*OUS, Rikshospitalet*/) then BehSh=181;
  		if behandlingssted2 in (974588951 /*OUS, Aker*/) then BehSh=182;
  		if behandlingssted2 in (974589087 /*OUS, Oslo legevakt*/) then BehSh=183;
  		if behandlingssted2 in (974589095 /*OUS, Ullev�l*/) then BehSh=184;
  		if behandlingssted2 in (974705761 /*OUS, Spesialsykehuset for epilepsi*/) then BehSh=185;
  		if behandlingssted2 in (974707152 /*OUS, Radiumhospitalet*/) then BehSh=186;
  		if behandlingssted2 in (974728230 /*OUS, Geilomo barnesykehus*/) then BehSh=187;
  		if behandlingssted2 in (974798263 /*OUS, Voksentoppen*/) then BehSh=188;
  		if behandlingssted2 in (975298744 /*OUS, Olafiaklinikken*/) then BehSh=189;



  /*************************
  *** Sunnaas sykehus HF ***
  *************************/

  		if behandlingssted2 in (974589214) /*Sunnaas sykehus*/ then BehSh=190/*Sunnaas sykehus*/;
  		if behandlingssted2 in (914356199) /*Sunnaas sykehus, Nesodden poliklinikk*/ then BehSh=191/*Sunnaas sykehus, Nesodden poliklinikk*/;
  		if behandlingssted2 in (994869736) /*Sunnaas sykehus, Aker poliklinikk*/ then BehSh=192/*Sunnaas sykehus, Aker poliklinikk*/;


  /***************************
  *** Sykehuset �stfold HF ***
  ***************************/
  	/* Lokalisasjoner: Kalnes, Fredrikstad, Moss, Sarpsborg, Halden, Askim og Eidsberg. */

  		if behandlingssted2 in (983971768 /*Sykehuset �stfold HF*/,
                                  974633698 /*Sykehuset �stfold, Moss*/,
  									974633752 /*Sykehuset �stfold*/,
        								974634052 /*Sykehuset �stfold, Fysioterapi*/,
        								974703734 /*Sykehuset �stfold, Sarpsborg*/,
                                      974703769 /*Sykehuset �stfold, Habiliteringstjenesten*/) then BehSh=200/*Sykehuset �stfold HF*/;

   		if behandlingssted2 in (974633698 /*Sykehuset �stfold, Moss*/, 974634052 /*Sykehuset �stfold, Fysioterapi*/) then BehSh=201;
  		if behandlingssted2 in (974703734 /*Sykehuset �stfold, Sarpsborg*/, 974703769 /*Sykehuset �stfold, Habiliteringstjenesten*/) then BehSh=202;

  /***************************
  *** S�rlandet sykehus HF ***
  ***************************/

  		if behandlingssted2 in (974595214 /*S�rlandet sykehus, Flekkefjord*/,
  							      	974595230 /*S�rlandet sykehus, Rehabilitering Kongsg�rd*/,
  									974631091 /*S�rlandet sykehus, Arendal*/,
  									974733013 /*S�rlandet sykehus, Kristiansand*/,
  	        						983975240 /*S�rlandet sykehus HF*/) then BehSh=210;

  		if behandlingssted2 in (974595214 /*S�rlandet sykehus, Flekkefjord*/) then BehSh=213;
  		if behandlingssted2 in (974631091 /*S�rlandet sykehus, Arendal*/) then BehSh=212;
  		if behandlingssted2 in (974733013 /*S�rlandet sykehus, Kristiansand*/, 974595230 /*S�rlandet sykehus, Rehabilitering Kongsg�rd*/) then BehSh=211;

  /******************************
  *** Sykehuset i Vestfold HF ***
  ******************************/

  		if behandlingssted2 in (974575396 /*Sykehuset i Vestfold, Rehabilitering Stavern*/,
  								974633574 /*Sykehuset i Vestfold T�nsberg*/,
                                  899643992 /*Sykehuset i Vestfold, Somatikk Solvang*/,
                                  974117002 /*Sykehuset i Vestfold, Habilitering Solvang*/) then BehSh=220;

  		if behandlingssted2 in (974633574 /*Sykehuset i Vestfold, T�nsberg*/) then BehSh=221 ;
  		if behandlingssted2 in (974575396 /*Sykehuset i Vestfold, Rehabilitering Kysthospitalet Stavern*/) then BehSh=222 ;
          if behandlingssted2 in (899643992 /*Sykehuset i Vestfold, Somatikk Solvang*/) then BehSh=223;
          if behandlingssted2 in (974117002 /*Sykehuset i Vestfold, Habilitering Solvang*/) then BehSh=224;

  /***********************************
  *** Diakonhjemmet sykehus ***
  ***********************************/
  		if behandlingssted2 in (974116804 /*Diakonhjemmet sykehus*/) then BehSh=230;

  /***********************************
  *** Lovisenberg diakonale sykehus **
  ***********************************/
  		if behandlingssted2 in (974207532 /*Lovisenberg diakonale sykehus*/) then BehSh=240;

  /***********************************
  *** Resterende Helse S�r-�st RHF ***
  ***********************************/
  		if behandlingssted2 in (985962170 /*Martina Hansens Hospital*/,
  									981275721 /*Betanien hospital*/,
  									985773238 /*Revmatismesykehuset AS, Lillehammer*/,
  									984630492, 997506499 /*Oslo kommunale legevakt*/) then BehSh=250;

  		if behandlingssted2 in (985962170 /*Martina Hansens Hospital*/) then BehSh=251;
  		if behandlingssted2 in (981275721 /*Betanien hospital*/) then BehSh=252;
  		if behandlingssted2 in (985773238 /*Revmatismesykehuset AS, Lillehammer*/) then BehSh=253;
  		if behandlingssted2 in (984630492, 997506499) /*Oslo kommunale legevakt*/ then behSh=254 /*Oslo kommunale legevakt, Observasjonsposten*/;

  		/* Oslo legevakt ligger under OUS HF siden den delen av Oslo legevakt som rapporterer data til NPR
  		er spesialisthelsetjeneste. Dette er Oslo skadelegevakt som er en avdeling ved OUS som mottar pasienter med akutte skader.
  		Se https://oslo-universitetssykehus.no/avdelinger/ortopedisk-klinikk/ortopedisk-avdeling-skadelegevakten */


  /**********************
  *** Private sykehus ***
  **********************/

  		if behandlingssted2 in (813381192 /*Aleris Helse AS Stavanger*/,
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
        								999230008 /*Ifocus �yeklinikk AS*/,
                                      812794922 /*Colosseum Mann AS*/,
                                      817178782 /*Medi 3 Ringvoll Klinikken AS, avd Kirurgi Hob�l*/,
                                      912011135 /*Medi 3 Ringvoll Klinikken AS, avd Oslo*/,
                                      914491908 /*Colosseumklinikken medisinske senter AS*/,
                                      916603290 /*Sandvika Nevrosenter*/,
                                      924291370 /*EEG Laboratoriet AS*/,
                                      953164701 /*Volvat medisinske senter AS Oslo - Majorstuen*/,
                                      993198846 /*Stiftelsen Barnas fysioterapisenter*/
                                      ) then BehSh=300;

  /*
  - Definere `BehHF` - Behandlende helseforetak
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
  - Definere `BehRHF` - Behandlende regionalt helseforetak
  */

  if BehHF in (1,2,3,4) then BehRHF=1;/* Helse Nord RHF */
  if BehHF in (5,6,7) then BehRHF=2;/* Helse Midt-Norge RHF */
  if BehHF in (9,10,11,12,13,26)then BehRHF=3;/* Helse Vest RHF */
  if BehHF in (14:25) then BehRHF=4;/* Helse S�r-�st RHF */
  if BehHF=27 then BehRHF=5;/* Private sykehus */;


run;

%mend;
