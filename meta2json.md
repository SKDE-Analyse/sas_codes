
# Dokumentasjon for filen *makroer/meta2json.sas*


## Makro `meta2json`

Makro for å lage metadatafil til resultatbokser.

I denne metadatafilen defineres
- Hvilke figurer som skal vises (årsvariasjon, to-delt, tre-delt etc.)
- Labels på aksene og to-,tre-deling
- Hva som skal vises i tabell, inkludert labels
- Natural breaks i kart

Resultatet skal se noe slikt ut:
```json
{"test": [
{
   type: "barchart",
   data: "datasett_1",
   x: ["rateSnitt"],
   y: "bohf",
   xLabel: "Antall kontaker per pasient",
   yLabel: "Opptaksområde",
   annualVar: ["rate2019", "rate2020", "rate2021"],
   annualVarLabels:{["2019", "2020", "2021"]},
   ci: [low, high]
},
{
   type: "barchart",
   data: "datasett_1",
   x: ["rate1", "rate2"],
   xLegend: ["Offentlig", "Privat"],
   y: "bohf",
   xLabel: "Antall kontaker per pasient",
   yLabel: "Opptaksområde",
   
},
{
   type: "barchart",
   data: "datasett_1",
   x: ["rate1a", "rate2a", "rate3a"],
   xLegend: ["Offentlig", "Privat", "Andre"],
   y="bohf",
   xLabel: "Antall kontaker per pasient",
   yLabel: "Opptaksområde",
},
{
   type: "table",
    data: "datasett_1",
    headers: [
      {id: "bohf", label: "Opptaksområde", typeVar: "string"},
      {id: "rateSnitt", label: "Rate", format: ".1f"},
      {},
     ]
 }
 {
    type: "data",
    label: "datasett_1",
    rawdata: [
        {bohf: "Finnmark", rateSnitt: 3.63476, ...},
        {bohf: "UNN", rateSnitt: 3.63476, ...},
    ]
 },
]}
```

Definer variabler slik før makro:

```sas
%let var = totsnitt;
%let jsonmappe = /sas_smb/skde_analyse/helseatlas/<sti til mongts-repo>/mongts/apps/skde/public/helseatlas/data/radiologi;
```

Lage tabell-def:

```sas
data work.table;
  infile datalines dlm='|' dsd;
  length id $25 label_no $50 label_en $50;
  input id $ label_en $ label_no $ typeVar $ format $;
  datalines;
  bohf|Referral areas|Opptaksområder|string|
  totsnitt|Rate|Rate|number|,.0f
  tot_pr_pas|Consultations per patient|Konsultasjoner pr. pas.|number|,.2f
  ;
run;
```

Datasettet heter her rater_&flag:

```sas
%let flag = mr_mod;
%meta2json(
  jsonmappe =&jsonmappe,
  filnavn = &flag,
  datasett_1 = rater_&flag,
  map_value = &var,
  map_label = "Antall per 1 000 innbyggere",
  annualvar_1 = tot2019 tot2020 tot2021 tot2022,
  annualvarlabels_1 = "2019" "2020" "2021" "2022",
  format_1 = ",.0f",
  format_map = ",.0f",
  barchart_2 = 1,
  x_2 = offsnitt privsnitt,
  xlegend_2 = "Offentlig" "Privat",
  table = work.table
);
```
  Makro for å lage Jenks natural breaks, til bruk i helseatlas-kart.
  
  Bruker SAS-prosedyren [fastclus](https://support.sas.com/documentation/onlinedoc/stat/132/fastclus.pdf). Kjøres som
  ```sas
  jenks(dsnin=<datasett inn>, dsnout=<datasett ut>, clusters=<antall clusters>, breaks=<antall brudd (clusters - 1)>, var=<variabel>);
  ```
  
  Laget av Frank Olsen i forbindelse med Kroniker-atlaset.
