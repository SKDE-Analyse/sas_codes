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
	- lagt til flere koder fra KlokeValg og liknende, april 2023, Janice
 */

array nc_utv {*} ncrp: ;
	do i=1 to dim(nc_utv);

		if substr(nc_utv{i},1,6) in ('ZTX0BC') then sekgransk = 1;

/* ---------------------------------------------------------------------------------------------------------------------------------------- */
/* Riksrevisjon utvalg - side 91 og 92 i rapporten (https://www.riksrevisjonen.no/globalassets/rapporter/no-2016-2017/bildediagnostikk.pdf) */
/* ---------------------------------------------------------------------------------------------------------------------------------------- */

/* NEVRORADIOLOGI */
		if substr(nc_utv{i},1,6) in ('SAA0AH'/*MRA arteriografi av caput*/,'SAA0AQ'/*MRANG angiografi av caput*/,
								'SAA0AJ' /*MRV venografi av caput*/'SAA0AQ'/*MRANG angiografi av caput*/,
								'SAA0AG' /*MR caput*/,
								'SAA0GH'/*MR caput og MRA arteriografi av caput*/,'SAA0GQ'/*MR caput og MRANG angiografi av caput*/)		then MR_caput=1;
		if substr(nc_utv{i},1,6) in ('SNA0GG'/*mr korsrygg*/) 																				then MR_lumbosakral=1;
		if substr(nc_utv{i},1,6) in ('SNA0AG'/*mr halsdelen av ryggraden*/ )																then MR_cervikalkol=1;
		if substr(nc_utv{i},1,6) in ('SNA0BG'/*mr brystdelen av ryggraden*/ )																then MR_torakalkol=1;
		if substr(nc_utv{i},1,6) in ('SNA0KG'/*mr hele ryggraden*/ )																		then MR_totalkol=1;

		if substr(nc_utv{i},1,6) in ('SAA0AD'/*ct hode*/,
								'SAA0DE'/*ct caput og cta arteriografi av caput*/,'SAA0DP'/*ct caput og CTANG angiografi av caput*/)		then CT_caput=1;
		if substr(nc_utv{i},1,6) in ('SNA0GD'/*ct korsrygg*/) 																				then CT_lumbosakral=1;
		if substr(nc_utv{i},1,6) in ('SNA0AD'/*ct halsdelen av ryggraden*/) 																then CT_cervikalkol=1;

/* MUSKEL OG SKJELETT */
		if substr(nc_utv{i},1,6) in ('SNG0AG')                                      														then MR_kne=1; 
		if substr(nc_utv{i},1,6) in ('SNB0BG')                                      														then MR_skulder=1; 
		if substr(nc_utv{i},1,6) in ('SSE0AG')                                      														then MR_bekken=1; 
		if substr(nc_utv{i},1,6) in ('SNF0AG' /*mr hofte*/
								/*, 'SSM0AG' mr bekken og underekstremiteter - riksrevisjon har den, men vi tar den ut*/)      															
																																			then MR_hofte=1; 
		if substr(nc_utv{i},1,6) in ('SND0AG' /*mr håndledd og håndrot*/, 
                                'SND0BG' /*mr hånd og fingre*/)                    															then MR_hand=1; 
		if substr(nc_utv{i},1,6) in ('SNH0BG')                                      														then MR_ankel=1; 
		if substr(nc_utv{i},1,6) in ('SNH0AG')                                      														then MR_fot=1; 

		if substr(nc_utv{i},1,6) in ('SNE0BG'/*ledd mellom nederste del av ryggrad og hoftekammene*/)										then MR_iliosakral=1; 
		if substr(nc_utv{i},1,6) in ('SNC0AG')                                      														then MR_albue=1; 

		if substr(nc_utv{i},1,6) in ('SNB0BA') 																								then RG_skulder = 1;
		if substr(nc_utv{i},1,6) in ('SNB0BD') 																								then CT_skulder = 1;

