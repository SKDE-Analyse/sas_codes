

%macro kpr_ugyldig_bo_missing(inndata= , utdata= );
/*! 
### Beskrivelse

Makro bruker formatfilen HNREF.FMT_KOMNR til � lage en ny variabel, "bostedavledet2", hvor kun gyldige bosted f�r verdi, dvs radene med ugyldig bosted f�r missing.
Opprinnelig utlevert "kommuneNr" beholdes som "kommuneNr_kpr".
Makroen kj�res f�r forny_komnr-makroen i tilretteleggingen. 

```
%kpr_ugyldig_bosted(inndata= , utdata= )
```

### Input 
      - inndata: mottatt datasett, f.eks HNMOT.KPR_L_ENKELTREGNING_2017_M21T2
      
### Output 
      - utdata:
      - ny variabel: "kommuneNr2"
    

### Endringslogg:
    - Opprettet januar 2022, Tove
 */

proc sql;
      create table &utdata as
      select *, kommuneNr as kommuneNr_kpr,
            case when kommuneNr in (select start from HNREF.fmtfil_komnr) then kommuneNr end as kommuneNr2
      from &inndata;
quit;

 %mend;