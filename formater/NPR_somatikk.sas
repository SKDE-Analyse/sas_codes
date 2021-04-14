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
      3 = 'NULL' /*ny 2020*/
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
      13	= 'Folketrygdfinansiert behandling via Helfo for pasienter bosatt i utlandet, men med medlemskap i folketrygden' /* ny 2020*/
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
      51 = 'Regional kurd�gnfinansiering' /*ny 2020*/
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
      6 = 'Videokonsultasjon'
      7 = 'Telefonkonsultasjon med egenandel'
      12 = 'Pasientadministrert behandling'  
      13 = 'Oppl�ring';
	  
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
      13 = 'Telefonkonsultasjon med egenadel' /*ny 2020*/
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
	  21 = 'Fotterapeut' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
     22 = 'Genetiker'   /* ny 2020 */
     23 = 'Logoped'  /* ny 2020 */
     24 = 'Perfusjonist'  /* ny 2020 */
     25 = 'Optiker'  /* ny 2020 */
     26 = 'Audiofysiker'  /* ny 2020 */
     27 = 'Kiropraktor'  /* ny 2020 */
     28 = 'Helsesykepleier'  /* ny 2020 */
     29 = 'Str�leterapeut'  /* ny 2020 */ ;
   
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

value individuellplan /* ny 2020 */
      1	 = 'Pasienten oppfyller ikke kriteriene'
      2	 = 'Pasienten har avsl�tt tilbud om IP'
      4	 = 'IP er under arbeid i spesialisthelsethenesten'
      5	 = 'Pasienten har allerede en IP'
      9	 = 'Ukjent med status for individuell plan'
      11	 = 'Pasienten oppfyller kriteriene'
      21	 = 'Pasienten �nsker individuell plan, samtykke foreligger'
      31	 = 'Melding om behov for IP sendt kommunen'
      101 = 'Ja, virksom plan'
      102 = 'Nei, individuell plan er ikke utarbeidet/planprosess ikke igangsatt'
      103 = 'Nei, �nsker ikke individuell plan'
      104 = 'Nei, oppfyller ikke retten til individuell plan'
      105 = 'Melding om behov for individuell plan er sendt kommunen'
      106 = 'Ukjent med status';

value epikriseSamtykke /* ny 2020 */
      1 = 'Ja, samtykke er innhentet'
      2 = 'Pasientens samtykke er ikke p�krevet i dette tilfellet'
      3 = 'Svar p� foresp�rsel e.l. som pasienten har gitt samtykke til'
      4 = 'Nei, pasienten har ikke gitt sitt samtykke';

value spesialist /* ny 2020 */
      1 = 'Ja'
      2 = 'Nei'
      9 = 'Ukjent';

value rolle /* ny 2020*/
      1 = 'Ansvarlig'
      2 = 'Ko-terapeut';
      
value fylke /* added 08.04.2021*/
      0	= '0	Ugyldig/blank'
      1	= '1	�stfold'
      2	= '2	Akershus'
      3	= '3	Oslo'
      4	= '4	Hedmark'
      5	= '5	Oppland'
      6	= '6	Buskerud'
      7	= '7	Vestfold'
      8	= '8	Telemark'
      9	= '9	Aust-Agder'
      10	= '10 Vest-Agder'
      11	= '11 Rogaland'
      12	= '12 Hordaland'
      14	= '14 Sogn og Fjordane'
      15	= '15 M�re og Romsdal'
      16	= '16 S�r-Tr�ndelag'
      17	= '17 Nord-Tr�ndelag'
      18	= '18 Nordland'
      19	= '19 Troms'
      20	= '20 Finnmark'
      30 = '30 Viken'                  /* ny 2020*/
      34 = '34 Innlandet'              /* ny 2020*/
      38 = '38 Vestfold og Telemark'   /* ny 2020*/
      42 = '42 Agder'                  /* ny 2020*/
      46 = '46 Vestland'               /* ny 2020*/
      50 = '50 Tr�ndelag'              
      54 = '54 Troms og Finnmark'      /* ny 2020*/
      88	= '88 Ikke spesifisert'
      99	= '99 Utlendinger'
      21	= '21 Svalbard'
;

value region /* added 08.04.2021*/
      3 = 'Helse Vest'
      4 = 'Helse Midt-Norge'
      5 = 'Helse Nord'
      6 = 'Utlendinger/annet'
      7 = 'Helse S�r-�st';

value SEKTOR
      1 = 'Somatiske aktivitetsdata'  
      2 = 'VOP'  
      3 = 'TSB'  
      4 = 'Avtalespesialister, psyk' 
      5 = 'Avtalespesialister, som' ;
run;
