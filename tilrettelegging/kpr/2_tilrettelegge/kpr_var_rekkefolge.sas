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
          diagnose
          kontakttype
          tjenestetype
          behandlingsnr
          minimumtidsbruk
          fritakskode
          egenandelpasient
          refusjonutbetalt
          ;
set &Inndata;
drop nr bostedavledet;
run;

%mend;