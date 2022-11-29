/*
Formater spesifikke for avtalespesialistfilene. Oppdatert av Linda Leivseth september 2018.

Formater er hentet fra NPR-melding v. 53.1.1 (gylding for rapportering av årsdata 2017), _NAVN-variabler i data, ISF regelverk 2017, SAMDATA og value labels fra tidligere år. 
Det ble ikke gjort en slik detaljert gjennomgang ved fjorårets tilreggelegging av data. Det er derfor usikkert når noen av endringene har funnet sted. Selv om det oppgis at en kode eller at en tekst er 
endret i NPR-melding 53.1.1 (2017) kan endringen ha vært gjort tidligere. 
*/
Proc format;

 value avtSpes
	  1 = 'Hos avtalespesialist';

 value FAG_SKDE
      1 = 'Anestesi'  
      2 = 'Barn'  
      3 = 'Fysmed'  
      4 = 'Gyn'  
      5 = 'Hud'  
      6 = 'Indremed'  
      7 = 'Indremed, Gastro'  
      8 = 'Indremed, generell'  
      9 = 'Indremed, kardiologi'  
      10 = 'Indremed, lunge'  
      11 = 'Kirurgi'  
      12 = 'Kirurgi, generell'  
      13 = 'Kirurgi, ortopedi'  
      14 = 'Kirurgi, urologi'  
      15 = 'Nevrologi'  
      16 = 'Ortopedi'  
      17 = 'Plastkir'  
      18 = 'Radiologi'  
      19 = 'Revma'  
      20 = 'Urologi'  
      21 = 'ØNH'  
      22 = 'Øye'  
      23 = 'Onkologi'  
      24 = 'Indremed, nyre'  
      25 = 'Indremed, endokrinologi'  
      30 = 'Psykiatri'  
      31 = 'Psykologi' ;

value KOMPLETT
      1 = 'All aktivitet'  
      2 = 'All aktivitet men på feil hjemmel'  
      3 = 'Begynt eller sluttet i året'  
      4 = 'Deler av produksjonen'  
      5 = 'Hjemmel men ikke aktivitet hele perioden-ekskl ferie' ;

value KONTAKT
      0 = 'Rapporterte kontakter uten konsultasjonstakst'  
      1 = 'Enkle kontakter'  
      2 = 'Allm.legekonsult./-sykebesøk'  
      3 = 'Kun spesialisterklæring med undersøkelse'  
      4 = 'Spesialistkonsultasjoner'  
      5 = 'Lysbehandling' ;
	 
value $sektor
	 'SOM'='Somatikk';
	 
	 	  
value fag

;

value fagLogg

;


value SEKTOR
      1 = 'Somatiske aktivitetsdata'  
      2 = 'VOP'  
      3 = 'TSB'  
      4 = 'Avtalespesialister, psyk' 
      5 = 'Avtalespesialister, som' ;
run;

