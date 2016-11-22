%macro VarFraParvus(dsnMagnus=,var_som=,var_avtspes=);

/*Makro i makro 1: Avdelingsopphold*/
%macro koble_avd (niva=,aar=);
data 	qwerty_avd_&aar;
set 	&dsnMagnus;
	if substrn (koblingsID,1,1)=1 and aar = &aar then output qwerty_&niva._&aar;
run;

proc sql;
create table qwerty_&niva._&aar as 
select *
from qwerty_&niva._&aar, npr_skde.PARVUS_&niva._&aar(keep=koblingsID &var_som)
where qwerty_&niva._&aar..koblingsID=PARVUS_&niva._&aar..koblingsID;
quit;
%mend koble_avd;

/*Makro i makro 2: Sykehusopphold*/
%macro koble_sho (niva=,aar=);
data 	qwerty_sho_&aar;
set 	&dsnMagnus;
	if substrn (koblingsID,1,1)=2 and aar = &aar then output qwerty_&niva._&aar;
run;

proc sql;
create table qwerty_&niva._&aar as 
select *
from qwerty_&niva._&aar, npr_skde.PARVUS_&niva._&aar(keep=koblingsID &var_som)
where qwerty_&niva._&aar..koblingsID=PARVUS_&niva._&aar..koblingsID;
quit;
%mend koble_sho;

/*Makro i makro 3: Avtalespesialister*/
%macro koble_avtspes (niva=,aar=);
data 	qwerty_&niva._&aar;
set 	&dsnMagnus;
	if substrn (koblingsID,1,1)=3 and aar = &aar then output qwerty_avtspes_&aar;
run;

proc sql;
create table qwerty_avtspes_&aar as 
select *
from qwerty_avtspes_&aar, npr_skde.PARVUS_avtspes_&aar(keep=koblingsID &var_avtspes)
where qwerty_avtspes_&aar..koblingsID=PARVUS_avtspes_&aar..koblingsID;
quit;
%mend koble_avtspes;

%koble_avd (niva=avd,aar=2011);
%koble_avd (niva=avd,aar=2012);
%koble_avd (niva=avd,aar=2013);
%koble_avd (niva=avd,aar=2014);
%koble_avd (niva=avd,aar=2015);
%koble_sho (niva=sho,aar=2011);
%koble_sho (niva=sho,aar=2012);
%koble_sho (niva=sho,aar=2013);
%koble_sho (niva=sho,aar=2014);
%koble_sho (niva=sho,aar=2015);
%koble_avtspes (niva=avtspes,aar=2011);
%koble_avtspes (niva=avtspes,aar=2012);
%koble_avtspes (niva=avtspes,aar=2013);
%koble_avtspes (niva=avtspes,aar=2014);
%koble_avtspes (niva=avtspes,aar=2015);

data &dsnMagnus;
set qwerty_avd_2011 qwerty_avd_2012 qwerty_avd_2013 qwerty_avd_2014 qwerty_avd_2015
	qwerty_sho_2011 qwerty_sho_2012 qwerty_sho_2013 qwerty_sho_2014 qwerty_sho_2015
qwerty_avtspes_2011 qwerty_avtspes_2012 qwerty_avtspes_2013 qwerty_avtspes_2014 qwerty_avtspes_2015;
run;

proc datasets nolist;
delete qwerty:;

%mend VarFraParvus;

/*%VarFraParvus (dsnMagnus=stor_test, var_som=komnrhjem2 cyto: opphold_ID aktiv:, var_avtspes=komnrhjem2 AvtaleRHF kontakt);*/ 
/*Rettet/deaktivert av FO 7/10-16 - Makroen bør vel også endre navn??*/

