%macro loop_kodeverk;
    /*! 
    ### Beskrivelse
    
    Makro for å lese inn laboratoriekodeverk som gir rett til refusjon.
    Filen vil inneholde alt fra laboratoriekodeverk, dvs mer enn medisinsk biokjemi. 
    For å ta ut det som gjelder medisinsk biokjemi: sett variabel MB = "MB"
    
    ```
    %loop_kodeverk;
    ```
    
    ### Input 
          - Leser inn CSV-filer som ligger lagret i mappe angitt i makroen: 
    
    ### Output 
          - SKDE20.LAB_kodeverk_2018_2023 
    
    ### Endringslogg:
        - Opprettet mai 2024, Tove J
        
     */

/*angi mappe hvor filene skal leses inn*/
%let path=/sas_smb/skde_analyse/Helseatlas/Lab/Laboratoriekodeverk/laboratoriekodeverk_2018_2023;
filename folder "&path" ;       
options validmemname=extend;
 
/* Liste over filer i folder */
data FilesInFolder;
   length Line 8 File $300;
   List = dopen('folder');  /* corrected the function argument */
   do Line = 1 to dnum(List);
        File = trim(dread(List,Line));
        output;
   end;
   drop list line;
run;
 
/* global macro variabler */  
data _NULL_;
     set FilesInFolder end=final;
     call symput(cats('File', _N_), trim(File));     
     call symput(cats('Name', _N_), trim(nliteral(substr(File,1,min(32, length(File)-4))))); 
     if final then call symputx(trim('Total'), _N_); 
run;


%macro loop;
%do i = 1 %to &Total;   

data work.&&name&i;
  infile "&path/&&File&i"
  delimiter=';'
  missover
  firstobs=2
  ENCODING="Windows-1252"
  DSD;
    FORMAT
        KODE             $CHAR8.
        TILDATO          MMDDYY10.
        FRADATO          DDMMYY10.
        ERSTATTES_AV     $CHAR8.
        SIST_ENDRET      DDMMYY10.
        HVA_ENDRET       $CHAR119.
        NORSK_BRUKSNAVN  $CHAR76.
        KOMPONENT        $CHAR123.
        SYSTEM           $CHAR30.
        ENHET            $CHAR37.
        EGENSKAPSART     $CHAR96.
        SPESIFISERT_KOMPONENT $CHAR27.
        NPU_DEFINISJON   $CHAR170.
        SPESIALITET_NPU  $CHAR3.
        SEKUNDAERT_FAGOMRAADE $CHAR33.
        FAGOMRAADE_NLK   $CHAR33.
        REFUSJONSKATEGORI $CHAR4.
        REFUSJON         BEST7.
        UGYLDIG_KOMB     $CHAR1.
        STJERNEKODE      BEST1.
        F21              $CHAR1. ;
 
 INPUT
        KODE             : $CHAR8.
        TILDATO          : ?? MMDDYY10.
        FRADATO          : ?? DDMMYY10.
        ERSTATTES_AV     : $CHAR8.
        SIST_ENDRET      : ?? DDMMYY10.
        HVA_ENDRET       : $CHAR119.
        NORSK_BRUKSNAVN  : $CHAR76.
        KOMPONENT        : $CHAR123.
        SYSTEM           : $CHAR30.
        ENHET            : $CHAR37.
        EGENSKAPSART     : $CHAR96.
        SPESIFISERT_KOMPONENT : $CHAR27.
        NPU_DEFINISJON   : $CHAR170.
        SPESIALITET_NPU  : $CHAR3.
        SEKUNDAERT_FAGOMRAADE : $CHAR33.
        FAGOMRAADE_NLK   : $CHAR33.
        REFUSJONSKATEGORI : $CHAR4.
        REFUSJON         : ?? COMMAX7.
        UGYLDIG_KOMB     : $CHAR1.
        STJERNEKODE      : ?? BEST1.
        F21              : $CHAR1. ;
RUN;

  %end;
%mend loop;


/*slette datasett i work med navn som starter på "lab"*/
/*nødvendig for å sikre at ikke andre datasett i work som starter på lab blir tatt med i produksjon av kodeverk*/
proc datasets nolist;
delete 
lab: ;
run;

%LOOP;

/*Hente datovariabel og offentlig/privat fra datasettnavn. Samle alt kodeverk i en fil*/
data kodeverk;
set Lab: (keep=kode fagomraade_NLK Norsk_bruksnavn komponent system refusjonskategori refusjon stjernekode) indsname=complete_name;

date_id = scan(complete_name, 3, '_');
refkat=scan(complete_name, 2, '_');
/* hjelpevariabel: angi Medisinsk biokjemi refusjonskategori */
MB = substr(left(put(refusjonskategori,$char4.)),1,2);
if MB ne "MB" then MB = "";
run;

/*Endre fra char til dato*/
Data kodeverk2 (drop=date_id);
set kodeverk;
Dato_id = input(date_id, DDMMYY10.);
format dato_id date9.;
run;

/*Hente opp dato fra raden under mhp. å lage gyldighetsperiode for kode*/
Proc sort data=kodeverk2;
by kode refkat dato_id ;  /*Samler offentlig og privat*/
run;

data temp;
set kodeverk2;
by kode refkat dato_id;
if first.kode then x =1;
else x + 1;
run;

proc sort data = temp;
by kode descending x;
run;

data temp2;
set temp;
by kode descending x;
l = lag(x); /*Til kontroll*/
Dato_slutt = lag(Dato_id);
if first.kode then do;
l = .;
dato_slutt= "31dec2023"d;
end;
format Dato_slutt date9.;
run;

proc sort data = temp2;
by kode x;
run;

/* format */
proc format;
value offpriv 
1="off"
2="priv"
run;

/*Lagrer kodeverk*/
Data skde20.LAB_kodeverk_2018_2023 (drop=x l refkat);
set temp2;
if refkat="STAT" then Ref_kat=1;
if refkat="PRIV" then Ref_kat=2;
format Ref_kat offpriv.;
run;
/* slette datasettene fra work */
proc datasets nolist;
delete 
lab: kodeverk: temp: filesinfolder ;
run;
%mend loop_kodeverk;