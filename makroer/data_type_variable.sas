/*macro å konvertere variabel til en rett type i NPR dataset
rett type og lengde er basert på HNREF.REF_TYPE_LENGDE_LABEL_TILRETTE

laget av Olena

eksempel av bruk : set inn dataset som siste steg av tilrettelegging - SOM, PHV_RUS, PHBU, ASPES, REHAB
%data_type (data=tmp,out=tmp);

*/


%macro data_type (data=,out=);
 /*list all variables that must be character*/
%let length_list_6 = 
takst_1 takst_10 takst_11 takst_12 takst_13 takst_14 takst_15 takst_2 takst_3 takst_4 takst_5
takst_6 takst_7 takst_8 takst_9 tilst1akse2 tilst1akse3 tilst1akse4 tilst1akse5 tilst1akse6
tilst2akse2 tilst2akse3 tilst2akse4 tilst2akse5 tilst2akse6 tilst3akse2 tilst3akse3 tilst3akse4
tilst3akse5 tilst3akse6 tilst4akse2 tilst4akse3 tilst4akse4 tilst4akse5 tilst4akse6 tilst5akse2
tilst5akse3 tilst5akse4 tilst5akse5 tilst5akse6 tilst6akse2 tilst6akse3 tilst6akse4 tilst6akse5
tilst6akse6 typemaling_1 typemaling_10 typemaling_11 typemaling_12 typemaling_13 typemaling_14
typemaling_15 typemaling_16 typemaling_17 typemaling_18 typemaling_19 typemaling_2 typemaling_20
typemaling_3 typemaling_4 typemaling_5 typemaling_6 typemaling_7 typemaling_8 typemaling_9 initiativtaker
oppholdstype cyto_1 cyto_2 cyto_3 cyto_4 cyto_5 normaltariff1 normaltariff10 normaltariff11
normaltariff12 normaltariff13 normaltariff14 normaltariff15 normaltariff2 normaltariff3
normaltariff4 normaltariff5 normaltariff6 normaltariff7 normaltariff8 normaltariff9
;

 /*list all variables that must be numeric with length 8*/

%let length_list_8 = 
aggrshoppid_lnr antallgangeravmeldt behandlingsstedisfrefusjon
behandlingsstedreshid drgreturkode episode_lnr fagenhetisfrefusjon fagenhetreshid
frainstitusjonid frasted friststartbehandling frittbehandlingsvalg henvfrahpr
henvfrainstitusjonid henvfratjeneste henvisning_id henvisningsperiode_lnr
henvtilinstitusjonid henvtiltjeneste henvvurd koblet npkopphold_drgbasispoeng
npkopphold_ertellendeisfopphold npkopphold_ertellendeisfoppholdo
npkopphold_isfpoeng npkopphold_poengsum produksjonid psykinstid retttilhelsehjelp samarbeidsinst_1 samarbeidsinst_2 samarbeidsinst_3
samarbeidsinst_4 samarbeidsinst_5 samarbeidsinst_6 tilinstitusjonid tilsted tjenesteenhetisfrefusjon tjenesteenhetkode tjenesteenhetreshid
verdi_1 verdi_10 verdi_11 verdi_12 verdi_13 verdi_14 verdi_15 verdi_16 verdi_17 verdi_18 verdi_19
verdi_2 verdi_20 verdi_3 verdi_4 verdi_5 verdi_6 verdi_7 verdi_8 verdi_9;

%let length_list_4 = 
aar aar_org aktivitetskategori aktivitetskategori3 alder alderidager avtspes barnet_1
barnet_2 barnet_3 barnet_4 barnevernetsrolle_1 barnevernetsrolle_2 fodselsar fodselsar_org fodselsvekt fylke individuellplan
innmnd inntid inntilstand kjonn kjonn_org komnr komnr_inn komnrhjem2 kontakttype liggetid liggetidperiode
nprid_reg nytilstand omsnivahenv omsorgsniva omsorgsniva_org pakkeforlop pas_reg2 pasfylke2 permisjonsdogn polindir polindirekteaktivitet polutforende_1
polutforende_2 polutforende_3 polutforende_4 polutforende_5 polutforende_6 rehabtype rolle_1 rolle_2 rolle_3
samarbeidspart_1 samarbeidspart_2 samarbeidspart_3 samarbeidspart_4 samarbeidspart_5 samarbeidspart_6 sektor sh_reg shfylke 
spesialist_1 spesialist_2 spesialist_3 stedaktivitet tidspunkt_1 tidspunkt_2 tidspunkt_3 tidspunkt_4
tidspunkt_5 trimpkt typetidspunkt_1 typetidspunkt_2 typetidspunkt_3 typetidspunkt_4 typetidspunkt_5
ukpdager utdato_org utforendehelseperson utmndutsettkode1 utsettkode2 utsettkode21 utsettkode22 utsettkode3
utsettkode4 utsettkode5 utskrivingsklar uttid uttilstand ventetidsluttkode;

