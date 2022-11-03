# SAS-makroer utviklet og brukt ved SKDE

## Lage en ny makro

I korte trekk gjør man følgende

1. Kopier mappen `felleskoder\main` og jobb i den kopierte mappen.
2. Lag en sas-fil som heter det samme som makroen man vil lage.
3. Lag makroen, og dokumenter den.
4. Lag en test
5. Dytt opp til egen `branch` på [github](https://github.com/SKDE-Analyse/sas_codes) og lag en `pull request`.
6. Oppdater `felleskoder\main` (`git pull --rebase`, ev. be Arnfinn gjøre det)

### Eksempel på makro

Eksempel på makro, som legges i en fil som heter `minNyeMakro.sas`:

```SAS
%macro minNyeMakro(datasett =, variabel1 = );

/*!
Min dokumentasjon av makroen minNyeMakro

Makroene dokumenteres direkte i koden.
*/

sas-kode...

%mend;
```

### Dokumentering av makroen

Legg inn en forklaring om hva makroen gjør rett under `%macro minNyeMakro;`. Start kommentaren med `/*!` (legg merke til `!` etter `/*`). Alt som ligger mellom `/*!` og `*/` vil legges på nett [(her)](http://skde-analyse.github.io/sas_codes/) etter at man har dyttet alt opp til *github*.

### Lage en test til makroen

Når man lager en makro burde man også lage en test. Denne kan så kjøres senere for å sjekke at makroen ikke er blitt ødelagt. en enkel test kan se slik ut:

```SAS
%macro minNyeMakro_test(branch = main, debug = 0, lagNyRef = 0, lagNyStart = 0);

%include "&filbane/makroer/minNyeMakro.sas";

data makronavn1;
set test.minNyeMakro_start;
run;

%minNyeMakro(datasett = makronavn1);

%sammenlignData(fil = makronavn1, lagReferanse = &lagNyRef);

%mend;
```

Her kjører man makroen på en kopi av datasettet `test.minNyeMakro_start` og tester at resultatet `makronavn1` er likt en referanse. Referansedatasettet er lagret som `tests\data\makronavn1.csv`, og ny referanse lages hvis testen kjøres med `lagNyRef ne 0`. Se i mappen `tests\` for eksempler på bruk av argumentene `branch`, `debug`, `lagNyRef` og `lagNyStart`.

Legg denne testen i mappen `tests` i filen `minNyeMakro_test.sas`. Legg så inn følgende kode i filen `tests\tests.sas`:

```SAS
/* Øverst i filen */
%include "&filbane/makroer/tests/minNyeMakro_test.sas";

/* Inne i makroen test*/
%minNyeMakro_test(branch = &branch, lagNyRef = &lag_ny_referanse);
```



### Dytte makroen opp til [github](https://github.com/SKDE-Analyse/sas_codes)

Man gjør følgende i mappen `SKDE_SAS\felleskoder\<min_mappe>\` med *git-bash* etter at man har lagd en makro og dokumentert den (eventuelt endret dokumentasjonen i en makro):

```bash
git status # for å sjekke at alt er som det skal
git diff # for å sjekke litt ekstra nøye
git checkout -b <branchname> # endre branch (bytt ut `<branchname>` med ønsket navn på branch).
git add <filnavn.sas> # Legg inn filene som skal dyttes opp (her legger vi til filen `filnavn.sas`)
git commit -m 'My new fancy macro, with doc and test' # Skriv en pen commit-beskjed
git push -u origin branchname # Dytt opp til github
```

Gå så inn på [github/branches](https://github.com/SKDE-Analyse/sas_codes/branches) og trykk på *New pull request* ved siden av din nye branch. Fyll ut og be en kollega se på hva du har gjort (legg inn en *Reviewer*).
