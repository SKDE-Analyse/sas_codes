%macro kpr_lengde_variabler(inndata=);

data &inndata._ut;
/* Mottatte variabler som kun er i KPR-data */
length KPRAntall                8;
length KPR_lnr                  8;
length behandlingsnr            8;
*length bostedAvledet            8;
length datotid                  8;
length diagnoseKode             $20;
length diagnoseTabell           $26;
length egenandelPasient         8;
length enkeltregning_Lnr        8;
*length erHoveddiagnose          1;
length fritakskode              $1;
*length hoveddiagnoseKode        $20;
*length hoveddiagnoseTabell      $26;
*length kjonn_navn               $6;
length kodeNr                   4;
length kontakttypeNavn          $21;
length kuhrKontakttypeId        8;
*length minimumTidsbruk          8;
length refusjonUtbetaltBeløp    8;
length takstKode                $6;
length tjenestetypeNavn         $22;
/* Andre variabler som er avledet og/eller rename */
length pid_kpr                  8;
length hdiag_kpr                $20;
*length bydel_kpr                    ;
length diag                 ;
length erhdiag                  ;
length icpc2_hdiag                  ;
length icpc2_kap                    ;
length icpc2_type                   ;
length kodeverk                 ;
length kontakttype_kpr                  ;
length refusjonutbetalt                 ;
length tjenestetype_kpr                 ;
/* Variabler vi oppretter eller mottar som er felles med NPR-data */
length aar                      4;
length alder                    8;
length fodselsar                4;
length ErMann                   3;
length bohf                     8;
length borhf                    8;
length boshhn                   8;
length komnr                    4;
length bydel                    6;
*length bydel2                   8;
length inndato                  8;
length inntid                   4;
length fylke                    4;
*length kjonn                    4;
set &inndata;

run;
%mend kpr_lengde_variabler;