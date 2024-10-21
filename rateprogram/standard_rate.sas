%macro standard_rate(dataspecifier,
   region=bohf,
   min_age=auto,
   max_age=auto,
   out=,
   out_vars=rate ant,
   age_group_size=5,
   ratemult=1000,
   std_year=auto,
   min_year=auto,
   max_year=auto,
   standardize_by=ka,
   yearly=rate,
   population_data=innbygg.INNB_SKDE_BYDEL,
   debug = no
);

/*
      Dokumentasjonen til %standard_rate() kan leses her: https://skde-analyse.github.io/sas_codes/standard_rate
*/

/*!

# Makro for kjønns- og/eller aldersstandardisering.

## Argumenter til %standard_rate()
- _første argument_ = `<simple dataspecifier>`. En simplifisert dataspecifier med formen `<dataset>/<variables>`. `<variables>` er her en SAS Variable List, og %standard_rate vil kalkulere en standardisert rate for alle variablene.
- **region** = `[bohf, borhf, boshhn]`. Denne variabelen styrer på hvilket regionalt nivå standardiseringen skal gjøres. Default: bohf.
- **min_age** = `[<number>, auto]`. Laveste alder man skal ha med i standardiseringen. Default: auto.
- **max_age** = `[<number>, auto]`. Høyeste alder man skal ha med i standardiseringen. Default: auto.
- **out** = `<text>`. Navn på utdatasett.
- **out_vars** = `<list>`. Liste over hvilke type variabler som skal med i ut-datasettet. Mulige verdier er rate (justert rate), crude (ujustert rate), ant (sum av variabelen), avg (justert gjennomsnittlig verdi av variabelen), cravg (ujustert gjennomsnitt). Default: rate ant.
- **age_group_size** = `<number>`. Størrelsen på algersgruppene brukt i standariseringen. Default: 5.
- **ratemult** = `<number>`. Ratemultiplikator, dvs. rate pr. Default: 1000.
- **std_year** = `<number>`. Standardiseringsår. Default: auto. (auto betyr at std_year = max_year).
- **min_year** = `<number>`. Første år man skal ha med i standardiseringen. Default: auto.
- **max_year** = `<number>`. Siste år man skal ha med i standardiseringen. Default: auto.
- **standardize_by** = `[ka, a, k]`. Denne variabelen bestemmer hvilken type standardisering som skal utføres. `ka` betyr kjønns- og aldersstandardisering; `a` betyr aldersstandardisering (uten kjønnsjustering); og `k` betyr kjønnsjustering (uten aldersjustering). Default: ka.
- **yearly** = `[no, rate, crude, cravg, avg, ant]`. Hvis denne er satt til noe annet enn `no` vil det lages et transponert datasett (med navnet &out._yearly) hvor kolonnene er opptaksområder, og hver rad viser tall for et år. Dette gjør det lett å lage en tidstrend med %graf(). Default: rate.
- **population_data** = `<text>`. Datasett med informasjon om befolkningstall brukt i standardiseringen. Default: innbygg.INNB_SKDE_BYDEL.

# Introduksjon

Dette er en makro for å beregne standardiserte rater for en eller flere variabler i input-datasettet. Disse variablene blir summert for hver kjønns og/eller aldersgruppe i hvert boområde (noe som betyr at man kan sende inn aggregerte data),
og så justeres verdiene slik at summen av hver av variablene for hvert boområde blir slik de ville vært om demografien (altså kjønnsratioen og alderspyramiden) for boområdet hadde vært identisk med norgespopulasjonen i standardiseringsåret
(std_year=).

For at makroen skal fungere må input-datasettet ha variablene `aar`, `alder`, `ermann`, og en av disse: (`bohf`, `borhf`, `boshhn`).

Utdatasettet er strukturert slik at det er kompatibelt med [`%graf()`](./graf), slik at det er enkelt å representere resultatet visuelt.

# Eksempel

La oss si at vi har et datasett (med navnet `datasett`) som inneholder en rad for hver konsultasjon i spesialisthelsetjenesten, og at dette datasettet
har et par variabler (`prosedyre_1` og `prosedyre_2`) som er satt til `1` hvis denne prosedyren er blitt utført. Hvis vi er interessert i å vite
hvor populær denne prosedyren er i de forskjellige opptaksområdene kan man bruke %standard_rate() til å regne ut kjønns- og aldersjusterte rater slik som dette:

```
%standard_rate(datasett/prosedyre_1 prosedyre_2,
               region=bohf,
               out=prosedyrer
)
```

Resultat vil da bli lagret i datasettet `prosedyrer`, som vil ha rundt 20 rader (en rad for hvert helseforetak, pluss en rad for norge). `prosedyrer` vil inneholder variabler slik som `prosedyre_1_ratesnitt` (kjønns- og aldersjusterte
rate for alle årene), `prosedyre_1_rate2019` (kjønns- og aldersjustert rate for 2019), `prosedyre_1_ant2019` (antall i 2019, uten noen standardisering) og `prosedyre_1_crudesnitt` (ujustert rate for alle årene). Den andre variabelen,
`prosedyre_2`, vil ha ekvivalente variabler i `prosedyrer`.

Utdatasettet `prosedyrer` vil også inneholde variabler slik som `popsnitt`, som sier hvor mange personer som bor i opptaksområdene som er i samme aldersgruppe som utvalget. Med andre ord, hvis datasettet bare inneholder data
for personer fra 75 til 105 år, vil variabelen `pop2022` være antallet i denne aldersgruppen som bor i et opptaksområde i 2022.

%standard_rate() finner automatisk ut av hvilken aldersgruppe som er med i utvalget, og hvilke år som er med. Standard-året blir automatisk satt til det siste året. Alt dette kan overstyres med å bruke variablene `min_age`, `max_age`, `min_year`, `max_year`,
og `std_year`. Det å finne ut hvilke år og hvilken aldersgruppe som er med i datasettet er tidskrevende, og man kan derfor få %standard_rate til å kjøre nesten dobbelt så raskt ved å spesifisere alle disse variablene.

# Kjønns- og/eller aldersstandardisering

Justeringen gjøres basert på følgende formel (adaptert fra forklaringen i [Eldrehelseatlaset fra 2017](https://www.skde.no/helseatlas/files/eldrehelseatlas_rapport.pdf#page=25)):

![img](/sas_codes/bilder/std_rate.png)

I formelen ovenfor refererer b til et geografisk område; b står for boområde. g står for en spesifikk kjønn og/eller aldersgruppe, og G er antall grupper.
sum(V<sub>gb</sub>) er summen av variabelen vi vil finne raten for i gruppen g i boområdet b; b<sub>g</sub> refererer til antall innbyggere
i gruppen g i boområdet b. Med andre ord, sum(V<sub>gb</sub>)/b<sub>g</sub> er en rate som sier noe om hvor mange hendelser det er per person i boområdet b, i
gruppen g. Hvis vi med hendelser mener konsultasjoner, og det er omtrent like mange konsultasjoner som det er innbyggere, vil denne raten bli rundt 1. A<sub>g</sub>
refererer til hvor mange prosent gruppen g utgjør av den nasjonale populasjonen.

En ting som er verdt å notere seg er at A<sub>g</sub> refererer til populasjonen i standardiseringsåret (std_year=); b<sub>g</sub> på sin side refererer til
populasjonen i boområdet i det året hendelsene skjedde. Intensjonen med å gjøre det slikt er at man skal kunne sammenligne over tid.

# KA-justert gjennomsnitt (inklusive KA-justerte andeler)

For å lage en KA-justert andel, og mer generelt en KA-justert gjennomsnittlig verdi, brukes ikke populasjonen i boområdene, men heller fordelingen av observasjonene
på de forskjellige KA-gruppene i input-datasettet (i standardiseringsåret) som basis for standardiseringen. Formelen ser slik ut:

![img](/sas_codes/bilder/std_avg.png)

avg(V<sub>gb</sub>) er den gjennomsnittlige verdien av variabelen for hver KA-gruppe. A<sub>gN</sub> er hvor stor andel av alle observasjonene i input-datasettet som tilhører KA-gruppen g.

KA-justert gjennomsnitt er normalt ikke inkludert i utdatasettet til %standard_rate. For å få den med må man legge til avg i variabelen &out_vars, slik som dette

```
%standard_rate(datasett/prosedyre,
               region=bohf,
               out_vars=rate ant avg cravg,
               out=prosedyrer
)
```

Ovenfor har vi også lagt til cravg, som er det ujusterte gjennomsnittet. Ved å sammenligne avg med cravg kan man se effekten av KA-justeringen, for eksempel slik som dette:

```
%graf(bars=prosedyrer/prosedyre_avgsnitt,
      variation=prosedyrer/prosedyre_avgsnitt prosedyre_cravgsnitt, variation_colors=gray red,
      category=bohf
)
```

*/
options minoperator;

