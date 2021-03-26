# Formater

Les inn formater:

```sas
%include "&filbane\formater\SKDE_somatikk.sas";
%include "&filbane\formater\NPR_somatikk.sas";
%include "&filbane\formater\bo.sas";
%include "&filbane\formater\beh.sas";
%include "&filbane\formater\komnr.sas";
```

Dette er kun de vanligste. Flere finnes i mappen `&filbane\formater\`. Makrovariablen `&filbane` må defineres på forhånd
```sas
%let filbane = <sti til kodebasen vår>;
```
