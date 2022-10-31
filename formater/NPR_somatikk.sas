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
      3 = 'NULL' /*ny 2020*/
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
      13	= 'Folketrygdfinansiert behandling via Helfo for pasienter bosatt i utlandet, men med medlemskap i folketrygden' /* ny 2020*/
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
      51 = 'Regional kurdøgnfinansiering' /*ny 2020*/
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
      5 = 'Indirekte pasientkontakt'  /*Arbeid eller aktivitet knyttet til helsehjelpen som gis til en pasient uten at pasienten deltar.*/
      6 = 'Videokonsultasjon' /*Polikliniske konsultasjoner med pasient gjennomført over video som oppfyller krav i ISF-regelverket for videokonsultasjoner. Midlertidig kode*/
      7 = 'Telefonkonsultasjon' /*Tidl. 'Telefonkonsultasjon med egenandel'. Polikliniske konsultasjoner med pasient gjennomført over telefon som oppfyller krav i ISF-regelverket for telefonkonsultasjoner. Midlertidig kode med egenandel*/
      12 = 'Pasientadministrert behandling'  
      13 = 'Opplæring'
	  14 = 'Screening'
	  99 = 'Annet';
	  
	  
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
      2 = 'Møte. Samarbeid (om pasient) med annet helsepersonell i spesialisthelsetjenesten'  
	 22 = 'Samarbeidsmøte (om pasient) med førstelinjetjenesten' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	 23 = 'Samarbeidsmøte (om pasient) med annen tjeneste' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
	  3 = 'Aktivitetsgruppe'  
      5 = 'Brev'  
      6 = 'e-post'  
      7 = 'Telefon (uten pasientens deltakelse)'  
	 71 = 'Telefonmøte (om pasient) med førstelinjetjenesten' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
      8 = 'Tele-/videokonferanse (uten pasientens deltakelse)'  /* Ny tekst i NPR-melding 53.1.1 - 2017 */
      11 = 'Telemedisin (med pasientens deltakelse)'  
      12 = 'Telefonsamtale med pasient' /*Samtale med pasient. Omfatter kun enkle samtaler som ikke oppfyller kravene til telefonkonsultasjon.*/
      13 = 'Telefonkonsultasjon med egenandel' /*ny 2020, utgår fra 01.01.2021 */
	  17 = 'Videokonsultasjoner' /*Utgår fra 01.01.2021 */
	  18 = 'Videosamtaler ol.'
      21 = 'Teknisk episode (pakkeforløp, innregistrering kvalitetsregistre)' /*Skal brukes dersom det må opprettes en teknisk episode for registrering av prosedyrer Pakkeforløp og innrapportering til kvalitetsregistre*/
	  ;
	  

	








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
	  21 = 'Fotterapeut' /* Ny kode i NPR-melding 53.1.1 - 2017 */ 
     22 = 'Genetiker'   /* ny 2020 */
     23 = 'Logoped'  /* ny 2020 */
     24 = 'Perfusjonist'  /* ny 2020 */
     25 = 'Optiker'  /* ny 2020 */
     26 = 'Audiofysiker'  /* ny 2020 */
     27 = 'Kiropraktor'  /* ny 2020 */
     28 = 'Helsesykepleier'  /* ny 2020 */
     29 = 'Stråleterapeut'  /* ny 2020 */ 
     30 = 'Tannpleier' /* fra 2020 */
     ;
   
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

value individuellplan /* ny 2020 */
      1	 = 'Pasienten oppfyller ikke kriteriene'
      2	 = 'Pasienten har avslått tilbud om IP'
      4	 = 'IP er under arbeid i spesialisthelsethenesten'
      5	 = 'Pasienten har allerede en IP'
      9	 = 'Ukjent med status for individuell plan'
      11	 = 'Pasienten oppfyller kriteriene'
      21	 = 'Pasienten ønsker individuell plan, samtykke foreligger'
      31	 = 'Melding om behov for IP sendt kommunen'
      101 = 'Ja, virksom plan'
      102 = 'Nei, individuell plan er ikke utarbeidet/planprosess ikke igangsatt'
      103 = 'Nei, ønsker ikke individuell plan'
      104 = 'Nei, oppfyller ikke retten til individuell plan'
      105 = 'Melding om behov for individuell plan er sendt kommunen'
      106 = 'Ukjent med status';

value epikriseSamtykke /* ny 2020 */
      1 = 'Ja, samtykke er innhentet'
      2 = 'Pasientens samtykke er ikke påkrevet i dette tilfellet'
      3 = 'Svar på forespørsel e.l. som pasienten har gitt samtykke til'
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
      1	= '1	Østfold'
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
      15	= '15 Møre og Romsdal'
      16	= '16 Sør-Trøndelag'
      17	= '17 Nord-Trøndelag'
      18	= '18 Nordland'
      19	= '19 Troms'
      20	= '20 Finnmark'
      24 = '24 Utlandet/Svalbard'      /* ny 2020*/
      30 = '30 Viken'                  /* ny 2020*/
      34 = '34 Innlandet'              /* ny 2020*/
      38 = '38 Vestfold og Telemark'   /* ny 2020*/
      42 = '42 Agder'                  /* ny 2020*/
      46 = '46 Vestland'               /* ny 2020*/
      50 = '50 Trøndelag'              
      54 = '54 Troms og Finnmark'      /* ny 2020*/
      88	= '88 Ikke spesifisert'
      99	= '99 Utlendinger'
      21	= '21 Svalbard'
      33 = '33 Ikke spesifisert' /* lagt til mars 2022 */
      83 = '83 Ikke spesifisert' /* lagt til mars 2022 */
;

value region /* added 08.04.2021*/
      3 = 'Helse Vest'
      4 = 'Helse Midt-Norge'
      5 = 'Helse Nord'
      6 = 'Utlendinger/annet'
      7 = 'Helse Sør-Øst'
      9 = 'Utlendinger/annet' /* ny 2021 - erstatter #6 */;

value SEKTOR
      1 = 'Somatiske aktivitetsdata'  
      2 = 'VOP'  
      3 = 'TSB'  
      4 = 'Avtalespesialister, psyk' 
      5 = 'Avtalespesialister, som' ;
run;
