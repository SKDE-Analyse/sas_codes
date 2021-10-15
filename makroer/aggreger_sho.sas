%macro aggreger(inndata = , utdata = , agg_var = , mappe = work);

/*!
Makro for å aggregere datasett, slik at det kan brukes i rateprogrammet.
Basert på kode som er brukt i Barnehelseatlaset og Eldrehelseatlaset.

Kjøres på følgende måte:
```
%aggreger(inndata = , utdata = , agg_var = , mappe = work);
```

### Variabler
- `inndata` er det sensitive datasettet som skal aggregeres. Må inneholde følgende variabler:

```
sho_aar, ermann, sho_alder, komnr, bydel, 
sho_liggetid, sho_inndato, sho_utdato, sho_id
off, priv, elektiv, ohjelp, innlegg, poli, &agg_var # disse er 1 eller 0/.
```

- `utdata` er navnet på det aggregerte datasettet
- `agg_var` er variabelen det skal aggregeres på. Må være 1 eller 0/.
- `mappe`: navn på mappen der utdatasettet skal lagres (default = work)

*/


/*
Marker tot, off, etc. for en gitt variabel (&agg_var)
*/



%macro unik_pasient(datasett = , variabel =);

/* 
Macro for å markere unike pasienter 

Ny variabel, &variabel._unik, lages i samme datasett
*/

/*1. Sorter på år, aktuell hendelse (merkevariabel), PID, InnDato, UtDato;*/
proc sort data=&datasett;
by sho_aar &variabel pid sho_inndato sho_utdato;
run;

/*2. By-statement sørger for at riktig opphold med hendelse velges i kombinasjon med First.-funksjonen og betingelse på hendelse*/
data &datasett;
set &datasett;
&variabel._unik = .;
by sho_aar &variabel pid sho_inndato sho_utdato;
if first.pid and &variabel = 1 then &variabel._unik = 1;	
run;

%mend;


%macro unik_pasient_alle_aar(datasett = , variabel =);

/* 
Macro for å markere unike pasienter i hele datasettet

Ny variabel, Unik_&variabel, lages i samme datasett
*/

/*1. Sorter på aktuell hendelse (merkevariabel), PID, InnDato, UtDato;*/
proc sort data=&datasett;
by &variabel pid sho_inndato sho_utdato;
run;

/*2. By-statement sørger for at riktig opphold med hendelse velges i kombinasjon med First.-funksjonen og betingelse på hendelse*/
data &datasett;
set &datasett;
Unik_&variabel = .;
by &variabel pid sho_inndato sho_utdato;
if first.pid and &variabel = 1 then &variabel._unik_alleaar=1;	
run;

%mend;


data &inndata._&agg_var;
set &inndata;
where &agg_var = 1;
run;

proc sort data=&inndata._&agg_var;
by sho_id;
run;

data &inndata._&agg_var;
set &inndata._&agg_var;
by sho_id;
if first.sho_id then behold=1;	
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
 * rename sho_aar = aar sho_alder = alder;
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
   SUM(sho_liggetid) as sho_liggetid
   from &inndata._&agg_var
   group by aar, ermann, alder, komnr, bydel;
quit; run;
*/
proc sql;
   create table &mappe..&utdata as 
   select distinct (sho_aar) as aar, ermann, (sho_alder) as alder, komnr, bydel,
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
   SUM(sho_liggetid) as sho_liggetid
   from &inndata._&agg_var
   group by sho_aar, ermann, sho_alder, komnr, bydel;
quit; run;


proc datasets nolist;
delete &inndata._&agg_var;
run;



%mend;
