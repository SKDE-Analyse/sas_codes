# SAS-koder for tilrettelegging av NPR-data


## Kjøre tilretteleggingen

Først må makro-filene inkluderes i prosjektet:

```

%let kodebane = \\hn.helsenord.no\unn-avdelinger\skde.avd\Analyse\Data\SAS\Tilrettelegging\Somatikk\koder\;

%include "&kodebane.Formater.sas";

%include "&kodebane.1_ Macro - Konvertering og stringrydding.sas";
%include "&kodebane.2_ Macro - Bo og behandler.sas";
%include "&kodebane.3_ Macro - ICD10.sas";
%include "&kodebane.4_ Macro - Øvrige avledede variable.sas";
%include "&kodebane.5_ Lage unik ID.sas";
%include "&kodebane.6_ Macro - Labler og formater.sas";
%include "&kodebane.7_ Redusere variabelstørrelser.sas";
%include "&kodebane.8_ Dele datasett.sas";

```

Så inkluderes kjørefilen (da kjøres alle makroene):

```
%include "&kodebane.Kjøring av macroer.sas";
```

