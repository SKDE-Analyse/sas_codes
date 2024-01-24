
%macro resolve_dataspecifiers(specifiers, prefix=, out=, keep=, join_with=);
/*!
   This helper macro parses +-delimited dataspecifiers of the form
   `(<library>.)<datasets>/<variables>(/<format-1> ... <format-n>) (+ <dataspecifier>) (#<label-1> ... #<label-n>)`.
   All the variables (and their values) in all the datasets are added to the output table in chronological order, but
   the variables are renamed to `&prefix._<n>`, where `<n>` starts at 1 and increases as new variables are added to the
   output dataset. This ensures that all the columns have unique variable names.

   Both `<datasets>` and `<variables>` are SAS variable lists, and are therefore
   very flexible. If both `<datasets>` and `<variables>` is a variable list of length
   greater than 1, the result is essentially a cartesian product; all combinations
   are added to the output dataset in the most logical order.

   More detailed information on how dataspecifiers work, with many examples, can be found in the dokumentation for [`%graf()`](./graf).
*/

%macro expand_varlist(library, ds, varlist, macrovar);
/*  Denne makroen tar en SAS variabelliste av ukjent form (f. eks. rate: eller rate2020-rate2023),
    og konverteren den til en liste av variabler atskilt med mellomrom. Resultatet lagres i en
    makrovariabel med det navnet som er spesifisert i &macrovar. Eksempel:

       rate2020-rate2023 -> rate2020 rate2021 rate2022 rate2023
       abc23 abc1 abc4   -> abc23 abc1 abc4 (rekkefølgen beholdes, selv om den ikke er kronologisk)

    Etter at variabellisten er konvertert er det lettere å jobbe med den videre.
*/
%global &macrovar;
data DELETEME_FILTER(keep=&varlist); retain &varlist; set &library..&ds (obs=1); run;

proc sql noprint;
   select name
          into :&macrovar separated by ' '
          from dictionary.columns
          where libname="WORK" and memname='DELETEME_FILTER';
quit;
%mend expand_varlist;


%macro parse_dataspecifier(specifier, prefix=, out=, keep=, add_old=);

%let regex = ^((\w+)\.)?([\w: -]*[\w:])\/([\w: -]*[\w:])(\/([\w\d\$. ]+))?$;

%let library    = %sysfunc(prxchange(s/&regex/$2/, 1, &specifier));
%let datasets   = %sysfunc(prxchange(s/&regex/$3/, 1, &specifier));
%let varlist    = %sysfunc(prxchange(s/&regex/$4/, 1, &specifier));
%let formatlist = %sysfunc(prxchange(s/&regex/$6/, 1, &specifier));

%if not %length(&library) %then %do;
   %let library = work;
%end;

proc sql;
create table deleteme_ds_names as
   select distinct memname as memname, memname as name
          from dictionary.columns
          where libname=upcase("&library");
quit;

proc transpose data=deleteme_ds_names out=deleteme_filtered (keep=&datasets);
   id memname;
   var name;
run;

proc transpose data=deleteme_filtered out=deleteme_ds_names_final (keep=_name_ rename=(_name_=name));
  var &datasets;
run;

proc sql noprint;
   select name
          into :expanded_dsnames separated by ' '
          from deleteme_ds_names_final;
quit;

%do i=1 %to %sysfunc(countw(&expanded_dsnames));
   %expand_varlist(&library, %scan(&expanded_dsnames, &i), &varlist,
                   expanded_varlist_&i)
%end;

data &out;
   %if &add_old^= %then
      set &add_old;;

   %do i=1 %to %sysfunc(countw(&expanded_dsnames));
      set &library..%scan(&expanded_dsnames, &i) (rename=(
      %do j=1 %to %sysfunc(countw(&&expanded_varlist_&i));
         /*
            All the variables are here renamed so that in the output dataset (&out),
            the have their own number (&num), which starts at 1 and goes up as more
            variables are added. This number increases chronologically, regardless
            of which dataset the variable originates from. The resulting variable name
            is &prefix._&num.
         */
         %let num = %eval(&total_num + %eval(&j + ((&i -1) * %sysfunc(countw(&&expanded_varlist_&i)))));
         %scan(&&expanded_varlist_&i, &j) =
               &prefix._&num.
      %end; ));
   %end;

   %do i=1 %to %sysfunc(countw(&expanded_dsnames));
      %do j=1 %to %sysfunc(countw(&&expanded_varlist_&i));
         %let num = %eval(&total_num + %eval(&j + ((&i -1) * %sysfunc(countw(&&expanded_varlist_&i)))));
         label &prefix._&num = %scan(&&expanded_varlist_&i, &j);
         /* 
            The logic of this loop is identical to the renaming loop above. This loop
            sets the label of each variable to the original variable name (otherwise the
            name would be lost).
         */
         %if %length(%scan(&formatlist, &num, %str( ))) > 2 %then
            format &prefix._&num %scan(&formatlist, &num, %str( ));;
     %end;
   %end;

   %let total_num = &num;

   keep &keep &prefix._1-&prefix._&num;
run;
%mend parse_dataspecifier;

%let specifiers_without_labels = %scan(&specifiers, 1, #);

%let num_specifiers = %sysfunc(countw(&specifiers_without_labels, +));
%let total_num = 0;

%do specifier=1 %to &num_specifiers;
   %parse_dataspecifier(%scan(&specifiers_without_labels, &specifier, +), prefix=&prefix, keep=&keep,
      out=deleteme_result_&specifier,
	  add_old=%if &specifier > 1 %then deleteme_result_%eval(&specifier - 1);
   )
%end;

data &out;
   %if &join_with^= %then
      set &join_with;;

   set deleteme_result_&num_specifiers end=eof;

   max_&prefix = max(of &prefix._1-&prefix._&total_num);
   min_&prefix = min(of &prefix._1-&prefix._&total_num);

   %do i=1 %to %sysfunc(countw(&specifiers, #)) - 1;
      %if %scan(&specifiers, &i+1, #) ^= . %then
         label &prefix._&i = %scan(&specifiers, &i+1, #);;
   %end;
run;
%mend resolve_dataspecifiers;