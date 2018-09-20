/*
Oppdatert av Linda Leivseth 10. september 2018. 

Formater er hentet fra NPR-melding v. 53.1.1 (gylding for rapportering av årsdata 2017), _NAVN-variabler i data, ISF regelverk 2017, SAMDATA og value labels fra tidligere år. 
Det ble ikke gjort en slik detaljert gjennomgang ved fjorårets tilreggelegging av data. Det er derfor usikkert når noen av endringene har funnet sted. Selv om det oppgis at en kode eller at en tekst er 
endret i NPR-melding 53.1.1 (2017) kan endringen ha vært gjort tidligere. 
*/

proc format;


value NPRID_REG
      1 = 'Fødselsnummer/ D-nummer er ok.'  
      2 = 'Ulikt kjønn i fødselsnummer/ D-nummer og i aktivitetsdata.'  
      3 = 'Ulikt fødselsår i fødselsnummer/ D-nummer og i aktivitetsdata.'  
      4 = 'Fødselsnummer/ D-nummer mangler.'  
      5 = 'Dødsdato i Det sentrale folkeregister er før inndato.' ;
  
   value KJONN
      0 = 'Ikke kjent'  
      1 = 'Mann'  
      2 = 'Kvinne'  
      9 = 'Ikke spesifisert' ;
	  
   value HENVFRATJENESTE
      1 = 'Pasienten selv'  
      2 = 'Fastlege/primærlege'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      4 = 'Spesialisthelsetjeneste'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      5 = 'Barnehage, skolesektor, PPT'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      6 = 'Sosialtjeneste, barnevern'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      7 = 'Politi, fengsel, rettsvesen'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      8 = 'Rehabiliteringsinstitusjoner, sykehjem'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      9 = 'Andre tjenester'  
      10 = 'Privatpraktiserede spesialister'  
      21 = 'Legevakt'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      22 = 'Kiropraktor'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      23 = 'Manuellterapeut'  /* Utgått før NPR-melding 53.1.1 - 2017 */
	  28 = 'Fastlege/primærlege/legevaktslege' /* Ny kode i NPR-melding 53.1.1 - 2017 */
      41 = 'Somatisk spesialisthelsetjeneste'  
      42 = 'Tverrfaglig spesialisert rusbehandling'  
      43 = 'Distriktspsykiatrisk senter (DPS)'  /* Utgått før NPR-melding 53.1.1 - 2017 */
	  44 = 'Psykisk helsevern' /* Ny kode i NPR-melding 53.1.1 - 2017 */
      49 = 'Annen institusjon innen psykisk helsevern'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      81 = 'Rehabiliteringsinstitusjoner'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      82 = 'Sykehjem' /* Utgått før NPR-melding 53.1.1 - 2017 */
	  88 = 'Andre kommunale tjenester' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;
 
   value HENVTYPE
      1 = 'Utredning'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      2 = 'Behandling (eventuelt også inkludert videre utredning)'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      3 = 'Kontroll'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      4 = 'Generert for Ø-hjelpspasient'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      5 = 'Friskt nyfødt barn'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      6 = 'Graviditet'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      7 = 'Omsorg, botilbud eller annet' /* Utgått før NPR-melding 53.1.1 - 2017 */
	  10 = 'Utredning/behandling' /* Ny kode i NPR-melding 53.1.1 - 2017 */
	  11 = 'Råd til henviser' /* Ny kode i NPR-melding 53.1.1 - 2017 */
	  99 = 'Øvrige henvisninger' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;
	  
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
     '020' = 'Barnekirurgi (under 15 år)'  
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
     '140' = 'Fordøyelsessykdommer'  
     '150' = 'Hjertesykdommer'  
     '160' = 'Infeksjonssykdommer'  
     '170' = 'Lungesykdommer'  
     '180' = 'Nyresykdommer'  
     '190' = 'Revmatiske sykdommer (revmatologi)'  
     '200' = 'Kvinnesykdommer og elektiv fødselshjelp'  
     '210' = 'Anestesiologi'  
     '220' = 'Barnesykdommer'  
     '230' = 'Fysikalsk medisin og (re) habilitering'  
     '231' = 'Rehabilitering'  /* Utgått før NPR-melding 53.1.1 - 2017 */
     '232' = 'Habilitering'   /* Utgått før NPR-melding 53.1.1 - 2017 */
     '233' = 'Habilitering barn og unge'  
     '234' = 'Habilitering voksne'  
     '240' = 'Hud og veneriske sykdommer'  
     '250' = 'Nevrologi'  
     '260' = 'Klinisk nevrofysiologi'  
     '290' = 'Øre-nese-hals sykdommer'  
     '300' = 'Øyesykdommer'  
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
     '851' = 'Nukleærmedisin'  
     '852' = 'Radiologi'  
     '853' = 'Onkologi'  
     '860' = 'Patologi'  
     '900' = 'Annet'  
     '999' = 'Ukjent' ;
	 	 
   value HENVTILTJENESTE
      1 = 'Pasienten selv'  
      2 = 'Fastlege/primærlege'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      4 = 'Spesialisthelsetjeneste'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      5 = 'Barnehage, skolesektor, PPT'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      6 = 'Sosialtjeneste, barnevern'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      7 = 'Politi, fengsel, rettsvesen'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      8 = 'Rehabiliteringsinstitusjoner, sykehjem'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      9 = 'Andre tjenester'  
      10 = 'Privatpraktiserede spesialister'  
      21 = 'Legevakt'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      22 = 'Kiropraktor'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      23 = 'Manuellterapeut'  /* Utgått før NPR-melding 53.1.1 - 2017 */
	  28 = 'Fastlege/primærlege/legevaktslege' /* Ny kode i NPR-melding 53.1.1 - 2017 */
      41 = 'Somatisk spesialisthelsetjeneste'  
      42 = 'Tverrfaglig spesialisert rusbehandling'  
      43 = 'Distriktspsykiatrisk senter (DPS)'  /* Utgått før NPR-melding 53.1.1 - 2017 */
	  44 = 'Psykisk helsevern' /* Ny kode i NPR-melding 53.1.1 - 2017 */
      49 = 'Annen institusjon innen psykisk helsevern'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      81 = 'Rehabiliteringsinstitusjoner'  /* Utgått før NPR-melding 53.1.1 - 2017 */
      82 = 'Sykehjem' /* Utgått før NPR-melding 53.1.1 - 2017 */
	  88 = 'Andre kommunale tjenester' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;

   value NYTILSTAND
      1 = 'Første gangs henvisning, ny tilstand'  
      2 = 'Tilstanden er diagnostisert tidligere' ;
	  
   value DEBITOR
      1 = 'Ordinær pasient. Opphold finansiert gjennom ISF, HELFO, og ordinær finansiering innen psykisk helse og TSB'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      11 = 'Konvensjonspasient behandlet ved ø-hjelp'  
      12 = 'Pasient  fra land uten konvensjonsavtale (selvbetalende)'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      20 = 'Sykepengeprosjekt, Raskere tilbake'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      22 = 'Forskningsprogram'  
	  24 = 'Finansiert (betalt) av kommunen' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
      30 = 'Selvbetalende norsk pasient og selvbetalende konvensjonspasient'  
	  32 = 'Selvbetalende pasient etter Eus pasientrettighetsdirektiv' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
      40 = 'Anbudspasient finansiert via ISF'  
	  41 = 'Anbudspasient på avtalen for Helse Øst RHF' /* Gammel og utgått kode */                          
	  42 = 'Anbudspasient på avtalen for Helse Sør RHF' /* Gammel og utgått kode */ 
      43 = 'Anbudspasient på avtalen for Helse Vest RHF'  
      44 = 'Anbudspasient på avtalen for Helse Midt-Norge RHF'  
      45 = 'Anbudspasient på avtalen for Helse Nord RHF'  
      47 = 'Anbudspasient på avtalen for Helse Sør-Øst RHF'  
      50 = 'Opphold hos avtalespesialist finansiert via ISF'  
      60 = 'Forsikringsfinansiert opphold'  
      70 = 'HELFO formidlet opphold ved fristbrudd'  
      80 = 'Opphold på avtale med HF/RHF. Ikke anbudsavtale' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      90 = 'Godkjent fritt behandlingsvalg (FBV)' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      99 = 'Annet' ;
	   	  
   value $EPISODEFAG
	 '' = 'Manglende registrering'  
     '010' = 'Generell kirurgi'  
     '020' = 'Barnekirurgi (under 15 år)'  
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
     '140' = 'Fordøyelsessykdommer'  
     '150' = 'Hjertesykdommer'  
     '160' = 'Infeksjonssykdommer'  
     '170' = 'Lungesykdommer'  
     '180' = 'Nyresykdommer'  
     '190' = 'Revmatiske sykdommer (revmatologi)'  
     '200' = 'Kvinnesykdommer og elektiv fødselshjelp'  
     '210' = 'Anestesiologi'  
     '220' = 'Barnesykdommer'  
     '230' = 'Fysikalsk medisin og (re) habilitering'  
     '231' = 'Rehabilitering'  /* Utgått før NPR-melding 53.1.1 - 2017 */
     '232' = 'Habilitering'   /* Utgått før NPR-melding 53.1.1 - 2017 */
     '233' = 'Habilitering barn og unge'  
     '234' = 'Habilitering voksne'  
     '240' = 'Hud og veneriske sykdommer'  
     '250' = 'Nevrologi'  
     '260' = 'Klinisk nevrofysiologi'  
	 '270' = 'Ukjent fagområde, brukes i 2013 og 2014' /* Finner ikke kodeverdi i NPR-meldig eller på volven.no */
	 '280' = 'Ukjent fagområde, brukes i 2013 og 2014' /* Finner ikke kodeverdi i NPR-meldig eller på volven.no */
     '290' = 'Øre-nese-hals sykdommer'  
     '300' = 'Øyesykdommer'  
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
     '851' = 'Nukleærmedisin'  
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
      13 = 'Ugyldig kode - Intermediærenhet/forsterket sykehjem'  /* Ikke i NPR-melding 53.1.1 */
      14 = 'Ugyldig kode - Kommunal legevakt'  /* Ikke i NPR-melding 53.1.1 */
      15 = 'Ugyldig kode'  /* Ikke i NPR-melding 53.1.1 */
      16 = 'Ugyldig kode - Distriktspsykiatrisk senter'  /* Ikke i NPR-melding 53.1.1 */
      21 = 'Kommunal akutt døgnenhet (KAD)'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
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
      2 = 'Død ved ankomst'  
      3 = 'Levende født i sykehus' ;
	  
   value INNMATEHAST
      1 = 'Akutt = uten opphold / venting'  
      2 = 'Ikke akutt, men behandling innen 6 timer'  
      3 = 'Venting mellom 6 og 24 timer'  
      4 = 'Planlagt' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
	  5 = 'Tilbakeføring av pasient fra annet sykehus';
	  
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
      13 = 'Ugyldig kode - Intermediærenhet/forsterket sykehjem'  /* Ikke i NPR-melding 53.1.1 */
      14 = 'Ugyldig kode - Kommunal legevakt'  /* Ikke i NPR-melding 53.1.1 */
      15 = 'Ugyldig kode'  /* Ikke i NPR-melding 53.1.1 */
      16 = 'Ugyldig kode - Distriktspsykiatrisk senter'  /* Ikke i NPR-melding 53.1.1 */
      21 = 'Kommunal akutt døgnenhet (KAD)'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
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
      2 = 'Som død'  
      3 = 'Suicid' ;
	  
   value TYPETIDSPUNKT
      1 = 'Tidspunkt for varsling til kommunen om innlagt pasient'  
      2 = 'Tidspunkt for når pasient er utskrivningsklar'  
      3 = 'Tidspunkt for varsel til kommunen om utskrivningsklar pasient'  
      4 = 'Tidspunkt for avmelding av pasient'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      6 = 'Tidspunkt for melding til sykehuset om at kommunen ikke kan ta imot pasient'  
      7 = 'Tidspunkt for melding til sykehuset om at kommunen kan ta imot pasient'  
      12 = 'Tidspunkt for når pasient er overføringsklar' /* Ny tekst i NPR-melding 53.1.1 - 2017 */
	  31 = 'Helfo varslet om fristbrudd' /* Ny kode i NPR-melding 53.1.1 - 2017 */
	  32 = 'Avtale med pasient om at Helfo ikke skal varsles om fristbrudd' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;
  
   value G_OMSORGSNIVA
      1 = 'Innleggelse'  
      2 = 'Poliklinisk kontakt' ;
	  
   value OMSORGSNIVA
      1 = 'Døgnopphold'  
      2 = 'Dagbehandling'  
      3 = 'Poliklinisk konsultasjon/kontakt'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      8 = 'Poliklinisk kontakt for inneliggende pasient - for stråleterapi' /* Ny tekst i NPR-melding 53.1.1 - 2017 (LL har lagt til "for stråleterapi", se volven.no) */ ;
	  
 /*  value OPPHOLDSTYPE - Variabelen er ikke lenger i bruk. Svært få episoder har informasjon om oppholdstype i 2017. 
      1 = 'Heldøgnsopphold'  
      2 = 'Dagopphold' ; */
	  
   value KONTAKTTYPE
      1 = 'Utredning'  
      2 = 'Behandling'  
      3 = 'Kontroll'  
      5 = 'Indirekte pasientkontakt'  
      12 = 'Pasientadministrert behandling'  
      13 = 'Opplæring' ;
	  
   value STEDAKTIVITET
      1 = 'På egen helseinstitusjon'  
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
      6 = 'Miljøterapi'  
      7 = 'Nettverksterapi'  
      8 = 'Fysisk trening' ;
	  
   value POLINDIR
      1 = 'Erklæring/uttalelse/melding'  
      2 = 'Møte. Samarbeid (om pasient) med annet helsepersonell'  
	 22 = 'Samarbeidsmøte (om pasient) med førstelinjetjenesten' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	 23 = 'Samarbeidsmøte (om pasient) med annen tjeneste' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  3 = 'Aktivitetsgruppe'  
      5 = 'Brev'  
      6 = 'e-post'  
      7 = 'Telefon'  
	 71 = 'Telefonmøte (om pasient) med førstelinjetjenesten' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
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
     3 = 'Sekundær' ;
	 
   value HDG /* Hentet fra ISF-regleverket 2017 */
      1 = 'Sykdommer i nervesystemet'  
      2 = 'Øyesykdommer'  
      3 = 'Øre-, nese- og halssykdommer'  
      4 = 'Sykdommer i åndedrettsorganene'  
      5 = 'Sykdommer i sirkulasjonsorganene'  
      6 = 'Sykdommer i fordøyelsesorganene'  
      7 = 'Sykdommer i lever, galleveier og bukspyttkjertel'  
      8 = 'Sykdommer i muskel-, skjelettsystemet og bindevev'  
      9 = 'Sykdommer i hud og underhud'  
      10 = 'Indresekretoriske-, ernærings- og stoffskiftesykdommer'  
      11 = 'Nyre- og urinveissykdommer'  
      12 = 'Sykdommer i mannlige kjønnsorganer'  
      13 = 'Sykdommer i kvinnelige kjønnsorganer'  
      14 = 'Sykdommer under svangerskap, fødsel og barseltid'  
      15 = 'Nyfødte med tilstander som har oppstått i perinatalperioden'  
      16 = 'Sykdommer i blod, bloddannende organer og immunapparat'  
      17 = 'Myeloproliferative sykdommer og lite differensierte svulster'  
      18 = 'Infeksiøse og parasittære sykdommer'  
      19 = 'Psykiske lidelser og rusproblemer'  
      21 = 'Skade, forgiftninger og toksiske effekter av medikamenter/andre stoffer, medikamentmisbruk og organiske sinnslidelser fremkalt av disse'  
      22 = 'Forbrenninger'  
      23 = 'Faktorer som påvirker helsetilstand - andre kontakter med helsetjenesten'
      24 = 'Signifikant multitraume'
      30 = 'Sykdommer i bryst'  
      40 = 'Kategorier på tvers av flere hoveddiagnosegrupper'  
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
      12 = 'Bioingeniør'  
      13 = 'Ergoterapeut'  
      14 = 'Fysioterapeut'  
      15 = 'Klinisk ernæringsfysiolog'  
      16 = 'Radiograf'  
      17 = 'Tannlege' 
	  18 = 'Ortoptist' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  19 = 'Ortopediingeniør' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  20 = 'Farmasøyt' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  21 = 'Fotterapeut' /* Ny kode i NPR-melding 53.1.1 - 2017 */ ;
   
   value GYLDIG /* Ikke oppgitt i utlevering 2018 */
      0 = ' ' /* Gjelder kun NCRP i 2017. Fikk vite betydningen fra Marte Kjelvik i NPR. */ 
      1 = 'Gyldig'  
      8 = 'Utgått - må oppdateres'  
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
      8 = 'Polikl stråleterapi'  
      9 = 'Dialyse 0 lgd' ;
	  
   value AKTIVITETSKATEGORI2F
      1 = 'Innlagt'  
      2 = 'Poliklinisk konsultasjon' ;
	  
   value AKTIVITETSKATEGORI3F
      1 = 'Døgnopphold'  
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
     '1520' = 'Ørsta'  
     '0620' = 'Hol'  
     '1620' = 'Frøya'  
     '0720' = 'Stokke'  
     '1820' = 'Alstahaug'  
     '1920' = 'Lavangen'  
     '2030' = 'Sør-Varanger'  
     '1130' = 'Strand'  
     '0230' = 'Lørenskog'  
     '0430' = 'Stor-Elvdal'  
     '1430' = 'Gaular'  
     '1630' = 'Åfjord'  
     '0830' = 'Nissedal'  
     '0540' = 'Sør-Aurdal'  
     '1640' = 'Røros'  
     '1740' = 'Namsskogan'  
     '1840' = 'Saltdal'  
     '0940' = 'Valle'  
     '1940' = 'Kåfjord'  
     '1750' = 'Vikna'  
     '1850' = 'Tysfjord'  
     '1160' = 'Vindafjord'  
     '1260' = 'Radøy'  
     '1560' = 'Tingvoll'  
     '1860' = 'Vestvågøy'  
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
     '0901' = 'Risør'  
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
     '1711' = 'Meråker'  
     '0811' = 'Siljan'  
     '1811' = 'Bindal'  
     '0911' = 'Gjerstad'  
     '1911' = 'Kvæfjord'  
     '1021' = 'Marnardal'  
     '2021' = 'Karasjok'  
     '0121' = 'Rømskog'  
     '1121' = 'Time'  
     '2121' = 'Bjørnøya'  
     '0221' = 'Aurskog-Høland'  
     '1221' = 'Stord'  
     '1421' = 'Aurland'  
     '0521' = 'Øyer'  
     '0621' = 'Sigdal'  
     '1621' = 'Ørland'  
     '1721' = 'Verdal'  
     '0821' = 'Bø'  
     '2131' = 'Hopen'  
     '0231' = 'Skedsmo'  
     '1231' = 'Ullensvang'  
     '1431' = 'Jølster'  
     '1531' = 'Sula'  
     '0631' = 'Flesberg'  
     '0831' = 'Fyresdal'  
     '1931' = 'Lenvik'  
     '1141' = 'Finnøy'  
     '1241' = 'Fusa'  
     '0441' = 'Os'  
     '1441' = 'Selje'  
     '0541' = 'Etnedal'  
     '1841' = 'Fauske'  
     '0941' = 'Bykle'  
     '1941' = 'Skjervøy'  
     '1151' = 'Utsira'  
     '1251' = 'Vaksdal'  
     '1551' = 'Eide'  
     '1751' = 'Nærøy'  
     '1851' = 'Lødingen'  
     '1571' = 'Halsa'  
     '1871' = 'Andøy'  
     '1002' = 'Mandal'  
     '2002' = 'Vardø'  
     '1102' = 'Sandnes'  
     '0402' = 'Kongsvinger'  
     '0502' = 'Gjøvik'  
     '1502' = 'Molde'  
     '0602' = 'Drammen'  
     '0702' = 'Holmestrand'  
     '1702' = 'Steinkjer'  
     '1902' = 'Tromsø'  
     '2012' = 'Alta'  
     '1112' = 'Lund'  
     '0412' = 'Ringsaker'  
     '1412' = 'Solund'  
     '0512' = 'Lesja'  
     '0612' = 'Hole'  
     '1612' = 'Hemne'  
     '1812' = 'Sømna'  
     '0912' = 'Vegårshei'  
     '2022' = 'Lebesby'  
     '0122' = 'Trøgstad'  
     '1122' = 'Gjesdal'  
     '1222' = 'Fitjar'  
     '1422' = 'Lærdal'  
     '0522' = 'Gausdal'  
     '0622' = 'Krødsherad'  
     '1622' = 'Agdenes'  
     '0722' = 'Nøtterøy'  
     '0822' = 'Sauherad'  
     '1822' = 'Leirfjord'  
     '1922' = 'Bardu'  
     '1032' = 'Lyngdal'  
     '1232' = 'Eidfjord'  
     '0432' = 'Rendalen'  
     '1432' = 'Førde'  
     '0532' = 'Jevnaker'  
     '1532' = 'Giske'  
     '0632' = 'Rollag'  
     '1632' = 'Roan'  
     '1832' = 'Hemnes'  
     '1142' = 'Rennesøy'  
     '1242' = 'Samnanger'  
     '0542' = 'Nord-Aurdal'  
     '1742' = 'Grong'  
     '1942' = 'Nordreisa'  
     '1252' = 'Modalen'  
     '1852' = 'Tjeldsund'  
     '1662' = 'Klæbu'  
     '1003' = 'Farsund'  
     '2003' = 'Vadsø'  
     '1103' = 'Stavanger'  
     '0403' = 'Hamar'  
     '1703' = 'Namsos'  
     '1903' = 'Harstad'  
     '0213' = 'Ski'  
     '1413' = 'Hyllestad'  
     '0513' = 'Skjåk'  
     '1613' = 'Snillfjord'  
     '0713' = 'Sande'  
     '1813' = 'Brønnøy'  
     '1913' = 'Skånland'  
     '2023' = 'Gamvik'  
     '0123' = 'Spydeberg'  
     '1223' = 'Tysnes'  
     '0423' = 'Grue'  
     '1523' = 'Ørskog'  
     '0623' = 'Modum'  
     '0723' = 'Tjøme'  
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
     '1743' = 'Høylandet'  
     '1943' = 'Kvænangen'  
     '1253' = 'Osterøy'  
     '1653' = 'Melhus'  
     '1853' = 'Evenes'  
     '1263' = 'Lindås'  
     '1563' = 'Sunndal'  
     '1663' = 'Malvik'  
     '1573' = 'Smøla'  
     '1004' = 'Flekkefjord'  
     '2004' = 'Hammerfest'  
     '0104' = 'Moss'  
     '1504' = 'Ålesund'  
     '0604' = 'Kongsberg'  
     '0704' = 'Tønsberg'  
     '1804' = 'Bodø'  
     '0904' = 'Grimstad'  
     '1014' = 'Vennesla'  
     '2014' = 'Loppa'  
     '1114' = 'Bjerkreim'  
     '0214' = 'Ås'  
     '0514' = 'Lom'  
     '1514' = 'Sande'  
     '0714' = 'Hof'  
     '1714' = 'Stjørdal'  
     '0814' = 'Bamble'  
     '0914' = 'Tvedestrand'  
     '2024' = 'Berlevåg'  
     '0124' = 'Askim'  
     '1124' = 'Sola'  
     '1224' = 'Kvinnherad'  
     '1424' = 'Årdal'  
     '1524' = 'Norddal'  
     '0624' = 'Øvre Eiker'  
     '1624' = 'Rissa'  
     '1724' = 'Verran'  
     '1824' = 'Vefsn'  
     '1924' = 'Målselv'  
     '1034' = 'Hægebostad'  
     '1134' = 'Suldal'  
     '0234' = 'Gjerdrum'  
     '1234' = 'Granvin'  
     '0434' = 'Engerdal'  
     '0534' = 'Gran'  
     '1534' = 'Haram'  
     '1634' = 'Oppdal'  
     '0834' = 'Vinje'  
     '1834' = 'Lurøy'  
     '1144' = 'Kvitsøy'  
     '1244' = 'Austevoll'  
     '1444' = 'Hornindal'  
     '0544' = 'Øystre Slidre'  
     '1644' = 'Holtålen'  
     '1744' = 'Overhalla'  
     '1554' = 'Averøy'  
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
     '0415' = 'Løten'  
     '0515' = 'Vågå'  
     '1515' = 'Herøy'  
     '0615' = 'Flå'  
     '0815' = 'Kragerø'  
     '1815' = 'Vega'  
     '1915' = 'Bjarkøy'  
     '2025' = 'Tana'  
     '0125' = 'Eidsberg'  
     '0425' = 'Åsnes'  
     '1525' = 'Stranda'  
     '0625' = 'Nedre Eiker'  
     '1725' = 'Namdalseid'  
     '1825' = 'Grane'  
     '1925' = 'Sørreisa'  
     '0135' = 'Råde'  
     '1135' = 'Sauda'  
     '0235' = 'Ullensaker'  
     '1235' = 'Voss'  
     '1535' = 'Vestnes'  
     '1635' = 'Rennebu'  
     '1835' = 'Træna'  
     '0935' = 'Iveland'  
     '1145' = 'Bokn'  
     '1245' = 'Sund'  
     '1445' = 'Gloppen'  
     '0545' = 'Vang'  
     '1545' = 'Midsund'  
     '1845' = 'Sørfold'  
     '1755' = 'Leka'  
     '1265' = 'Fedje'  
     '1665' = 'Tydal'  
     '1865' = 'Vågan'  
     '0106' = 'Fredrikstad'  
     '1106' = 'Haugesund'  
     '0706' = 'Sandefjord'  
     '0806' = 'Skien'  
     '0906' = 'Arendal'  
     '0216' = 'Nesodden'  
     '1216' = 'Sveio'  
     '1416' = 'Høyanger'  
     '0516' = 'Nord-Fron'  
     '1516' = 'Ulstein'  
     '0616' = 'Nes'  
     '0716' = 'Re'  
     '1816' = 'Vevelstad'  
     '1026' = 'Åseral'  
     '0226' = 'Sørum'  
     '0426' = 'Våler'  
     '1426' = 'Luster'  
     '1526' = 'Stordal'  
     '0626' = 'Lier'  
     '0826' = 'Tinn'  
     '1826' = 'Hattfjelldal'  
     '0926' = 'Lillesand'  
     '1926' = 'Dyrøy'  
     '0136' = 'Rygge'  
     '0236' = 'Nes'  
     '0436' = 'Tolga'  
     '0536' = 'Søndre Land'  
     '1636' = 'Meldal'  
     '1736' = 'Snåsa'  
     '1836' = 'Rødøy'  
     '1936' = 'Karlsøy'  
     '1046' = 'Sirdal'  
     '1146' = 'Tysvær'  
     '1246' = 'Fjell'  
     '1546' = 'Sandøy'  
     '1256' = 'Meland'  
     '1756' = 'Inderøy'  
     '1856' = 'Røst'  
     '1266' = 'Masfjorden'  
     '1566' = 'Surnadal'  
     '1866' = 'Hadsel'  
     '1576' = 'Aure'  
     '0807' = 'Notodden'  
     '1017' = 'Songdalen'  
     '2017' = 'Kvalsund'  
     '0217' = 'Oppegård'  
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
     '0627' = 'Røyken'  
     '1627' = 'Bjugn'  
     '0827' = 'Hjartdal'  
     '1827' = 'Dønna'  
     '1927' = 'Tranøy'  
     '1037' = 'Kvinesdal'  
     '0137' = 'Våler'  
     '0237' = 'Eidsvoll'  
     '0437' = 'Tynset'  
     '1837' = 'Meløy'  
     '0937' = 'Evje og Hornnes'  
     '1247' = 'Askøy'  
     '1547' = 'Aukra'  
     '1557' = 'Gjemnes'  
     '1657' = 'Skaun'  
     '1857' = 'Værøy'  
     '1567' = 'Rindal'  
     '1867' = 'Bø'  
     '1018' = 'Søgne'  
     '2018' = 'Måsøy'  
     '0118' = 'Aremark'  
     '0418' = 'Nord-Odal'  
     '1418' = 'Balestrand'  
     '0618' = 'Hemsedal'  
     '1718' = 'Leksvik'  
     '1818' = 'Herøy'  
     '2028' = 'Båtsfjord'  
     '0128' = 'Rakkestad'  
     '0228' = 'Rælingen'  
     '1228' = 'Odda'  
     '0428' = 'Trysil'  
     '1428' = 'Askvoll'  
     '0528' = 'Østre Toten'  
     '1528' = 'Sykkylven'  
     '0628' = 'Hurum'  
     '0728' = 'Lardal'  
     '0828' = 'Seljord'  
     '1828' = 'Nesna'  
     '0928' = 'Birkenes'  
     '1928' = 'Torsken'  
     '0138' = 'Hobøl'  
     '0238' = 'Nannestad'  
     '1238' = 'Kvam'  
     '0438' = 'Alvdal'  
     '1438' = 'Bremanger'  
     '0538' = 'Nordre Land'  
     '1638' = 'Orkdal'  
     '1738' = 'Lierne'  
     '1838' = 'Gildeskål'  
     '0938' = 'Bygland'  
     '1938' = 'Lyngen'  
     '1548' = 'Fræna'  
     '1648' = 'Midtre Gauldal'  
     '1748' = 'Fosnes'  
     '1848' = 'Steigen'  
     '1868' = 'Øksnes'  
     '0709' = 'Larvik'  
     '2019' = 'Nordkapp'  
     '0119' = 'Marker'  
     '1119' = 'Hå'  
     '0219' = 'Bærum'  
     '1219' = 'Bømlo'  
     '0419' = 'Sør-Odal'  
     '1419' = 'Leikanger'  
     '0519' = 'Sør-Fron'  
     '1519' = 'Volda'  
     '0619' = 'Ål'  
     '0719' = 'Andebu'  
     '1719' = 'Levanger'  
     '0819' = 'Nome'  
     '0919' = 'Froland'  
     '1919' = 'Gratangen'  
     '1029' = 'Lindesnes'  
     '1129' = 'Forsand'  
     '0229' = 'Enebakk'  
     '0429' = 'Åmot'  
     '1429' = 'Fjaler'  
     '0529' = 'Vestre Toten'  
     '1529' = 'Skodje'  
     '1729' = 'Inderøy'  
     '0829' = 'Kviteseid'  
     '0929' = 'Åmli'  
     '1929' = 'Berg'  
     '0239' = 'Hurdal'  
     '0439' = 'Folldal'  
     '1439' = 'Vågsøy'  
     '1539' = 'Rauma'  
     '1739' = 'Røyrvik'  
     '1839' = 'Beiarn'  
     '1939' = 'Storfjord'  
     '1149' = 'Karmøy'  
     '1449' = 'Stryn'  
     '1749' = 'Flatanger'  
     '1849' = 'Hamarøy'  
     '1259' = 'Øygarden'  
     '1859' = 'Flakstad'  
     '9999' = 'Ukjent kommunenummer' ;
  
