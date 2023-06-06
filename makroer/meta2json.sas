%macro meta2json(
  jsonmappe =,
  filnavn =,
  map_value =,
  map_data = "datasett_1",
  map_label = "tmp",
  map_label_en = "tmp",
  format_map = ,
  /**/
  barchart_1 = 1,
  barchart_1_data = "datasett_1",
  x_1 = &map_value,
  xlegend_1 = ,
  xlabel_1 = ,
  xlabel_1_en = &map_label_en,
  y_1 = "bohf",
  ylabel_1 = "Opptaksområder",
  ylabel_1_en = "Referral areas",
  annualvar_1 = 0,
  annualvarlabels_1 =,
  format_1 =,
  /**/
  barchart_2 = 0,
  barchart_2_data = "datasett_1",
  x_2 =,
  xlabel_2 = ,
  xlabel_2_en = &map_label_en,
  xlegend_2 = ,
  xlegend_2_en = &xlegend_2,
  y_2 = "bohf",
  ylabel_2 = "Opptaksområder",
  ylabel_2_en = "Referral areas",
  annualvar_2 = 0,
  annualvarlabels_2 =,
  format_2 =,
  /**/
  barchart_3 = 0,
  barchart_3_data = "datasett_1",
  x_3 =,
  xlabel_3 = ,
  xlabel_3_en = &map_label_en,
  y_3 = "bohf",
  xlegend_3 = ,
  ylabel_3 = "Opptaksområder",
  ylabel_3_en = "Referral areas",
  annualvar_3 = 0,
  annualvarlabels_3 =,
  format_3 =,
    /**/
  barchart_4 = 0,
  barchart_4_data = "datasett_1",
  x_4 =,
  xlabel_4 = ,
  xlabel_4_en = &map_label_en,
  y_4 = "bohf",
  xlegend_4 = ,
  ylabel_4 = "Opptaksområder",
  ylabel_4_en = "Referral areas",
  annualvar_4 = 0,
  annualvarlabels_4 =,
  format_4 =,
  /**/
  linechart_1 = 0,
  linechart_1_x = ,
  linechart_1_y = ,
  linechart_1_label = ,
  linechart_1_data = ,
  linechart_1_ylabel = ,
  linechart_1_ylabel_en = ,
  linechart_1_xlabel = ,
  linechart_1_xlabel_en = ,
  linechart_1_format_x = ,
  linechart_1_format_y = ,
  linechart_2 = 0,
  linechart_2_x = ,
  linechart_2_y = ,
  linechart_2_label = ,
  linechart_2_data = ,
  linechart_2_ylabel = ,
  linechart_2_ylabel_en = ,
  linechart_2_xlabel = ,
  linechart_2_xlabel_en = ,
  linechart_2_format_x = ,
  linechart_2_format_y = ,
  table =,
  table_data = "datasett_1",
  table_caption = "Årlige gjennomsnittsverdier for perioden 2018–2022. Rate pr. 10 000 innbyggere",
  table_caption_en = &table_caption,
  /* jenks */
  clusters = 4,
  breaks = 3,
  datasett_1 =,
  datasett_2 =
);

/*!
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
*/

/*
Definere jenks
*/

%macro jenks(dsnin=, dsnout=, clusters=, breaks=, var=ratesnitt);

  /*!
  Makro for å lage Jenks natural breaks, til bruk i helseatlas-kart.
  
  Bruker SAS-prosedyren [fastclus](https://support.sas.com/documentation/onlinedoc/stat/132/fastclus.pdf). Kjøres som
  ```sas
  jenks(dsnin=<datasett inn>, dsnout=<datasett ut>, clusters=<antall clusters>, breaks=<antall brudd (clusters - 1)>, var=<variabel>);
  ```
  
  Laget av Frank Olsen i forbindelse med Kroniker-atlaset.
  */
  
  /*clusters=breaks+1*/
  data jenks1;
  set &dsnin;
  keep bohf &var;
  where bohf lt 999;  /* Ta ut Norge, som pleier å være 8888 eller lignende */
  run;
  
  proc sort data=jenks1;
  by &var;
  run;
  
  proc fastclus data=jenks1 out=jenks2 maxclusters=&clusters noprint;
     var &var;
  run;
  
  proc sql;
  create table jenks2a as
  select *, 
    (select count(b.cluster) from jenks2 as b
      where b.&var<=a.&var and a.cluster=b.cluster)
    as kluster
  from jenks2 as a
  group by cluster
  order by &var;
  quit;
  
  data jenks2a;
  set jenks2a;
  where kluster=1;
  run;
  
  proc sort data=jenks2a;
  by &var;
  run;
  
  data jenks2a;
  set jenks2a;
  nr=_N_;
  run;
  
  proc sql;
  create table jenks2b as
  select a.bohf,a.&var,b.nr
  from jenks2 as a left join jenks2a as b
  on a.cluster=b.cluster;
  quit;
  
  data jenks2b;
  set jenks2b;
  rename nr=cluster;
  run;
  
  proc sort data=jenks2b;
  by &var;
  run;
  
  proc means data=jenks2b noprint;
  var &var;
  class cluster;
  output out=jenks3 max=max min=min;
  run;
  
  data jenks3;
  set jenks3;
  keep max min cluster;
  where cluster ne .;
  run;
  
  proc sort data=jenks3;
  by descending max;
  run;
  
  data jenks3;
  set jenks3;
  lag_min=lag(min);
  grense=(max+lag_min)/2;
  run;
  
  proc sort data=jenks3;
  by cluster;
  run;
  
  data &dsnout;
  set jenks3;
  where cluster in (1:&breaks);
  format _all_ ;
  run;
  
  proc datasets nolist;
  delete jenks:;
  run;
  
  %mend jenks;