%include "&filbane/makroer/assert.sas";
%include "&filbane/makroer/assert_member.sas";
%include "&filbane/makroer/expand_varlist.sas";
%include "&filbane/makroer/boomraader.sas";
%include "&filbane/rateprogram/graf.sas";

%let region = %lowcase(&region);                 %assert_member(region, bohf borhf boshhn)
%let standardize_by = %lowcase(&standardize_by); %assert_member(standardize_by, a ak k ka)
%let debug = %lowcase(&debug);                   %assert_member(debug, yes no)
%let yearly = %lowcase(&yearly);                 %assert_member(yearly, no rate crude cravg avg ant)
%assert("&out" ^= "", message=No output dataset specified for %nrstr(%%)standard_rate())

%macro parse_simple_dataspecifier(specifier, ds_var=, varlist_var=);
/*
   This is a macro to parse a very simplified version of the dataspecifier used in %graf(). Unlike the dataspecifier in %graf,
   the dataspecifier for %standard_rate only allows one dataset, and there are no formats and no labels.
*/
%global &ds_var &varlist_var;

%let regex = ^((\w+)\.)?(\w*)\/([\w: -]*[\w:])$;
%let library    = %sysfunc(prxchange(s/&regex/$2/, 1, &specifier));
%let dataset    = %sysfunc(prxchange(s/&regex/$3/, 1, &specifier));
%let varlist    = %sysfunc(prxchange(s/&regex/$4/, 1, &specifier));

