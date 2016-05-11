
%macro type1_type2_bohf_Hjelp;
options nomlogic nomprint;
%put =============================================================================================================================;
%put Lage datasett klart for ratefigurer ala offentlig/privat - Opprettet 11/5-16 av Arnfinn og Linda;
%put Parametre:;
%put 1. type1: navn på datasett 1 fra ratestrøm for bohf (for eksempel off);
%put 2. type2: navn på datasett 2 fra annen ratestrøm for bohf (for eksempel priv);
%put ================================================================================================================================;
%mend type1_type2_bohf_hjelp;


%macro type1_type2_bohf(type1=, type2=);

data &type1.;
set &type1._bohf;
ratesnitt_&type1.=ratesnitt;
Norge_&type1.=Norge;
type=1;
run;

data &type2.;
set &type2._bohf;
ratesnitt_&type2.v=ratesnitt;
Norge_&type2.=Norge;
type=2;
run;

data &type1._&type2.;
set &type1. &type2.;
drop aar rate2012 rate2013 rate2014;
run;

proc sql;
   create table &type1._&type2. as 
   select *, SUM(ratesnitt) as Totalsnitt, SUM(Norge) as Norge_totalt
   from &type1._&type2.
   group by  BoHF;
quit;

data &type1._&type2.;
set &type1._&type2.;
Plassering_andel=10;
andel_&type1.=(ratesnitt_&type1./totalsnitt);
run; 


data &type1._priv;
set &type1._priv;
if type=1 then ratesnitt=ratesnitt_&type1.;
if type=2 then ratesnitt=ratesnitt_&type2.;
format ratesnitt_&type1. ratesnitt_&type2. Norge_totalt totalsnitt andel_&type1. NLNUM8.0; /* Formatet gir åpenrom som tusenskilletegn og komma som desimaltegn */
/*format andel_offentlig NLNUM8.0;*/
label ratesnitt_&type1.="Rate offentlig" ratesnitt_&type2.="Rate privat"; /* Label gir overskrif til søylene kolonnene til figuren som skal lages senere */
format BoHF BoHF_figurer. type type.;
run;

proc sort data=&type1._&type2.;
by descending totalsnitt;
run;

%mend type1_type2_bohf;

