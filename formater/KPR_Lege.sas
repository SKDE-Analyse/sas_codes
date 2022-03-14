Proc format;

 value tjenestetype_kpr
	 1 = 'Fastlege'
      2 = 'Legevakt'
      3 = 'Fysioterapeut privat'
      4 = 'Fysioterapeut kommunal'
      5 = 'Kiropraktor'
      6 = 'Tannlege'
      7 = 'Kjeveortoped'
      8 = 'Tannpleier'
      9 = 'Helsestasjon'
      10 = 'Logoped'
      11 = 'Ridefysioterapi'
      12 = 'Audiopedagog'
      13 = 'Ortoptist'
      14 = 'Ukjent'
      ;

 value kodeverk_kpr
      1 = 'ICPC-2'
      2 = 'ICPC-2B'
      3 = 'ICD-10'
      4 = 'ICD-DA-3'
      5 = 'Akser i BUP-klassifikasjon'
      ;

 value kontakttype_kpr
      1 = 'Annet'
      2 = 'Enkel kontakt'
      3 = 'Konsultasjon'
      4 = 'Sykebes�k'
      5 = 'Tverrfaglig samarbeid'
      6 = 'Administrativt arbeid'
      0 = 'Ukjent'
      ;

 value erHdiag_kpr
     1 = "Ja"
     0 = "Nei"
     ;

value $icpc2_Kap
     'A' = "Allment og uspesifisert"
     'B' = "Blod, bloddannende organer og immunsystemet "
     'D' = "Ford�yelsessystemet"
     'F' = "�ye"
     'H' = "�re"
     'K' = "Hjerte-karsystemet"
     'L' = "Muskel og skjelettsystemet"
     'N' = "Nervesystemet"
     'P' = "Psykisk"
     'R' = "Luftveier"
     'S' = "Hud"
     'T' = "Endokrine, metabolske og ern�ringsmessige problemer"
     'U' = "Urinveier"
     'W' = "Svangerskap, f�dsel og familieplanlegging"
     'X' = "Kvinnelige kj�nnsorganer"
     'Y' = "Mannlige kj�nnsorganer"
     'Z' = "Sosiale problemer"
     ;

 value icpc2_type
     1 = "Sympt./plager"
     2 = "Diag./sykdom"
     3 = "Prosesskode"
     ;
value $fritakskode
      'A' = 'Smittefarlig sykdom'
      'B' = 'Barn under 16 �r'
      'C' = ''
      'D' = ''
      'E' = ''
      'F' = 'Frikort'
      'G' = 'HIV-infeksjon'
      'H' = 'Pasientens tilstand til hinder for avkreving av egenandel'
      'I' = 'Innsatt i fengel/sikringsanstalt'
      'J' = 'Barn under 18 �r psykoterapeutisk/psykiatrisk behandling'
      'K' = 'Krigsskade'
      'M' = 'Milit�rperson, vernepliktig'
      'N' = 'Fritak ved unders�kelse p� Statens barnehus'
      'O' = 'Opps�kende behandling overfor rusmiddelavhengige'
      'P' = 'Allmennlegetjenester der det gis opps�kende helsehjelp'
      'R' = 'Akutt behandling av vold i n�re relasjoner/seksuelle overgrep'
      'S' = 'Svangerskap'
      'U' = ''
      'W' = 'Veiledning om, innsetting eller fjerning av langtidsvirkende prevensjon til kvinner i fertil alder som f�r behandling i Legemiddelassistert rehabilitering (LAR)'
      'Y' = 'Yrkesskade'
      ; 
run;

