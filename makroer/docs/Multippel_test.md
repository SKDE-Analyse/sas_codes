[Ta meg tilbake.](./)

# Multippel_test

multippel_test Makro - Opprettet 29/3-17 av Frank Olsen
endret 3/5-17 - Frank Olsen
For å teste om noen boområders rater er forskjellige fra den totale raten for alle de aktuelle områdene
multippel_test(dsn1=,Nobs=,Ntot=,Gruppe=,rate_pr=,tittel=,gr1=,gr2=,print_log=)
Parametre:
1. dsn1: datasett man utfører analysen på - som regel ett aggregert sett fra Rateprogrammet
2. Nobs: ratevariabelen - som regel vil det være "RateSnitt"
3. Ntot: Teller i raten, som regel vil dette være "Innbyggere"
4. Gruppe: Boområdene, dvs BOHF, BoShHN, BoRHF osv.
5. rate_pr: Fra innstillinger i Rateprogrammet, 1000, 10000 eller 100000 f.eks
6. tittel: Legg gjerne på tittel (kommer i BOX i tabellen)
7. gr1 og gr2: Dersom du ønsker spesifikk test mellom to områder - skriv inn gr1=5 og gr2=7 f.eks
8. print_log: Settes lik 1 dersom man ønsker resultater fra den logistiske regresjonen
Resultat: tabell med 4 kolonner med p-verdier
Kolonne 1: Boområdene
Kolonne 2: Rå-verdier: p-verdier for hvert område ifht til totalen uten å justere for multippel testing
Kolonne 3: Bonferroni: p-verdier for hvert område ifht til totalen justert for multippel testing vha Bonferroni (strengeste metode)
Kolonne 4: FDR: p-verdier for hvert område ifht til totalen justert for multippel testing vha FDR - False Discovery Rate (vanligste metode)

[Info om metoden](http://support.sas.com/kb/22/571.html)
