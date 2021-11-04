Proc format;

 value tjenestetype
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

 value kodeverk
      1 = 'ICPC-2'
      2 = 'ICPC-2B'
      3 = 'ICD-10'
      4 = 'ICD-DA-3'
      5 = 'Akser i BUP-klassifikasjon'
      ;

 value kontakttype
      1 = 'Annet'
      2 = 'Enkel kontakt'
      3 = 'Konsultasjon'
      4 = 'Sykebesøk'
      5 = 'Tverrfaglig samarbeid'
      6 = 'Administrativt arbeid'
      0 = 'Ukjent'
      ;
 value erHdiag
     1 = "Ja"
     0 = "Nei"
     ;
 /* value $fritakskode
      'A' = ''
      'B' = ''
      'C' = ''
      'D' = ''
      'E' = ''
      'F' = ''
      'H' = ''
      'I' = ''
      'J' = ''
      'K' = ''
      'M' = ''
      'P' = ''
      'R' = ''
      'S' = ''
      'U' = ''
      'W' = ''
      'Y' = ''

      ; */
run;

