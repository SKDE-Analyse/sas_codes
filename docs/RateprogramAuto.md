%let filbane=/sas_smb/skde_analyse/Data/SAS/felleskoder/main;
options sasautos=("&filbane/makroer" SASAUTOS);

%include "&filbane/formater/bo.sas";

%include "&filbane/stiler/stil_figur.sas";
%include "&filbane/stiler/Anno_logo_kilde_NPR_SSB.sas";

%include "&filbane/rateprogram/proc_stdrate.sas";
%proc_stdrate(dsn=, rate_var=, standardaar=, start=, slutt=, utdata=);

%proc_stdrate(
    dsn=, /*Grunnlagsdatsettet det skal beregnes rater fra*/
    rate_var=, /*Ratevariabel, kan være aggregert (verdier større enn en) eller dikotom (0,1)*/
    bo=bohf, /*BoHf, BoRHF eller BoShHN, BoHf er default*/
    alder_min=0, /*Laveste alder i utvalget, 0 er default*/
    alder_max=105, /*Høyeste alder i utvalget, 105 er default*/
    rmult=1000, /*Ratemultiplikator, dvs rate pr, 1000 er default*/
    indirekte=, /*Settes lik 1 dersom indirekte, ellers direkte metode, direkte er default*/
    standardaar=, /*Standardiseringsår*/
    start=, /*Startår*/
    slutt=, /*Sluttår*/
    utdata=, /*Navn på utdatasett, utdatasettet er på "wide" form*/
    long=, /*if long=1 --> skriv ut "langt" datasett, ikke aktivert er default*/
    innbygg_dsn=innbygg.INNB_SKDE_BYDEL, /*Innbyggerdatasett: innbygg.INNB_SKDE_BYDEL, innbygg.INNB_SKDE_BYDEL er default*/
    /*Til boområde-makroen: Standard er:(inndata=pop, indreOslo = 0, bydel = 1);*/
    bodef_indreoslo=0, /*0 er standard, 0 er default*/
    bodef_bydel=1 /*1 er standard, 1 er default*/
);

/*! 
### Beskrivelse

Makro for å beregne rater

```
kortversjon (kjøres med default verdier for resten)
%proc_stdrate(dsn=, rate_var=, standardaar=, start=, slutt=, utdata=);
```
### Input
- datasett med variabel det skal beregnes rater på, 
	- kan være 0,1 variabel eller aggregert
	- må innheolde bo-nivået det skal kjøres rater på

### Output
- &utdata + evt. long_&utdata

### Endringslogg:
- februar 2022 opprettet, Frank
*/