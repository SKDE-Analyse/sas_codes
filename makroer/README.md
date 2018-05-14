[![Status](https://travis-ci.org/SKDE-Analyse/sas_makroer.svg?branch=master)](https://travis-ci.org/SKDE-Analyse/sas_makroer/builds)

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

Hvis man vil lage en ny makro, lager man en sas-fil som heter det samme som makroen. Eksempel på makro, som legges i en fil som heter `minNyeMakro.sas`:
```
%macro minNyeMakro(variabel1 = );

/*!
Min dokumentasjon av makroen minNyeMakro

Makroene dokumenteres direkte i koden.
*/

sas-kode...

%mend;
```

Alt som ligger mellom `/*!` og `*/` vil legges på nett [(her)](http://skde-analyse.github.io/sas_makroer/) etter at man har dyttet alt opp til *github*. Med andre ord, man gjør følgende i mappen `\\tos-sas-skde-01\SKDE_SAS\Makroer\master` med *git-bash* etter at man har lagd en makro og dokumentert den (eventuelt endret dokumentasjonen i en makro):
```bash
git status # for å sjekke at alt er som det skal
git diff # for å sjekke litt ekstra nøye
git add <filnavn.sas> # Legg inn filene som skal dyttes opp (her legger vi til filen `filnavn.sas`)
git commit -m 'Min nye fancy makro, med dokumentasjon selvfølgelig' # Skriv en pen commit-beskjed
git pull --rebase # sørg for at du har siste versjon av makroene
git push # dytte opp til github
```
