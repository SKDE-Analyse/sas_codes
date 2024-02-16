
%macro resolve_dataspecifiers(specifiers, prefix=, out=, categories=, join_with=);
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

%include "&filbane/makroer/expand_varlist.sas";

%macro remove_all_quotes(string);
   /* Removes all double and single quotation marks in string */
   %sysfunc(prxchange(s/[%str(%'%")]//, -1, %quote(&string)))
%mend remove_all_quotes; /* ' */

%macro parse_dataspecifier(specifier, prefix=, out=, add_old=);

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

%do dataspec_i=1 %to %sysfunc(countw(&expanded_dsnames));
   %expand_varlist(&library, %scan(&expanded_dsnames, &dataspec_i), &varlist,
                   expanded_varlist_&dataspec_i)
%end;
%let dataspec_numvars = %sysfunc(countw(&&expanded_varlist_1));

%macro inner_join_on_categories(datasets_joined, out=);
proc sql noprint;
create table &out as
   select *
   from %scan(&datasets_joined, 1)
   %do dataspec_ds=2 %to %sysfunc(countw(&datasets_joined));
      %let current_ds = %scan(&datasets_joined, &dataspec_ds);
      inner join &current_ds on %do dataspec_catvar=1 %to %sysfunc(countw(&categories));
         %let current_catvar = %scan(&categories, &dataspec_catvar);
         %if &dataspec_catvar > 1 %then and;
            &current_ds..&current_catvar = %scan(&datasets_joined, 1).&current_catvar
      %end;
   %end;
   ;
quit;
%mend inner_join_on_categories;

%do dataspec_i=1 %to %sysfunc(countw(&expanded_dsnames));
   /* Every dataset in the dataspecifier is copied below, and the variables from each dataset are given the corrent number that they
      should have in the output dataset from %resolve_dataspecifiers, as well as the format specified in the dataspecifier. All
      these datasets will afterwords be joined using SQL INNER JOIN to ensure that the category variable is given the correct value from
      each dataset, even if these datasets are ordered differently, or have different lengths, etc.
   */
   data deleteme_dsvars_&dataspec_i ;
      set &library..%scan(&expanded_dsnames, &dataspec_i);

      %do dataspec_j=1 %to &dataspec_numvars;
         %let num = %eval(&total_num + %eval(&dataspec_j + ((&dataspec_i -1) * &dataspec_numvars)));
         %let current_var = %scan(&&expanded_varlist_&dataspec_i, &dataspec_j);

         rename &current_var = &prefix._&num;
         label &current_var  = &current_var;
         %if %length(%scan(&formatlist,  %eval(&num - &total_num), %str( ))) > 2 %then
            format &current_var %scan(&formatlist, %eval(&num - &total_num), %str( ));;
     %end;
     keep &categories &&expanded_varlist_&dataspec_i;
   run;
%end;

%inner_join_on_categories(&add_old %do dataspec_i=1 %to %sysfunc(countw(&expanded_dsnames)); deleteme_dsvars_&dataspec_i %end;,
   out=&out)

%let total_num = &num;

%mend parse_dataspecifier;

%let specifiers_without_labels = %scan(&specifiers, 1, #);

%let num_specifiers = %sysfunc(countw(&specifiers_without_labels, +));
%let total_num = 0; /* This variable keeps track of how many variables have currently been processed for earlier datasets in the dataspecifier,
                       so that the number in the variable names &prefix_<number> is correct, and all the intermediate datasets can be joined together
                       to the &out dataset with no conflict in variable naming.  */

%do specifier=1 %to &num_specifiers;
   %parse_dataspecifier(%scan(&specifiers_without_labels, &specifier, +), prefix=&prefix,
      out=deleteme_result_&specifier,
      add_old=%if &specifier > 1 %then deleteme_result_%eval(&specifier - 1);
   )
%end;

%inner_join_on_categories(&join_with deleteme_result_&num_specifiers, out=&out)

data &out;
   set &out;

   max_&prefix = max(of &prefix._1-&prefix._&total_num);
   min_&prefix = min(of &prefix._1-&prefix._&total_num);

   %do dataspec_i=1 %to %sysfunc(countw(&specifiers, #)) - 1;
      %let var_label = "%remove_all_quotes(%quote(%scan(%quote(&specifiers), &dataspec_i+1, #)))";
      %if &var_label ^= "" %then
         label &prefix._&dataspec_i = &var_label;;
   %end;
run;
%mend resolve_dataspecifiers;