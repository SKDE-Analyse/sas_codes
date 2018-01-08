/*!
Makro som gir oversikt over antall ulike verdier av en variabel, hvilke verdier som forekommer i variabelen og hvor mange ganger hver verdi forekommer, PER PID.

## INPUT:
 
Inndata: navn på inndatasett
utdata: navn på utdatasett
variabel: navn på variabel
type: c for character eller n for numerisk (default er numerisk)



F.eks: Antall ulike behandlingssteder en person er registrert på, hvilke behandlingssteder og hvor mange ganger personen er registrert på hvert behandlingssted.

Makroen kan håndtere inntil 9 ulike verdier for en variabel pr PID. NB: MISSING-VERDIER IGNORERES.

To datasett lages:
&utdata og &utdata._oversikt

---------------------------------------

&utdata består av inndatasettet pluss en rekke nye variabler:

unik: angir ny unik PID. Settes lik 1 på første rad med en ny PID
oppholdsnummer: teller antall opphold pr PID


unik_&variabel: angir ny unik verdi i &variabel. Settes lik 1 på første rad med en ny verdi.
&variabel._teller: teller antall forekomster av hver verdi for &variabel.



&variabel._1: Inneholder den første verdien som forekommer i &variabel
&variabel._2: Inneholder den andre verdien som forekommer i &variabel
....
&variabel._9: Inneholder den niende verdien som forekommer i &variabel



&variabel._1_teller: Inneholder antall ganger verdien i &variabel_1 forekommer
&variabel._2_teller: Inneholder antall ganger verdien i &variabel_2 forekommer
....
&variabel._9_teller: Inneholder antall ganger verdien i &variabel_9 forekommer

-------------------------------------

&utdata._oversikt gir en oppsummering med en rad pr PID.


## Forfatter

Hanne Sigrun

*/

%macro telle_pr_PID(inndata=, utdata=,variabel=, type=n);

proc sort data=&inndata;
by pid &variabel;
quit;

data &inndata._unik;
set &inndata;
by pid &variabel;

if first.pid then unik=1; 
if first.pid then oppholdsnr=0;
	oppholdsnr+1;

if first.&variabel then do;
	if not missing(&variabel) then unik_&variabel=1;
end;

if first.pid then &variabel._teller=0;
	if first.&variabel then &variabel._teller=0;
	&variabel._teller+1;

run;

data temp1;
set &inndata._unik;

if oppholdsnr=1 then do; 
	&variabel._1=&variabel;
end;
else do;
	if missing(&variabel._1) then do; 
		&variabel._1=&variabel;
	end;
	else do;
		&variabel._1=&variabel._1;
	end;
end;
		
retain &variabel._1;

run;

data temp2;
set temp1;

if oppholdsnr=1 then do;
	if &type='c' then do;
		length &variabel._2 $20;
	end;
	call missing(&variabel._2);
end;
else do;
	&variabel._2=&variabel._2;
	if missing(&variabel._2) then do;
		if &variabel ne &variabel._1 and not missing(&variabel) then &variabel._2=&variabel;
	end;
end;

retain &variabel._2;

run;

data temp3;
set temp2;

if oppholdsnr=1 then do;
	if &type='c' then do;
		length &variabel._3 $20;
	end;
	call missing(&variabel._3);
end;
else do;
	&variabel._3=&variabel._3;
	if missing(&variabel._3) and not missing(&variabel._2) then do;
		if &variabel ne &variabel._1 and &variabel ne &variabel._2 and not missing(&variabel) then &variabel._3=&variabel;
	end;
end;

retain &variabel._3;

run;

data temp4;
set temp3;

if oppholdsnr=1 then do;
	if &type='c' then do;
		length &variabel._4 $20;
	end;
	call missing(&variabel._4);
end;
else do;
	&variabel._4=&variabel._4;
	if missing(&variabel._4) and not missing(&variabel._3) then do;
		if &variabel ne &variabel._1 and &variabel ne &variabel._2 and &variabel ne &variabel._3 and not missing(&variabel) then &variabel._4=&variabel;
	end;
end;

retain &variabel._4;

run;

data temp5;
set temp4;

if oppholdsnr=1 then do;
	if &type='c' then do;
		length &variabel._5 $20;
	end;
	call missing(&variabel._5);
end;
else do;
	&variabel._5=&variabel._5;
	if missing(&variabel._5) and not missing(&variabel._4) then do;
		if &variabel ne &variabel._1 and &variabel ne &variabel._2 and &variabel ne &variabel._3 and &variabel ne &variabel._4 and not missing(&variabel) then &variabel._5=&variabel;
	end;
end;

retain &variabel._5;

run;

data temp6;
set temp5;

if oppholdsnr=1 then do;
	if &type='c' then do;
		length &variabel._6 $20;
	end;
	call missing(&variabel._6);
end;
else do;
	&variabel._6=&variabel._6;
	if missing(&variabel._6) and not missing(&variabel._5) then do;
		if &variabel ne &variabel._1 and &variabel ne &variabel._2 and &variabel ne &variabel._3 
		and &variabel ne &variabel._4 and &variabel ne &variabel._5 and not missing(&variabel) then &variabel._6=&variabel;
	end;