%if not %length(&library) %then %do; %let library = work; %end;

%expand_varlist(&library, &dataset, &varlist, &varlist_var)

data _null_; call symput("&ds_var", "&library..&dataset"); run;

%mend parse_simple_dataspecifier;


/* Using &sql_grouping in all the sql queries makes it possible to choose whether
   to standardize based on age, sex, or both. */
%let sql_grouping = age_group, ermann;
%if &standardize_by = a %then
   %let sql_grouping = age_group;
%else %if &standardize_by = k %then
   %let sql_grouping = ermann;

%parse_simple_dataspecifier(&dataspecifier, ds_var=std_dataset, varlist_var=std_varlist);
%put &=std_dataset;
%put &=std_varlist;

%if auto in (&min_age &max_age &min_year &max_year) %then %do;
   /* Finding the values of the &min_ &max_ variables automatically is inefficient for large datasets.
      We therefore do it only if we have to. */
   proc sql noprint;
   select min(aar), max(aar), min(alder), max(alder)
      into :auto_min_year, :auto_max_year, :auto_min_age, :auto_max_age
      from &std_dataset;
   quit;
   
   %if &min_age  = auto %then %let min_age  = &auto_min_age;
   %if &max_age  = auto %then %let max_age  = &auto_max_age;
   %if &min_year = auto %then %let min_year = &auto_min_year;
   %if &max_year = auto %then %let max_year = &auto_max_year;
