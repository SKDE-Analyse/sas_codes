%macro kodematch(koder, regexes, adjust=yes);
/*!
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

   magetarm = %kodematch(all_diag,
     coeliac := K900
      smerte := R10
                K21[09]
                K5[01]
                K59
   );
run;
```

Variabelen `all_diag` er i dette tilfellet en lang tekst som inneholder alle diagnosekodene for hver rad i utvalget, med et mellomrom
mellom hver diagnosekode. Denne variabelen er det første argumentet til %kodematch.

Det andre variabelen er en rekke små regular expressions som matcher forskjellige kodegrupper; noen av disse har `<navn> :=` foran seg,
noe som betyr at vi vil lage en under-variabel som matcher den kodegruppen som følger etter. I eksempelet ovenfor vil variabelen `magetarm`
bli 1 hvis denne regexen matcher all_diag: `/\b(K900|R10|K21[09]|K5[01]|K59)/`. Makroen vil i tillegg lage to under-variabler, `coeliac` og
`smerte`, og disse variablene vil bare bli 1 hvis deres respektive regex matcher (`R900` for coeliac og `R10` for smerte).

Det er vikig å poengtere at %kodematch matcher i alle tilfeller begynnelsen av en kode; koden i all_diag kan være en lengre, mer detaljert
kode. For eksempel så vil under-variabelen `smerte` ovenfor matche ikke bare R10 (Smerte i buk og bekken), men også R101 (Smerte lokalisert til øvre abdomen).

Når man lager en under-variabel må man sørge for at regexen som etterfulger `:=` ikke har noen mellomrom i seg. Hvis man vil lage en
under-variabel som matcher en litt mer komplisert regex kan man bruke `|` for å skille fra hverandre deler av regexen.

Makroen vil også lage en ekstra variabel for hver under-variabel som unngår dobbelt-telling ved å distribuere verdien 1
på hver av de kodene som matchet. For eksempel, hvis både under-variablene `diagnose_1` og `diagnose_2` matcher, vil %kodematch
lage variablene `diagnose_1_adj` og `diagnose_2_adj` som hver blir lik 0.5. %kodematch vil bare fordele verdien 1 på under-variablene;
hvis regexen in %kodematch inkluderer koder som ikke får en egen under-variabel så vil ikke dette bli tatt med i beregningen.
*/

%let re = ((\S+\s*):=\s*)(\S+);
%let without_equals = %sysfunc(prxchange(s/&re/$3/, -1, &regexes));
%let joined = %sysfunc(prxchange(s/\s+/|/, -1, &without_equals));
%let names = ;
   (prxmatch("/\b(&joined)/", &koder) > 0)

%do %while(%sysfunc(prxmatch(/&re/, &regexes)));
   %let first_name  = %sysfunc(prxchange(s/.*?&re..*/$2/, 1, &regexes));
   %let names = &names &first_name;
   %let first_regex = %sysfunc(prxchange(s/.*?&re..*/$3/, 1, &regexes));

   %put &=first_name;

   ; &first_name = (prxmatch("/\b(&first_regex)/", &koder) > 0)

   %let regexes = %sysfunc(prxchange(s/&re/$3/, 1, &regexes));
%end;

%put &=names;

%let num_names = 0;
%if &names ^= %then %do;
  %let num_names = %sysfunc(countw(&names));
%end;

%if &adjust=yes %then %do;
   %do dist_i=1 %to &num_names;
      %let dist_var = %scan(&names, &dist_i);
      ;  &dist_var._adj = 0;
         if &dist_var > 0 then
           &dist_var._adj = &dist_var / sum(of &names)
   %end;
%end;

%mend kodematch;