%let length_list_3 = 
debitor drgtypehastegrad epikrisesamtykke episodefag_org ermann fag
fag_skde fattetav_1 g_omsorgsniva hastegrad hdg henvformal henvtype hf icd10kap icd10katblokk
innmatehast isf_opphold kontakt kontakt_def kontakt_org maleresultatnr_1 maleresultatnr_10 maleresultatnr_11
maleresultatnr_12 maleresultatnr_13 maleresultatnr_14 maleresultatnr_15 maleresultatnr_16
maleresultatnr_17 maleresultatnr_18 maleresultatnr_19 maleresultatnr_2 maleresultatnr_20 maleresultatnr_3 maleresultatnr_4
maleresultatnr_5 maleresultatnr_6 maleresultatnr_7 maleresultatnr_8 maleresultatnr_9 polkonaktivitet
rolleip tutor typeformalitet_1 typeformalitet_2;

 /*list all variables that must be numeric date*/
%let length_list_date = datorolle_1 datorolle_2 datospesialistvedtak_1 datospesialistvedtak_2 doddato emigrertdato
epikrisedato individuellplandato inndato mottaksdato sluttdato tildeltdato utsettdato1
utsettdato2 utsettdato21 utsettdato22 utsettdato3 utsettdato4 utsettdato5 utdato utskrklardato ventetidsluttdato vurddato
malingdato_1 malingdato_10 malingdato_11 malingdato_12 malingdato_13 
malingdato_14 malingdato_15 malingdato_16 malingdato_17 malingdato_18 malingdato_19 malingdato_2
malingdato_20 malingdato_3 malingdato_4 malingdato_5 malingdato_6 malingdato_7 malingdato_8
malingdato_9 malingtid_1 malingtid_10 malingtid_11 malingtid_12 malingtid_13 malingtid_14
malingtid_15 malingtid_16 malingtid_17 malingtid_18 malingtid_19 malingtid_2
malingtid_20 malingtid_3 malingtid_4 malingtid_5 malingtid_6 malingtid_7 malingtid_8 malingtid_9 ; 

