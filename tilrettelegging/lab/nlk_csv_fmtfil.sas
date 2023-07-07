/* Endringslogg: Opprettet juli 2023, Tove*/

/* Makro for å lage formater til NLKKODER */
/* Husk å definere filbane før makro kjøres */

/* Input: en CSV-fil:
            alle_nlk_stat_priv_23052023_redusert.csv
*/
/* Output fem formater:
      Navn på formatene:
         $nlk_fmt 
*/
/* Formatene kan blant annet brukes i et datasteg:

   Data utdata;
   Set inndata;
   Format nlkkode1 $nlk_fmt. ;
   Run;
 */

/* hente inn CSV-fil */
data ref;
    infile "&filbane/tilrettelegging/lab/alle_nlk_stat_priv_23052023_redusert.csv"
    delimiter=';'
    missover firstobs=2 DSD;
  
    format kode $8.;
    format norsk_bruksnavn $120.;
    format SEKUNDAERT_FAGOMRAADE $8.;
    format FAGOMRAADE_NLK $20.;
    format REFUSJONSKATEGORI $8.;
    format REFUSJON_stat $8.;
    format REFUSJON_privat $8.;
    format STJERNEKODE best8.;
    format REFUSJONSKATEGORI_ENDRET $8.;
  
    input	
     kode $
     norsk_bruksnavn $
     SEKUNDAERT_FAGOMRAADE $
     FAGOMRAADE_NLK $
     REFUSJONSKATEGORI $
     REFUSJON_stat $
     REFUSJON_privat $
     STJERNEKODE
     REFUSJONSKATEGORI_ENDRET $;
  if kode eq "" then delete;
  run;
  

/* ----------------- */
/*  NORSK BRUKSNAVN  */  
/* ----------------- */                                                                           
/* Remove duplicate values */
proc sort data=ref nodupkey out=nlk_fmt(keep=kode norsk_bruksnavn);                                                                                                        
   by kode;  
   where kode is not missing;                                                                                                                              
run; 
/* Build format data set */                                                                                                            
data fmtfil_nlk(rename=(kode=start) keep=kode fmtname label);                                                                                    
   retain fmtname '$nlk_fmt';                                                                                                 
   length norsk_bruksnavn $200.;                                                                                                                    
   set nlk_fmt;
   label = catx('-',kode,norsk_bruksnavn); 
run; 
 /* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_nlk; run;

