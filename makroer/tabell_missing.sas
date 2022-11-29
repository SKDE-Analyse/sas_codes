/*!
Macro som beregner antall missing-verdier for alle variabler i et datasett.

## INPUT:
- ds: navn på datasett
- where: where statement på formen where=where ermann=0;

## OUTPUT:

1. En tabell-rapport med antall datarader og antall missing for alle variabler
2. Ett datasett (&ds._f) hvor alle variabler i det opprinnelige datasettet er omgjort til 
	numeriske variabler og alle verdier i det opprinnelige datasettet er 
	erstattet med enten 1 (hvis missing) eller 0 (hvis ikke missing).

*/

%macro tabell_missing(ds=, where=);


proc format;
 value $missfmt ' '=1 other=0;
 value  missfmt  . =1 other=0;
run;

data format;
set &ds;

&where

format _CHAR_ $missfmt.; 
format _NUMERIC_ missfmt.;

array alle_C(*) _CHARACTER_;
	do i=1 to dim(alle_C);
	alle_C(i)=vvalue(alle_C(i));
	end;

array alle_N(*) _NUMERIC_;
	do i=1 to dim(alle_N);
	alle_N(i)=vvalue(alle_N(i));
	end;

run;

proc contents data=format out=vars(keep=name type) noprint; 
 
/*A DATA step is used to subset the VARS data set to keep only the character */
/*variables and exclude the one ID character variable.  A new list of numeric*/ 
/*variable names is created from the character variable name with a "_n"     */
/*appended to the end of each name.                                          */                                                        

data vars;                                                
set vars;                                                 
if type=2;                               
newname=trim(left(name))||"_n";                                                                               

/*The macro system option SYMBOLGEN is set to be able to see what the macro*/
/*variables resolved to in the SAS log.                                    */                                                       

options symbolgen;                                        

/*PROC SQL is used to create three macro variables with the INTO clause.  One  */
/*macro variable named c_list will contain a list of each character variable   */
/*separated by a blank space.  The next macro variable named n_list will       */
/*contain a list of each new numeric variable separated by a blank space.  The */
/*last macro variable named renam_list will contain a list of each new numeric */
/*variable and each character variable separated by an equal sign to be used on*/ 
/*the RENAME statement.                                                        */                                                        

proc sql noprint;                                         
select trim(left(name)), trim(left(newname)),             
       trim(left(newname))||'='||trim(left(name))         
into :c_list separated by ' ', :n_list separated by ' ',  
     :renam_list separated by ' '                         
from vars;                                                
quit;                                                                                                               
 
/*The DATA step is used to convert the numeric values to character.  An ARRAY  */
/*statement is used for the list of character variables and another ARRAY for  */
/*the list of numeric variables.  A DO loop is used to process each variable   */
/*to convert the value from character to numeric with the INPUT function.  The */
/*DROP statement is used to prevent the character variables from being written */
/*to the output data set, and the RENAME statement is used to rename the new   */
/*numeric variable names back to the original character variable names.        */                                                        

data format_NUM;                                               
set format;                                                 
array ch(*) $ &c_list;                                    
array nu(*) &n_list;                                      
do i = 1 to dim(ch);                                      
  nu(i)=input(ch(i),8.);                                  
end;                                                      
drop i &c_list;                                           
rename &renam_list;                                                                                     
run;    

TITLE "&ds";
PROC TABULATE DATA=format_NUM;
VAR _ALL_;

TABLE 
_ALL_,
N={LABEL="Antall datarader"} Sum={LABEL="Antall missing"}*F=8. / BOX='Variabelnavn';
QUIT;
TITLE;

data &ds._f;
set format_NUM;
run;

proc delete data=vars format format_NUM ;
quit;

%mend tabell_missing; 