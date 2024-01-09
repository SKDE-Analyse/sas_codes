%macro graf(
    bars=,      /* <dataspecifier>. En eller flere variabler det skal lages et søylediagram av */
	lines=,     /* <dataspecifier>. En eller flere variabler det skal lages et linjediagram av */
	table=,     /* <dataspecifier>. En eller flere variabler det skal lages en tabell av */
	variation=, /* <dataspecifier>. En eller flere variabler det skal lages en variasjon av (brukt for å lage årsvariasjon) */
	category=,  /* Kategorivariabelen + valgri formatering av denne etter en "/", Eksempel: bohf/bohf_fmt. */
	description="test", /* En beskrivelse av hva grafen representerer, med eller uten anførselstegn. */
	reverse=false, /* Hvis denne er true reverseres rekkefølgen på kategoriene i grafen. 
	                  Mulige valg: (true, false). Default: false. */
	direction=horizontal, /* Denne variabelen styrer hvilken retning grafen går. Mulige valg: (horizontal, vertical).
	                         Endrer man på denne er det som å vri grafen 90 grader. %graf sørger for at alle dataene
	                         beholder sine relative plasseringer, inklusive tabellen. Default: horizontal. */
	bar_grouping=stack, /* Denne variabelen styrer hvoran %graf() kombinerer dataene når man har flere variabler for
	                       et søylediagram. Dette er valgene: (stack, cluster). Stack stabler variablene oppå hverandre
	                       for å lage et n-delt søylediagram. Cluster på sin side lager en liten søyle for hver variabel 
	                       og plasserer de ved siden av hverandre for hver valgte kategori. I begge tilfeller er det totalsummen
	                       av alle søyle-variablene som definerer rekkefølgen på kategoriene i resultat-grafen. Default: stack. */
	special_categories=8888 7777, /* En liste med nummer som definerer "special categories", dvs kategorier som
	                                 får en grå farge i søylediagrammet - vanlighis er dette norgesgjennomsnittet.
	                                 Default: 8888 7777. */
	save="", /* Hvis man vil lagre filen, setter man her inn fullt navn på den nye filen i anførselstegn.
	            Dette må inkludere hele filbanen, pluss filetternavn (f. eks.: .png eller .pdf).
	            Hvis filetternavnet er .png, lagres bildet som en png fil, også videre. Default: "". */
	source="" /* Kildehenvisning nederst til venstre. Default: "". */,
	logo=none, /* Velg mellom følgende logoer: (skde, hn, none). Default: none. */
	panelby=,  /* Settes til navnet på variablen som brukes med sgpanel for å lage flere små grafer i en og samme graf. Hver
	              lille graf må ha en unik verdi for panelby i datasettet som sendes inn. Hvis man bruker panelby må
	              input-datasettet være ferdig sortert i den rekkefølgen man vil vise dataene. */
	height=500 /* Høyde på grafen, i pixels. Default: 500. */,
	width=700  /* Bredde på grafen, i pixels. Default: 700. */
) / minoperator;

