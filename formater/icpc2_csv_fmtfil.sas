
data icpc2;
  infile "&filbane\formater\icpc2.csv"
  delimiter=';'
  missover firstobs=2 DSD;

  format icpc2_kode $4.;
  format icpc2_tekst $51.;
  format icpc2_kap $1.;
  format icpc2_type 1.;
 
  input	
  icpc2_kode $ icpc2_tekst $ icpc2_kap $ icpc2_type ;
  run;

/* -------- */
/*  ICPC-2  */  
/* -------- */                                                                           
/* Remove duplicate values */
proc sort data=icpc2 nodupkey;                                                                                                        
   by icpc2_kode;                                                                                                                                
run; 

/* Build format data set */                                                                                                            
data hnref.fmtfil_icpc2(rename=(icpc2_kode=start) keep=icpc2_kode fmtname label);                                                                                    
   retain fmtname '$icpc2_fmt';                                                                                                 
   length tekst $51.;                                                                                                                    
   set icpc2; 
   label = cat(icpc2_kode,"",icpc2_tekst); 
run; 
 
/* Create the format using the control data set. */                                                                                     
proc format cntlin=hnref.fmtfil_icpc2;
run;

proc datasets nolist;
delete icpc2 ;
run;
