%macro kpr_var_rekkefolge(inndata= , utdata=);

Data &Utdata;
retain    aar 
          KPR_pid 
          enkeltregning_lnr
          dato 
          tid
          ErMann
          alder
          fodselsar
          komnr
          bydel
          bohf
          borhf
          boshhn
          fylke
          kodeverk
          hdiag
          icpc2_hdiag
          icpc2_kap
          icpc2_type
          tjenestetype
          kontakttype
          behandlingsnr
          minimumtidsbruk
          fritakskode
          egenandelpasient
          refusjonutbetalt
          ;
set &Inndata;
drop nr komnr_inn;
run;

%mend;