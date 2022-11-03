%macro kpr_var_rekkefolge(inndata= , utdata=);

Data &Utdata;
%if &sektor=enkeltregning %then %do;
retain    aar 
          pid_kpr 
          enkeltregning_lnr
          inndato 
          inntid
          ErMann
          alder
          fodselsar
          komnr
          bydel
          bohf
          borhf
          boshhn
          fylke
          kodeverk_kpr
          hdiag_kpr
          ant_bdiag_kpr
          tjenestetype_kpr
          kontakttype_kpr
          icpc2_hdiag
          icpc2_kap
          icpc2_type
          fritakskode
          egenandelpasient
          refusjonutbetalt;
%end;

%if &sektor=diagnose %then %do;
retain    aar
          enkeltregning_lnr
          kodeverk_kpr
          icpc2_diag
          diag_kpr
          erhdiag_kpr
          kodenr;
%end;

%if &sektor=takst %then %do;
retain    aar
          enkeltregning_lnr
          takstkode
          kprantall;
%end;
set &Inndata;
run;

%mend;