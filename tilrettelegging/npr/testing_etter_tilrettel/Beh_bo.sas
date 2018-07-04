/*****************************
*** Sjekke behandlingssted ***
*****************************/

%macro behandlingssted (mottatt=, aar=);

ods excel options (sheet_name="&mottatt._&aar.");

PROC TABULATE
DATA=NPR_SKDE.&mottatt._Magnus_Avd_&aar.;	
	CLASS BehRHF /	ORDER=UNFORMATTED MISSING;
	CLASS BehHF /	ORDER=UNFORMATTED MISSING;
	CLASS behSh /	ORDER=UNFORMATTED MISSING;
	CLASS behandlingsstedKode2 /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
BehRHF* BehHF* behSh* behandlingsstedKode2,
/* Column Dimension */
N;
RUN;

%mend behandlingssted;

ods excel file="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\data\SAS\Tilrettelegging\Somatikk\Tilrettelegging_2018\Magnus_Avd_BEH.xlsx";

%behandlingssted (mottatt=T18, aar=2017);

%behandlingssted (mottatt=T17, aar=2016);
%behandlingssted (mottatt=T18, aar=2016);

%behandlingssted (mottatt=T17, aar=2015);
%behandlingssted (mottatt=T18, aar=2015);

%behandlingssted (mottatt=T17, aar=2014);
%behandlingssted (mottatt=T18, aar=2014);

%behandlingssted (mottatt=T17, aar=2013);
%behandlingssted (mottatt=T18, aar=2013);

%behandlingssted (mottatt=T17, aar=2012);

ods excel close;

/*Haraldsplass Diakonale Sykehus AS er et av tre store private ikke-kommersielle sykehus i Norge. Sykehuset er en del av 
det offentlige helsetilbudet gjennom driftsavtale med Helse Vest RHF. Sykehuset tilbyr spesialisthelsetjenester innen 
indremedisin, kirurgi, ortopedi og radiologi med tilhørende poliklinisk aktivitet. Vi har spesialkompetanse innen geriatri 
og regionsfunksjon innen lindrende behandling (Sunniva senter). Vi tar i mot henvisninger til planlagt behandling innenfor 
utvalgte medisinske, kirurgiske og ortopediske områder.*/

/*Vi har øyeblikkelig hjelp funksjon innen indremedisin og kirurgi, og er lokalsykehus for bydelene 
Åsane, Arna, og Bergenhus, samt Samnanger og kommunene i Nordhordland.*/


/********************
*** Sjekke bosted ***
********************/

%macro bosted (mottatt=, aar=);

ods excel options (sheet_name="&mottatt._&aar.");

PROC TABULATE
DATA=NPR_SKDE.&mottatt._Magnus_Avd_&aar.;	
	CLASS BoRHF /	ORDER=UNFORMATTED MISSING;
	CLASS BoHF /	ORDER=UNFORMATTED MISSING;
	CLASS boShHN /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
BoRHF* BoHF* boShHN,
/* Column Dimension */
N;
RUN;


PROC TABULATE
DATA=NPR_SKDE.T17_Magnus_Avd_&aar.;	
	CLASS  KomNr /	ORDER=UNFORMATTED MISSING;
	CLASS bydel /	ORDER=UNFORMATTED MISSING;
	TABLE /* Row Dimension */
komNr* bydel ,
/* Column Dimension */
N;
RUN;

%mend bosted;

ods excel file="\\hn.helsenord.no\UNN-Avdelinger\SKDE.avd\Analyse\data\SAS\Tilrettelegging\Somatikk\Tilrettelegging_2018\Magnus_Avd_BO.xlsx";

%bosted (mottatt=T18, aar=2017);

%bosted (mottatt=T17, aar=2016);
%bosted (mottatt=T18, aar=2016);

%bosted (mottatt=T17, aar=2015);
%bosted (mottatt=T18, aar=2015);

%bosted (mottatt=T17, aar=2014);
%bosted (mottatt=T18, aar=2014);

%bosted (mottatt=T17, aar=2013);
%bosted (mottatt=T18, aar=2013);

%bosted (mottatt=T17, aar=2012);

ods excel close;