 /* formater til radiologi-data */
 proc format;

 value kontakttype_rad
      1 = '1 Utredning (poliklinikk privat lab/radiologi)'
      2 = '2 Behandling (poliklinikk privat lab/radiologi)'
      3 = '3 Kontroll (poliklinikk privat lab/radiologi)'
      4 = '5 Indirekte pasientkontakt (poliklinikk privat lab/radiologi)'
      5 = '12 Pasientadministrert behandling (poliklinikk privat lab/radiologi)'
      6 = '13 Opplæring (poliklinikk privat lab/radiologi)'
      14 = '14 Screening (poliklinikk privat lab/radiologi)'
      ;
value kontakttype_lege
     1 = 'Enkel kontakt/fremmøte (lege)'
     2 = 'Telefon (lege)'
     3 = 'Konsultasjon (lege)'
     4 = 'Sykebesøk (lege)'
     0 = '0 Ingen kontakt (lege)'
     ;

run;