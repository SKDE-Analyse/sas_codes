/*-----------------------------------------
Legge til Antall_opphold på PID
Opprettet av FO august 2012
Redigert FO 17/10-2012

1. Sorter data på PID og descending på Oppholdsvariabel og på Inndato og Utdato
2. Legg til oppholdsnummer (og slett oppholdsnummer for opphold med missing oppholdsvariabel)
3. Sorter på PID og Oppholdsnr (desending)
4. Lag Antall_opphold variabel
5. Sorter tilbake på PID, ascending oppholdsnr
------------------------------------------*/

proc sort data=utvalg1;
by PID descending oppholdsvariabel Inndato Utdato; /* 1.Sortering */
run;

data utvalg1;
set utvalg1;
by PID descending oppholdsvariabel Inndato Utdato; /* 2.Legger til Oppholdsnr */
if first.PID=1 then oppholdsnr=0;
oppholdsnr+1;
if oppholdsvariabel=. then oppholdsnr=.; /* 2.Sletter oppholdsnr for opphold med missing oppholdsvariabel - kan strykes*/
run;


proc sort data=utvalg1;
	by PID descending Oppholdsnr; /* 3.Sorter på PID og Oppholdsnr (desending) */
run;

data utvalg1;
	set utvalg1;
	by PID;
	if first.PID=1 then Antall_Opphold=Oppholdsnr; /* 4. Lag Antall_opphold variabel */
	Antall_Opphold+0;
run;

proc sort data=utvalg1;
	by PID ascending oppholdsnr; /* 5. Sorter tilbake på PID, ascending oppholdsnr */
run;