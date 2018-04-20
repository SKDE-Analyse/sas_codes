# Bruk av makroene

Makroene ligger her:
```
\\tos-sas-skde-01\SKDE_SAS\Makroer\master
```
For å bruke de i din egen SAS-kode, legges følgende inn i koden:
```
%let filbane=\\tos-sas-skde-01\SKDE_SAS\;
options sasautos=("&filbane.Makroer\master" SASAUTOS);
```

# Lage ny makro

Hvis man vil lage en ny makro, lager man en sas-fil som heter det samme som makroen. Makroene dokumenteres direkte i koden. Eksempel på makro, som legges i en fil som heter `minNyeMakro.sas`:
```
%macro minNyeMakro(variabel1 = );

/*!
Min dokumentasjon av makroen minNyeMakro
*/

sas-kode...

%mend;
```

## Dokumentasjon av makro

Alt som ligger mellom `/*!` og `*/` vil havne [her](http://skde-analyse.github.io/sas_makroer/) hvis man dytter opp til *github*:
```
git status # sjekk hva som er endret
git add <filename> # legg til filer som skal dyttes opp til github 
git commit -m 'my commit message' # Commit det som skal commites
git pull --rebase # Hent ned eventuelle oppdateringer fra github
git push # Dytt opp endringene
```

# Linker til dokumentasjon av de ulike makroene
