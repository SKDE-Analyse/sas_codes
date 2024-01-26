%macro standard_rate(dataspecifier,
   region=bohf, /* BoHf, BoRHF eller BoShHN. BoHf er default */
   min_age=auto, /* Laveste alder i utvalget, 0 er default */
   max_age=auto, /* Høyeste alder i utvalget, 105 er default */
   out=,
   age_group_size=5,
   ratemult=1000, /* Ratemultiplikator, dvs rate pr, 1000 er default */
   std_year=auto, /* Standardiseringsår */
   min_year=auto, /* Startår */
   max_year=auto,  /* Sluttår */
   standardize_by=ka,
   population_data=innbygg.INNB_SKDE_BYDEL
);

/*!

Dette er en makro for å beregne standardiserte rater.

Justeringen gjøres basert på følgende formel (Adaptert fra forklaringen i [Eldrehelseatlaset fra 2017](https://www.skde.no/helseatlas/files/eldrehelseatlas_rapport.pdf#page=25)):

![img](/sas_codes/bilder/standard_rate_formel.png)

I formelen ovenfor refererer b til et geografisk område; b står for boområde. g står for en spesifikk kjønn og/eller aldersgruppe, og G er antall grupper.
b<sub>hg</sub> referer til anntall hendelser i gruppen g i boområde b (h for hendelser); b<sub>pg</sub> refererer til antall innbyggere (p for populasjon)
i gruppen g i boområdet b. Med andre ord, b<sub>hg</sub>/b<sub>pg</sub> er en rate som sier noe om hvor mange hendelser det er per person i boområdet b, i
gruppen g. Hvis vi med hendelser mener konsultasjoner, og det er omtrent like mange konsultasjoner som det er innbyggere, vil denne raten bli rundt 1. a<sub>g</sub>
refererer til hvor mange prosent gruppen g utgjør av den nasjonale populasjonen.

En ting som er verdt å notere seg er at a<sub>g</sub> refererer til populasjonen i standardiseringsåret (std_year=); b<sub>pg</sub> på sin side refererer til
populasjonen i boområdet i det året hendelsene skjedde. Intensjonen med å gjøre det slikt er at man skal kunne sammenligne over tid.

*/
options minoperator;

%include "&filbane/makroer/assert_member.sas";
%include "&filbane/makroer/expand_varlist.sas";
%include "&filbane/makroer/boomraader.sas";

%let region = %lowcase(&region);                 %assert_member(region, bohf borhf boshhn)
%let standardize_by = %lowcase(&standardize_by); %assert_member(standardize_by, a ak k ka)

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
  value age_group_fmt %do i=0 %to 105/&age_group_size;
     %eval(&i+1) = "%eval(&i*&age_group_size)-%eval(&i*&age_group_size + &age_group_size - 1) år"
  %end;;
run;

%let std_numvars = %sysfunc(countw(&std_varlist));
%put &=std_numvars; /* Number of arguments the user wants to standardize */

data deleteme_rateutvalg;
   set &std_dataset;
   where (%scan(&std_varlist, 1) %do i=2 %to %sysfunc(countw(&std_varlist)); or %scan(&std_varlist, &i) %end;) and
         aar in (&min_year:&max_year) and
         alder in (&min_age:&max_age) and             
         &region in (1:%if &region=bohf   %then 31;
                 %else %if &region=borhf  %then 4;
                 %else %if &region=boshhn %then 11;);
   /* This data step filters out all the rows we are not interested in. This often means a considerable reduction in
      the quantity of data, so that the rest of the code runs fast. age*/

   keep alder ermann age_group aar &region &std_varlist;
   format &region &region._fmt. age_group age_group_fmt.;

   age_group = floor(alder/&age_group_size) +1;
run;

/* The code below aggregates the data, not only for each region and year, but also for each region for
   all the years (aar=9999), and also for the whole country (&region=8888) */
