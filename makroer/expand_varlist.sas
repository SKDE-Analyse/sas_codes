%macro expand_varlist(library, ds, varlist, macrovar);
/*!  Denne makroen tar en SAS variabelliste av ukjent form (f. eks. rate: eller rate2020-rate2023),
    og konverteren den til en liste av variabler atskilt med mellomrom. Resultatet lagres i en
    makrovariabel med det navnet som er spesifisert i &macrovar. Eksempel:

    ```
    rate2020-rate2023 -> rate2020 rate2021 rate2022 rate2023
    abc23 abc1 abc4   -> abc23 abc1 abc4 (rekkefølgen beholdes, selv om den ikke er kronologisk)
    ```

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