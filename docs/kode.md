# Utvikling av vår felles sas-kode

I mappen `main` ligger vår stabile versjon av felles sas-kode. Endringer skal helst ikke gjøres direkte her, siden enkelte endringer kan ødelegge for andre. Vi gjør endringer i separate mapper og dytter opp til [github](https://github.com/SKDE-Analyse/sas_codes) for evaluering av medarbeider, før mappen `main` kan oppdateres.

## Prosedyre

Denne prosedyren forutsetter at [git](https://git-scm.com/) er installert på maskinen og at man har gjort noe ala denne dokumentasjonen: <https://skde-analyse.github.io/dokumentasjon/git.html> (hvis man har gjort sistnevnte på `p`-disken, trenger man ikke gjøre det på nytt på ny maskin).

1. Opprett en egen mappe med en ny versjon av SAS-kodene. Kan gjøres ved å klone siste versjon av main fra [github](https://github.com/SKDE-Analyse/sas_codes):

       git clone githubhn:SKDE-Analyse/sas_codes "ny mappe" # "ny mappe" byttes ut med et mappenavn

2. Lag en egen *branch* der utviklingen kan skje uten å påvirke `main`-branchen:

       cd "ny mappe"
       git checkout -b "branch navn"
       git push -u origin "branch navn" # for å "koble" den lokale branchen til ny branch på github

3. Alle endringer kan nå skje i denne mappen, og man kan bruke denne mappen for å kjøre tester etc.
4. Når man føler for det (har utviklet noe nytt) kan man dytte det opp til github for å få andre til å se på dine endringer

       git status # for å se hvilke filer som er endret
       git diff # hvis man vil se hva som er endret
       git add "filnavn" # Legge fil til en commit. Med git add . legger man til alle røde filer
       git status # sjekk at de filene du ville ha med i din commit faktisk er med
       git commit # Nå åpnes et skriveprogram. Man skriver så inn en commit beskjed, lagrer og lukker
       git push # Dytte opp dine endringer til github

5. Man kan nå gå inn på [github](https://github.com/SKDE-Analyse/sas_codes). Forhåpentligvis ligger det informasjon om at man har dyttet opp noe, og det kommer frem en knapp for å lage en `pull request`. Trykk på denne knappen og fyll inn informasjon.  
    - Andre ved SKDE kan nå se på koden og se at det ikke er noen åpenbare feil.
    - De kan så eventuelt godkjenne og trykke på `Squash merge`
    - Hvis de ønsker endringer så kan dette gjøres i samme mappe som tidligere (punkt 3) og så gjenta punkt 4. Nye endringer vil da automatisk bli en del av `pull request`en.
6. Oppdater mappen `main` med nyeste versjon:

       cd ..
       cd main
       git status # Sjekke at ikke noe er endret direkte i denne mappen
       git pull --rebase # dra ned siste oppdateringer fra github
7. Slett branchen (eventuelt slett mappen)

       cd ..
       # rm -rf "ny mappe" # hvis man vil slette mappen og heller lage ny neste gang. Da kan man droppe å gjøre resten.
       cd "ny mappe"
       git checkout main
       git push origin --delete "branch navn"
       git branch -D "branch navn"