end;

retain &variabel._6;

run;

data temp7;
set temp6;

if oppholdsnr=1 then do;
	if &type='c' then do;
		length &variabel._7 $20;
	end;
	call missing(&variabel._7);
end;
else do;
	&variabel._7=&variabel._7;
	if missing(&variabel._7) and not missing(&variabel._6) then do;
		if &variabel ne &variabel._1 and &variabel ne &variabel._2 and &variabel ne &variabel._3 
		and &variabel ne &variabel._4 and &variabel ne &variabel._5  and &variabel ne &variabel._6 and not missing(&variabel) then &variabel._7=&variabel;
	end;
end;

retain &variabel._7;

run;

data temp8;
set temp7;

if oppholdsnr=1 then do;
	if &type='c' then do;
		length &variabel._8 $20;
	end;
	call missing(&variabel._8);
end;
else do;
	&variabel._8=&variabel._8;
	if missing(&variabel._8) and not missing(&variabel._7) then do;
		if &variabel ne &variabel._1 and &variabel ne &variabel._2 and &variabel ne &variabel._3 
		and &variabel ne &variabel._4 and &variabel ne &variabel._5 and &variabel ne &variabel._6 and &variabel ne &variabel._7 and not missing(&variabel) then &variabel._8=&variabel;
	end;
end;

retain &variabel._8;

run;

data &utdata;
set temp8;

if oppholdsnr=1 then do;
	if &type='c' then do;
		length &variabel._9 $20;
	end;
	call missing(&variabel._9);
end;
else do;
	&variabel._9=&variabel._9;
	if missing(&variabel._9) and not missing(&variabel._8) then do;
		if &variabel ne &variabel._1 and &variabel ne &variabel._2 and &variabel ne &variabel._3 
		and &variabel ne &variabel._4 and &variabel ne &variabel._5 and &variabel ne &variabel._6 
		and &variabel ne &variabel._7 and &variabel ne &variabel._8 and not missing(&variabel) then &variabel._9=&variabel;
	end;
end;

if not missing(&variabel._1) and missing(&variabel._2) and missing(&variabel._3) and missing(&variabel._4) and missing(&variabel._5)
 and missing(&variabel._6) and missing(&variabel._7) and missing(&variabel._8) and missing(&variabel._9) then &variabel._1_teller=&variabel._teller;

if not missing(&variabel._2) and missing(&variabel._3) and missing(&variabel._4) and missing(&variabel._5)
 and missing(&variabel._6) and missing(&variabel._7) and missing(&variabel._8) and missing(&variabel._9) then &variabel._2_teller=&variabel._teller;

if not missing(&variabel._3) and missing(&variabel._4) and missing(&variabel._5)
 and missing(&variabel._6) and missing(&variabel._7) and missing(&variabel._8) and missing(&variabel._9) then &variabel._3_teller=&variabel._teller;

if not missing(&variabel._4) and missing(&variabel._5)
 and missing(&variabel._6) and missing(&variabel._7) and missing(&variabel._8) and missing(&variabel._9) then &variabel._4_teller=&variabel._teller;

if not missing(&variabel._5) and missing(&variabel._6) and missing(&variabel._7) and missing(&variabel._8) and missing(&variabel._9) then &variabel._5_teller=&variabel._teller;

if not missing(&variabel._6) and missing(&variabel._7) and missing(&variabel._8) and missing(&variabel._9) then &variabel._6_teller=&variabel._teller;

if not missing(&variabel._7) and missing(&variabel._8) and missing(&variabel._9) then &variabel._7_teller=&variabel._teller;

if not missing(&variabel._8) and missing(&variabel._9) then &variabel._8_teller=&variabel._teller;

if not missing(&variabel._9) then &variabel._9_teller=&variabel._teller;

retain &variabel._9;

run;

proc delete data=temp1-temp8 &inndata._unik;
quit;

PROC SQL;
   CREATE TABLE &utdata._oversikt AS 
   SELECT DISTINCT pid, MAX(oppholdsnr) AS ant_kontakter,
				MAX(&variabel._1) AS &variabel.1, max(&variabel._1_teller) as ant_&variabel._1,
   				MAX(&variabel._2) AS &variabel.2, max(&variabel._2_teller) as ant_&variabel._2,
				MAX(&variabel._3) AS &variabel.3, max(&variabel._3_teller) as ant_&variabel._3,
				MAX(&variabel._4) AS &variabel.4, max(&variabel._4_teller) as ant_&variabel._4,
				MAX(&variabel._5) AS &variabel.5, max(&variabel._5_teller) as ant_&variabel._5,
				MAX(&variabel._6) AS &variabel.6, max(&variabel._6_teller) as ant_&variabel._6,
				MAX(&variabel._7) AS &variabel.7, max(&variabel._7_teller) as ant_&variabel._7,
				MAX(&variabel._8) AS &variabel.8, max(&variabel._8_teller) as ant_&variabel._8,
				MAX(&variabel._9) AS &variabel.9, max(&variabel._9_teller) as ant_&variabel._9
	FROM &utdata
      GROUP BY pid;
QUIT;

%mend telle_pr_PID;
