%macro kpr_komnr_ukjent(inndata=, aar=);
/*! 
### Beskrivelse

Makro for å telle opp antall rader, enkeltregninger og kpr_lnr som ikke har gyldig komnr rapportert.
Makroen bruker error_komnr_&aar-filene som er output fra makroen 'kontroll_komnr_bydel.sas'.

```
%komnr_ukjent(inndata= , aar=)
```

### Input 
      - Inndata: mottatt datasett, f.eks HNMOT.KPR_L_ENKELTREGNING_2017_M21T2
      - aar:  hvilket år en ønsker å telle rader med ukjent komnr
      
### Output 
      - datasett som inneholder radene med ukjent komnr
      - resultat fra proc sql som viser antall rader, kpr_lnr og enkeltregninger

### Endringslogg:
    - Opprettet november 2021, Tove
 */
proc sql;
	create table ukjent_bosted_&aar. as
	select kpr_lnr, kommuneNr, enkeltregning_lnr
	from &inndata 
	where kommuneNr in (select komnr2 from error_komnr_&aar.);
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