/* TORAKS, ABDOMEN OG KAR */
		if substr(nc_utv{i},1,6) in ('SSC0AD'/*ct toraks*/) 																				then CT_toraks=1;
		if substr(nc_utv{i},1,6) in ('SSD0AD'/*ct abdomen*/) 																				then CT_abdom=1;
		if substr(nc_utv{i},1,6) in ('SSE0AD'/*ct bekken*/) 																				then CT_bekken=1;
		
		if substr(nc_utv{i},1,6) in ('SSQ0AD'/*ct toraks, abdomen og bekken*/)     															then CT_toraks_abdom_bekken=1;
		if substr(nc_utv{i},1,6) in ('SSL0AD'/*ct abdomen og bekken*/)             															then CT_abdom_bekken=1;
		if substr(nc_utv{i},1,6) in ('SSK0AD'/*ct toraks og abdomen*/)   																	then CT_toraks_abdom=1;

		if substr(nc_utv{i},1,6) in ('SKX0AD'/*ct urinveier*/)   																			then CT_urinveier=1; 
		if substr(nc_utv{i},1,6) in ('SJF0BD'/*ct tykktarm*/)  																				then CT_tykktarm=1; 

		if substr(nc_utv{i},1,6) in ('SKE0AG')  																							then MR_prostata=1; 
		if substr(nc_utv{i},1,6) in ('SSB0AD')  																							then CT_hals=1; 
		if substr(nc_utv{i},1,6) in ('SST0AD')  																							then CT_hals_toraks_abdom_bekken=1;

/* DIVERSE */
		if substr(nc_utv{i},1,6) in ('SDX0AD')                                      														then CT_bihuler=1; 
		if substr(nc_utv{i},1,6) in ('SDE0AG')                                      														then MR_tinningben=1; 
		if substr(nc_utv{i},1,6) in ('SAF0AD')                                      														then CT_ansikt=1; 

/* ------------------- */
/* ANDRE PASIENTUTVALG */
/* ------------------- */

/* MR */
		if substr(nc_utv{i},1,6) in ('SJF0AG')				        				then MR_tynntarm=1; 
		if substr(nc_utv{i},1,6) in ('SJF0BG')				        				then MR_tykktarm=1; 
		if substr(nc_utv{i},1,6) in ('SSB0AG')                                 		then MR_hals=1; 
		if substr(nc_utv{i},1,6) in ('SST0AG')                                 		then MR_hals_toraks_abdom_bekken=1; 
		if substr(nc_utv{i},1,6) in ('SDX0AG')                                      then MR_bihuler=1; 
		if substr(nc_utv{i},1,6) in ('SAF0AG')                                      then MR_ansikt=1; 
		if substr(nc_utv{i},1,6) in ('SJJ0AG') 										then mr_lever = 1; /* MR lever */
		if substr(nc_utv{i},1,6) in ('SKX0AG') 										then mr_urin = 1; /* MR urinveier */

		if substr(nc_utv{i},1,6) in ('SNA0AG') 										then mr_ck = 1; /* MR_cervikalkolumna (MR_ck) */
		if substr(nc_utv{i},1,6) in ('SNA0BG') 										then mr_tk = 1; /* MR_torakalkolumna (MR_tk) */
		if substr(nc_utv{i},1,6) in ('SNA0EG') 										then mr_ct = 1; /* MR_cervikal_torakalkol (MR_ct) */
		if substr(nc_utv{i},1,6) in ('SNA0EG')                                      then MR_cervikal_torakal=1; 
		if substr(nc_utv{i},1,6) in ('SNA0FG')                                      then MR_torakal_lumbal=1; 
		if substr(nc_utv{i},1,6) in ('SNA0HG')                                      then MR_cerv_tora_lumbal=1; 
		if substr(nc_utv{i},1,6) in ('SNA0JG')                                      then MR_tora_lumbosakral=1; 
		if substr(nc_utv{i},1,6) in ('SNA0LG')                                      then MR_caput_totalkol=1; 
		if substr(nc_utv{i},1,6) in ('SNA0MG')                                      then MR_totalkol_bekken=1; 
		if substr(nc_utv{i},1,6) in ('SNA0NG'/*ny i 2017, ingen tidl kode*/)        then MR_caput_delkolumna=1; 
		if substr(nc_utv{i},1,6) in ('SNA0PG'/*ny i 2017, ingen tidl kode*/)        then MR_caput_kolumna_overekstr=1; 
		if substr(nc_utv{i},1,6) in ('SNA0SG'/*ny i 2017, ingen tidl kode*/)        then MR_cervikal_lumbosakral=1; 
		if substr(nc_utv{i},1,6) in ('SNA0TG'/*ny i 2017, ingen tidl kode*/)        then MR_bekken_delkomuna=1; 

		/* MR TORAKS, ABDOMEN OG KAR */
		if substr(nc_utv{i},1,6) in ('SSC0AG'/*mr toraks*/) 						then MR_toraks=1;
		if substr(nc_utv{i},1,6) in ('SSD0AG'/*mr abdomen*/)						then MR_abdom=1;		
		if substr(nc_utv{i},1,6) in ('SSQ0AG'/*mr toraks, abdomen og bekken*/) 		then MR_toraks_abdom_bekken=1;
		if substr(nc_utv{i},1,6) in ('SSL0AG'/*mr abdomen og bekken*/) 				then MR_abdom_bekken=1;
		if substr(nc_utv{i},1,6) in ('SSK0AG'/*mr toraks og abdomen*/) 				then MR_toraks_abdom=1;

