/*use all the nokkel files to date to make a master key*/
/*
contains values of all previous keys received.  
nonmatch is a flag that shows if a given npr_lnr has more than one kpr_id (aside from missing)
If not, then create a new variable kpr_lnr as the confirmed value
*/

/*******************************************************************************************/
/*initial creation of the master key*/
/*no need to rerun, keep as documentation for which key is from which file*/
/*
proc sort data=hnnokkel.nokkel_2017_2021_m21t3 	out=nokkel_2017_2021_m21t3; by NPR_lnr; run;
proc sort data=hnnokkel.nokkel_2022_m22t1 		out=nokkel_2022_m22t1; 		by NPR_lnr; run;
proc sort data=hnnokkel.nokkel_2022_m22t2 		out=nokkel_2022_m22t2; 		by NPR_lnr; run;
proc sort data=hnnokkel.nokkel_2022_t3 			out=nokkel_2022_t3; 		by NPR_lnr; run;
proc sort data=hnnokkel.nokkel_2022t3_2023t1 	out=nokkel_2022t3_2023t1; 	by NPR_lnr; run;
proc sort data=hnnokkel.nokkel_2023_t2 			out=nokkel_2023_t2; 		by NPR_lnr; run;
proc sort data=hnnokkel.nokkel_2023_t3 			out=nokkel_2023_t3; 		by NPR_lnr; run;

data masterkey;
  merge nokkel_2017_2021_m21t3(in=a rename=(kpr_lnr=kpr_1721))
        nokkel_2022_m22t1     (in=b rename=(kpr_lnr=kpr_22t1))
        nokkel_2022_m22t2     (in=c rename=(kpr_lnr=kpr_22t2))
        nokkel_2022_t3        (in=e rename=(kpr_lnr=kpr_22t3_2))
        nokkel_2022t3_2023t1  (in=f rename=(kpr_lnr=kpr_23t1))
        nokkel_2023_t2        (in=g rename=(kpr_lnr=kpr_23t2))
        nokkel_2023_t3        (in=h rename=(kpr_lnr=kpr_23t3));
  by npr_lnr;
  if a or b or c or e or f or g or h;
run;

*a similar version of the following code was also run during the initial creation of the key to assign kpr_lnr;
*/
/*
Additional files that have been attached to the master file after the initial run:
%let new_key_file=HNNOKKEL.NOKKEL_2017_2023; 
%let new_key_file=HNNOKKEL.NOKKEL_2024_T3; 
%let new_key_file=HNNOKKEL.NOKKEL_2025_M08; 
%let new_key_file=HNNOKKEL.NOKKEL_2025_M10;
%let new_key_file=HNNOKKEL.NOKKEL_2025_M11;
*/
/*******************************************************************************************/

data hnnokkel.nokkel_2025_M11;
  set WORK.'Nøkkel_2025M11'n;
run;

/*maintaining the master key when receiving new file*/
%let new_key_file=HNNOKKEL.NOKKEL_2025_M11; * new file to be added to the exisiting master key;
%let var_flag=25m11;                     * kpr_lnr from new file to be added to the master key;

proc sort data=hnnokkel.master_key 	out=master_key; by NPR_lnr; run;
proc sort data=&new_key_file. 		out=nokkel_new; by NPR_lnr; run;

data new_master_key;
  merge master_key (in=a drop=nonmatch kpr_lnr)
        nokkel_new (in=b rename=(kpr_lnr=kpr_&var_flag.));
  by npr_lnr;
  if a or b;

    array vars {*} kpr_:;    /* Define an array for the variables */
    call sortn(of vars[*]);  /* Sort values in ascending order, ignoring missing */
    nonmatch = 0;            /* Initialize flag variable */
	kpr_lnr=.;               /* Initialize */

    /* Loop through the array to check for differing values */
    do i = 1 to dim(vars) - 1;
        if not missing(vars[i]) and not missing(vars[i+1]) and vars[i] ne vars[i+1] then do;
            nonmatch = 1; /* Flag the row */
            leave;        /* Exit the loop as we found a difference */
        end;
    end;

	/* For the line with no differing values, assign kpr_lnr */
    if nonmatch = 0 then do;
        do i = 1 to dim(vars);
            if not missing(vars[i]) then do;
                kpr_lnr = vars[i]; /* Assign the common value to kpr_lnr */
                leave;             /* Exit the loop after finding the first non-missing value */
            end;
        end;
    end;
    drop i; /* Drop the temporary loop index variable */
run;

/*double check that both NPR and KPR are unique*/
proc sort data=new_master_key nodupkey dupout=check_npr; by NPR_lnr; run;
proc sort data=new_master_key nodupkey dupout=check_kpr; by KPR_lnr; run;

/*check that there are no lines (npr) with multiple kpr*/
proc freq data=new_master_key;
  tables nonmatch;
run;

/*******************/
/******* STOP ******/
/* make sure previous steps run properlye before continuing */
/*******************/

/*once everything looks good, save the new master key to the server*/
/*data HNNOKKEL.MASTER_KEY;*/
/*  set new_master_key;*/
/*run;*/


/*******************/
/******* STOP ******/
/* make sure previous steps run properlye before continuing */
/*******************/

/*LOG*/
%let aar_periode   = 2025 - M11;     /*hvilken årgang har du tilrettelagt*/    
%let datakilde     = NPR/KPR;      /*hvilken kilde: NPR/KPR/HELFO/SSB*/
%let datasett      = Nøkkel;    /*hvilket datasett har du tilrettelagt eller endret. */              
%let ikke_standard = /*1*/;  /*Default er missing, hvis du har gjort manuelle endringer på filen før tilrettelegging kjøres, sett verdi til 1. Angi hva som er gjort i beskrivelsen*/ 
%let beskrivelse   = Innlesing av NPR-KPR nøkkel, og oppdatere master_key ;    /* Beskrivelse. Hvis det er gjort ikke-standard tilrettelegging angi hvorfor, eller hvis re-tilrettelegging av filer angi hvorfor.*/
%let bruker        = Janice Shu; /*angi deg selv, eller en annen hvis ønskelig! :)*/

data ny_logg;
    length aar_periode $20 datakilde $10 datasett $200 ikke_standard 3. beskrivelse $1000 bruker $50;
    format dato ddmmyy10.;

/* bruk systemtid*/
  dato = today() ; /*bruker systemtid*/

/* evnt sett dato manuelt*/
  *dato = input('10/12/2025',ddmmyy10.);

/*beskrivelse av tilrettelegging*/
  aar_periode = "&aar_periode";
  datakilde = "&datakilde";
  datasett = "&datasett";
  ikke_standard = "&ikke_standard";
  beskrivelse = "&beskrivelse";
  bruker = "&bruker";
run;
/*slå sammen ny loggføring med eksisterende logg på HNANA.*/
proc append base=HNANA.ABC_logg_tilrettelegging data=ny_logg; run;

/* Hold loggen sortert med nyeste først */
proc sort data=HNANA.ABC_logg_tilrettelegging;
  by descending dato;
run;