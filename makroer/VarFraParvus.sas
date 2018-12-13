%macro VarFraParvus(dsnMagnus=,var_som=,var_avtspes=, taar = 18);

/*!
### Beskrivelse

Hente variable fra Parvus til Magnus

```
%VarFraParvus(dsnMagnus=,var_som=,var_avtspes=,taar= );
```

### Parametre

- `dsnMagnus`: Datasettet du vil koble variable til. Kan være avdelingsoppholdsfil, sykehusoppholdsfil, avtalespesialistfil eller kombinasjoner av disse
- `var_som`: Variable som skal kobles fra avdelingsopphold- eller sykehusoppholdsfil
- `var_avtspes`: Variable som skal kobles fra avtalespesialistfil.
- `taar`: Tilretteleggingsår. 

### Eksempel

```
VarFraParvus(dsnMagnus=radiusfrakturer,var_som=cyto: komnrhjem2, var_avtspes=Fag_navn komnrhjem2)
```

De varible du har valgt hentes fra aktuelle filer, kobles med variabelen *KoblingsID* og legges til inndatasettet
Start gjerne med et ferdig utvalg om det er mulig, da vil makroen kjøre raskere og kreve mindre ressurser

### Endringsoversikt

- 5/10-16 Opprettet av Petter Otterdal
- juni 2017: Tilpasset versjon for tilrettelagte sett (Petter Otterdal)
- juli 2018: tilpasset t18 (Arnfinn)
*/


/*Makro i makro: Koble til parvus-data*/
%macro koble_parvus(niva=, aar=);

%if &niva = avd %then %do;
%let num = 1;
%let var_par = &var_som;
%end;
%if &niva = sho %then %do;
%let num = 2;
%let var_par = &var_som;
%end;
%if &niva = avtspes %then %do;
%let num = 3;
%let var_par = &var_avtspes;
%end;

%if &taar = 17 %then %do;
%let server = npr_skde;
%let parvus = t17_PARVUS_&niva._&aar;
%end;
%if &taar = 18 %then %do;
%let server = skde18;
%let parvus = t18_PARVUS_&niva._&aar;
%end;

data 	qwerty_&niva._&aar;
set 	&dsnMagnus;
	if substrn (koblingsID,3,1)=&num and aar = &aar then output qwerty_&niva._&aar;
run;

proc sql;
create table qwerty_&niva._&aar as
select *
from qwerty_&niva._&aar, &server..&parvus(keep=koblingsID &var_par)
where qwerty_&niva._&aar..koblingsID=&parvus..koblingsID;
quit;

%mend; /* koble_parvus */

%if &taar = 17 %then %do;
%koble_parvus (niva=avd,aar=2012);
%end;
%koble_parvus (niva=avd,aar=2013);
%koble_parvus (niva=avd,aar=2014);
%koble_parvus (niva=avd,aar=2015);
%koble_parvus (niva=avd,aar=2016);
%if &taar = 18 %then %do;
%koble_parvus (niva=avd,aar=2017);
%end;

%if &taar = 17 %then %do;
%koble_parvus (niva=sho,aar=2012);
%end;
%koble_parvus (niva=sho,aar=2013);
%koble_parvus (niva=sho,aar=2014);
%koble_parvus (niva=sho,aar=2015);
%koble_parvus (niva=sho,aar=2016);
%if &taar = 18 %then %do;
%koble_parvus (niva=sho,aar=2017);
%end;

%if &taar = 17 %then %do;
%koble_parvus (niva=avtspes,aar=2012);
%end;
%koble_parvus (niva=avtspes,aar=2013);
%koble_parvus (niva=avtspes,aar=2014);
%koble_parvus (niva=avtspes,aar=2015);
%koble_parvus (niva=avtspes,aar=2016);
%if &taar = 18 %then %do;
%koble_parvus (niva=avtspes,aar=2017);
%end;

data &dsnMagnus;
set  qwerty_avd_:
	 qwerty_sho_:
     qwerty_avtspes_:;
run;

proc datasets nolist;
delete qwerty:;

%mend; /* VarFraParvus */
