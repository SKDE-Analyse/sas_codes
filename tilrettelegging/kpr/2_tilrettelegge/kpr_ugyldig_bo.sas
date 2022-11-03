%macro kpr_ugyldig_bo(inndata= , utdata= );
/*! 
### Beskrivelse

Makro bruker formatfilen HNREF.FMT_KOMNR til å lage en ny variabel, "kommunenr2", hvor kun gyldige bosted får verdi, dvs radene med ugyldig bosted får missing.
Makroen kjøres før forny_komnr-makroen i tilretteleggingen. 

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
      select *, case when kommuneNr in (select start from HNREF.fmtfil_komnr) then kommuneNr end as kommuneNr2
      from &inndata;
quit;

 %mend;