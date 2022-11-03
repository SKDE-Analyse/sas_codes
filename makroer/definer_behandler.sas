%macro definer_behandler(dsn=);

/*!

Makro for å definere behandlende sykehus i Helse Nord, der det skilles på
eget lokalsykehus og andre sykehus etter følgende inndeling:

```sas
1="Eget lokalsykehus"
2="UNN Tromsø"
3="NLSH Bodø"
4="Annet sykehus i eget HF"
5="Annet HF i HN"
6="HF i andre RHF"
7="Private sykehus"
8="Avtalespesialister"
9="UNN HF"
10="NLSH HF"
```

Hvis sykehus er kodet på HF-nivå så kodes det som eget lokalsykehus.

*/

proc format;
value behandler
1="Eget lokalsykehus"
2="UNN Tromsø"
3="NLSH Bodø"
4="Annet sykehus i eget HF"
5="Annet HF i HN"
6="HF i andre RHF"
7="Private sykehus"
8="Avtalespesialister"
9="UNN HF"
10="Nordlandssykehuset HF";


data &dsn;
set &dsn;

/*
Kirkenes
*/
If BoSHHN=1 then do;
	If BehSh in (10,11) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (12) then Behandler=4;
	else if BehSh in (22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Hammerfest
*/
If BoSHHN=2 then do;
	If BehSh in (10,12) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (11) then Behandler=4;
	else if BehSh in (22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Tromsø
*/
If BoSHHN=3 then do;
	If BehSh in (21,24,25,26) then Behandler=1;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (22,23) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Harstad
*/
If BoSHHN=4 then do;
	If BehSh in (22) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (23) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Narvik
*/
If BoSHHN=5 then do;
	If BehSh in (23) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (22) then Behandler=4;
	else if BehSh in (10,11,12,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Vesterålen
*/
If BoSHHN=6 then do;
	If BehSh in (31) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH=32 then Behandler=4;
	else if BehSh in (10,11,12,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Lofoten
*/
If BoSHHN=7 then do;
	If BehSh in (32) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH=31 then Behandler=4;
	else if BehSh in (10,11,12,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Bodø
*/
If BoSHHN=8 then do;
	If BehSh in (33) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSH in (31,32) then Behandler=4;
	else if BehSh in (10,11,12,22,23,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Rana
*/
If BoSHHN=9 then do;
	If BehSh in (40,41) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (42,43) then Behandler=4;
	else if BehSh in (10,11,12,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Mosjøen
*/
If BoSHHN=10 then do;
	If BehSh in (40,42) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (41,43) then Behandler=4;
	else if BehSh in (10,11,12,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Sandnessjøen
*/
If BoSHHN=11 then do;
	If BehSh in (40,43) then Behandler=1;
	else if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSH in (41,42) then Behandler=4;
	else if BehSh in (10,11,12,22,23,31,32) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

/*
Utenfor Helse Nord
*/
If BoSHHN=12 then do;
	if BehSh in (21,24,25,26) then Behandler=2;
	else if BehSh in (33) then Behandler=3;
	else if BehSh in (10,11,12,22,23,31,32,40,41,42,43) then Behandler=5;
	else if BehRHF in (2,3,4) then Behandler=6;
	else if BehRHF=5 then Behandler=7;
	else if BehRHF=6 then Behandler=8;
	else if BehSh in (20) then Behandler=9;
	else if BehSh in (30) then Behandler=10;
end;

format behandler behandler.;

run;

%mend;