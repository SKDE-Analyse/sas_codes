

data icd10_fmt;
  infile "&filbane\data\ICD10.csv"
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
data fmtfil_icd10(rename=(icd10=start) keep=icd10 fmtname label);                                                                                    
   retain fmtname '$icd10_fmt';                                                                                                 
   length tekst $63.;                                                                                                                    
   set icd10_fmt; 
   label = cat(icd10,"",tekst); 
run; 
 
/* Create the format using the control data set. */                                                                                     
proc format cntlin=fmtfil_icd10;
run;

/* Example code of how to use the format
data AVD_1_testfmt;
  set AVD_1(obs=999 keep=hdiag);
  format hdiag $icd10_fmt.;
run;
*/

proc datasets nolist;
delete icd10_fmt ;
run;