%macro kpr_lengde_variabler(inndata=, utdata=);

data &utdata;
/* alle datasettene */
    length enkeltregning_Lnr        8;
    length aar                      4;

/* regning og diagnose */
%if &sektor=enkeltregning or &sektor=diagnose %then %do;
    length kodeverk_kpr             3;
%end;

/* regning */
%if &sektor=enkeltregning %then %do;
    length fritakskode              $1;
    length egenandelPasient         8;
    length pid_kpr                  8;
    length hdiag_kpr                $20;
    length icpc2_hdiag              $5;
    length icpc2_kap                $1;
    length icpc2_type               3;
    length ant_bdiag_kpr            3;
    length tjenestetype_kpr         3;
    length kontakttype_kpr          3;
    length refusjonutbetalt         8;
    /* Variabler i tilrettelagte data som er felles med NPR */
    length aar                      4;
    length alder                    8;
    length fodselsar                4;
    length ErMann                   3;
    length bohf                     4;
    length borhf                    4;
    length boshhn                   4;
    length komnr                    4;
    length bydel                    6;
    length inndato                  8;
    length inntid                   4;
    length fylke                    4;
%end;

/* diagnose */
%if &sektor=diagnose %then %do;
    length diag_kpr                 $20;
    length erhdiag_kpr              3;
    length kodeNr                   4;
    length icpc2_diag               $5;
%end;

/* takst */
%if &sektor=takst %then %do;
    length takstKode                $7;
    length kprantall                3;
%end;
set &inndata;
run;
%mend kpr_lengde_variabler;