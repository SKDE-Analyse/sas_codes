[![Build Status](https://travis-ci.org/SKDE-Analyse/tilrettelegging.svg?branch=master)](https://travis-ci.org/SKDE-Analyse/tilrettelegging)
[![Dokumentasjon](https://img.shields.io/badge/Dokumentasjon--grey.svg)](https://skde-analyse.github.io/tilrettelegging)

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