%end;
%if &std_year = auto %then %let std_year = &max_year;

%put &=min_year &=max_year &=std_year &=min_age &=max_age;

proc format;
  value age_group_fmt %do std_i=0 %to 105/&age_group_size;
     %eval(&std_i+1) = "%eval(&std_i*&age_group_size)-%eval(&std_i*&age_group_size + &age_group_size - 1) år"
  %end;;
run;

%let std_numvars = %sysfunc(countw(&std_varlist));
%put &=std_numvars; /* Number of arguments the user wants to standardize */

data deleteme_rateutvalg;
   set &std_dataset;
   where aar in (&min_year:&max_year) and
         alder in (&min_age:&max_age) and             
         &region in (1:%if &region=bohf   %then 31;
                 %else %if &region=borhf  %then 4;
                 %else %if &region=boshhn %then 11;);
   /* This data step filters out all the rows we are not interested in. This often means a considerable reduction in
      the quantity of data, so that the rest of the code runs fast. */

   keep alder ermann age_group aar &region &std_varlist;
   format &region &region._fmt. age_group age_group_fmt.;

   age_group = floor(alder/&age_group_size) +1;
run;

/* The code below aggregates the data, not only for each region and year, but also for each region for
   all the years (aar=9999), and also for the whole country (&region=8888) */
proc sql;
create table deleteme_summed_vars_ as
	select aar, &region, &sql_grouping, count(*) as n_obs %do std_i=1 %to &std_numvars;
      , sum(%scan(&std_varlist, &std_i)) as %scan(&std_varlist, &std_i)
   %end;
	from deleteme_rateutvalg
	group by aar, &region, &sql_grouping
   union all
   select 9999 as aar, &region, &sql_grouping, count(*) / (&max_year-&min_year+1) as n_obs %do std_i=1 %to &std_numvars;
      , sum(%scan(&std_varlist, &std_i)) / (&max_year-&min_year+1) as %scan(&std_varlist, &std_i)
   %end;
   from deleteme_rateutvalg
   group by &region, &sql_grouping;

create table deleteme_summed_vars as
   select * from deleteme_summed_vars_
   union all
   select aar, 8888 as &region, &sql_grouping, sum(n_obs) as n_obs %do std_i=1 %to &std_numvars;
      , sum(%scan(&std_varlist, &std_i)) as %scan(&std_varlist, &std_i)
   %end;
   from deleteme_summed_vars_
	group by aar, &sql_grouping;

create table deleteme_std_avg_sums_ as
   select &sql_grouping, sum(n_obs) as n_obs
   from deleteme_summed_vars_
   where aar = &std_year
   group by &sql_grouping
   %if ermann in (&sql_grouping) %then having ermann is not missing; ;
create table deleteme_std_avg_sums as
   select *, n_obs / sum(n_obs) as avg_av_obs
   from deleteme_std_avg_sums_;
quit;

data deleteme_population;
   /* Here we load in the population data for Norway, and structure it so that it can be joined to deleteme_rateutvalg */
   set &population_data;
   where aar in (&min_year:&max_year) and alder in (&min_age:&max_age);
   format &region &region._fmt. age_group age_group_fmt.;  

   age_group = floor(alder/&age_group_size) +1;
run;
data deleteme_population_copy; set deleteme_population; run;

/* The problem with &population_data is that it only has population data on the commune level; the %boomraader macro tacks
   on the regional information as new variables at the end of the population dataset (without aggregating the data) */
%boomraader(inndata=deleteme_population);

