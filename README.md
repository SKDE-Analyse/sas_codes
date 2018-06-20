[![Build Status](https://travis-ci.org/SKDE-Analyse/sas_codes.svg?branch=master)](https://travis-ci.org/SKDE-Analyse/sas_codes)
[![Dokumentasjon](https://img.shields.io/badge/Dokumentasjon--grey.svg)](https://skde-analyse.github.io/sas_codes)

En kombinasjon av SAS-kode-repositoriene ved SKDE

## Hvilke repository er med?

Dette er en kombinasjon av følgende (nå utdaterte) repositorer:
- https://github.com/SKDE-Analyse/sas_figurer
- https://github.com/SKDE-Analyse/sas_formater
- https://github.com/SKDE-Analyse/sas_makroer
- https://github.com/SKDE-Analyse/tilrettelegging
- https://github.com/SKDE-Analyse/rateprogram

De har blitt kombinert med [denne fremgangsmåten](https://stackoverflow.com/a/618113):
```
mkdir sas_codes
cd sas_codes
git clone git@github.com:SKDE-Analyse/sas_figurer include
git clone git@github.com:SKDE-Analyse/sas_formater formater
git clone git@github.com:SKDE-Analyse/sas_makroer makroer
git clone git@github.com:SKDE-Analyse/tilrettelegging tilrettelegging
git clone git@github.com:SKDE-Analyse/rateprogram rateprogram

# Do the following for makroer tilrettelegging include formater rateprogram
cd makroer
git filter-branch --index-filter \
    'git ls-files -s | sed "s-\t-&makroer/-" |
     GIT_INDEX_FILE=$GIT_INDEX_FILE.new \
     git update-index --index-info &&
     mv $GIT_INDEX_FILE.new $GIT_INDEX_FILE' HEAD
cd ..


git init

for i in makroer tilrettelegging include formater rateprogram; do
git pull $i --allow-unrelated-histories
rm -rf ${i}/${i}
rm ${i}/.git
done
```

# SAS-makroer utviklet og brukt ved SKDE

## Bruke makroene

Makroene ligger her:
```
\\tos-sas-skde-01\SKDE_SAS\Makroer\master
```
For å bruke de i din egen SAS-kode, legges følgende inn i koden:
```
%let filbane=\\tos-sas-skde-01\SKDE_SAS\;
options sasautos=("&filbane.Makroer\master" SASAUTOS);
```

Dokumentasjon om de ulike makroene finnes [her](http://skde-analyse.github.io/sas_makroer/)

## Lage en ny makro

I korte trekk gjør man følgende

1. Kopier mappen `\\tos-sas-skde-01\SKDE_SAS\Makroer\master` og jobb i den kopierte mappen.
2. Lag en sas-fil som heter det samme som makroen man vil lage.
3. Lag makroen, og dokumenter den.
4. Lag en test
5. Dytt opp til egen `branch` på [github](https://github.com/SKDE-Analyse/sas_makroer) og lag en `pull request` (ev. be [Arnfinn](https://github.com/arnfinn) gjøre det).
6. Oppdater `\\tos-sas-skde-01\SKDE_SAS\Makroer\master` (`git pull --rebase`, ev. be Arnfinn gjøre det) 


### Eksempel på makro

Eksempel på makro, som legges i en fil som heter `minNyeMakro.sas`:
```
%macro minNyeMakro(datasett =, variabel1 = );

/*!
Min dokumentasjon av makroen minNyeMakro

Makroene dokumenteres direkte i koden.
*/

sas-kode...

%mend;
```

### Dokumentering av makroen

Legg inn en forklaring om hva makroen gjør rett under `%macro minNyeMakro;`. Start kommentaren med `/*!` (legg merke til `!` etter `/*`). Alt som ligger mellom `/*!` og `*/` vil legges på nett [(her)](http://skde-analyse.github.io/sas_makroer/) etter at man har dyttet alt opp til *github*.


### Lage en test til makroen

Når man lager en makro burde man også lage en test. Denne kan så kjøres senere for å sjekke at makroen ikke er blitt ødelagt. en enkel test kan se slik ut:
```
%macro minNyeMakro_test(branch = master, debug = 0, lagNyRef = 0, lagNyStart = 0);

%include "\\tos-sas-skde-01\SKDE_SAS\makroer\&branch.\minNyeMakro.sas";

data test;
set skde_tst.minNyeMakro_start;
run;

%minNyeMakro(variabel1 = test);

proc compare base=skde_tst.ref_minNyeMakro compare=test BRIEF WARNING LISTVAR;

%mend;
```
Her kjører man makroen på en kopi av datasettet `skde_tst.minNyeMakro_start` og tester at det er likt datasettet `skde_tst.ref_minNyeMakro`. Disse to datasettene er lagret på server på forhånd. Se i mappen `tests\` for eksempler på bruk av argumentene `branch`, `debug`, `lagNyRef` og `lagNyStart`. 

Legg denne testen i mappen `tests` i filen `minNyeMakro_test.sas`. Legg så inn følgende kode i filen `test_makroer.sas`:
```
%include "&filbane.makroer\&branch.\tests\minNyeMakro_test.sas";
%minNyeMakro_test(branch = &branch, lagNyRef = &lagNyRef, lagNyStart = &lagNyStart);
```


### Dytte makroen opp til [github](https://github.com/SKDE-Analyse/sas_makroer)

Man gjør følgende i mappen `\\tos-sas-skde-01\SKDE_SAS\Makroer\<min_mappe>` med *git-bash* etter at man har lagd en makro og dokumentert den (eventuelt endret dokumentasjonen i en makro):
```bash
git status # for å sjekke at alt er som det skal
git diff # for å sjekke litt ekstra nøye
git checkout -b <branchname> # endre branch (bytt ut `<branchname>` med ønsket navn på branch).
git add <filnavn.sas> # Legg inn filene som skal dyttes opp (her legger vi til filen `filnavn.sas`)
git commit -m 'My new fancy macro, with doc and test' # Skriv en pen commit-beskjed
git push -u origin branchname # Dytt opp til github
```

Gå så inn på [github/branches](https://github.com/SKDE-Analyse/sas_makroer/branches) og trykk på *New pull request* ved siden av din nye branch. Fyll ut og be en kollega se på hva du har gjort (legg inn en *Reviewer*).



# Rateprogrammet

- Beregner kjønns- og aldersjusterte rater for ulike boområder.
- Utviklet av Frank Olsen

## Hvordan bruke rateprogrammet

- Ha oppdatert *automacro*, se [her](http://skde-analyse.github.io/dokumentasjon/sas.html#macroer)
- Åpne et nytt program i SAS, begynn å skriv `rate` og velg `RATEPROGRAM`

![Alt text](bilder/automakro.png)

- Da vil man få inn kode som kan kjøre rateprogrammet. Pr. 29. juni 2017 ser denne [slik ut](RateprogramAuto).

## Hvordan endre rateprogrammet

- [Prosedyrer for utvikling av koden](kode)
- [Prosedyrer for testing av koden](testing)
- [Forslag til endringer av rateprogrammet](endringer)



# SAS-koder for tilrettelegging av NPR-data

## Kjøre tilretteleggingen av NPR-data

Først må makro-filene inkluderes i prosjektet:

```
%let kodebane = \\hn.helsenord.no\unn-avdelinger\skde.avd\Analyse\Data\SAS\Tilrettelegging\saskoder\npr\;

%include "&kodebane.Formater.sas";

%include "&kodebane.1_Macro-Konvertering_og_stringrydding.sas";
%include "&kodebane.2_Macro-Bo_og_behandler.sas";
%include "&kodebane.3_Macro-ICD10.sas";
%include "&kodebane.4_Macro-Ovrige_avledede_variable.sas";
%include "&kodebane.5_Macro-Lage_unik_ID.sas";
%include "&kodebane.6_Macro-Labler_og_formater.sas";
%include "&kodebane.7_Macro-Redusere_variabelstorrelser.sas";
%include "&kodebane.8_Macro-Dele_datasett.sas";
```

Så inkluderes kjørefilen (da kjøres alle makroene):

```
%include "&kodebane.Kjoring_av_macroer.sas";
```

## Kjøre tilrettelegging av innbyggertall fra SSB

Følgende kode ble kjørt for å legge til innbyggertallene 1. januar 2018:
```
%let kodebane = \\hn.helsenord.no\unn-avdelinger\skde.avd\Analyse\Data\SAS\Tilrettelegging\saskoder\ssb\;
%include "&kodebane.lesSSBdata.sas";

%lesSSBdata(aar=2018, utdata = bydel, bydel = 1);

%lesSSBdata(aar=2018, utdata = kommune, bydel = 0);

data innbygg.innb_2004_2017_bydel_allebyer;
set innbygg.innb_2004_2016_bydel_allebyer kommune bydel;
run;
```

Se ellers [SKDE-dokumentasjon](https://skde-analyse.github.io/dokumentasjon/tilrettelegging-av-data.html#tilrettelegging-av-innbyggertall-fra-ssb).


