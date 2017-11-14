[![Status](https://travis-ci.org/SKDE-Analyse/sas_macroer.svg?branch=master)](https://travis-ci.org/SKDE-Analyse/sas_macroer/builds)

# SAS-makroer utviklet og brukt ved SKDE

Makroene ligger her:
```
\\tos-sas-skde-01\SKDE_SAS\Makroer\master
```
For å bruke de i din egen SAS-kode, legges følgende inn i koden:
```
%let filbane=\\tos-sas-skde-01\SKDE_SAS\;
options sasautos=("&filbane.Makroer\master" SASAUTOS);
```

Hvis man vil lage en ny makro, lager man en sas-fil som heter det samme som makroen. Makroene dokumenteres direkte i koden. Eksempel på makro, som legges i en fil som heter `minNyeMakro.sas`:
```
%macro minNyeMakro(variabel1 = );

/*!
Min dokumentasjon av makroen minNyeMakro
*/

sas-kode...

%mend;
```

Alt som ligger mellom `/*!` og `*/` vil legges på nett [(her)](http://skde-analyse.github.io/sas_macroer/) etter at man har dyttet alt opp til *github*. Med andre ord, man gjør følgende i mappen `\\tos-sas-skde-01\SKDE_SAS\Makroer\master` med *git-bash* etter at man har lagd en makro og dokumentert den (eventuelt endret dokumentasjonen i en makro):
```bash
git status # for å sjekke at alt er som det skal
git diff # for å sjekke litt ekstra nøye
git add <filnavn.sas> # Legg inn filene som skal dyttes opp (her legger vi til filen `filnavn.sas`)
git commit -m 'Min nye fancy makro, med dokumentasjon selvfølgelig' # Skriv en pen commit-beskjed
git pull --rebase # sørg for at du har siste versjon av makroene
git push # dytte opp til github
```

Dokumentasjon kan finnes [her](http://skde-analyse.github.io/sas_macroer/)

