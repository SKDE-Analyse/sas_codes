%macro tilstandskoder_akse(inndata=);

data &inndata;
set &inndata;
/* ----------------- */
/* tilstand -> akser */
/* ----------------- */

array tilstand(*) $ tilst1akse1 tilst2akse1 tilst3akse1 tilst4akse1 tilst5akse1 tilst6akse1 tilst7akse1 tilst8akse1 tilst9akse1 tilst10akse1;
do i = 1 to dim(tilstand);
  tilstand(i)=upcase(compress(tilstand(i),"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890","ki")); /*The modifier "ki" means Keep the characters in the list and Ignore the case of the characters */
end;

data &inndata.;
set &inndata.;

array akse1{*} $ tilst1akse1 tilst2akse1 tilst3akse1 tilst4akse1 tilst5akse1 tilst6akse1 tilst7akse1 tilst8akse1 tilst9akse1 tilst10akse1 ;
array nyakse{*} $ akse1_diag1-akse1_diag10;
do j=1 to dim(akse1);
    nyakse{j}=(akse1{j});
end;
drop i j tilst1akse1 tilst2akse1 tilst3akse1 tilst4akse1 tilst5akse1 tilst6akse1 tilst7akse1 tilst8akse1 tilst9akse1 tilst10akse1;
run; 

%mend tilstandskoder_akse;
