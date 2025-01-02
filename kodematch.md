
# Dokumentasjon for filen *makroer/kodematch.sas*


## Makro `kodematch`

Dette er en makro for å søke etter grupper av diagnose/prosedyre-koder i et data step med regular expressions,
og gi en variabelen en verdi av 1 (hvis det matcher) eller 0 (hvis det ikke matcher). Makroen er skrevet på en
slik måte at man kan skrive regexen på flere linjer; disse vil bli slått sammen til en stor og uleselig regex
(en eller flere mellomrom vil bli erstattet med en `|`, som er regex-karakteren for "enten eller") som blir sent
til prxmatch-funksjonen.

Det er i tillegg mulig å lage under-variabler som bare blir 1 hvis en under-gruppe av regexen matcher.

# Eksempel

Den letteste måten å forklare hvordan %kodematch fungerer er med et eksempel:

```
data mage_tarm;
   set <utvalg>;

   length all_diag $200;
   all_diag = catx(" ", of Hdiag Hdiag2 bdiag:);

   magetarm = %kodematch(all_diag, K900 R10 K21[09] K5[01] K59);
run;
```

Variabelen `all_diag` er i dette tilfellet en lang tekst som inneholder alle diagnosekodene for hver rad i utvalget, med et mellomrom
mellom hver diagnosekode. Denne variabelen er det første argumentet til %kodematch.

Det andre variabelen er en rekke små regular expressions som matcher forskjellige kodegrupper, I eksempelet ovenfor vil variabelen `magetarm`
bli 1 hvis denne regexen matcher all_diag: `/\b(K900|R10|K21[09]|K5[01]|K59)/`.

Dette er et mer avansert eksempel med "undervariabler":

```
data mage_tarm;
   set <utvalg>;

   length all_diag $200;
   all_diag = catx(" ", of Hdiag Hdiag2 bdiag:);

   magetarm = %kodematch(all_diag,
     coeliac := K900
      smerte := R10
                K21[09]
                K5[01]
                K59
   );
run;
```

 Forskjellen er at denne i tillegg vil lage to variabler, `coeliac` og `smerte`, og disse variablene vil bare bli 1 hvis deres respektive
 regex matcher (`R900` for coeliac og `R10` for smerte).

Det er vikig å poengtere at %kodematch matcher i alle tilfeller begynnelsen av en kode; koden i all_diag kan være en lengre, mer detaljert
kode. For eksempel så vil under-variabelen `smerte` ovenfor matche ikke bare R10 (Smerte i buk og bekken), men også R101 (Smerte lokalisert til øvre abdomen).

Når man lager en under-variabel må man sørge for at regexen som etterfulger `:=` ikke har noen mellomrom i seg. Hvis man vil lage en
under-variabel som matcher en litt mer komplisert regex kan man bruke `|` for å skille fra hverandre deler av regexen.