/*!
   One %graf() to rule them all!

   Den viktigste delen av %graf() er de fire variablene bars, lines, table og variation. For alle disse variablene kan
   man sende inn en eller flere variabler, fra ett eller flere datasett/tabeller, fra ett eller flere bibliotek/library.
   %graf() vil da legge sammen disse variablene en etter en, i kronologisk rekkefølge, og lage et n-delt søylediagram
   (hvis man bruker bars=), en tabell med n kolonner (hvis man bruker table=), et linjediagram med n linjer (hvis man
   bruker lines=), eller prikker og linjer for årsvariasjon (hvis man bruker variation=).

   Man kan bruke alle disse 4 graf-typene samtidig, slik at man kan lage et 3-delt søylediagram med en tabell med 2
   kolonner, samt et linjediagram på toppen av alt det, for eksempel. Man kan også spesifisere hvilket format disse variablene
   skal ha, og en label for variablene slik at de får en beskrivelse i output-grafen.

   Bars, lines, table og variation tar alle en <dataspecifier> som input, som defineres slik:

      <dataspecifier>: (<library>.)<datasets>/<variables>(/<format-1> ... <format-n>) (#<label-1> ... #<label-n>) (+ <dataspecifier>)

   Det som er i parentes er valgfritt, så man trenger egentlig bare <datasets>/<variables>. Både <datasets> og <variables> er hva
   SAS kaller for Variable Lists, og er derfor veldig fleksible. Hvis man bare bruker et datasett og en variabel med bars, får man
   et helt enkelt søylediagram:

      %graf(bars=datasett/rate,
            category=bohf/bohf_fmt.
      )

   Hva gjør man hvis man vil lage et todelt søylediagram med to variabler (rate1 og rate2) i datasettet? Det gjør man slik:

      %graf(bars=datasett/rate1 rate2,
            category=bohf/bohf_fmt.
      )

   Man må alltid spesifisere en kategorivariabel (category=) når man bruker %graf(), og denne variabelen må være den samme
   for alle datasett man sender inn i makroen. Man kan også velge å formatere kategorivariabelen; i eksempelet ovenfor er
   kategorivariabelen bohf, og formatet til bohf er "bohf_fmt.".

   Hva hvis man har to forskjellige datasett (datasett1 og datasett2) med samme variabel (rate), og man vil lage et todelt
   søylediagram med de? Det er bare en liten forandring i koden som må til:

      %graf(bars=datasett1 datasett2/rate,
            category=bohf/bohf_fmt.
      )

   I eksempelet ovenfor vil datasett1/rate bli den første søyla, og datasett2 bli den andre. Hvis man har både mer en ett datasett
   og mer enn en variabel, vil alle mulige kombinasjoner av de to listene bli sin egen søyle (i den mest logiske rekkefølgen).

   Hva gjør man hvis man har lyst til å legge til en tabell med 3 kolonner på høyre side? Det er en lett sak:

      %graf(bars=datasett1 datasett2/rate,
            table=datasett3/tabvar1-tabvar3
            category=bohf/bohf_fmt.
      )

   "tabvar1-tabvar3" er en Variable List, så %graf() forstår at man vil ma med de tre variablene tabvar1, tabvar2 og tabvar3. Hva
   hvis vil bruke et format på disse tabellvariablene? Det gjør man slik:

      %graf(bars=datasett1 datasett2/rate,
            table=datasett3/tabvar1-tabvar3/comma10.1 . dollar10.2
            category=bohf/bohf_fmt.
      )

   I eksempelet ovenfor blir tabvar1 formatert med comma10.1, tabvar2 blir uendret siden det bare var et punktum, og tabvar3
   blir formatert med dollar10.2. %graf() leser alle formatene fra venstre til høyre og bruker de på de respektive variablene.
   Det er derfor tabvar2 bare får et punktum i eksempelet; vi er egentlig bare interessert i å formatere tabvar3, så vi bruker
   et punktum for å "hoppe over" tabvar2 uten å endre formatet. Hva hvis vi også har lyst til å gi tabvar2 og tabvar3 (ikke
   tabvar1) en label, altså en kort beskrivelse av kolonnen i tabellen? Det gjør man helt på slutten med å bruke emneknagg (#).
   La oss i samme slengen gi en kort beskrivelse av de to søylene i den todelte grafen:

      %graf(bars=datasett1 datasett2/rate #Offentlig #Privat,
            table=datasett3/tabvar1-tabvar3/comma10.1 . dollar10.2 #. #Uformatert tabellvariabel #"Dette, er tekst"
            category=bohf/bohf_fmt.
      )
   
   Det er to ting som er verdt å notere seg med eksempelet ovenfor:
      1) På samme måte som vi "hoppet over" formatet til tabvar2 med et punktum, "hopper vi over" tabvar1 med å bruke "#.".
         Dette er fordi vi bare har lyst til å gi en label til tabvar2 og tabvar3.
      2) Teksten til tabvar3 inneholder et komma, og må derfor være i anførselstegn.

   Av og til vil det ikke være mulig å bruke en enkelt <dataspecifier> slik som ovenfor. Det man kan gjøre da er simpelten
   å "plusse" sammen flere <dataspecifier>s slik som dette:

      %graf(bars=bib1.datasett1 datasett2/rate1 + bib2.datasett/rate2,
            category=bohf/bohf_fmt.
      )

   Resultatet av det vil være en tredelt graf; den første søyla vil være bib1.datasett1/rate1, den andre søyla bib1.ratesett2/rate1,
   og den tredje søyla bib2.datasett/rate2. Det var nødvendig å "plusse" i dette tilfellet både fordi datasettene kommer fra to ulike
   bibliotek (man kan bare ha ett bibliotek per <dataspecifier>), men også fordi navnene på variablene (rate1 og rate2) er ulike i
   de forskjellige datasettene.
*/