/* CT */
		if substr(nc_utv{i},1,6) in ('SNG0AD')                                     	then CT_kne=1; 
		if substr(nc_utv{i},1,6) in ('SNH0BD')                                      then CT_ankel=1; 
		if substr(nc_utv{i},1,6) in ('SNH0AD')                                      then CT_fot=1; 
		if substr(nc_utv{i},1,6) in ('SNE0BD')                                      then CT_iliosakral=1; 
		if substr(nc_utv{i},1,6) in ('SNC0AD')                                      then CT_albue=1; 
		if substr(nc_utv{i},1,6) in ('SJF0AD')        								then CT_tynntarm=1; 
		if substr(nc_utv{i},1,6) in ('SDE0AD')                                     	then CT_tinningben=1; 
		if substr(nc_utv{i},1,6) in ('SFY0AD') 										then ct_hjerte = 1;
		if substr(nc_utv{i},1,6) in ('SFN0AP') 										then ct_ak = 1; /* (angio_koronar) */
		if substr(nc_utv{i},1,6) in ('SKX0BD') 										then CT_nyre_ou = 1; /* CT_nyre_ovre_urinveier */

/* UL */										
		if substr(nc_utv{i},1,6) in ('SBA0AK') 										then ul_thyroidea = 1;
		if substr(nc_utv{i},1,6) in ('SKX0AK') 										then UL_urin = 1; /* UL_urinveier */

/* RG */										
		if substr(nc_utv{i},1,6) in ('SDX0AA') 										then rg_bihuler = 1; 

/*KlokeValg og liknende*/
		if substr(nc_utv{i},1,6) in ('SSE0AK', 'SSE0AG', 'SSE0AD') 					then ul_mr_ct_bekken = 1; /*Kloke valg - ovarialcyster*/
		if substr(nc_utv{i},1,6) in ('SJX0AK') 										then ul_abdom = 1; /* UL/CT abdomen hos barn  */
		if substr(nc_utv{i},1,6) in ('SAA0AD') 										then ct_hode = 1; 
		if substr(nc_utv{i},1,6) in ('SNB0BG', 'SNC0AG', 'SND0AG', 'SND0BG') 		then MR_ue = 1; /* MRI upper extremity */
		if substr(nc_utv{i},1,6) in ('SNF0AG', 'SSM0AG', 'SSE0AG', 'SNJ0AG') 		then MR_hp = 1; /* MRI Hip pain */
		if substr(nc_utv{i},1,6) in ('SJK0AG') 										then MR_pancreas = 1; /* MR - acute pancreatitis */
		if substr(nc_utv{i},1,6) in ('SPA0AK') 										then UL_cs = 1; /* UL - carotid screening */
		if substr(nc_utv{i},1,6) in ('SSC0AA') 										then RG_thorax = 1; 
		if substr(nc_utv{i},1,6) in ('SNX0XA ')										then Dexa = 1; 	/* DEXA osteoporosis screening */
		if substr(nc_utv{i},1,6) in ('SDX0AD', 'SDX0AK', 'SDX0AA') 					then Xray_bihule = 1; /* x-ray acute rhino */
		if substr(nc_utv{i},1,6) in ('TFY0DN ') 									then mpi = 1; 	/* myocardial perfusion imaging (non-invasive / stress test) */

		if substr(nc_utv{i},1,6) in ('SNA0GA ') 									then RG_ls = 1; /* RG lumbosakral */

