/* Endringslogg: Sist endret av Tove 21.06.2021 */

/* Makro for å lage formater til boområder */
/* Husk å definere filbane før makro kjøres */

/* Input: CSV-file:
            ICD10.csv
            
*/
/* Output fem formater:
      Navn på formatene:
         icd10_fmt 
         
*/
/* Formatene kan blant annet brukes i et datasteg:

   Data utdata;
   Set inndata;
   Format hdiag icd10_fmt. ;
   Run;

 */

 /* Hente inn CSV-fil */
data icd10_fmt;
  infile "&filbane\formater\ICD10.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format ICD10 $10.;
  format Tekst $63.;

  input	
   ICD10 $ Tekst $  ;
  run;

/* Remove duplicate values */
proc sort data=icd10_fmt nodupkey;                                                                                                        
   by ICD10;                                                                                                                                
run; 

/* Build format data set */                                                                                                            
data hnref.fmtfil_icd10(rename=(icd10=start) keep=icd10 fmtname label);                                                                                    
   retain fmtname '$icd10_fmt';                                                                                                 
   length tekst $63.;                                                                                                                    
   set icd10_fmt; 
   label = cat(icd10,"",tekst); 
run; 
 
/* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_icd10;
run;

proc datasets nolist;
delete icd10_fmt ;
run;