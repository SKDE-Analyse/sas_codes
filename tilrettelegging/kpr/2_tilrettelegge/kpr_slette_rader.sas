%macro kpr_slette_rader(inndata=, utdata=);
/*! 
### Beskrivelse

Makroen gj�r f�lgende:
Hvis "kpr_lnr" er missing -> slette radene.

Makroen kj�res f�rst p� hovedfilen (regning), hvor det i steg 1 lages et datasett, "slette_.&aar", som inneholder alle "enkeltregning_lnr" hvor "kpr_lnr" er missing.
I steg 2 lages &utdata hvor kun "enkeltregning_lnr" som har "kpr_lnr" beholdes. 

N�r makroen brukes p� takst- eller diagnosefilene er det kun steg 2 som kj�res.
	- NB: m� kj�re tilrettelegging p� hovedfil (regning) f�r diagnose- og takstfil.
	- Bruker &aar. som suffix for � forhindre feil p� tvers av �rssettene
 
```
%kpr_slette_rader(inndata=, utdata=);
```
### Input 
      - inndata: mottatt datasett, f.eks HNMOT.KPR_L_ENKELTREGNING_2017_M21T2
	  - aar: �rssett det gjelder, f.eks 2017
      
### Output 
      - utdata: inndata hvor rader med manglende "kpr_lnr" er tatt ut
    
### Endringslogg:
    - Opprettet desember 2021, Tove
 */

/*----------------*/
/*-----STEG 1 ----*/
/*----------------*/
%if &sektor=regning %then %do; 
proc sql;
	create table slette_&aar. as
	select enkeltregning_lnr
	from &inndata
	where kpr_lnr eq . ;
quit;
%end;

/*----------------*/
/*-----STEG 2 ----*/
/*----------------*/
proc sql;
	create table &utdata as
	select *
	from &inndata
	where enkeltregning_lnr not in (select enkeltregning_lnr from slette_&aar.);
quit;

%mend;