/* kolumna */
		if substr(nc_utv{i},1,6) in ('SNA0AA') 										then RG_c_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0AD') 										then CT_c_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0AG') 										then MR_c_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0BA') 										then RG_t_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0BD') 										then CT_t_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0BG') 										then MR_t_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0CA') 										then RG_ct_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0ED') 										then CT_ct_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0EG') 										then MR_ct_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0FA') 										then RG_tl_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0FG') 										then MR_tl_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0GA') 										then RG_ls_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0GD') 										then CT_ls_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0GG') 										then MR_ls_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0HA') 										then RG_ctl_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0HG') 										then MR_ctl_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0JA') 										then RG_tls_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0JD') 										then CT_tls_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0JG') 										then MR_tls_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0KA') 										then RG_tot_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0KD') 										then CT_tot_kol = 1; 
		if substr(nc_utv{i},1,6) in ('SNA0KG') 										then MR_tot_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0LG') 										then MR_cap_tot_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0MG') 										then MR_tot_kol_bek = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0NG') 										then MR_cap_dkol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0PG') 										then MR_cap_kol_ov = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0SG') 										then MR_cls_kol = 1; 

		if substr(nc_utv{i},1,6) in ('SNA0TG') 										then MR_bek_dkol = 1; 

    end;


/* -------------- */
/* KOMBINASJONER */
/* -------------- */

/*CT toraks, abdomen og  bekken*/
if CT_toraks eq 1 and CT_abdom eq 1 and CT_bekken eq 1 then CT_toraks_abdom_bekken=1;
if CT_toraks eq 1 and CT_abdom_bekken eq 1 then CT_toraks_abdom_bekken=1;
if CT_bekken eq 1 and CT_toraks_abdom eq 1 then CT_toraks_abdom_bekken=1;

/*CT abdomen og  bekken, gitt at det ikke er utført ct toraks*/
if CT_toraks_abdom_bekken ne 1 and CT_toraks ne 1 then do;
	if CT_abdom eq 1 and CT_bekken eq 1 then CT_abdom_bekken=1;
end; 

/*CT toraks og abdomen, gitt at det ikke er utført CT bekken */
if CT_toraks_abdom_bekken ne 1 and CT_bekken ne 1 then do;
	if CT_abdom eq 1 and CT_toraks eq 1 then CT_toraks_abdom=1; 
end; 

/* CT toraks */
if CT_toraks_abdom_bekken eq 1 or CT_abdom_bekken eq 1 or CT_toraks_abdom eq 1 or CT_abdom eq 1 then CT_toraks=.;

/* CT hjerte og angiokor */
if ct_hjerte=1 or ct_ak=1 then ct_hak=1; /* (hjerteangiokor) */
if alder in (68:73) and ct_ak=1 then ct_ak_sjekk=1;

/* MR nakke/rygg */
if MR_cervikalkol eq 1 or MR_torakalkol eq 1 or MR_cervikal_torakal eq 1 or MR_torakal_lumbal eq 1 or 
    MR_lumbosakral eq 1 or MR_cerv_tora_lumbal eq 1 or MR_totalkol eq 1 or MR_tora_lumbosakral eq 1 or
    MR_caput_totalkol eq 1 or MR_totalkol_bekken eq 1 or MR_caput_delkolumna eq 1 or MR_caput_kolumna_overekstr eq 1 or
    MR_cervikal_lumbosakral eq 1 or MR_bekken_delkomuna eq 1                    
                                                                                then MR_nakke_rygg = 1;

/* -------------- */

/*kort-navn*/
if MR_cervikal_lumbosakral=1 then MR_cls=1;
if CT_cervikalkol=1 then CT_ck=1;


/* forløpspasienter */
if MR_nakke_rygg eq 1 or MR_kne eq 1 or MR_skulder eq 1 or MR_prostata eq 1 	then forlop_pas = 1;
drop i;
%mend radiologi_utvalg;