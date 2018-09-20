/*
Oppdatert av Linda Leivseth 10. september 2018. 

Formater er hentet fra NPR-melding v. 53.1.1 (gylding for rapportering av �rsdata 2017), _NAVN-variabler i data, ISF regelverk 2017, SAMDATA og value labels fra tidligere �r. 
Det ble ikke gjort en slik detaljert gjennomgang ved fjor�rets tilreggelegging av data. Det er derfor usikkert n�r noen av endringene har funnet sted. Selv om det oppgis at en kode eller at en tekst er 
endret i NPR-melding 53.1.1 (2017) kan endringen ha v�rt gjort tidligere. 
*/

proc format;


value NPRID_REG
      1 = 'F�dselsnummer/ D-nummer er ok.'  
      2 = 'Ulikt kj�nn i f�dselsnummer/ D-nummer og i aktivitetsdata.'  
      3 = 'Ulikt f�dsels�r i f�dselsnummer/ D-nummer og i aktivitetsdata.'  
      4 = 'F�dselsnummer/ D-nummer mangler.'  
      5 = 'D�dsdato i Det sentrale folkeregister er f�r inndato.' ;
  
   value KJONN
      0 = 'Ikke kjent'  
      1 = 'Mann'  
      2 = 'Kvinne'  
      9 = 'Ikke spesifisert' ;
	  
   value HENVFRATJENESTE
      1 = 'Pasienten selv'  
      2 = 'Fastlege/prim�rlege'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      4 = 'Spesialisthelsetjeneste'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      5 = 'Barnehage, skolesektor, PPT'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      6 = 'Sosialtjeneste, barnevern'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      7 = 'Politi, fengsel, rettsvesen'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      8 = 'Rehabiliteringsinstitusjoner, sykehjem'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      9 = 'Andre tjenester'  
      10 = 'Privatpraktiserede spesialister'  
      21 = 'Legevakt'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      22 = 'Kiropraktor'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      23 = 'Manuellterapeut'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
	  28 = 'Fastlege/prim�rlege/legevaktslege' /* Ny kode i NPR-melding 53.1.1 - 2017 */
      41 = 'Somatisk spesialisthelsetjeneste'  
      42 = 'Tverrfaglig spesialisert rusbehandling'  
      43 = 'Distriktspsykiatrisk senter (DPS)'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
	  44 = 'Psykisk helsevern' /* Ny kode i NPR-melding 53.1.1 - 2017 */
      49 = 'Annen institusjon innen psykisk helsevern'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      81 = 'Rehabiliteringsinstitusjoner'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      82 = 'Sykehjem' /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
	  88 = 'Andre kommunale tjenester' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;
 
   value HENVTYPE
      1 = 'Utredning'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      2 = 'Behandling (eventuelt ogs� inkludert videre utredning)'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      3 = 'Kontroll'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      4 = 'Generert for �-hjelpspasient'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      5 = 'Friskt nyf�dt barn'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      6 = 'Graviditet'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      7 = 'Omsorg, botilbud eller annet' /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
	  10 = 'Utredning/behandling' /* Ny kode i NPR-melding 53.1.1 - 2017 */
	  11 = 'R�d til henviser' /* Ny kode i NPR-melding 53.1.1 - 2017 */
	  99 = '�vrige henvisninger' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;
	  
   value FRITTSYKEHUSVALG
      1 = 'Ja'  
      2 = 'Nei'  
      9 = 'Ukjent' ;
	  
   value frittBehandlingsvalg
	  1 = 'Ja'
      2 = 'Nei'
	  9 = 'Ukjent';
	  
   value SECONDOPINION
      1 = 'Ja'  
      2 = 'Nei' ;
	  
   value $FAGOMRADE
     '' = 'Manglende registrering'  
     '010' = 'Generell kirurgi'  
     '020' = 'Barnekirurgi (under 15 �r)'  
     '030' = 'Gasteroenterologisk kirurgi'  
     '040' = 'Karkirurgi'  
     '050' = 'Ortopedisk kirurgi (inklusiv revmakirurgi)'  
     '060' = 'Thoraxkirurgi (inklusiv hjertekirurgi)'  
     '070' = 'Urologi'  
     '080' = 'Kjevekirugi og munnhulesykdom'  
     '090' = 'Plastikk-kirurgi'  
     '100' = 'Nevrokirurgi'  
     '105' = 'Mamma- og para-/tyreoideakirurgi'  
     '110' = 'Generell indremedisin'  
     '120' = 'Blodsykdommer (hematologi)'  
     '130' = 'Endokrinologi'  
     '140' = 'Ford�yelsessykdommer'  
     '150' = 'Hjertesykdommer'  
     '160' = 'Infeksjonssykdommer'  
     '170' = 'Lungesykdommer'  
     '180' = 'Nyresykdommer'  
     '190' = 'Revmatiske sykdommer (revmatologi)'  
     '200' = 'Kvinnesykdommer og elektiv f�dselshjelp'  
     '210' = 'Anestesiologi'  
     '220' = 'Barnesykdommer'  
     '230' = 'Fysikalsk medisin og (re) habilitering'  
     '231' = 'Rehabilitering'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
     '232' = 'Habilitering'   /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
     '233' = 'Habilitering barn og unge'  
     '234' = 'Habilitering voksne'  
     '240' = 'Hud og veneriske sykdommer'  
     '250' = 'Nevrologi'  
     '260' = 'Klinisk nevrofysiologi'  
     '290' = '�re-nese-hals sykdommer'  
     '300' = '�yesykdommer'  
     '310' = 'Psykisk helsevern barn og unge'  
     '320' = 'Psykisk helsevern voksne'  
     '330' = 'Yrkes- og arbeidsmedisin'  
     '340' = 'Transplantasjon, utredning og kirurgi'  
     '350' = 'Geriatri'  
     '360' = 'Rus'  
     '365' = 'LAR - Legemiddelassistert rehabilitering'  
     '370' = 'Spillavhengighet'  
     '380' = 'Palliativ medisin'  
     '410' = 'Allergologi'	/*Ny kode fra 2017*/
     '420' = 'Sykelig overvekt'	/*Ny kode fra 2017*/
     '430' = 'Smertetilstander'	/*Ny kode fra 2017*/
     '821' = 'Klinisk farmakologi'  
     '822' = 'Medisinsk biokjemi'  
     '823' = 'Medisinsk mikrobiologi'  
     '830' = 'Immunologi og transfusjonsmedisin'  
     '840' = 'Medisinsk genetikk'  
     '851' = 'Nukle�rmedisin'  
     '852' = 'Radiologi'  
     '853' = 'Onkologi'  
     '860' = 'Patologi'  
     '900' = 'Annet'  
     '999' = 'Ukjent' ;
	 	 
   value HENVTILTJENESTE
      1 = 'Pasienten selv'  
      2 = 'Fastlege/prim�rlege'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      4 = 'Spesialisthelsetjeneste'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      5 = 'Barnehage, skolesektor, PPT'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      6 = 'Sosialtjeneste, barnevern'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      7 = 'Politi, fengsel, rettsvesen'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      8 = 'Rehabiliteringsinstitusjoner, sykehjem'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      9 = 'Andre tjenester'  
      10 = 'Privatpraktiserede spesialister'  
      21 = 'Legevakt'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      22 = 'Kiropraktor'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      23 = 'Manuellterapeut'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
	  28 = 'Fastlege/prim�rlege/legevaktslege' /* Ny kode i NPR-melding 53.1.1 - 2017 */
      41 = 'Somatisk spesialisthelsetjeneste'  
      42 = 'Tverrfaglig spesialisert rusbehandling'  
      43 = 'Distriktspsykiatrisk senter (DPS)'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
	  44 = 'Psykisk helsevern' /* Ny kode i NPR-melding 53.1.1 - 2017 */
      49 = 'Annen institusjon innen psykisk helsevern'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      81 = 'Rehabiliteringsinstitusjoner'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
      82 = 'Sykehjem' /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
	  88 = 'Andre kommunale tjenester' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;

   value NYTILSTAND
      1 = 'F�rste gangs henvisning, ny tilstand'  
      2 = 'Tilstanden er diagnostisert tidligere' ;
	  
   value DEBITOR
      1 = 'Ordin�r pasient. Opphold finansiert gjennom ISF, HELFO, og ordin�r finansiering innen psykisk helse og TSB'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      11 = 'Konvensjonspasient behandlet ved �-hjelp'  
      12 = 'Pasient  fra land uten konvensjonsavtale (selvbetalende)'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      20 = 'Sykepengeprosjekt, Raskere tilbake'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      22 = 'Forskningsprogram'  
	  24 = 'Finansiert (betalt) av kommunen' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
      30 = 'Selvbetalende norsk pasient og selvbetalende konvensjonspasient'  
	  32 = 'Selvbetalende pasient etter Eus pasientrettighetsdirektiv' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
      40 = 'Anbudspasient finansiert via ISF'  
	  41 = 'Anbudspasient p� avtalen for Helse �st RHF' /* Gammel og utg�tt kode */                          
	  42 = 'Anbudspasient p� avtalen for Helse S�r RHF' /* Gammel og utg�tt kode */ 
      43 = 'Anbudspasient p� avtalen for Helse Vest RHF'  
      44 = 'Anbudspasient p� avtalen for Helse Midt-Norge RHF'  
      45 = 'Anbudspasient p� avtalen for Helse Nord RHF'  
      47 = 'Anbudspasient p� avtalen for Helse S�r-�st RHF'  
      50 = 'Opphold hos avtalespesialist finansiert via ISF'  
      60 = 'Forsikringsfinansiert opphold'  
      70 = 'HELFO formidlet opphold ved fristbrudd'  
      80 = 'Opphold p� avtale med HF/RHF. Ikke anbudsavtale' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      90 = 'Godkjent fritt behandlingsvalg (FBV)' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      99 = 'Annet' ;
	   	  
   value $EPISODEFAG
	 '' = 'Manglende registrering'  
     '010' = 'Generell kirurgi'  
     '020' = 'Barnekirurgi (under 15 �r)'  
     '030' = 'Gasteroenterologisk kirurgi'  
     '040' = 'Karkirurgi'  
     '050' = 'Ortopedisk kirurgi (inklusiv revmakirurgi)'  
     '060' = 'Thoraxkirurgi (inklusiv hjertekirurgi)'  
     '070' = 'Urologi'  
     '080' = 'Kjevekirugi og munnhulesykdom'  
     '090' = 'Plastikk-kirurgi'  
     '100' = 'Nevrokirurgi'  
     '105' = 'Mamma- og para-/tyreoideakirurgi'  
     '110' = 'Generell indremedisin'  
     '120' = 'Blodsykdommer (hematologi)'  
     '130' = 'Endokrinologi'  
     '140' = 'Ford�yelsessykdommer'  
     '150' = 'Hjertesykdommer'  
     '160' = 'Infeksjonssykdommer'  
     '170' = 'Lungesykdommer'  
     '180' = 'Nyresykdommer'  
     '190' = 'Revmatiske sykdommer (revmatologi)'  
     '200' = 'Kvinnesykdommer og elektiv f�dselshjelp'  
     '210' = 'Anestesiologi'  
     '220' = 'Barnesykdommer'  
     '230' = 'Fysikalsk medisin og (re) habilitering'  
     '231' = 'Rehabilitering'  /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
     '232' = 'Habilitering'   /* Utg�tt f�r NPR-melding 53.1.1 - 2017 */
     '233' = 'Habilitering barn og unge'  
     '234' = 'Habilitering voksne'  
     '240' = 'Hud og veneriske sykdommer'  
     '250' = 'Nevrologi'  
     '260' = 'Klinisk nevrofysiologi'  
	 '270' = 'Ukjent fagomr�de, brukes i 2013 og 2014' /* Finner ikke kodeverdi i NPR-meldig eller p� volven.no */
	 '280' = 'Ukjent fagomr�de, brukes i 2013 og 2014' /* Finner ikke kodeverdi i NPR-meldig eller p� volven.no */
     '290' = '�re-nese-hals sykdommer'  
     '300' = '�yesykdommer'  
     '310' = 'Psykisk helsevern barn og unge'  
     '320' = 'Psykisk helsevern voksne'  
     '330' = 'Yrkes- og arbeidsmedisin'  
     '340' = 'Transplantasjon, utredning og kirurgi'  
     '350' = 'Geriatri'  
     '360' = 'Rus'  
     '365' = 'LAR - Legemiddelassistert rehabilitering'  
     '370' = 'Spillavhengighet'  
     '380' = 'Palliativ medisin'  
     '410' = 'Allergologi'	/*Ny kode fra 2017*/
     '420' = 'Sykelig overvekt'	/*Ny kode fra 2017*/
     '430' = 'Smertetilstander'	/*Ny kode fra 2017*/
     '821' = 'Klinisk farmakologi'  
     '822' = 'Medisinsk biokjemi'  
     '823' = 'Medisinsk mikrobiologi'  
     '830' = 'Immunologi og transfusjonsmedisin'  
     '840' = 'Medisinsk genetikk'  
     '851' = 'Nukle�rmedisin'  
     '852' = 'Radiologi'  
     '853' = 'Onkologi'  
     '860' = 'Patologi'  
     '900' = 'Annet'  
     '999' = 'Ukjent' ;
	 
   value FRASTED
      1 = 'Bosted/arbeidssted'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      2 = 'Skade- eller funnsted'  
      3 = 'Annen helseinstitusjon innen spesialisthelsetjenesten'  
      5 = 'Institusjon i utlandet'  
      6 = 'Annet, ukjent'  /* Ikke i NPR-melding 53.1.1 */
      7 = 'Annen (somatisk) enhet ved egen helseinstitusjon'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      8 = 'Annen enhet (ikke somatikk) ved egen helseinstitusjon' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      9 = 'Ugyldig kode - Sykehotell'  /* Ikke i NPR-melding 53.1.1 */
      10 = 'Pasienthotell'  
      11 = 'Sykehjem/aldershjem'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      12 = 'Ugyldig kode - Annen enhet innen TSB ved egen helseinstitusjon'  /* Ikke i NPR-melding 53.1.1 */
      13 = 'Ugyldig kode - Intermedi�renhet/forsterket sykehjem'  /* Ikke i NPR-melding 53.1.1 */
      14 = 'Ugyldig kode - Kommunal legevakt'  /* Ikke i NPR-melding 53.1.1 */
      15 = 'Ugyldig kode'  /* Ikke i NPR-melding 53.1.1 */
      16 = 'Ugyldig kode - Distriktspsykiatrisk senter'  /* Ikke i NPR-melding 53.1.1 */
      21 = 'Kommunal akutt d�gnenhet (KAD)'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      22 = 'Ugyldig kode - Barneverninstitusjon'  /* Ikke i NPR-melding 53.1.1 */
	  23 = 'Ugyldig kode - Beredskapshjem/fosterhjem'  /* Ikke i NPR-melding 53.1.1 */
	  88 = 'Annet'
	  98 = 'Ukjent'
      99 = 'Sted identifisert ved rapportering av attributt  Fra institusjon'  
      100 = 'Ugyldig kode - Vanlig bosted med kommunale tjenester'  /* Ikke i NPR-melding 53.1.1 */
      111 = 'Ugyldig kode - Sykehjem/aldershjem korttidsplass'  /* Ikke i NPR-melding 53.1.1 */
      112 = 'Ugyldig kode - Sykehjem/aldershjem langtidsplass'  /* Ikke i NPR-melding 53.1.1 */
      119 = 'Ugyldig kode - Sykehjem, aldershjem annet eller ukjent' /* Ikke i NPR-melding 53.1.1 */;
 
   value INNTILSTAND
      1 = 'Levende ved ankomst til institusjon'  
      2 = 'D�d ved ankomst'  
      3 = 'Levende f�dt i sykehus' ;
	  
   value INNMATEHAST
      1 = 'Akutt = uten opphold / venting'  
      2 = 'Ikke akutt, men behandling innen 6 timer'  
      3 = 'Venting mellom 6 og 24 timer'  
      4 = 'Planlagt' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
	  5 = 'Tilbakef�ring av pasient fra annet sykehus';
	  
   value TILSTED
      1 = 'Bosted/arbeidssted'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      2 = 'Skade- eller funnsted'  
      3 = 'Annen helseinstitusjon innen spesialisthelsetjenesten'  
      5 = 'Institusjon i utlandet'  
      6 = 'Annet, ukjent'  /* Ikke i NPR-melding 53.1.1 */
      7 = 'Annen (somatisk) enhet ved egen helseinstitusjon'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      8 = 'Annen enhet (ikke somatikk) ved egen helseinstitusjon' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      9 = 'Ugyldig kode - Sykehotell'  /* Ikke i NPR-melding 53.1.1 */
      10 = 'Pasienthotell'  
      11 = 'Sykehjem/aldershjem'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      12 = 'Ugyldig kode - Annen enhet innen TSB ved egen helseinstitusjon'  /* Ikke i NPR-melding 53.1.1 */
      13 = 'Ugyldig kode - Intermedi�renhet/forsterket sykehjem'  /* Ikke i NPR-melding 53.1.1 */
      14 = 'Ugyldig kode - Kommunal legevakt'  /* Ikke i NPR-melding 53.1.1 */
      15 = 'Ugyldig kode'  /* Ikke i NPR-melding 53.1.1 */
      16 = 'Ugyldig kode - Distriktspsykiatrisk senter'  /* Ikke i NPR-melding 53.1.1 */
      21 = 'Kommunal akutt d�gnenhet (KAD)'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      22 = 'Ugyldig kode - Barneverninstitusjon'  /* Ikke i NPR-melding 53.1.1 */
	  23 = 'Ugyldig kode - Beredskapshjem/fosterhjem'  /* Ikke i NPR-melding 53.1.1 */
	  88 = 'Annet'
	  98 = 'Ukjent'
      99 = 'Sted identifisert ved rapportering av attributt  Fra institusjon'  
      100 = 'Ugyldig kode - Vanlig bosted med kommunale tjenester'  /* Ikke i NPR-melding 53.1.1 */
      111 = 'Ugyldig kode - Sykehjem/aldershjem korttidsplass'  /* Ikke i NPR-melding 53.1.1 */
      112 = 'Ugyldig kode - Sykehjem/aldershjem langtidsplass'  /* Ikke i NPR-melding 53.1.1 */
      119 = 'Ugyldig kode - Sykehjem, aldershjem annet eller ukjent' /* Ikke i NPR-melding 53.1.1 */;
	  
   value UTTILSTAND
      1 = 'Som levende'  
      2 = 'Som d�d'  
      3 = 'Suicid' ;
	  
   value TYPETIDSPUNKT
      1 = 'Tidspunkt for varsling til kommunen om innlagt pasient'  
      2 = 'Tidspunkt for n�r pasient er utskrivningsklar'  
      3 = 'Tidspunkt for varsel til kommunen om utskrivningsklar pasient'  
      4 = 'Tidspunkt for avmelding av pasient'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      6 = 'Tidspunkt for melding til sykehuset om at kommunen ikke kan ta imot pasient'  
      7 = 'Tidspunkt for melding til sykehuset om at kommunen kan ta imot pasient'  
      12 = 'Tidspunkt for n�r pasient er overf�ringsklar' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
	  31 = 'Helfo varslet om fristbrudd' /* Ny kode i NPR-melding 53.1.1 - 2017 */
	  32 = 'Avtale med pasient om at Helfo ikke skal varsles om fristbrudd' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;
  
   value G_OMSORGSNIVA
      1 = 'Innleggelse'  
      2 = 'Poliklinisk kontakt' ;
	  
   value OMSORGSNIVA
      1 = 'D�gnopphold'  
      2 = 'Dagbehandling'  
      3 = 'Poliklinisk konsultasjon/kontakt'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      8 = 'Poliklinisk kontakt for inneliggende pasient - for str�leterapi' /* Ny tekst i NPR-melding 53.1.1 - 2017 (LL har lagt til "for str�leterapi", se volven.no) */ ;
	  
 /*  value OPPHOLDSTYPE - Variabelen er ikke lenger i bruk. Sv�rt f� episoder har informasjon om oppholdstype i 2017. 
      1 = 'Held�gnsopphold'  
      2 = 'Dagopphold' ; */
	  
   value KONTAKTTYPE
      1 = 'Utredning'  
      2 = 'Behandling'  
      3 = 'Kontroll'  
      5 = 'Indirekte pasientkontakt'  
      12 = 'Pasientadministrert behandling'  
      13 = 'Oppl�ring' ;
	  
   value STEDAKTIVITET
      1 = 'P� egen helseinstitusjon'  
      2 = 'Hos ekstern instans'  
      3 = 'Telemedisinsk behandling (der behandlende lege er)' /* Ny tekst i NPR-melding 53.1.1 - 2017 */ 
      4 = 'Hjemme hos pasienten'  
      5 = 'Annet ambulant sted'  
      6 = 'Telemedisinsk behandling (der pasienten er)'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      9 = 'Annet sted' ;
	  
   value POLKONAKTIVITET
      1 = 'Individualbehandling'  
      2 = 'Parbehandling'  
      3 = 'Familiebehandling'  
      4 = 'Gruppebehandling'  
      5 = 'Annet'  
      6 = 'Milj�terapi'  
      7 = 'Nettverksterapi'  
      8 = 'Fysisk trening' ;
	  
   value POLINDIR
      1 = 'Erkl�ring/uttalelse/melding'  
      2 = 'M�te. Samarbeid (om pasient) med annet helsepersonell'  
	 22 = 'Samarbeidsm�te (om pasient) med f�rstelinjetjenesten' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	 23 = 'Samarbeidsm�te (om pasient) med annen tjeneste' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  3 = 'Aktivitetsgruppe'  
      5 = 'Brev'  
      6 = 'e-post'  
      7 = 'Telefon'  
	 71 = 'Telefonm�te (om pasient) med f�rstelinjetjenesten' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
      8 = 'Tele-/videokonferanse'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      11 = 'Telemedisin'  
      12 = 'Telefonsamtale med pasient' 
      21 = 'Teknisk Episode';

   value INTERN_KONS
      1 = 'Ja'  
      2 = 'Nei'  
      3 = 'Ja, fra psykiatri' ;
	  
   value $NIVA /* Ikke oppgitt i utlevering 2018 */
     '' = 'Enavdelingsopphold eller poliklinisk kontakt'  
     'F' = 'Fleravdelingsopphold'  
     'S' = 'Sykehusopphold' ;
	 
   value $DRG_TYPE /* Ikke oppgitt i utlevering 2018 */
     'K' = 'Kirurgisk'  
     'M' = 'Medisinsk' ;
	 
   value $KOMP_DRG /* Ikke oppgitt i utlevering 2018 */
     'J' = 'Ja'  
     'N' = 'Nei' ;
	 
   value $DAG_KIR /* Ikke oppgitt i utlevering 2018 */
     'J' = 'Ja'  
     'N' = 'Nei' ;
	 
   value $SPES_DRG /* Ikke oppgitt i utlevering 2018 */
     'J' = 'Ja'  
     'N' = 'Nei' ;
	 
   value REHABTYPE /* Ikke oppgitt i utlevering 2018 */
     1 = 'Vanlig'  
     2 = 'Kompleks'  
     3 = 'Sekund�r' ;
	 
   value HDG /* Hentet fra ISF-regleverket 2017 */
      1 = 'Sykdommer i nervesystemet'  
      2 = '�yesykdommer'  
      3 = '�re-, nese- og halssykdommer'  
      4 = 'Sykdommer i �ndedrettsorganene'  
      5 = 'Sykdommer i sirkulasjonsorganene'  
      6 = 'Sykdommer i ford�yelsesorganene'  
      7 = 'Sykdommer i lever, galleveier og bukspyttkjertel'  
      8 = 'Sykdommer i muskel-, skjelettsystemet og bindevev'  
      9 = 'Sykdommer i hud og underhud'  
      10 = 'Indresekretoriske-, ern�rings- og stoffskiftesykdommer'  
      11 = 'Nyre- og urinveissykdommer'  
      12 = 'Sykdommer i mannlige kj�nnsorganer'  
      13 = 'Sykdommer i kvinnelige kj�nnsorganer'  
      14 = 'Sykdommer under svangerskap, f�dsel og barseltid'  
      15 = 'Nyf�dte med tilstander som har oppst�tt i perinatalperioden'  
      16 = 'Sykdommer i blod, bloddannende organer og immunapparat'  
      17 = 'Myeloproliferative sykdommer og lite differensierte svulster'  
      18 = 'Infeksi�se og parasitt�re sykdommer'  
      19 = 'Psykiske lidelser og rusproblemer'  
      21 = 'Skade, forgiftninger og toksiske effekter av medikamenter/andre stoffer, medikamentmisbruk og organiske sinnslidelser fremkalt av disse'  
      22 = 'Forbrenninger'  
      23 = 'Faktorer som p�virker helsetilstand - andre kontakter med helsetjenesten'
      24 = 'Signifikant multitraume'
      30 = 'Sykdommer i bryst'  
      40 = 'Kategorier p� tvers av flere hoveddiagnosegrupper'  
      99 = 'Kategorier for feil og uvanlige diagnose-prosedyrekombinasjoner' ;
	  
   value UTFORENDEHELSEPERSON /* Antar denne er lik value label for polUtforende */
      1 = 'Lege'  
      2 = 'Sykepleier'  
      3 = 'Pedagog'  
      4 = 'Psykolog'  
      5 = 'Sosionom'  
      6 = 'Barnevernpedagog'  
      7 = 'Vernepleier'  
      8 = 'Jordmor'  
      9 = 'Annet helsepersonell'  
      11 = 'Audiograf'  
      12 = 'Bioingeni�r'  
      13 = 'Ergoterapeut'  
      14 = 'Fysioterapeut'  
      15 = 'Klinisk ern�ringsfysiolog'  
      16 = 'Radiograf'  
      17 = 'Tannlege' 
	  18 = 'Ortoptist' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  19 = 'Ortopediingeni�r' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  20 = 'Farmas�yt' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  21 = 'Fotterapeut' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;
   
   value GYLDIG /* Ikke oppgitt i utlevering 2018 */
      0 = ' ' /* Gjelder kun NCRP i 2017. Fikk vite betydningen fra Marte Kjelvik i NPR. */ 
      1 = 'Gyldig'  
      8 = 'Utg�tt - m� oppdateres'  
      9 = 'Ugyldig' ;	  
    
   value ISF_OPPHOLD /* Ikke oppgitt i utlevering 2018 */
      1 = 'Ja'  
      2 = 'Nei' ;
	  
   value AKTIVITETSKATEGORI
      0 = 'Innlagt rehab'  
      1 = 'Innlagt mer enn 2 lgd'  
      2 = 'Innlagt 1 lgd'  
      3 = 'Innlagt 0 lgd'  
      4 = 'Kir 0 lgd (innlagt+poli)'  
      5 = 'Polikl'  
      6 = 'Polikl rehab'  
      7 = 'Polikl kjemoterapi'  
      8 = 'Polikl str�leterapi'  
      9 = 'Dialyse 0 lgd' ;
	  
   value AKTIVITETSKATEGORI2F
      1 = 'Innlagt'  
      2 = 'Poliklinisk konsultasjon' ;
	  
   value AKTIVITETSKATEGORI3F
      1 = 'D�gnopphold'  
      2 = 'Dagbehandling'  
      3 = 'Poliklinisk konsultasjon' ;
	  
   value AKTIVITETSKATEGORI4F
      1 = 'Innlagt'  
      2 = 'Innlagt dagbehandling'  
      3 = 'Kirurgisk dagbehandling'  
      4 = 'Poliklinisk konsultasjon' ;
	  
   value $KOMNRHJEM2F /* Ikke oppdatert */
     '0000' = 'Ugyldig'  
     '9000' = 'Utenlandske statsborgere uten konvensjonsavtale'  
     '9900' = 'Utenlandske statsborgere med konvensjonsavtale'  
     '2020' = 'Porsanger'  
     '1120' = 'Klepp'  
     '0220' = 'Asker'  
     '0420' = 'Eidskog'  
     '1420' = 'Sogndal'  
     '0520' = 'Ringebu'  
     '1520' = '�rsta'  
     '0620' = 'Hol'  
     '1620' = 'Fr�ya'  
     '0720' = 'Stokke'  
     '1820' = 'Alstahaug'  
     '1920' = 'Lavangen'  
     '2030' = 'S�r-Varanger'  
     '1130' = 'Strand'  
     '0230' = 'L�renskog'  
     '0430' = 'Stor-Elvdal'  
     '1430' = 'Gaular'  
     '1630' = '�fjord'  
     '0830' = 'Nissedal'  
     '0540' = 'S�r-Aurdal'  
     '1640' = 'R�ros'  
     '1740' = 'Namsskogan'  
     '1840' = 'Saltdal'  
     '0940' = 'Valle'  
     '1940' = 'K�fjord'  
     '1750' = 'Vikna'  
     '1850' = 'Tysfjord'  
     '1160' = 'Vindafjord'  
     '1260' = 'Rad�y'  
     '1560' = 'Tingvoll'  
     '1860' = 'Vestv�g�y'  
     '1870' = 'Sortland'  
     '1001' = 'Kristiansand'  
     '0101' = 'Halden'  
     '1101' = 'Eigersund'  
     '1201' = 'Bergen'  
     '0301' = 'Oslo'  
     '1401' = 'Flora'  
     '0501' = 'Lillehammer'  
     '1601' = 'Trondheim'  
     '0701' = 'Horten'  
     '0901' = 'Ris�r'  
     '1901' = 'Harstad'  
     '2011' = 'Kautokeino'  
     '0111' = 'Hvaler'  
     '1111' = 'Sokndal'  
     '2111' = 'Spitsbergen'  
     '0211' = 'Vestby'  
     '1211' = 'Etne'  
     '2211' = 'Jan Mayen'  
     '1411' = 'Gulen'  
     '0511' = 'Dovre'  
     '1511' = 'Vanylven'  
     '0711' = 'Svelvik'  
     '1711' = 'Mer�ker'  
     '0811' = 'Siljan'  
     '1811' = 'Bindal'  
     '0911' = 'Gjerstad'  
     '1911' = 'Kv�fjord'  
     '1021' = 'Marnardal'  
     '2021' = 'Karasjok'  
     '0121' = 'R�mskog'  
     '1121' = 'Time'  
     '2121' = 'Bj�rn�ya'  
     '0221' = 'Aurskog-H�land'  
     '1221' = 'Stord'  
     '1421' = 'Aurland'  
     '0521' = '�yer'  
     '0621' = 'Sigdal'  
     '1621' = '�rland'  
     '1721' = 'Verdal'  
     '0821' = 'B�'  
     '2131' = 'Hopen'  
     '0231' = 'Skedsmo'  
     '1231' = 'Ullensvang'  
     '1431' = 'J�lster'  
     '1531' = 'Sula'  
     '0631' = 'Flesberg'  
     '0831' = 'Fyresdal'  
     '1931' = 'Lenvik'  
     '1141' = 'Finn�y'  
     '1241' = 'Fusa'  
     '0441' = 'Os'  
     '1441' = 'Selje'  
     '0541' = 'Etnedal'  
     '1841' = 'Fauske'  
     '0941' = 'Bykle'  
     '1941' = 'Skjerv�y'  
     '1151' = 'Utsira'  
     '1251' = 'Vaksdal'  
     '1551' = 'Eide'  
     '1751' = 'N�r�y'  
     '1851' = 'L�dingen'  
     '1571' = 'Halsa'  
     '1871' = 'And�y'  
     '1002' = 'Mandal'  
     '2002' = 'Vard�'  
     '1102' = 'Sandnes'  
     '0402' = 'Kongsvinger'  
     '0502' = 'Gj�vik'  
     '1502' = 'Molde'  
     '0602' = 'Drammen'  
     '0702' = 'Holmestrand'  
     '1702' = 'Steinkjer'  
     '1902' = 'Troms�'  
     '2012' = 'Alta'  
     '1112' = 'Lund'  
     '0412' = 'Ringsaker'  
     '1412' = 'Solund'  
     '0512' = 'Lesja'  
     '0612' = 'Hole'  
     '1612' = 'Hemne'  
     '1812' = 'S�mna'  
     '0912' = 'Veg�rshei'  
     '2022' = 'Lebesby'  
     '0122' = 'Tr�gstad'  
     '1122' = 'Gjesdal'  
     '1222' = 'Fitjar'  
     '1422' = 'L�rdal'  
     '0522' = 'Gausdal'  
     '0622' = 'Kr�dsherad'  
     '1622' = 'Agdenes'  
     '0722' = 'N�tter�y'  
     '0822' = 'Sauherad'  
     '1822' = 'Leirfjord'  
     '1922' = 'Bardu'  
     '1032' = 'Lyngdal'  
     '1232' = 'Eidfjord'  
     '0432' = 'Rendalen'  
     '1432' = 'F�rde'  
     '0532' = 'Jevnaker'  
     '1532' = 'Giske'  
     '0632' = 'Rollag'  
     '1632' = 'Roan'  
     '1832' = 'Hemnes'  
     '1142' = 'Rennes�y'  
     '1242' = 'Samnanger'  
     '0542' = 'Nord-Aurdal'  
     '1742' = 'Grong'  
     '1942' = 'Nordreisa'  
     '1252' = 'Modalen'  
     '1852' = 'Tjeldsund'  
     '1662' = 'Kl�bu'  
     '1003' = 'Farsund'  
     '2003' = 'Vads�'  
     '1103' = 'Stavanger'  
     '0403' = 'Hamar'  
     '1703' = 'Namsos'  
     '1903' = 'Harstad'  
     '0213' = 'Ski'  
     '1413' = 'Hyllestad'  
     '0513' = 'Skj�k'  
     '1613' = 'Snillfjord'  
     '0713' = 'Sande'  
     '1813' = 'Br�nn�y'  
     '1913' = 'Sk�nland'  
     '2023' = 'Gamvik'  
     '0123' = 'Spydeberg'  
     '1223' = 'Tysnes'  
     '0423' = 'Grue'  
     '1523' = '�rskog'  
     '0623' = 'Modum'  
     '0723' = 'Tj�me'  
     '1723' = 'Mosvik'  
     '1923' = 'Salangen'  
     '1133' = 'Hjelmeland'  
     '0233' = 'Nittedal'  
     '1233' = 'Ulvik'  
     '1433' = 'Naustdal'  
     '0533' = 'Lunner'  
     '0633' = 'Nore og Uvdal'  
     '1633' = 'Osen'  
     '0833' = 'Tokke'  
     '1833' = 'Rana'  
     '1933' = 'Balsfjord'  
     '1243' = 'Os'  
     '1443' = 'Eid'  
     '0543' = 'Vestre Slidre'  
     '1543' = 'Nesset'  
     '1743' = 'H�ylandet'  
     '1943' = 'Kv�nangen'  
     '1253' = 'Oster�y'  
     '1653' = 'Melhus'  
     '1853' = 'Evenes'  
     '1263' = 'Lind�s'  
     '1563' = 'Sunndal'  
     '1663' = 'Malvik'  
     '1573' = 'Sm�la'  
     '1004' = 'Flekkefjord'  
     '2004' = 'Hammerfest'  
     '0104' = 'Moss'  
     '1504' = '�lesund'  
     '0604' = 'Kongsberg'  
     '0704' = 'T�nsberg'  
     '1804' = 'Bod�'  
     '0904' = 'Grimstad'  
     '1014' = 'Vennesla'  
     '2014' = 'Loppa'  
     '1114' = 'Bjerkreim'  
     '0214' = '�s'  
     '0514' = 'Lom'  
     '1514' = 'Sande'  
     '0714' = 'Hof'  
     '1714' = 'Stj�rdal'  
     '0814' = 'Bamble'  
     '0914' = 'Tvedestrand'  
     '2024' = 'Berlev�g'  
     '0124' = 'Askim'  
     '1124' = 'Sola'  
     '1224' = 'Kvinnherad'  
     '1424' = '�rdal'  
     '1524' = 'Norddal'  
     '0624' = '�vre Eiker'  
     '1624' = 'Rissa'  
     '1724' = 'Verran'  
     '1824' = 'Vefsn'  
     '1924' = 'M�lselv'  
     '1034' = 'H�gebostad'  
     '1134' = 'Suldal'  
     '0234' = 'Gjerdrum'  
     '1234' = 'Granvin'  
     '0434' = 'Engerdal'  
     '0534' = 'Gran'  
     '1534' = 'Haram'  
     '1634' = 'Oppdal'  
     '0834' = 'Vinje'  
     '1834' = 'Lur�y'  
     '1144' = 'Kvits�y'  
     '1244' = 'Austevoll'  
     '1444' = 'Hornindal'  
     '0544' = '�ystre Slidre'  
     '1644' = 'Holt�len'  
     '1744' = 'Overhalla'  
     '1554' = 'Aver�y'  
     '1854' = 'Ballangen'  
     '1264' = 'Austrheim'  
     '1664' = 'Selbu'  
     '1874' = 'Moskenes'  
     '0105' = 'Sarpsborg'  
     '1505' = 'Kristiansund'  
     '0605' = 'Ringerike'  
     '0805' = 'Porsgrunn'  
     '1805' = 'Narvik'  
     '2015' = 'Hasvik'  
     '0215' = 'Frogn'  
     '0415' = 'L�ten'  
     '0515' = 'V�g�'  
     '1515' = 'Her�y'  
     '0615' = 'Fl�'  
     '0815' = 'Krager�'  
     '1815' = 'Vega'  
     '1915' = 'Bjark�y'  
     '2025' = 'Tana'  
     '0125' = 'Eidsberg'  
     '0425' = '�snes'  
     '1525' = 'Stranda'  
     '0625' = 'Nedre Eiker'  
     '1725' = 'Namdalseid'  
     '1825' = 'Grane'  
     '1925' = 'S�rreisa'  
     '0135' = 'R�de'  
     '1135' = 'Sauda'  
     '0235' = 'Ullensaker'  
     '1235' = 'Voss'  
     '1535' = 'Vestnes'  
     '1635' = 'Rennebu'  
     '1835' = 'Tr�na'  
     '0935' = 'Iveland'  
     '1145' = 'Bokn'  
     '1245' = 'Sund'  
     '1445' = 'Gloppen'  
     '0545' = 'Vang'  
     '1545' = 'Midsund'  
     '1845' = 'S�rfold'  
     '1755' = 'Leka'  
     '1265' = 'Fedje'  
     '1665' = 'Tydal'  
     '1865' = 'V�gan'  
     '0106' = 'Fredrikstad'  
     '1106' = 'Haugesund'  
     '0706' = 'Sandefjord'  
     '0806' = 'Skien'  
     '0906' = 'Arendal'  
     '0216' = 'Nesodden'  
     '1216' = 'Sveio'  
     '1416' = 'H�yanger'  
     '0516' = 'Nord-Fron'  
     '1516' = 'Ulstein'  
     '0616' = 'Nes'  
     '0716' = 'Re'  
     '1816' = 'Vevelstad'  
     '1026' = '�seral'  
     '0226' = 'S�rum'  
     '0426' = 'V�ler'  
     '1426' = 'Luster'  
     '1526' = 'Stordal'  
     '0626' = 'Lier'  
     '0826' = 'Tinn'  
     '1826' = 'Hattfjelldal'  
     '0926' = 'Lillesand'  
     '1926' = 'Dyr�y'  
     '0136' = 'Rygge'  
     '0236' = 'Nes'  
     '0436' = 'Tolga'  
     '0536' = 'S�ndre Land'  
     '1636' = 'Meldal'  
     '1736' = 'Sn�sa'  
     '1836' = 'R�d�y'  
     '1936' = 'Karls�y'  
     '1046' = 'Sirdal'  
     '1146' = 'Tysv�r'  
     '1246' = 'Fjell'  
     '1546' = 'Sand�y'  
     '1256' = 'Meland'  
     '1756' = 'Inder�y'  
     '1856' = 'R�st'  
     '1266' = 'Masfjorden'  
     '1566' = 'Surnadal'  
     '1866' = 'Hadsel'  
     '1576' = 'Aure'  
     '0807' = 'Notodden'  
     '1017' = 'Songdalen'  
     '2017' = 'Kvalsund'  
     '0217' = 'Oppeg�rd'  
     '0417' = 'Stange'  
     '1417' = 'Vik'  
     '0517' = 'Sel'  
     '1517' = 'Hareid'  
     '0617' = 'Gol'  
     '1617' = 'Hitra'  
     '1717' = 'Frosta'  
     '0817' = 'Drangedal'  
     '1917' = 'Ibestad'  
     '1027' = 'Audnedal'  
     '2027' = 'Nesseby'  
     '0127' = 'Skiptvet'  
     '1127' = 'Randaberg'  
     '0227' = 'Fet'  
     '1227' = 'Jondal'  
     '0427' = 'Elverum'  
     '0627' = 'R�yken'  
     '1627' = 'Bjugn'  
     '0827' = 'Hjartdal'  
     '1827' = 'D�nna'  
     '1927' = 'Tran�y'  
     '1037' = 'Kvinesdal'  
     '0137' = 'V�ler'  
     '0237' = 'Eidsvoll'  
     '0437' = 'Tynset'  
     '1837' = 'Mel�y'  
     '0937' = 'Evje og Hornnes'  
     '1247' = 'Ask�y'  
     '1547' = 'Aukra'  
     '1557' = 'Gjemnes'  
     '1657' = 'Skaun'  
     '1857' = 'V�r�y'  
     '1567' = 'Rindal'  
     '1867' = 'B�'  
     '1018' = 'S�gne'  
     '2018' = 'M�s�y'  
     '0118' = 'Aremark'  
     '0418' = 'Nord-Odal'  
     '1418' = 'Balestrand'  
     '0618' = 'Hemsedal'  
     '1718' = 'Leksvik'  
     '1818' = 'Her�y'  
     '2028' = 'B�tsfjord'  
     '0128' = 'Rakkestad'  
     '0228' = 'R�lingen'  
     '1228' = 'Odda'  
     '0428' = 'Trysil'  
     '1428' = 'Askvoll'  
     '0528' = '�stre Toten'  
     '1528' = 'Sykkylven'  
     '0628' = 'Hurum'  
     '0728' = 'Lardal'  
     '0828' = 'Seljord'  
     '1828' = 'Nesna'  
     '0928' = 'Birkenes'  
     '1928' = 'Torsken'  
     '0138' = 'Hob�l'  
     '0238' = 'Nannestad'  
     '1238' = 'Kvam'  
     '0438' = 'Alvdal'  
     '1438' = 'Bremanger'  
     '0538' = 'Nordre Land'  
     '1638' = 'Orkdal'  
     '1738' = 'Lierne'  
     '1838' = 'Gildesk�l'  
     '0938' = 'Bygland'  
     '1938' = 'Lyngen'  
     '1548' = 'Fr�na'  
     '1648' = 'Midtre Gauldal'  
     '1748' = 'Fosnes'  
     '1848' = 'Steigen'  
     '1868' = '�ksnes'  
     '0709' = 'Larvik'  
     '2019' = 'Nordkapp'  
     '0119' = 'Marker'  
     '1119' = 'H�'  
     '0219' = 'B�rum'  
     '1219' = 'B�mlo'  
     '0419' = 'S�r-Odal'  
     '1419' = 'Leikanger'  
     '0519' = 'S�r-Fron'  
     '1519' = 'Volda'  
     '0619' = '�l'  
     '0719' = 'Andebu'  
     '1719' = 'Levanger'  
     '0819' = 'Nome'  
     '0919' = 'Froland'  
     '1919' = 'Gratangen'  
     '1029' = 'Lindesnes'  
     '1129' = 'Forsand'  
     '0229' = 'Enebakk'  
     '0429' = '�mot'  
     '1429' = 'Fjaler'  
     '0529' = 'Vestre Toten'  
     '1529' = 'Skodje'  
     '1729' = 'Inder�y'  
     '0829' = 'Kviteseid'  
     '0929' = '�mli'  
     '1929' = 'Berg'  
     '0239' = 'Hurdal'  
     '0439' = 'Folldal'  
     '1439' = 'V�gs�y'  
     '1539' = 'Rauma'  
     '1739' = 'R�yrvik'  
     '1839' = 'Beiarn'  
     '1939' = 'Storfjord'  
     '1149' = 'Karm�y'  
     '1449' = 'Stryn'  
     '1749' = 'Flatanger'  
     '1849' = 'Hamar�y'  
     '1259' = '�ygarden'  
     '1859' = 'Flakstad'  
     '9999' = 'Ukjent kommunenummer' ;
  