/* We aggregate the population data in the same way as we aggregated deleteme_rateutvalg above. */
proc sql;
create table deleteme_pop_in_region_ as
	select aar, &region, &sql_grouping, sum(innbyggere) as population
	from deleteme_population
	group by aar, &region, &sql_grouping
   union all
   select 9999 as aar, &region, &sql_grouping, sum(innbyggere) / (&max_year-&min_year+1) as population
   from deleteme_population
   group by &region, &sql_grouping;

create table deleteme_pop_in_region as
   select * from deleteme_pop_in_region_
   union all
   select aar, 8888 as &region, &sql_grouping, sum(population) as population
   from deleteme_pop_in_region_
	group by aar, &sql_grouping;
quit;

proc sql;
create table deleteme_pop_in_norway_ as
	select &sql_grouping, sum(innbyggere) as population
	from deleteme_population
	where aar=&std_year
	group by &sql_grouping;
create table deleteme_pop_in_norway as
  select *, sum(population) as norwegian_population, population / calculated norwegian_population as andel_av_innbyggere
  from deleteme_pop_in_norway_
quit;

%macro join_on(first_table, second_table);
   %if %sysfunc(find(&standardize_by, a)) %then &first_table..age_group=&second_table..age_group;
   %if &standardize_by in (ak ka) %then and;
   %if %sysfunc(find(&standardize_by, k)) %then &first_table..ermann=&second_table..ermann;
%mend;

proc sql;
create table deleteme_ratedata as
   select a.&region, a.aar, sum(a.population) as pop
   %do std_i=1 %to &std_numvars;
      %let var = %scan(&std_varlist, &std_i);
      , sum(&var) / sum(b.n_obs) as &var._cravg
      , sum(&var / b.n_obs * d.avg_av_obs) as &var._avg
      , sum(&var) as &var._ant
      , sum(&var) / sum(a.population) * &ratemult as &var._crude
      , sum(&var / a.population * c.andel_av_innbyggere) * &ratemult as &var._rate format=16.2
   %end;
   from deleteme_pop_in_region as a
   left join deleteme_summed_vars as b
      on a.&region=b.&region and a.aar=b.aar and %join_on(a, b)
   left join deleteme_pop_in_norway as c
      on %join_on(a, c)
   left join deleteme_std_avg_sums as d
       on %join_on(a, d)
   group by a.aar, a.&region;
run;

proc sort data=deleteme_ratedata out=deleteme_sorted;
  by &region aar;
  format &region &region._fmt.;
run;

data &out._long;
   /* Keeping only variables in &out_vars */
   set deleteme_sorted;
   keep &region aar pop %do std_i=1 %to &std_numvars;
      %do std_j=1 %to %sysfunc(countw(&out_vars));
         %scan(&std_varlist, &std_i)_%scan(&out_vars, &std_j)
      %end;
   %end;;
run;


