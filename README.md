[![Bygg og distribuer dokumentasjon](https://github.com/SKDE-Analyse/sas_codes/actions/workflows/create_doc.yml/badge.svg)](https://github.com/SKDE-Analyse/sas_codes/actions/workflows/create_doc.yml)
[![Les dokumentasjon](https://img.shields.io/badge/Dokumentasjon--grey.svg)](https://skde-analyse.github.io/sas_codes)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/SKDE-Analyse/sas_codes/blob/main/LICENSE)

# Felles SAS-koder for SKDE

Dette *repository* inneholder felles SAS-koder brukt ved SKDE. Det er de samme kodene som normalt ligger på `Analyse/Data/SAS/felleskoder/main` og andre mapper under `felleskoder`.

## Hva finnes her (lenke for mer informasjon)?

- [Makroer](https://skde-analyse.github.io/sas_codes/makroer_doc)
- [Formater](https://skde-analyse.github.io/sas_codes/formater_doc)
- [Rateprogram](https://skde-analyse.github.io/sas_codes/rateprogram_doc)
- [Kode for tilrettelegging av data fra NPR](https://skde-analyse.github.io/sas_codes/tilrettelegging_doc)
- [Eksempler](https://skde-analyse.github.io/sas_codes/eksempler_doc)
- [Tester](https://skde-analyse.github.io/sas_codes/testing)

## Hvordan bruke disse kodene?

De fleste av kodene bruker makrovariablen `&filbane`, som sier i hvilken mappe disse kodene ligger i. Denne må derfor defineres før kodene kan brukes i et prosjekt:

```sas
%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
```