value pakkeforlop
1 = 'Ja'
2 = 'Nei';

value ICD_KAP /* Sjekket mot og oppdatert basert p� ICD-10 versjon 2017 p� ehelse.no */
      1 = 'Kapittel I Visse infeksjonssykdommer og parasittsykdommer (A00-B99)'  
      2 = 'Kapittel II Svulster (C00-D48)'  
      3 = 'Kapittel III Sykdommer i blod og bloddannende organer og visse tilstander som ang�r immunsystemet (D50-D89)'  
      4 = 'Kapittel IV Endokrine sykdommer, ern�ringssykdommer og metabolske forstyrrelse (E00-E90)'  
      5 = 'Kapittel V Psykiske lidelser og atferdsforstyrrelser (F00-F99)'  
      6 = 'Kapittel VI Sykdommer i nervesystemet (G00-G99)'  
      7 = 'Kapittel VII Sykdommer i �yet og �yets omgivelser (H00-H59)'  
      8 = 'Kapittel VIII Sykdommer i �re og �rebensknute (processus mastoideus) (H60-H95)'  
      9 = 'Kapittel IX Sykdommer i sirkulasjonssystemet (I00-I99)'  
      10 = 'Kapittel X Sykdommer i �ndedrettssystemet (J00-J99)'  
      11 = 'Kapittel XI Sykdommer i ford�yelsessystemet (K00-K93)'  
      12 = 'Kapittel XII Sykdommer i hud og underhud (L00-L99)'  
      13 = 'Kapittel XIII Sykdommer i muskel-skjelettsystemet og bindevev (M00-M99)'  
      14 = 'Kapittel XIV Sykdommer i urin- og kj�nnsorganer (N00-N99)'  
      15 = 'Kapittel XV Svangerskap, f�dsel og barseltid (O00-O99)'  
      16 = 'Kapittel XVI Visse tilstander som oppst�r i perinatalperioden (P00-P96)'  
      17 = 'Kapittel XVII Medf�dte misdannelser, deformiteter og kromosomavvik (Q00-Q99)'  
      18 = 'Kapittel XVIII Symptomer, tegn, unormale kliniske funn og laboratoriefunn,IKAS (R00-R99)'  
      19 = 'Kapittel XIX Skader, forgiftninger og visse andre konsekvenser av ytre �rsaker (S00-T98)'  
      20 = 'Kapittel XX Ytre �rsaker til sykdommer, skader og d�dsfall (V0n-Y98)'  
      21 = 'Kapittel XXI Faktorer som har betydning for helsetilstand og kontakt med helsetjenesten (Z00-Z99)' ;

run;
