

%macro kpr_ugyldig_bo_missing(inndata= , utdata= );
/*! 
### Beskrivelse

Makro bruker formatfilen HNREF.FMT_KOMNR til � lage en ny variabel, "bostedavledet2", hvor kun gyldige bosted f�r verdi, dvs radene med ugyldig bosted f�r missing.
Opprinnelig utlevert "bostedavledet" beholdes som "bostedavledet_org".
Makroen kj�res f�r forny_komnr-makroen i tilretteleggingen. 

```
%kpr_ugyldig_bosted(inndata= , utdata= )
```

### Input 
      - inndata: mottatt datasett, f.eks HNMOT.KPR_L_ENKELTREGNING_2017_M21T2
      
### Output 
      - utdata:
      - ny variabel: "bostedavledet2"
    

### Endringslogg:
    - Opprettet januar 2022, Tove
 */

proc sql;
      create table &utdata as
      select *, bostedavledet as bostedavledet_org,
            case when bostedavledet in (select start from HNREF.fmtfil_komnr) then bostedavledet end as bostedavledet2
      from &inndata;
quit;

 %mend;