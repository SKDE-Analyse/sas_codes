%macro length_label(inndata= , reftab=hnref.ref_type_lengde_label_tilrette);

/* Hente inn variable liste fra inndata */
proc contents data=&inndata out=varlist noprint; run;

data varlist;
  set varlist;
  name=lowcase(name);
run;

/* Lage length og label statements */
data ref_type_lengde_label_tilrette;
  set &reftab.;
  if TYPE=1 then length_statement=cat("length ",compress(name),"  ",length,";");
  if TYPE=2 then length_statement=cat("length ",compress(name)," $",length,";");
  if label ne '' then label_statement=cat("label ",compress(name)," = ",catq('AS',label),";");
run;

/* Lage macro variabler */
proc sql noprint;
  select length_statement, label_statement
  into :length_statement separated by ' ',
       :label_statement separated by ' '
  from varlist a, ref_type_lengde_label_tilrette b
  where a.name=b.name
    and a.type=b.type;
quit;

/* Kjøre length og label på datasett */
data &inndata;
  &length_statement;
  set &inndata;
  &label_statement;
run;

%mend;
