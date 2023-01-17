%macro radiologi_utvalg;
/*! 
### Beskrivelse

Makro for å kode opp undersøkelser radiologi. 
Må kjøres inni et datasteg.

```
%radiologi_utvalg;
```

### Endringslogg:
    - Opprettet desember 2022, Tove
	- lagt til riksrevisjonsutvalg + noen andre, januar 2023, Tove
 */

array nc {*} ncrp: ;
	do i=1 to dim(nc);

/* ---------------------------------------------------------------------------------------------------------------------------------------- */
/* Riksrevisjon utvalg - side 91 og 92 i rapporten (https://www.riksrevisjonen.no/globalassets/rapporter/no-2016-2017/bildediagnostikk.pdf) */
/* ---------------------------------------------------------------------------------------------------------------------------------------- */

/* NEVRORADIOLOGI */
		if substr(nc{i},1,6) in ('SAA0AH'/*MRA arteriografi av caput*/,'SAA0AQ'/*MRANG angiografi av caput*/,
								'SAA0AJ' /*MRV venografi av caput*/'SAA0AQ'/*MRANG angiografi av caput*/,
								'SAA0AG' /*MR caput*/,
								'SAA0GH'/*MR caput og MRA arteriografi av caput*/,'SAA0GQ'/*MR caput og MRANG angiografi av caput*/)		then MR_caput=1;
		if substr(nc{i},1,6) in ('SNA0GG'/*mr korsrygg*/ 																					then MR_lumbosakral=1;
		if substr(nc{i},1,6) in ('SNA0AG'/*mr halsdelen av ryggraden*/ 																		then MR_cervikalkol=1;
		if substr(nc{i},1,6) in ('SNA0BG'/*mr brystdelen av ryggraden*/ 																	then MR_torakalkol=1;
		if substr(nc{i},1,6) in ('SNA0KG'/*mr hele ryggraden*/ 																				then MR_totalkol=1;

		if substr(nc{i},1,6) in ('SAA0AD'/*ct hode*/,
								'SAA0DE'/*ct caput og cta arteriografi av caput*/,'SAA0DP'/*ct caput og CTANG angiografi av caput*/)		then CT_caput=1;
		if substr(nc{i},1,6) in ('SNA0GD'/*ct korsrygg*/) 																					then CT_lumbosakral=1;
		if substr(nc{i},1,6) in ('SNA0AD'/*ct halsdelen av ryggraden*/) 																	then CT_cervikalkol=1;

/* MUSKEL OG SKJELETT */
		if substr(nc{i},1,6) in ('SNG0AG')                                      															then MR_kne=1; 
		if substr(nc{i},1,6) in ('SNB0BG')                                      															then MR_skulder=1; 
		if substr(nc{i},1,6) in ('SSE0AG')                                      															then MR_bekken=1; 
		if substr(nc{i},1,6) in ('SNF0AG' /*mr hofte*/, 
                                'SSM0AG' /*mr bekken og underekstremiteter*/)      															then MR_hofte=1; 
		if substr(nc{i},1,6) in ('SND0AG' /*mr håndledd og håndrot*/, 
                                'SND0BG' /*mr hånd og fingre*/)                    															then MR_hand=1; 
		if substr(nc{i},1,6) in ('SNH0BG')                                      															then MR_ankel=1; 
		if substr(nc{i},1,6) in ('SNH0AG')                                      															then MR_fot=1; 

		if substr(nc{i},1,6) in ('SNE0BG'/*ledd mellom nederste del av ryggrad og hoftekammene*/)											then MR_iliosakral=1; 
		if substr(nc{i},1,6) in ('SNC0AG')                                      															then MR_albue=1; 

/* TORAKS, ABDOMEN OG KAR */
		if substr(nc{i},1,6) in ('SSQ0AD'/*ct toraks, abdomen og bekken*/)         															then CT_toraks_abdom_bekken=1; 
		if substr(nc{i},1,6) in ('SSC0AD'/*ct toraks*/,'SSD0AD'/*ct abdomen*/,'SSE0AD'/*ct bekken*/)                               			then CT_toraks_abdom_bekken=1; 
		if substr(nc{i},1,6) in ('SSL0AD'/*ct abdomen og bekken*/,'SSC0AD'/*ct toraks*/)      			                         			then CT_toraks_abdom_bekken=1; 
		if substr(nc{i},1,6) in ('SSK0AD'/*ct toraks og abdomen*/,'SSE0AD'/*ct bekken*/)      			                         			then CT_toraks_abdom_bekken=1; 

		if substr(nc{i},1,6) in ('SSL0AD'/*ct abdomen og bekken*/)  /*hvis toraks -> ekskludering*/               							then CT_abdom_bekken=1; 
		if substr(nc{i},1,6) in ('SSD0AD'/*ct abdomen*/,'SSE0AD'/*ct bekken*/)        						                       			then CT_abdom_bekken=1; 

		if substr(nc{i},1,6) in ('SSK0AD'/*ct toraks og abdomen*/)   /*hvis bekken -> ekskludering*/                      					then CT_toraks_abdom=1; 
		if substr(nc{i},1,6) in ('SSC0AD'/*ct toraks*/,'SSD0AD'/*ct abdomen*/)        						                       			then CT_toraks_abdom=1; 

		if substr(nc{i},1,6) in ('SKX0AD'/*ct urinveier*/)        						                       								then CT_urinveier=1; 
		if substr(nc{i},1,6) in ('SJF0BD'/*ct tykktarm*/)        						                       								then CT_tykktarm=1; 

		if substr(nc{i},1,6) in ('SKE0AG')                                      															then MR_prostata=1; 
		if substr(nc{i},1,6) in ('SSB0AD')                                      															then CT_hals=1; 
		if substr(nc{i},1,6) in ('SST0AD')                                      															then CT_hals_toraks_abdom_bekken=1; 

/* DIVERSE */
		if substr(nc{i},1,6) in ('SDX0AD')                                      															then CT_bihuler=1; 
		if substr(nc{i},1,6) in ('SDE0AG')                                      															then MR_tinningben=1; 
		if substr(nc{i},1,6) in ('SAF0AD')                                      															then CT_ansikt=1; 

/* ------------------- */
/* ANDRE PASIENTUTVALG */
/* ------------------- */

/* MR */
		if substr(nc{i},1,6) in ('SJF0AG')				        				then MR_tynntarm=1; 
		if substr(nc{i},1,6) in ('SJF0BG')				        				then MR_tykktarm=1; 
		if substr(nc{i},1,6) in ('SSB0AG')                                 		then MR_hals=1; 
		if substr(nc{i},1,6) in ('SST0AG')                                 		then MR_hals_toraks_abdom_bekken=1; 
		if substr(nc{i},1,6) in ('SDX0AG')                                      then MR_bihuler=1; 
		if substr(nc{i},1,6) in ('SAF0AG')                                      then MR_ansikt=1; 

		if substr(nc{i},1,6) in ('SNA0EG')                                      then MR_cervikal_torakal=1; 
		if substr(nc{i},1,6) in ('SNA0FG')                                      then MR_torakal_lumbal=1; 
		if substr(nc{i},1,6) in ('SNA0HG')                                      then MR_cerv_tora_lumbal=1; 
		if substr(nc{i},1,6) in ('SNA0JG')                                      then MR_tora_lumbosakral=1; 
		if substr(nc{i},1,6) in ('SNA0LG')                                      then MR_caput_totalkol=1; 
		if substr(nc{i},1,6) in ('SNA0MG')                                      then MR_totalkol_bekken=1; 
		if substr(nc{i},1,6) in ('SNA0NG'/*ny i 2017, ingen tidl kode*/)        then MR_caput_delkolumna=1; 
		if substr(nc{i},1,6) in ('SNA0PG'/*ny i 2017, ingen tidl kode*/)        then MR_caput_kolumna_overekstr=1; 
		if substr(nc{i},1,6) in ('SNA0SG'/*ny i 2017, ingen tidl kode*/)        then MR_cervikal_lumbosakral=1; 
		if substr(nc{i},1,6) in ('SNA0TG'/*ny i 2017, ingen tidl kode*/)        then MR_bekken_delkomuna=1; 

/* CT */
		if substr(nc{i},1,6) in ('SNG0AD')                                     	then CT_kne=1; 
		if substr(nc{i},1,6) in ('SNH0BD')                                      then CT_ankel=1; 
		if substr(nc{i},1,6) in ('SNH0AD')                                      then CT_fot=1; 
		if substr(nc{i},1,6) in ('SNE0BD')                                      then CT_iliosakral=1; 
		if substr(nc{i},1,6) in ('SNC0AD')                                      then CT_albue=1; 
		if substr(nc{i},1,6) in ('SJF0AD')        								then CT_tynntarm=1; 
		if substr(nc{i},1,6) in ('SDE0AD')                                     	then CT_tinningben=1; 
    end;

/*CT abdomen og  bekken, gitt at det ikke er utført ct toraks*/
if CT_abdom_bekken eq 1 and (CT_toraks_abdom_bekken eq 1 or CT_toraks_abdom eq 1) then CT_abdom_bekken =.; 
/* CT toraks og abdomen, gitt at det ikke er utført CT bekken */
if CT_toraks_abdom eq 1 and (CT_toraks_abdom_bekken eq 1 or CT_abdom_bekken eq 1) then CT_toraks_abdom =.;

if MR_cervikalkol eq 1 or MR_torakalkol eq 1 or MR_cervikal_torakal eq 1 or MR_torakal_lumbal eq 1 or 
    MR_lumbosakral eq 1 or MR_cerv_tora_lumbal eq 1 or MR_totalkol eq 1 or MR_tora_lumbosakral eq 1 or
    MR_caput_totalkol eq 1 or MR_totalkol_bekken eq 1 or MR_caput_delkolumna eq 1 or MR_caput_kolumna_overekstr eq 1 or
    MR_cervikal_lumbosakral eq 1 or MR_bekken_delkomuna eq 1                    
                                                                                then MR_nakke_rygg = 1;

/* forløpspasienter */
if MR_nakke_rygg eq 1 or MR_kne eq 1 or MR_skulder eq 1 or MR_prostata eq 1 	then forlop_pas = 1;

%mend radiologi_utvalg;