%macro char_dates_to_numeric(ds, vars, _length=, informat=, format=, out=);
  %local lib mem clean i item inlist _todo;

  /* Resolve lib/mem and OUT */
  %if %index(&ds,.) %then %do;
    %let lib=%upcase(%scan(&ds,1,.));
    %let mem=%upcase(%scan(&ds,2,.));
  %end;
  %else %do;
    %let lib=WORK; %let mem=%upcase(&ds);
  %end;
  %if %superq(out)= %then %let out=&ds;

  /* Clean the incoming list: remove quotes/commas, collapse spaces */
  %let clean=%sysfunc(compbl(%sysfunc(compress(&vars,%str(%',)))));
  /* Build an IN(...) list of uppercased names: "A","B","C" */
  %let i=1; %let inlist=;
  %do %while(%length(%scan(&clean,&i,%str( ))));
    %let item=%upcase(%scan(&clean,&i,%str( )));
    %let inlist=&inlist%sysfunc(ifc(%length(&inlist),%str(, ),));
    %let inlist=&inlist"%superq(item)";
    %let i=%eval(&i+1);
  %end;

  /* Keep only variables that actually exist and are character */
  proc sql noprint;
    select name into :_todo separated by ' '
    from dictionary.columns
    where libname="&lib" and memname="&mem" and type='char'
      %if %length(&inlist) %then %do; and upcase(name) in (&inlist) %end;
  ;
  quit;

  /* pass-through if nothing to convert */
  %if %superq(_todo)= %then %do;
    %put NOTE: No matching numeric variables to convert in &ds.. Creating &out as pass-through.;
    %if %superq(out)= %then %let out=&ds;
    %if %upcase(&out) ne %upcase(&ds) %then %do;
      data &out; set &ds; run;
    %end;
    %return;
  %end;

  /* Convert in one pass; invalid dates -> missing (?? suppresses notes),lenght is 8 */
  data &out;
    set &ds;
    %let i=1;
    %do %while(%length(%scan(&_todo,&i,%str( ))));
      %let item=%scan(&_todo,&i,%str( ));
	length __cdtn_&item &_length;
	__cdtn_&item = input(&item, ?? &informat);
	format __cdtn_&item &format;   /* <= apply to the numeric temp */
	drop &item;
	rename __cdtn_&item = &item;               /* e.g., YYMMDD10. */
      %let i=%eval(&i+1);
    %end;
  run;
%mend;



%macro num_to_char_vars(ds, vars, format=, out=);
  %local lib mem clean i item inlist _fmt _digits _len _todo;

  /* Resolve lib/mem and OUT */
  %if %index(&ds,.) %then %do;
    %let lib=%upcase(%scan(&ds,1,.));
    %let mem=%upcase(%scan(&ds,2,.));
  %end;
  %else %do;
    %let lib=WORK; %let mem=%upcase(&ds);
  %end;
  %if %superq(out)= %then %let out=&ds;

  /* Default format and target length */
  %if %superq(format)= %then %do;
    %let _fmt=BEST32.;
    %let _len=32;
  %end;
  %else %do;
    %let _fmt=&format;
    /* Extract width from the format text (digits before the first dot). */
    %let _digits=%sysfunc(compress(&_fmt,0123456789.,k));
    %let _len=%scan(&_digits,1,.);
    %if %superq(_len)= %then %let _len=32;
  %end;

  /* Clean the incoming list: remove quotes/commas, collapse spaces */
  %let clean=%sysfunc(compbl(%sysfunc(compress(&vars,%str(%',)))));

  /* Build an IN(...) list of uppercased names: "A","B","C" */
  %let i=1; %let inlist=;
  %do %while(%length(%scan(&clean,&i,%str( ))));
    %let item=%upcase(%scan(&clean,&i,%str( )));
    %let inlist=&inlist%sysfunc(ifc(%length(&inlist),%str(, ),));
    %let inlist=&inlist"%superq(item)";
    %let i=%eval(&i+1);
  %end;

  /* Keep only variables that actually exist and are numeric */
  proc sql noprint;
    select name into :_todo separated by ' '
    from dictionary.columns
    where libname="&lib" and memname="&mem" and type='num'
      %if %length(&inlist) %then %do; and upcase(name) in (&inlist) %end;
  ;
  quit;

  /* pass-through if nothing to convert */
  %if %superq(_todo)= %then %do;
    %put NOTE: No matching numeric variables to convert in &ds.. Creating &out as pass-through.;
    %if %superq(out)= %then %let out=&ds;
    %if %upcase(&out) ne %upcase(&ds) %then %do;
      data &out; set &ds; run;
    %end;
    %return;
  %end;

  /* Convert in one pass */
  data &out;
    set &ds;
    %let i=1;
    %do %while(%length(%scan(&_todo,&i,%str( ))));
      %let item=%scan(&_todo,&i,%str( ));
      length __ntc_&item $&_len;
      __ntc_&item = put(&item, &_fmt);
      drop &item;
      rename __ntc_&item = &item;
      %let i=%eval(&i+1);
    %end;
  run;
%mend;




%char_dates_to_numeric(
  ds=&data,
  vars=&length_list_8,
  _length=8,
  informat=best32.,
  format=BEST12.,
  out=&data
);

%char_dates_to_numeric(
  ds=&data,
  vars=&length_list_4,
  _length=4,
  informat=best32.,
  format=BEST12.,
  out=&data
);

%char_dates_to_numeric(
  ds=&data,
  vars=&length_list_3,
  _length=3,
  informat=best32.,
  format=BEST12.,
  out=&data
);
%char_dates_to_numeric(
  ds=&data,
  vars=&length_list_date,
  _length=8,
  informat=yymmdd10.,
  format=YYMMDD10.,
  out=&data
);

%num_to_char_vars(
	ds=&data, 
	vars=&length_list_6,
	format=BEST6., 
	out=%superq(out));

%mend;