value pakkeforlop
1 = 'Ja'
2 = 'Nei';

value ICD_KAP /* Sjekket mot og oppdatert basert på ICD-10 versjon 2017 på ehelse.no */
      1 = 'Kapittel I Visse infeksjonssykdommer og parasittsykdommer (A00-B99)'  
      2 = 'Kapittel II Svulster (C00-D48)'  
      3 = 'Kapittel III Sykdommer i blod og bloddannende organer og visse tilstander som angår immunsystemet (D50-D89)'  
      4 = 'Kapittel IV Endokrine sykdommer, ernæringssykdommer og metabolske forstyrrelse (E00-E90)'  
      5 = 'Kapittel V Psykiske lidelser og atferdsforstyrrelser (F00-F99)'  
      6 = 'Kapittel VI Sykdommer i nervesystemet (G00-G99)'  
      7 = 'Kapittel VII Sykdommer i øyet og øyets omgivelser (H00-H59)'  
      8 = 'Kapittel VIII Sykdommer i øre og ørebensknute (processus mastoideus) (H60-H95)'  
      9 = 'Kapittel IX Sykdommer i sirkulasjonssystemet (I00-I99)'  
      10 = 'Kapittel X Sykdommer i åndedrettssystemet (J00-J99)'  
      11 = 'Kapittel XI Sykdommer i fordøyelsessystemet (K00-K93)'  
      12 = 'Kapittel XII Sykdommer i hud og underhud (L00-L99)'  
      13 = 'Kapittel XIII Sykdommer i muskel-skjelettsystemet og bindevev (M00-M99)'  
      14 = 'Kapittel XIV Sykdommer i urin- og kjønnsorganer (N00-N99)'  
      15 = 'Kapittel XV Svangerskap, fødsel og barseltid (O00-O99)'  
      16 = 'Kapittel XVI Visse tilstander som oppstår i perinatalperioden (P00-P96)'  
      17 = 'Kapittel XVII Medfødte misdannelser, deformiteter og kromosomavvik (Q00-Q99)'  
      18 = 'Kapittel XVIII Symptomer, tegn, unormale kliniske funn og laboratoriefunn,IKAS (R00-R99)'  
      19 = 'Kapittel XIX Skader, forgiftninger og visse andre konsekvenser av ytre årsaker (S00-T98)'  
      20 = 'Kapittel XX Ytre årsaker til sykdommer, skader og dødsfall (V0n-Y98)'  
      21 = 'Kapittel XXI Faktorer som har betydning for helsetilstand og kontakt med helsetjenesten (Z00-Z99)' ;

run;