data &out;
   /*
      At this point in the program the rates are already calculated. This datastep is merely transposing the data so
      that the output is structured in a way so that it can be used directly with %graf(). It is possible that this
      code could be improved by using `proc transpose` with the `by` statement, but I didn't figure out how to do it
      in an elegant way.
   */
   %let snitt_vars = ;
   %do std_i=1 %to &std_numvars;
      %let var = %scan(&std_varlist, &std_i);
      %let snitt_vars = &snitt_vars
             &var._ratesnitt &var._rate&min_year-&var._rate&max_year
             &var._antsnitt &var._ant&min_year-&var._ant&max_year
             &var._cravgsnitt &var._cravg&min_year-&var._cravg&max_year
             &var._avgsnitt &var._avg&min_year-&var._avg&max_year
             &var._crudesnitt &var._crude&min_year-&var._crude&max_year;
   %end;
   retain &region popsnitt pop&min_year-pop&max_year &snitt_vars;

   format &snitt_vars 16.2;

   set deleteme_sorted;

   array pop_array{&min_year:&max_year} pop&min_year-pop&max_year;

   if aar ^= 9999 then
      pop_array{aar} = pop;
   else do;
      popsnitt = pop;

      %do std_i=1 %to &std_numvars;
         %let var = %scan(&std_varlist, &std_i);
         &var._antsnitt = &var._ant;
         &var._ratesnitt = &var._rate;
         &var._cravgsnitt = &var._cravg;
         &var._avgsnitt = &var._avg;
         &var._crudesnitt = &var._crude;
      %end;

      output; /* Since the data is sorted by region and year, we know that all the data for a region has been loaded into the
                 Program Data Vector when aar=9999. That's why we use the output statment at this point. */
   end;

   %do std_i=1 %to &std_numvars;
      %let var = %scan(&std_varlist, &std_i);
      array ant_&var{&min_year:&max_year} &var._ant&min_year-&var._ant&max_year;
      array rate_&var{&min_year:&max_year} &var._rate&min_year-&var._rate&max_year;
      array cravg_&var{&min_year:&max_year} &var._cravg&min_year-&var._cravg&max_year;
      array avg_&var{&min_year:&max_year} &var._avg&min_year-&var._avg&max_year;
      array crude_&var{&min_year:&max_year} &var._crude&min_year-&var._crude&max_year;

      if aar ^= 9999 then do;
         ant_&var{aar} = &var._ant;
         rate_&var{aar}   = &var._rate;
         cravg_&var{aar}    = &var._cravg;
         avg_&var{aar}  = &var._avg;
         crude_&var{aar}  = &var._crude;
      end;

   %end;
run;


%do std_i=1 %to &std_numvars;
   %let var = %scan(&std_varlist, &std_i);
   title "%nrstr(%%)standard_rate(): Justering av variabelen &var i &std_dataset:";
   %graf(bars=&out/&var._ratesnitt,
         variation=&out/&var._ratesnitt &var._crudesnitt,
         table=&out/&var._ratesnitt &var._crudesnitt #Ratesnitt #Crudesnitt,
         category=&region/&region._fmt.,
         variation_sizes = 6pt 8pt,
         variation_colors = green red,
         variation_symbols = circlefilled diamondfilled,
         width = 750,
         description="Justeringen av variabelen &var, hvor standardize_by=&standardize_by.. Den røde diamanten er hvor &var ville vært hvis man ikke &standardize_by-justerte (crude rate).",
         debug=&debug
   )
%end;
title;

data &out;
   /* This data step is here to remove variables the user is not interested in (i.e., not in &out_vars) */
   set &out;
   keep &region;
   %do std_i=1 %to &std_numvars;
      %let var = %scan(&std_varlist, &std_i);
      %do std_j=1 %to %sysfunc(countw(&out_vars));
         %let out_var = %scan(&out_vars, &std_j);
         keep &var._&out_var.snitt &var._&out_var.&min_year-&var._&out_var.&max_year;;
      %end;
   %end;
   keep popsnitt pop&min_year-pop&max_year;
run;


%if &yearly ^= no %then %do;
   data deleteme_yearly_prep;
      set &out;
      category_label = put(&region, &region._fmt.);
      format bohf 16.;
   run;

   %do std_i=1 %to &std_numvars;
      %let var = %scan(&std_varlist, &std_i);

      proc transpose data=deleteme_yearly_prep out=deleteme_yearly_&std_i prefix=&var._ name=year;
         id &region;
         idlabel category_label;
         var &var._&yearly&min_year-&var._&yearly&max_year;
      run;

      data deleteme_yearly_&std_i;
         set deleteme_yearly_&std_i;
         year = prxchange("s/.*(\d{4})$/$1/", -1, year);
      run;
   %end;

   data &out._yearly;
      %do std_i=1 %to &std_numvars;
         set deleteme_yearly_&std_i;
      %end;
   run;
%end;

%if &debug=no %then %do;
   proc datasets nolist; delete deleteme_: ; run;
%end;

%mend standard_rate;