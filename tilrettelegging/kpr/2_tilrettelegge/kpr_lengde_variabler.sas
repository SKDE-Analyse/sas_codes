%macro kpr_lengde_variabler(inndata=);

data &inndata._ut;
/* variabler i tilrettelagte data unik for KPR-datakilde */
length KPRAntall                8;
length inndato                  8;
length diagnoseKode             $20;
length diagnoseTabell           $26;
length egenandelPasient         8;
length enkeltregning_Lnr        8;
length fritakskode              $1;
length kodeNr                   4;
length minimumTidsbruk          8;
length takstKode                $7;
length pid_kpr                  8;
length hdiag_kpr                $20;
length diag                 ;
length erhdiag                  ;
length icpc2_hdiag                  ;
length icpc2_kap                    ;
length icpc2_type                   ;
length kodeverk_kpr                 ;
length kontakttype_kpr                  ;
length refusjonutbetalt                 ;
length tjenestetype_kpr                 ;

/* Variabler i tilrettelagte data som er felles med andre datakilder */
length aar                      4;
length alder                    8;
length fodselsar                4;
length ErMann                   3;
length bohf                     8;
length borhf                    8;
length boshhn                   8;
length komnr                    4;
length bydel                    6;
length inndato                  8;
length inntid                   4;
length fylke                    4;
set &inndata;
run;
%mend kpr_lengde_variabler;