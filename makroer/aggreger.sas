%macro aggreger(inndata = , utdata = , agg_var = , mappe = work);

/*!
Makro for � aggregere datasett, slik at det kan brukes i rateprogrammet.
Basert p� kode som er brukt i Barnehelseatlaset og Eldrehelseatlaset.

Kj�res p� f�lgende m�te:
```
%aggreger(inndata = , utdata = , agg_var = , mappe = work);
```

### Variabler
- `inndata` er det sensitive datasettet som skal aggregeres. M� inneholde f�lgende variabler:

```
eoc_aar, ermann, eoc_alder, komnr, bydel, 
eoc_liggetid, eoc_inndato, eoc_utdato, eoc_id
off, priv, elektiv, ohjelp, innlegg, poli, &agg_var # disse er 1 eller 0/.
```

- `utdata` er navnet p� det aggregerte datasettet
- `agg_var` er variabelen det skal aggregeres p�. M� v�re 1 eller 0/.
- `mappe`: navn p� mappen der utdatasettet skal lagres (default = work)

*/


/*
Marker tot, off, etc. for en gitt variabel (&agg_var)
*/



%macro unik_pasient(datasett = , variabel =);

/* 
Macro for � markere unike pasienter 

Ny variabel, &variabel._unik, lages i samme datasett
*/

/*1. Sorter p� �r, aktuell hendelse (merkevariabel), PID, InnDato, UtDato;*/
proc sort data=&datasett;
by eoc_aar &variabel pid eoc_inndato eoc_utdato;
run;

/*2. By-statement s�rger for at riktig opphold med hendelse velges i kombinasjon med First.-funksjonen og betingelse p� hendelse*/
data &datasett;
set &datasett;
&variabel._unik = .;
by eoc_aar &variabel pid eoc_inndato eoc_utdato;
if first.pid and &variabel = 1 then &variabel._unik = 1;	
run;

%mend;


%macro unik_pasient_alle_aar(datasett = , variabel =);

/* 
Macro for � markere unike pasienter i hele datasettet

Ny variabel, Unik_&variabel, lages i samme datasett
*/

/*1. Sorter p� aktuell hendelse (merkevariabel), PID, InnDato, UtDato;*/
proc sort data=&datasett;
by &variabel pid eoc_inndato eoc_utdato;
run;

/*2. By-statement s�rger for at riktig opphold med hendelse velges i kombinasjon med First.-funksjonen og betingelse p� hendelse*/
data &datasett;
set &datasett;
Unik_&variabel = .;
by &variabel pid eoc_inndato eoc_utdato;
if first.pid and &variabel = 1 then &variabel._unik_alleaar=1;	
run;

%mend;


data &inndata._&agg_var;
set &inndata;
where &agg_var = 1;
run;

proc sort data=&inndata._&agg_var;
by eoc_id;
run;

data &inndata._&agg_var;
set &inndata._&agg_var;
by eoc_id;
if first.eoc_id then behold=1;	
run;

data &inndata._&agg_var;
set &inndata._&agg_var;
where behold = 1;
run;

data &inndata._&agg_var;
set &inndata._&agg_var;
tot = 1;
drop behold;
run;

data &inndata._&agg_var;
set &inndata._&agg_var;
  if innlegg = 1 then do;
    if elektiv = 1 then inn_elektiv = 1;
    if ohjelp = 1 then inn_ohjelp = 1;
  end;
run;

data &inndata._&agg_var;
set &inndata._&agg_var;
  if poli = 1 then do;
    if off = 1 then poli_off = 1;
    if priv = 1 then poli_priv = 1;
  end;
 * rename eoc_aar = aar eoc_alder = alder;
run;

%unik_pasient(datasett = &inndata._&agg_var., variabel = tot);
%unik_pasient_alle_aar(datasett = &inndata._&agg_var., variabel = tot);
%unik_pasient(datasett = &inndata._&agg_var., variabel = priv);
%unik_pasient(datasett = &inndata._&agg_var., variabel = off);
%unik_pasient(datasett = &inndata._&agg_var., variabel = ohjelp);
%unik_pasient(datasett = &inndata._&agg_var., variabel = elektiv);
%unik_pasient(datasett = &inndata._&agg_var., variabel = innlegg);
%unik_pasient(datasett = &inndata._&agg_var., variabel = poli);
%unik_pasient(datasett = &inndata._&agg_var., variabel = inn_elektiv);
%unik_pasient(datasett = &inndata._&agg_var., variabel = inn_ohjelp);
%unik_pasient(datasett = &inndata._&agg_var., variabel = poli_off);
%unik_pasient(datasett = &inndata._&agg_var., variabel = poli_priv);

/*
Aggreger datasettet
*/
/*
proc sql;
   create table &mappe..&utdata as 
   select distinct aar, ermann, alder, komnr, bydel,
   SUM(tot) as tot, SUM(tot_unik) as tot_unik, sum(tot_unik_alleaar) as tot_unik_alleaar,
   SUM(off) as off, SUM(off_unik) as off_unik,
   SUM(priv) as priv, SUM(priv_unik) as priv_unik,
   SUM(elektiv) as elek, SUM(elektiv_unik) as elek_unik,
   SUM(ohjelp) as ohj, SUM(ohjelp_unik) as ohj_unik,
   SUM(innlegg) as inn, SUM(innlegg_unik) as inn_unik,
   SUM(inn_elektiv) as inn_elek, SUM(inn_elektiv_unik) as inn_elek_unik,
   SUM(inn_ohjelp) as inn_ohj, SUM(inn_ohjelp_unik) as inn_ohj_unik,
   SUM(poli) as poli, SUM(poli_unik) as poli_unik,
   SUM(poli_off) as poli_off, SUM(poli_off_unik) as poli_off_unik,
   SUM(poli_priv) as poli_priv, SUM(poli_priv_unik) as poli_priv_unik,
   SUM(eoc_liggetid) as eoc_liggetid
   from &inndata._&agg_var
   group by aar, ermann, alder, komnr, bydel;
quit; run;
*/
proc sql;
   create table &mappe..&utdata as 
   select distinct (eoc_aar) as aar, ermann, (eoc_alder) as alder, komnr, bydel,
   SUM(tot) as tot, SUM(tot_unik) as tot_unik, sum(tot_unik_alleaar) as tot_unik_alleaar,
   SUM(off) as off, SUM(off_unik) as off_unik,
   SUM(priv) as priv, SUM(priv_unik) as priv_unik,
   SUM(elektiv) as elek, SUM(elektiv_unik) as elek_unik,
   SUM(ohjelp) as ohj, SUM(ohjelp_unik) as ohj_unik,
   SUM(innlegg) as inn, SUM(innlegg_unik) as inn_unik,
   SUM(inn_elektiv) as inn_elek, SUM(inn_elektiv_unik) as inn_elek_unik,
   SUM(inn_ohjelp) as inn_ohj, SUM(inn_ohjelp_unik) as inn_ohj_unik,
   SUM(poli) as poli, SUM(poli_unik) as poli_unik,
   SUM(poli_off) as poli_off, SUM(poli_off_unik) as poli_off_unik,
   SUM(poli_priv) as poli_priv, SUM(poli_priv_unik) as poli_priv_unik,
   SUM(eoc_liggetid) as eoc_liggetid
   from &inndata._&agg_var
   group by eoc_aar, ermann, eoc_alder, komnr, bydel;
quit; run;


proc datasets nolist;
delete &inndata._&agg_var;
run;



%mend;
