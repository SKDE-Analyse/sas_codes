%macro omkoding_komnr_bydel(inndata=);
/*! 
### Beskrivelse

Makro for � omkode mottatte kommunenummer (bruker andre bydelsnummer enn SSB) til kommunenummer og bydel likt SSB.

```
%omkoding_komnr_bydel(inndata= ,utdata=)
```

### Input 
      - Inndata: 

### Output 
      - Utdata med variablene: komnr, bydel og bydel_kort (to siffer)

### Endringslogg:
    - Opprettet desember 2022, Tove J
 */


/* lese inn fil med nav-bydeler og mapping til "ordin�re"-bydeler */
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
  on a.pasient_kommune=b.bydel_utlevert;
quit;

data &inndata;
set &inndata;

/*hvis ingen omkoding er gjort -> bruk utlevert pasient_kommune*/
if komnr_mottatt eq . then do;
komnr_mottatt=pasient_kommune;
end;

/*hent ut to siste siffer for � lage bydel slik vi vanligvis mottar den*/
/* dette for � kunne bruke makroer som krever bydelsnr som to siffer */
 if komnr_mottatt in (301,4601,5001,1103) then do; 
	bydel_kort=mod(bydel,10**2);
	if bydel_kort eq 99 then bydel_kort = .;
	format  bydel_kort z2.;
  end;

/* drop av variabler */
drop pasient_kommune;
run;
%mend omkoding_komnr_bydel;