proc sql;
create table deleteme_summed_vars_ as
	select aar, &region, &sql_grouping %do i=1 %to %sysfunc(countw(&std_varlist));
      , sum(%scan(&std_varlist, &i)) as %scan(&std_varlist, &i)
   %end;
	from deleteme_rateutvalg
	group by aar, &region, &sql_grouping
   union all
   select 9999 as aar, &region, &sql_grouping %do i=1 %to %sysfunc(countw(&std_varlist));
      , sum(%scan(&std_varlist, &i)) / (&max_year-&min_year+1) as %scan(&std_varlist, &i)
   %end;
   from deleteme_rateutvalg
   group by &region, &sql_grouping;

create table deleteme_summed_vars as
   select * from deleteme_summed_vars_
   union all
   select aar, 8888 as &region, &sql_grouping %do i=1 %to %sysfunc(countw(&std_varlist));
      , sum(%scan(&std_varlist, &i)) as %scan(&std_varlist, &i)
   %end;
   from deleteme_summed_vars_
	group by aar, &sql_grouping;
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
   select a.aar, a.&region, sum(a.population) as innbyggere
   %do i=1 %to %sysfunc(countw(&std_varlist));
      %let var = %scan(&std_varlist, &i);
      , sum(&var) as &var._antall
      , sum(&var) / sum(a.population) * &ratemult as &var._crude
      , sum(&var / a.population * c.andel_av_innbyggere) * &ratemult as &var._rate format=16.2
   %end;
   from deleteme_pop_in_region as a
   left join deleteme_summed_vars as b
      on a.&region=b.&region and a.aar=b.aar and %join_on(a, b)
   left join deleteme_pop_in_norway as c
      on %join_on(a, c)
   group by a.aar, a.&region;
run;

proc sort data=deleteme_ratedata out=deleteme_sorted;
  by &region aar;
run;

data &out;
   /*
      At this point in the program the rates are already calculated. This datastep is merely transposing the data so
      that the output is structured in a way so that it can be used directly with %graf(). It is possible that this
      code could be improved by using `proc transpose` with the `by` statement, but I didn't figure out how to do it
      in an elegant way.
   */
   %let snitt_vars = ;
   %do i=1 %to %sysfunc(countw(&std_varlist));
      %let var = %scan(&std_varlist, &i);
      %let snitt_vars = &snitt_vars
             &var._ratesnitt &var._rate&min_year-&var._rate&max_year
             &var._antsnitt &var._ant&min_year-&var._ant&max_year
             &var._crudesnitt &var._crude&min_year-&var._crude&max_year;
   %end;
   retain &region popsnitt pop&min_year-pop&max_year &snitt_vars;
   format &snitt_vars 16.2;

   set deleteme_sorted;
   drop innbyggere aar;
   format &region &region._fmt.;

   array pop{&min_year:&max_year} pop&min_year-pop&max_year;

   if aar ^= 9999 then
      pop{aar} = innbyggere;
   else do;
      popsnitt = innbyggere;

      %do i=1 %to %sysfunc(countw(&std_varlist));
         %let var = %scan(&std_varlist, &i);
         &var._antsnitt = &var._antall;
         &var._ratesnitt = &var._rate;
         &var._crudesnitt = &var._crude;
         drop &var._antall &var._rate &var._crude;
      %end;

      output; /* Since the data is sorted by region and year, we know that all the data for a region has been loaded into the
                 Program Data Vector when aar=9999. That's why we use the output statment at this point. */
   end;

   %do i=1 %to %sysfunc(countw(&std_varlist));
      %let var = %scan(&std_varlist, &i);
      array antall_&var{&min_year:&max_year} &var._ant&min_year-&var._ant&max_year;
      array rate_&var{&min_year:&max_year} &var._rate&min_year-&var._rate&max_year;
      array crude_&var{&min_year:&max_year} &var._crude&min_year-&var._crude&max_year;

      if aar ^= 9999 then do;
         antall_&var{aar} = &var._antall;
         rate_&var{aar}   = &var._rate;
         crude_&var{aar}  = &var._crude;
      end;

   %end;
run;

%mend standard_rate;