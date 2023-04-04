
# Dokumentasjon for filen *makroer/jenks.sas*


## Makro `jenks`

Makro for å lage Jenks natural breaks, til bruk i helseatlas-kart.

Bruker SAS-prosedyren [fastclus](https://support.sas.com/documentation/onlinedoc/stat/132/fastclus.pdf). Kjøres som
```sas
jenks(dsnin=<datasett inn>, dsnout=<datasett ut>, clusters=<antall clusters>, breaks=<antall brudd (clusters - 1)>, var=<variabel>);
```

Laget av Frank Olsen i forbindelse med Kroniker-atlaset.
