
%include "&filbane\tilrettelegging\npr\1_kontroll_foer_tilrette\1_kontroll_komnr_bydel.sas";

%macro komnr_ukjent(inndata=, aar=);
/*! 
### Beskrivelse

Makro for � telle opp antall rader, enkeltregninger og kpr_lnr som ikke har gyldig komnr rapportert.
Makroen bruker error_komnr_&aar-filene som er output fra makroen 'kontroll_komnr_bydel.sas'.

```
%komnr_ukjent(inndata= , aar=)
```

### Input 
      - Inndata: mottatt datasett, f.eks HNMOT.KPR_L_ENKELTREGNING_2017_M21T2
      - aar:  hvilket �r en �nsker � telle rader med ukjent komnr
      
### Output 
      - datasett som inneholder radene med ukjent komnr
      - resultat fra proc sql som viser antall rader, kpr_lnr og enkeltregninger

### Endringslogg:
    - Opprettet november 2021, Tove
 */
proc sql;
	create table ukjent_bosted_&aar. as
	select a.kpr_lnr, a.bostedavledet, a.enkeltregning_lnr, b.komnr2
	from &inndata a
	inner join error_komnr_&aar. b
	ON a.bostedavledet=b.komnr2;
quit;

proc sql;
select	&aar as aar, 
			count(*) as rader, 
			count(distinct kpr_lnr) as unik_pas,
			count(distinct enkeltregning_lnr) as unik_regning,
			sum(missing(kpr_lnr)) as uten_kpr_lnr
from ukjent_bosted_&aar.;
quit;
%mend;