%macro meta2json(
  jsonmappe =,
  filnavn =,
  map_value =,
  map_data = "datasett_1",
  barchart_1 = 1,
  barchart_1_data = "datasett_1",
  x_1 = &map_value,
  xlabel_1 = "tmp",
  xlabel_1_en = "tmp",
  y_1 = "bohf",
  ylabel_1 = "tmp",
  ylabel_1_en = "tmp",
  annualvar_1 = 0,
  annualvarlabels_1 =,
  format_1 =,
  barchart_2 = 0,
  barchart_2_data = "datasett_1",
  x_2 =,
  xlabel_2 =,
  xlabel_1_e2 =,
  y_2 = "bohf",
  ylabel_2 =,
  ylabel_1_e2 =,
  annualvar_2 = 0,
  annualvarlabels_2 =,
  barchart_3 = 0,
  barchart_3_data = "datasett_1",
  x_3 =,
  xlabel_3 =,
  xlabel_1_e3 =,
  y_3 = "bohf",
  ylabel_3 =,
  ylabel_1_e3 =,
  annualvar_3 = 0,
  annualvarlabels_3 =,
  table =,
  table_data = "datasett_1",
  table_caption =,
  table_caption_en =,
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


Definer variabler slik før makro:

%let rbsti = <sti>\<til>\<csv-filer>;
%let filnavn = <filnavn uten .csv-endelse>;

%let barchart_1 = 1;
%let x_1 = rateSnitt;
%let y_1 = bohf;
%let xlabel_1 = "Antall per 1 000 innbyggere";
%let ylabel_1 = "Opptaksområder";
%let annualvar_1 = rate2019 rate2020 rate2021;
%let annualvarlabels_1 = "2019" "2020" "2021";


%let barchart_2 = 1;
%let x_2 = "spes_rate" "overlapp_rate" "prim_rate";
%let xlegend_2 = "Spesialist" "Overlapp" "Primær";
%let y_2 = bohf;
%let xlabel_2 = "Antall per 1 000 innbyggere";
%let ylabel_2 = "Opptaksområder";
%let annualvar_2 = 0;

%let barchart_3 = 0;

* lage datasett som brukes til å definere hva som skal vises i tabell;
data work.table;
infile datalines dlm='|' dsd;
length id $25 label_no $50 label_en $50;
input id $ label $ typeVar $ format $;
datalines;
bohf|Opptaksområder|string|
rateSnitt|Pasientrate, alle pasienter|number|,.1f
pas_rate_barn|Pasientrate, barn|number|,.1f
pas_rate_eldre|Pasientrate, eldre|number|,.1f
andel3_prim|Andel pasienter kun i primærhelsetj.|number|,.1f
pasienter|Antall pasienter|number|,.0f
;
run;

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
  format bohf bohf_fmt.;
  run;
%end;

proc json out="&jsonmappe/&filnavn..json" pretty nosastags FMTNUMERIC;
  write open object;
  write values innhold;
  write open array;
    %if &barchart_1 = 1 %then %do;
    write open object;
      write values "type" "barchart";
      write values "data" &barchart_1_data;
      write values "x";
        write open array;
           write values &x_1;
        write close;
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
    %if &barchart_2 = 1 %then %do;
    write open object;
      write values "type" "barchart";
      write values "data" &barchart_2_data;
      write values "x";
        write open array;
           write values &x_2;
        write close;
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
    write close;
	%end;
    %if &barchart_3 = 1 %then %do;
    write open object;
      write values "type" "barchart";
      write values "data" &barchart_3_data;
      write values "x";
        write open array;
           write values &x_3;
        write close;
      write values "y" &y_3;
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
    write close;
	%end;
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
    write open object;
      write values "type" "map";
  	  write values "data" &map_data;
      write values "x" &map_value;
      write values "caption";
        write open object;
          write values "nb" &xlabel_1;
          write values "en" &xlabel_1_en;
        write close;
      write values "jenks";
        write open array;
          export work.qwerty_jenks;
        write close;
    write close;
    write open object; /* Selve dataene*/
      write values "type" "data";
      write values "label" "datasett_1";
      write values "national" "Norge";
      write values "description" "Hoveddatasettet for gitt resultatboks";
      write values "data";
        write open array;
          export work.qwerty;
        write close;
      write close;
      %if %length(&datasett_2) > 0 %then %do;
      write open object; /* Ekstradata*/
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
