%macro radiologi;
/*! 
### Beskrivelse

Makro for å kode opp undersøkelser radiologi. 
Må kjøres inni et datasteg.

```
%radiologi;
```

### Endringslogg:
    - Opprettet desember 2022, Tove J
 */


array nc {*} ncrp: ;
	do i=1 to dim(nc);

    /* MR */
		if substr(nc{i},1,6) in ('SNG0AG')                                      then MR_kne=1; 
		if substr(nc{i},1,6) in ('SNB0BG')                                      then MR_skulder=1; 
		if substr(nc{i},1,6) in ('SSE0AG')                                      then MR_bekken=1; 
		if substr(nc{i},1,6) in ('SNF0AG' /*hofte*/, 
                                'SSM0AG' /*bekken og underekstremiteter*/)      then MR_hofte=1; 
		if substr(nc{i},1,6) in ('SND0AG' /*håndledd og håndrot*/, 
                                'SND0BG' /*hånd og fingre*/)                    then MR_hand=1; 
		if substr(nc{i},1,6) in ('SNH0BG')                                      then MR_ankel=1; 
		if substr(nc{i},1,6) in ('SNH0AG')                                      then MR_fot=1; 
		if substr(nc{i},1,6) in ('SNE0BG')                                      then MR_ileosakral=1; 
		if substr(nc{i},1,6) in ('SNC0AG')                                      then MR_albue=1; 
		if substr(nc{i},1,6) in ('SKE0AG')                                      then MR_prostata=1; 

		if substr(nc{i},1,6) in ('SNA0AG')                                      then MR_cervikalkol=1; 
		if substr(nc{i},1,6) in ('SNA0BG')                                      then MR_torakalkol=1; 
		if substr(nc{i},1,6) in ('SNA0EG')                                      then MR_cervikal_torakal=1; 
		if substr(nc{i},1,6) in ('SNA0FG')                                      then MR_torakal_lumbal=1; 
        if substr(nc{i},1,6) in ('SNA0GG')                                      then MR_lumbosakral=1; 
		if substr(nc{i},1,6) in ('SNA0HG')                                      then MR_cerv_tora_lumb=1; 
		if substr(nc{i},1,6) in ('SNA0KG')                                      then MR_totalkol=1; 
		if substr(nc{i},1,6) in ('SNA0JG')                                      then MR_tora_lumbosakral=1; 
		if substr(nc{i},1,6) in ('SNA0LG')                                      then MR_caput_totalkol=1; 
		if substr(nc{i},1,6) in ('SNA0MG')                                      then MR_totalkol_bekken=1; 
		if substr(nc{i},1,6) in ('SNA0NG')                                      then MR_caput_delkolumna=1; 
		if substr(nc{i},1,6) in ('SNA0PG')                                      then MR_caput_kolumna_overekstr=1; 
		if substr(nc{i},1,6) in ('SNA0SG')                                      then MR_cervikal_lumbosakral=1; 
		if substr(nc{i},1,6) in ('SNA0TG')                                      then MR_bekken_delkomuna=1; 
    end;

if MR_cervikalkol eq 1 or MR_torakalkol eq 1 or MR_cervikal_torakal eq 1 or MR_torakal_lumbal eq 1 or 
    MR_lumbosakral eq 1 or MR_cerv_tora_lumb eq 1 or MR_totalkol eq 1 or MR_tora_lumbosakral eq 1 or
    MR_caput_totalkol eq 1 or MR_totalkol_bekken eq 1 or MR_caput_delkolumna eq 1 or MR_caput_kolumna_overekstr eq 1 or
    MR_cervikal_lumbosakral eq 1 or MR_bekken_delkomuna eq 1                    
                                                                                then MR_nakke_rygg = 1;
%mend radiologi;