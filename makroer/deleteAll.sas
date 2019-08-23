%macro deleteALL;
/*!
Makro som sletter alle makro-variabler, slik at man slipper å restarte SAS EG.

"Stjålet" fra https://blogs.sas.com/content/sastraining/2018/05/07/deleting-global-macro-variables/

*/


   	options nonotes;
 
  	%local vars;
 
  	proc sql noprint;
      	     select name into: vars separated by ' '
         	  from dictionary.macros
            	      where scope='GLOBAL' 
			   and not name contains 'SYS_SQL_IP_'
			   and not name contains 'FILBANE'
			   and not name contains 'BRANCH';
   	quit;
 
   	%symdel &vars;
 
   	options notes;
 
    	%put NOTE: Macro variables &vars deleted.;
 
%mend deleteALL;