%jenks(dsnin=&datasett_1, dsnout=qwerty_jenks, clusters=&clusters, breaks=&breaks, var=&map_value);

/*
Fjerne formatering på datasettet,
for å ikke få tusenskilletegn etc.
*/
data qwerty;
set &datasett_1;
format _all_ ;
run;

/* Legge på bohf format */
data qwerty;
set qwerty;
format bohf bohf_fmt.;
run;

%if %length(dataset_2) > 0 %then %do;
  data qwerty2;
  set &datasett_2;
  format _all_ ;
  run;

  data qwerty2;
  set qwerty2;
  format bohf bohf_fmt. ermann ermann.;
  run;
%end;

/* Skrive til json */
proc json out="&jsonmappe/&filnavn..json" pretty nosastags FMTNUMERIC;
  write open object;
  write values innhold;
  write open array;
  /* Barchart 1 */
    %if &barchart_1 = 1 %then %do;
    write open object;
      write values "type" "barchart";
      write values "data" &barchart_1_data;
      write values "x";
        write open array;
           write values &x_1;
        write close;
      %if %length(&xlegend_1) > 0 %then %do;
      write values "xLegend";
        write open object;
          write values "nb";
            write open array;
              write values &xlegend_1;
            write close;
          write values "en";
            write open array;
              write values &xlegend_1;
            write close;
        write close;
      %end;
      write values "y" &y_1;
      write values "xLabel";
        write open object;
          write values "nb" &xlabel_1;
          write values "en" &xlabel_1_en;
        write close;
      write values "yLabel";
        write open object;
          write values "nb" &ylabel_1;
          write values "en" &ylabel_1_en;
        write close;
	  %if &annualvar_1 ne 0 %then %do;
      write values "annualVar";
  	    write open array;
          write values &annualvar_1;
        write close;
      write values "annualVarLabels";
        write open object;
          write values "nb";
            write open array;
              write values &annualvarlabels_1;
            write close;
          write values "en";
            write open array;
              write values &annualvarlabels_1;
            write close;
        write close;
	  %end;
    %if %length(&format_1) > 0 %then %do;
      write values "format" &format_1;
    %end;
    write close;
	%end;
  /* Barchart 2 */
    %if &barchart_2 = 1 %then %do;
    write open object;
      write values "type" "barchart";
      write values "data" &barchart_2_data;
      write values "x";
        write open array;
           write values &x_2;
        write close;
      %if %length(&xlegend_2) > 0 %then %do;
      write values "xLegend";
        write open object;
          write values "nb";
            write open array;
              write values &xlegend_2;
            write close;
          write values "en";
            write open array;
              write values &xlegend_2_en;
            write close;
        write close;
      %end;
      write values "y" &y_2;
      write values "xLabel";
        write open object;
          write values "nb" &xlabel_2;
          write values "en" &xlabel_2_en;
        write close;
      write values "yLabel";
        write open object;
          write values "nb" &ylabel_2;
          write values "en" &ylabel_2_en;
        write close;
	  %if &annualvar_2 ne 0 %then %do;
      write values "annualVar";
	    write open array;
          write values &annualvar_2;
        write close;
      write values "annualVarLabels";
        write open object;
          write values "nb";
            write open array;
              write values &annualvarlabels_2;
            write close;
          write values "en";
            write open array;
              write values &annualvarlabels_2;
            write close;
        write close;
	  %end;
    %if %length(&format_2) > 0 %then %do;
      write values "format" &format_2;
    %end;
    write close;
	%end;    
  /* Barchart 3 */
    %if &barchart_3 = 1 %then %do;
    write open object;
      write values "type" "barchart";
      write values "data" &barchart_3_data;
      write values "x";
        write open array;
           write values &x_3;
        write close;
      write values "y" &y_3;
      %if %length(&xlegend_3) > 0 %then %do;
      write values "xLegend";
        write open object;
          write values "nb";
            write open array;
              write values &xlegend_3;
            write close;
          write values "en";
            write open array;
              write values &xlegend_3;
            write close;
        write close;
      %end;
      write values "xLabel";
        write open object;
          write values "nb" &xlabel_3;
          write values "en" &xlabel_3_en;
        write close;
      write values "yLabel";
        write open object;
          write values "nb" &ylabel_3;
          write values "en" &ylabel_3_en;
        write close;
	  %if &annualvar_3 ne 0 %then %do;
      write values "annualVar";
	    write open array;
          write values &annualvar_3;
        write close;
      write values "annualVarLabels";
        write open object;
          write values "nb";
            write open array;
              write values &annualvarlabels_3;
            write close;
          write values "en";
            write open array;
              write values &annualvarlabels_3;
            write close;
        write close;
	  %end;
    %if %length(&format_3) > 0 %then %do;
      write values "format" &format_3;
    %end;
    write close;
	%end;
  /* Barchart 4 */
    %if &barchart_4 = 1 %then %do;
    write open object;
      write values "type" "barchart";
      write values "data" &barchart_4_data;
      write values "x";
        write open array;
           write values &x_4;
        write close;
      write values "y" &y_4;
      %if %length(&xlegend_4) > 0 %then %do;
      write values "xLegend";
        write open object;
          write values "nb";
            write open array;
              write values &xlegend_4;
            write close;
          write values "en";
            write open array;
              write values &xlegend_4;
            write close;
        write close;
      %end;
      write values "xLabel";
        write open object;
          write values "nb" &xlabel_4;
          write values "en" &xlabel_4_en;
        write close;
      write values "yLabel";
        write open object;
          write values "nb" &ylabel_4;
          write values "en" &ylabel_4_en;
        write close;
	  %if &annualvar_4 ne 0 %then %do;
      write values "annualVar";
	    write open array;
          write values &annualvar_4;
        write close;
      write values "annualVarLabels";
        write open object;
          write values "nb";
            write open array;
              write values &annualvarlabels_4;
            write close;
          write values "en";
            write open array;
              write values &annualvarlabels_4;
            write close;
        write close;
	  %end;
    %if %length(&format_4) > 0 %then %do;
      write values "format" &format_4;
    %end;
    write close;
	%end;
  /* Linechart 1 */
  %if &linechart_1 = 1 %then %do;
  write open object;
    write values "type" "linechart";
    write values "data" &linechart_1_data;
    write values "label" &linechart_1_label;
    write values "x";
      write open array;
         write values &linechart_1_x;
      write close;
    write values "y" &linechart_1_y;
    write values "xLabel";
      write open object;
        write values "nb" &linechart_1_xlabel;
        write values "en" &linechart_1_xlabel_en;
      write close;
    write values "yLabel";
      write open object;
        write values "nb" &linechart_1_ylabel;
        write values "en" &linechart_1_ylabel_en;
      write close;
    %if %length(&linechart_1_format_x) > 0 %then %do;
      write values "format_x" &linechart_1_format_x;
    %end;
    %if %length(&linechart_1_format_y) > 0 %then %do;
      write values "format_y" &linechart_1_format_y;
    %end;
  write close;
	%end;
  /* Linechart 2 */
  %if &linechart_2 = 1 %then %do;
  write open object;
    write values "type" "linechart";
    write values "data" &linechart_2_data;
    write values "label" &linechart_2_label;
    write values "x";
      write open array;
         write values &linechart_2_x;
      write close;
    write values "y" &linechart_2_y;
    write values "xLabel";
      write open object;
        write values "nb" &linechart_2_xlabel;
        write values "en" &linechart_2_xlabel_en;
      write close;
    write values "yLabel";
      write open object;
        write values "nb" &linechart_2_ylabel;
        write values "en" &linechart_2_ylabel_en;
      write close;
    %if %length(&linechart_2_format_x) > 0 %then %do;
      write values "format_x" &linechart_2_format_x;
    %end;
    %if %length(&linechart_2_format_y) > 0 %then %do;
      write values "format_y" &linechart_2_format_y;
    %end;
  write close;
	%end;
  /* Tabell */
  %if %length(&table) > 0 %then %do;
    write open object;
      write values "type" "table";
  	  write values "data" &table_data;
      write values "caption";
      write open object;
        write values "nb" &table_caption;
        write values "en" &table_caption_en;
      write close;
  	  write values "columns";
	      write open array;
		      export &table;
        write close;
    write close;
  %end;
  /* Kart */
    write open object;
      write values "type" "map";
  	  write values "data" &map_data;
      write values "x" &map_value;
      write values "caption";
        write open object;
          write values "nb" &map_label;
          write values "en" &map_label_en;
        write close;
      write values "jenks";
        write open array;
          export work.qwerty_jenks;
        write close;
      %if %length(&format_map) > 0 %then %do;
      write values "format" &format_map;
      %end;
      write close;
    /* Selve dataene*/
    write open object;
      write values "type" "data";
      write values "label" "datasett_1";
      write values "national" "Norge";
      write values "description" "Hoveddatasettet for gitt resultatboks";
      write values "data";
        write open array;
          export work.qwerty;
        write close;
      write close;
      /* Ekstradata*/
      %if %length(&datasett_2) > 0 %then %do;
      write open object;
        write values "type" "data";
        write values "label" "datasett_2";
        write values "description" "Ekstradatasettet for gitt resultatboks";
        write values "data";
          write open array;
            export work.qwerty2;
          write close;
      write close;
      %end;
    write close;
  write close;
run;

proc datasets nolist;
delete qwerty:;
run;

%mend;