%macro expand_varlist(library, ds, varlist, macrovar);
/*  Denne makroen tar en SAS variabelliste av ukjent form (f. eks. rate: eller rate2020-rate2023),
    og konverteren den til en liste av variabler atskilt med mellomrom. Resultatet lagres i en
    makrovariabel med det navnet som er spesifisert i &macrovar. Eksempel:

       rate2020-rate2023 -> rate2020 rate2021 rate2022 rate2023
       abc23 abc1 abc4   -> abc23 abc1 abc4 (rekkefølgen beholdes, selv om den ikke er kronologisk)

    Etter at variabellisten er konvertert er det lettere å jobbe med den i %sdiagram.
*/
%global &macrovar;
data DELETEME_FILTER(keep=&varlist); retain &varlist; set &library..&ds; run;

proc sql noprint;
   select name
          into :&macrovar separated by ' '
          from dictionary.columns
          where libname="WORK" and memname='DELETEME_FILTER';
quit;
%mend expand_varlist;

%macro remove_quotes(string);
   /* Removes both double and single quotation marks at the beginning and end of the string */
   %sysfunc(prxchange(s/^[%str(%'%")](.*)[%str(%'%")]$/$1/, -1, %quote(&string)))
%mend remove_quotes;


%macro parse_dataspecifier(specifier, prefix=, out=, keep=, add_old=);

%let regex = ^((\w+)\.)?([\w: -]*[\w:])\/([\w: -]*[\w:])(\/([\w\d\$. ]+))?$;

%let library     = %sysfunc(prxchange(s/&regex/$2/, 1, &specifier));
%let datasets    = %sysfunc(prxchange(s/&regex/$3/, 1, &specifier));
%let varlist     = %sysfunc(prxchange(s/&regex/$4/, 1, &specifier));
%let formatlist  = %sysfunc(prxchange(s/&regex/$6/, 1, &specifier));

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
                   expanded_varlist_%scan(&expanded_dsnames, &i))
%end;

data &out;
   %if &add_old^= %then
      set &add_old;;

   %do i=1 %to %sysfunc(countw(&expanded_dsnames));
      %let dataset = %scan(&expanded_dsnames, &i);

      set &library..&dataset (rename=(
      %do j=1 %to %sysfunc(countw(&&expanded_varlist_&dataset));
         /*
            All the variables are here renamed so that in the output dataset (&out),
            the have their own number (&num), which starts at 1 and goes up as more
            variables are added. This number increases chronologically, regardless
            of which dataset the variable originates from. The resulting variable name
            is &prefix._&num.
         */
         %let num = %eval(&total_num + %eval(&j + ((&i -1) * %sysfunc(countw(&&expanded_varlist_&dataset)))));
         %scan(&&expanded_varlist_&dataset, &j) =
               &prefix._&num.
      %end; ));
   %end;

      %do i=1 %to %sysfunc(countw(&expanded_dsnames));
      %let dataset = %scan(&expanded_dsnames, &i);
      %do j=1 %to %sysfunc(countw(&&expanded_varlist_&dataset));
         %let num = %eval(&total_num + %eval(&j + ((&i -1) * %sysfunc(countw(&&expanded_varlist_&dataset)))));
         label &prefix._&num = %scan(&&expanded_varlist_&dataset, &j);
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




%macro parse_dataspecifiers(specifiers, prefix=, out=, keep=, join_with=);
/*
   This helper macro parses +-delimited dataspecifiers of the form
   (<library.>)<datasets>/<variables>. All the variables (and their values)
   in all the datasets are added to the output table in chronological order, but
   the variables are renamed to &prefix._<n>, where <n> starts at 1 and increases
   as new variables are added to the output dataset. This ensures that all the
   columns have unique variable names.

   Both <datasets> and <variables> are SAS variable lists, and are therefore
   very flexible. If both <datasets> and <variables> is a variable list of length
   greater than 1, the result is essentially a cartesian product; all combinations
   are added to the output dataset in the most logical order.
*/
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
%mend parse_dataspecifiers;





%let bar_colors         = CX00509E CX95BDE6 CXe0e0f0 CXA0EDE0 CX80cD3F CXFFED4F CX00FFFF CXFFFF00;
%let special_bar_colors = CX333333 CXBDBDBD CXe0e0e0 CXA0A0A0 CX808080 CXFEFEFE CX0F0F0F CXEEEEEE;
%let circle_symbols     = circlefilled circlefilled circle circle circle;
%let circle_colors      = black grey black charcoal black;
%let circle_sizes       = 4pt 6pt 8pt 9pt 10pt;

%let line_patterns      = solid shortdash mediumdash longdash mediumdashshortdash;
%let line_colors        = CX30F07E CX55BDA6 CX30e010 CXA0EDE0 CX80cD3F;

%let category_regex = (\w+)(\/([\w.\$]+))?;
%let category_format = %sysfunc(prxchange(s/&category_regex/$3/, 1, &category));
%let category = %sysfunc(prxchange(s/&category_regex/$1/, 1, &category));

data graf_annotation;
   length x1space $ 13 y1space $ 13 anchor $ 11 Label $ 25;
   x1space="graphpercent"; y1space="graphpercent";
   y1 = 2;

   %if &logo ^= none %then %do;
      function = "Image"; anchor = "bottomright";
      x1 = 98; width=12;
      image="/sas_smb/skde_analyse/Data/SAS/felleskoder/main/stiler/logo/&logo..png";
      output; /*Logo*/
   %end;

   %if "%remove_quotes(%quote(&source))" ^= "" %then %do;
      function = "text"; anchor = "bottomleft";
      x1 = 1; width=150; textsize = 8;
      label = "%remove_quotes(%quote(&source))";
      output; /*Kilde*/
   %end;
run;

proc datasets nolist; delete deleteme_output; run;

%let graf_types = bars variation table lines;
%do index=1 %to %sysfunc(countw(&graf_types));
   %let type = %scan(&graf_types, &index);
   %if "&&&type" ^= "" %then %do;
      %parse_dataspecifiers(&&&type, prefix=&type, out=deleteme_output, keep=&category &panelby
         %if %sysfunc(exist(deleteme_output)) %then ,join_with=deleteme_output;)

      data deleteme_output;
         set deleteme_output;

         array all_&type.vars [*] &type._: ;
        if _n_ = 1 then do;
            call symput("total_&type.vars", dim(all_&type.vars));
	     end;
      run;
   %end;
%end;

data deleteme_output;
   length group $8;
   drop i;
   set deleteme_output;

   array all_barsvars [*] bars_: ;
   do i=1 to dim(all_barsvars);
	   group = strip(put(i, 8.));

      bar = all_barsvars[i];
      if &category in (&special_categories) then do;
         group = "n" || group;
      end;
	  output;
   end;
   if dim(all_barsvars) = 0 then
      output;
run;

data graf_data_attributes;
   length ID $10 value $6 linecolor $ 9 fillcolor $ 9;

   %if "&bars" ^= "" %then %do;
      %do i=1 %to %sysfunc(countw(&bar_colors));
         %let color_index= &i + 0;
         %if &total_barsvars=1 %then
	        %let color_index= &i + 1; /* Color number 2 looks better when there's only one bar */
         ID = "BarAttr"; value =  "&i"; fillcolor = "%scan(&bar_colors, &color_index)"; linecolor = "%scan(&bar_colors, 1)"; output;
         ID = "BarAttr"; value = "n&i"; fillcolor = "%scan(&special_bar_colors, &color_index)"; output;
      %end;
   %end;
run;

data deleteme_output;
   set deleteme_output;
   format &category &category_format;
   input_order = -_N_;

   total_sum = 0;
   array allbars [*] bars: ;
   do i=1 to dim(allbars);
      total_sum = total_sum + allbars[i];
   end;

   if _n_ = 1 then do;
      %if "&variation" ^= "" %then %do;
         %do i=1 %to &total_variationvars;
		    if prxmatch("/^rate\d{4}$/i", vlabel(variation_&i)) then
			     call symput("variation_&i._label", prxchange("s/^rate(\d{4})$/$1/i", 1, vlabel(variation_&i)));
			else call symput("variation_&i._label", vlabel(variation_&i));
		 %end;
      %end;
	  %if "&bars" ^= "" %then %do;
         %do i=1 %to &total_barsvars;
		    call symput("bars_&i._label", vlabel(bars_&i));
		 %end;
      %end;
	  %if "&lines" ^= "" %then %do;
         %do i=1 %to &total_linesvars;
		    call symput("lines_&i._label", vlabel(lines_&i));
		 %end;
      %end;
   end;
run;

%if &panelby= %then %do;
   proc sort data=deleteme_output;
      by %if &reverse=false %then descending; %if "&bars" ^= "" %then total_sum; %else input_order; ;
   run;
%end;

ods graphics on / height=&height.px width=&width.px;

%if &save ^= "" %then %do;
   %let image_regex = ^["']?(.+)\/([\w\d]+)\.(\w+)['"]?$;

   %let image_path   = %sysfunc(prxchange(s/&image_regex/$1/, 1, &save));
   %let image_name   = %sysfunc(prxchange(s/&image_regex/$2/, 1, &save));
   %let image_format = %sysfunc(prxchange(s/&image_regex/$3/, 1, &save));

   ods graphics on /reset=All imagename="&image_name" imagefmt=&image_format border=off height=&height.px width=&width.px;
   ods listing Image_dpi=300 GPATH="&image_path";
%end;

proc %if &panelby= %then sgplot; %else sgpanel; data=deleteme_output sganno=graf_annotation %if &panelby= %then noborder; noautolegend pad=(Bottom=5%) dattrmap=graf_data_attributes;
   %let main_axis   = %scan(X Y, %eval(&direction=horizontal) + 1);
   %let second_axis = %scan(X Y, %eval(&direction=vertical) + 1);
   %let main_panel_axis   = %scan(col row, %eval(&direction=horizontal) + 1);
   %let second_panel_axis = %scan(col row, %eval(&direction=vertical) + 1);

   %if &panelby^= %then
         panelby &panelby;;

   %if "&bars" ^= "" %then %do;
      %substr(&direction, 1, 1)barparm category=&category response=bar
         / group=group groupdisplay=&bar_grouping attrid=BarAttr barwidth=0.75;

      %if &total_barsvars > 1 %then %do;
         %do i=1 %to &total_barsvars;
            legenditem type=fill name="legend&i" / label="&&bars_&i._label"
               fillattrs   =(color=%scan(&bar_colors, &i))
               outlineattrs=(color=%scan(&bar_colors, 1));
         %end;
         keylegend %do i=1 %to &total_barsvars; "legend&i" %end;
            / across=4 %if &panelby= %then location=outside; position=bottom down=1 noborder titleattrs=(size=7 weight=bold);
      %end;
   %end;

   %if "&lines" ^= "" %then %do;
      %do i=1 %to &total_linesvars;
         %let lineattrs=(pattern=%scan(&line_patterns, &i)
                         color=  %scan(&line_colors,   &i)
                         thickness=3);
         series &main_axis=&category &second_axis=lines_&i / lineattrs=&lineattrs;


         legenditem type=line name="linelegend&i" / label="&&lines_&i._label" lineattrs=&lineattrs;
     %end;
      keylegend %do i=1 %to &total_linesvars; "linelegend&i" %end;
         / across=4 %if &panelby= %then location=outside; position=bottom linelength=35 down=1 noborder titleattrs=(size=7 weight=bold);
   %end;

   %if "&variation" ^= "" %then %do;
      Highlow &main_axis=&category low=min_variation high=max_variation
         / type=line lineattrs=(color=black thickness=1 pattern=1);

      %do i=1 %to &total_variationvars;
        %let markerattrs=(symbol=%scan(&circle_symbols, &i)
                           color= %scan(&circle_colors,  &i)
                           size=  %scan(&circle_sizes,   &i));
         legenditem type=marker name="varlegend&i" / label="&&variation_&i._label" markerattrs=&markerattrs;

         scatter &main_axis=&category &second_axis=variation_&i / markerattrs=&markerattrs;
     %end;

      %let position=%scan(bottomright topright topleft, 1 + (&direction=vertical) + (&reverse=true));

      keylegend %do i=1 %to &total_variationvars; "varlegend&i" %end;
              / across=1 position=&position %if &panelby= %then location=inside; noborder valueattrs=(size=8pt);
   %end;

   %if "&table" ^= "" %then %do;
      %if &panelby= %then &main_axis.axistable; %else &main_panel_axis.axistable; %do i=1 %to &total_tablevars;
            table_%eval(%if &direction=vertical %then &total_tablevars+1 -;  &i)
         %end; / label %if &panelby= %then location=inside; valueattrs=(size=8 family=arial) labelattrs=(size=8)
            %if &direction=vertical %then %do; labelpos=left position=top %end;;
   %end;

   %if &panelby= %then %do;
      &main_axis.axis label="Main axis" %if &direction=horizontal %then labelpos=top;
         labelattrs=(size=8 weight=bold) valueattrs=(size=8)
         type=discrete discreteorder=data;
      &second_axis.axis label="%remove_quotes(%quote(&description))"
         display=(noticks noline) %if &direction=vertical %then labelpos=top;;
   %end;
   %else %do;
      &main_panel_axis.axis type=discrete discreteorder=data label="Main axis";
	  &second_panel_axis.axis label="%remove_quotes(%quote(&description))";
   %end;
run;

 
%if &save ^= "" %then %do;
    ods listing close;
%end;
ods graphics off;

/*proc datasets nolist; delete deleteme_: graf_annotation graf_data_attributes; run;*/

%mend graf;