%macro multippel_test_hjelp;
options nomlogic nomprint;
%put ===========================================================================================;
%put multippel_test Makro - Opprettet 29/3-17 av Frank Olsen;
%put endret 3/5-17 - Frank Olsen;
%put For � teste om noen boomr�ders rater er forskjellige fra den totale raten for alle de aktuelle omr�dene;
%put multippel_test(dsn1=,Nobs=,Ntot=,Gruppe=,rate_pr=,tittel=,gr1=,gr2=,print_log=);
%put Parametre:;
%put 1. dsn1: datasett man utf�rer analysen p� - som regel ett aggregert sett fra Rateprogrammet;
%put 2. Nobs: ratevariabelen - som regel vil det v�re "RateSnitt";
%put 3. Ntot: Teller i raten, som regel vil dette v�re "Innbyggere";
%put 4. Gruppe: Boomr�dene, dvs BOHF, BoShHN, BoRHF osv.;
%put 5. rate_pr: Fra innstillinger i Rateprogrammet, 1000, 10000 eller 100000 f.eks;
%put 6. tittel: Legg gjerne p� tittel (kommer i BOX i tabellen);
%put 7. gr1 og gr2: Dersom du �nsker spesifikk test mellom to omr�der - skriv inn gr1=5 og gr2=7 f.eks;
%put 8. print_log: Settes lik 1 dersom man �nsker resultater fra den logistiske regresjonen;
%put Resultat: tabell med 4 kolonner med p-verdier;
%put Kolonne 1: Boomr�dene;
%put Kolonne 2: R�-verdier: p-verdier for hvert omr�de ifht til totalen uten � justere for multippel testing;
%put Kolonne 3: Bonferroni: p-verdier for hvert omr�de ifht til totalen justert for multippel testing vha Bonferroni (strengeste metode);
%put Kolonne 4: FDR: p-verdier for hvert omr�de ifht til totalen justert for multippel testing vha FDR - False Discovery Rate (vanligste metode);
%put Info om metoden: http://support.sas.com/kb/22/571.html;
%put ===========================================================================================;
%mend multippel_test_hjelp;