%macro Episode_of_care_hjelp;
options nomlogic nomprint;
%put ================================================================================;
%put Episode_of_care Makro - Opprettet 26.10.2016 av Frank Olsen;
%put Endret 26.10.2016 av Frank Olsen;
%put Endret 29.11.2016 av Arnfinn;
%put NOTE: Inndatasettet m� inneholde inndato utdato inntid og uttid;
%put NOTE: inntid og uttid m� (forel�pig) hentes fra parvus;
%put NOTE: Episode_of_care(dsn=, tidskrav=28800, forste_hastegrad=1, behold_datotid=0, debug=0, nulle_liggedogn=0);
%put NOTE: Parametre:;
%put NOTE: 1. dsn: datasett man utf�rer analysen p�;
%put NOTE: 2. tidskrav (=28800): tidskrav i sekunder (default 28800 er 8 timer) for opphold med tidsdifferanse - m� v�re et tall;
%put NOTE: 3. forste_hastegrad (=1): Hastegrad for f�rste kontakt hvis ulik 0; hvis 0: hastegrad for f�rste d�gnopphold;
%put NOTE: 4. behold_datotid (=0): Hvis ulik 0, ;
%put NOTE: 5. debug (=0): Spytter ut midlertidige datasett hvis forskjellig fra null;
%put NOTE: 6. nulle_liggedogn (=0): Hvis forskjellig fra null, setter antall EoC_liggedogn til null hvis opphold er <8 timer;
%put Episode of care omfatter da:;
%put a. Dersom inndatotid p� nytt opphold er f�r utdatotid p� forrige opphold;
%put b. Dersom nytt opphold er innen x sekunder fra utdatotid p� forrige opphold;
%put Makroen lager 11 (eventuelt 13) nye variabler:;
%put 1.  EoC_nr_pid: Nummererte EoC-opphold pr pid, dersom EoC best�r av flere opphold har disse samme nummer;
%put 2.  EoC_id: Unik ID for hver EoC (pid+EoC_nr_pid);
%put 3.  EoC_Intern_nr: Nummerer oppholdene innenfor hver EoC for hver pid;
%put 4.  EoC_Antall_i_EoC: Antall opphold i EoC;
%put 5.  EoC_inndato: inndato p� f�rste opphold i EoC;
%put 6.  EoC_utdato: utdato p� siste opphold i EoC;
%put (7.  EoC_inndatotid: inntid (dato og tidspunkt) p� f�rste opphold i EoC (hvis behold_datotid ulik 0));
%put (8.  EoC_utdatotid: uttid (dato og tidspunkt) p� siste opphold i EoC (hvis behold_datotid ulik 0));
%put 9.  EoC_aar: �r ved utskriving;
%put 10. EoC_liggetid: tidsdifferanse mellom inndatotid p� det f�rste oppholdet og utdatotid p� det siste oppholdet i EoC;
%put 11. EoC_aktivitetskategori3: 1 hvis ett oppholdene er d�gn, 2 hvis ett av oppholdene er dag, 3 hvis ett av oppholdene er poli;
%put 12. EoC_hastegrad: 1 hvis ett av oppholdene er akutt, 4 ellers;
%put 13. EoC_forste_hastegrad: Hastegrad for f�rste avdelingsopphold. 1 for akutt, 4 for elektiv;
%put ==================================================================================;
%mend;
