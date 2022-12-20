%macro omkoding_komnr_bydel(inndata=, pas_komnr=);
/*! 
### Beskrivelse

Makro for å omkode mottatte kommunenummer (bruker andre bydelsnummer enn SSB) til kommunenummer og bydel likt SSB.

```
%omkoding_komnr_bydel(inndata= , pas_komnr=)
```

### Input 
      - Inndata: 
      - pas_komnr: 

### Output 
      - Utdata med variablene: komnr, bydel og bydel_kort (to siffer)

### Endringslogg:
    - Opprettet desember 2022, Tove J
 */


/* lese inn fil med nav-bydeler og mapping til "ordinære"-bydeler */
data mapping;
  infile "&filbane/tilrettelegging/radiologi/mapping_komnr_bydel.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format bydel_utlevert best6.;
  format komnr_mapping best4.;
  format bydel_mapping best6.;
  format bydel_navn $24.;
  format kommentar $204.;
 
  input	
   bydel_utlevert
   komnr_mapping 
   bydel_mapping 
   bydel_navn $
   kommentar $;
if bydel_utlevert eq . then delete; /*fjerner radene som ikke har mapping (de er kun til informasjon)*/
run;

proc sql;
  create table &inndata as
  select a.*, b.komnr_mapping as komnr_mottatt, b.bydel_mapping as bydel
  from &inndata a 
  left join mapping b
  on a.&pas_komnr=b.bydel_utlevert;
quit;

data &inndata;
set &inndata;

/*hvis ingen omkoding er gjort -> bruk utlevert pasient_kommune*/
if komnr_mottatt eq . then do;
komnr_mottatt=&pas_komnr;
end;

/*hent ut to siste siffer for å lage bydel slik vi vanligvis mottar den*/
/* dette for å kunne bruke makroer som krever bydelsnr som to siffer */
 if komnr_mottatt in (301,4601,5001,1103) then do; 
	bydel_kort=mod(bydel,10**2);
	if bydel_kort eq 99 then bydel_kort = .;
	format  bydel_kort z2.;
  end;

/* drop av variabler */
drop &pas_komnr.;
run;
%mend omkoding_komnr_bydel;