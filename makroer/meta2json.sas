%macro meta2json(
  jsonmappe =,
  filnavn =,
  barchart_1 = 0,
  barchart_1_data = "qwerty",
  x_1 = "tmp",
  xlabel_1 = "tmp",
  xlabel_1_en = "tmp",
  y_1 = "tmp",
  ylabel_1 = "tmp",
  ylabel_1_en = "tmp",
  annualvar_1 =,
  annualvarlabels_1 =,
  barchart_2 = 0,
  barchart_2_data = "qwerty",
  x_2 =,
  xlabel_2 =,
  xlabel_1_e2 =,
  y_2 =,
  ylabel_2 =,
  ylabel_1_e2 =,
  annualvar_2 =,
  annualvarlabels_2 =,
  barchart_3 = 0,
  barchart_3_data = "qwerty",
  x_3 =,
  xlabel_3 =,
  xlabel_1_e3 =,
  y_3 =,
  ylabel_3 =,
  ylabel_1_e3 =,
  annualvar_3 =,
  annualvarlabels_3 =,
  table =,
  table_caption =,
  table_caption_en =,
  map_value =,
  jenks =,
  datasett =,
  datasett2 =
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
   data: "qwerty",
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
   data: "qwerty",
   x: ["rate1", "rate2"],
   xLegend: ["Offentlig", "Privat"],
   y: "bohf",
   xLabel: "Antall kontaker per pasient",
   yLabel: "Opptaksområde",
   
},
{
   type: "barchart",
   data: "qwerty",
   x: ["rate1a", "rate2a", "rate3a"],
   xLegend: ["Offentlig", "Privat", "Andre"],
   y="bohf",
   xLabel: "Antall kontaker per pasient",
   yLabel: "Opptaksområde",
},
{
   type: "table",
    data: "qwerty",
    headers: [
      {id: "bohf", label: "Opptaksområde", typeVar: "string"},
      {id: "rateSnitt", label: "Rate", format: ".1f"},
      {},
     ]
 }
 {
    type: "data",
    label: "qwerty",
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
Fjerne formatering på datasettet,
for å ikke få tusenskilletegn etc.
*/
data qwerty;
set &datasett;
format _all_ ;
run;

/* Legge på bohf format */
data qwerty;
set qwerty;
format bohf bohf_fmt.;
run;

%if %length(datasett2) > 0 %then %do;
  data qwerty2;
  set &datasett2;
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
      write values "data" "qwerty";
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
    %if %length(format_1) > 0 %then %do;
      write values "format" &format_1;
    %end;
    write close;
	%end;
    %if &barchart_2 = 1 %then %do;
    write open object;
      write values "type" "barchart";
      write values "data" "qwerty";
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
      write values "data" "qwerty";
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
  	  write values "data" "qwerty";
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
  	  write values "data" "qwerty";
      write values "x" &map_value;
      write values "caption";
        write open object;
          write values "nb" &xlabel_1;
          write values "en" &xlabel_1_en;
        write close;
      write values "jenks";
        write open array;
          export &jenks;
        write close;
    write close;
    write open object; /* Selve dataene*/
      write values "type" "data";
      write values "label" "qwerty";
      write values "national" "Norge";
      write values "description" "Hoveddatasettet for gitt resultatboks";
      write values "data";
        write open array;
          export work.qwerty;
        write close;
      write close;
    write close;
  %if %length(datasett2) > 0 %then %do;
    write open object; /* Ekstradata*/
      write values "type" "data";
      write values "label" "qwerty2";
      write values "description" "Ekstradatasettet for gitt resultatboks";
      write values "data";
        write open array;
          export work.qwerty2;
        write close;
      write close;
    write close;
  %end;
  write close;
run;

proc datasets nolist;
delete qwerty:;
run;

%mend;
