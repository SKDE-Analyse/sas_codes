
%macro infile_length;
length
	
Aktivitetskategori3	8
aar	8
aktivitetskategori	8
alderIdager	8
ansiendato	8
antallGangerAvmeldt	8
atc_1	8
atc_2	8
atc_3	8
atc_4	8
atc_5	8
behandlingsstedISFRefusjon	8
behandlingsstedKode	8
behandlingsstedLokal	$50
behandlingsstedReshID	8
bydel2	8
cyto_1	8
cyto_2	1
cyto_3	1
cyto_4	1
cyto_5	1
dag_kir	1
debitor	8
dodDato	8
drg	4
drg_type	1
drgreturKode	8
epikriseSamtykke	8
epikrisedato	8
episodeFag	3
episode_Lnr	8
fagenhetISFRefusjon	8
fagenhetKode	8
fagenhetLokal	$50
fagenhetReshID	8
fagomrade	3
fbvTjenesteEpisode	4
fbvTjenesteHenvisning	4
fodselsar	8
fodselsvekt	8
fraInstitusjonID	8
fraSted	8
fristStartBehandling	8
g_omsorgsniva	8
hdg	8
henvFraInstitusjonID	8
henvFraTjeneste	8
henvTilInstitusjonID	8
henvTilTjeneste	8
henvType	8
henvVurd	8
henvisning_Lnr	8
hf	8
individuellplan	8
individuellplanDato	8
initiativtaker	1
innDato	8
innTid	8
innmateHast	8
innmnd	8
inntilstand	8
institusjonID	8
kjonn	8
koblet	8
komnrhjem2	8
komp_drg	1
kontakttype	8
liggetid	8
lopenr	8
mottaksDato	8
ncmp_1	6
ncmp_2	6
ncmp_3	6
ncmp_4	6
ncmp_5	6
ncmp_6	6
ncmp_7	6
ncmp_8	6
ncmp_9	6
ncmp_10	6
ncmp_11	6
ncmp_12	6
ncmp_13	6
ncmp_14	6
ncmp_15	6
ncmp_16	6
ncmp_17	6
ncmp_18	6
ncmp_19	6
ncmp_20	6
ncrp_1	6
ncrp_2	6
ncrp_3	6
ncrp_4	6
ncrp_5	6
ncrp_6	6
ncrp_7	6
ncrp_8	6
ncrp_9	6
ncrp_10	6
ncrp_11	6
ncrp_12	6
ncrp_13	6
ncrp_14	6
ncrp_15	6
ncrp_16	6
ncrp_17	6
ncrp_18	6
ncrp_19	6
ncrp_20	6
ncsp_1	6
ncsp_2	6
ncsp_3	6
ncsp_4	6
ncsp_5	6
ncsp_6	6
ncsp_7	6
ncsp_8	6
ncsp_9	6
ncsp_10	6
ncsp_11	6
ncsp_12	6
ncsp_13	6
ncsp_14	6
ncsp_15	6
ncsp_16	6
ncsp_17	6
ncsp_18	6
ncsp_19	6
ncsp_20	6
niva	1
npkOpphold_DRGBasispoeng	8
npkOpphold_ErTellendeISFOppholdO	8
npkOpphold_ISFPoeng	8
npkopphold_poengsum	8
nyTilstand	8
omsnivaHenv	8
omsorgsniva	8
oppholdstype	1
pas_reg2	8
pasfylke2	8
permisjonsdogn	8
polIndir	8
polUtforende_1	8
polUtforende_2	8
polUtforende_3	8
rehabType	8
rettTilHelsehjelp	8
rolle_1	8
rolle_2	8
rolle_3	1
sektor	8
sh_reg	8
shfylke	8
sluttdato	8
spes_drg	1
spesialist_1	8
spesialist_2	8
spesialist_3	1
stedaktivitet	8
takst_1	5
takst_2	5
takst_3	5
takst_4	5
takst_5	5
takst_6	5
takst_7	5
takst_8	5
takst_9	5
takst_10	4
takst_11	4
takst_12	4
takst_13	4
takst_14	4
takst_15	4
tidspunkt_1	8
tidspunkt_2	8
tidspunkt_3	8
tidspunkt_4	8
tidspunkt_5	8
tilInstitusjonID	8
tilSted	8
tildeltDato	8
tilstand_10_1	5
tilstand_11_1	5
tilstand_12_1	5
tilstand_13_1	5
tilstand_14_1	5
tilstand_15_1	5
tilstand_16_1	5
tilstand_17_1	5
tilstand_18_1	5
tilstand_19_1	5
tilstand_1_1	6
tilstand_1_2	5
tilstand_20_1	5
tilstand_2_1	6
tilstand_3_1	6
tilstand_4_1	6
tilstand_5_1	6
tilstand_6_1	6
tilstand_7_1	6
tilstand_8_1	5
tilstand_9_1	5
tjenesteenhetISFRefusjon	8
tjenesteenhetKode	8
tjenesteenhetLokal	$102
tjenesteenhetReshID	8
trimpkt	8
trygdenasjon	2
typeTidspunkt_1	8
typeTidspunkt_2	8
typeTidspunkt_3	8
typeTidspunkt_4	8
typeTidspunkt_5	8
ukpDager	8
utDato	8
utTid	8
utTilstand	8
utforendeHelseperson	8
utmnd	8
utsettKode1	8
utsettKode2	8
utsettKode3	8
utsettKode4	8
utsettKode5	8
utsettKode21	8
utsettKode22	8
utskrKlarDato	8
utskrivingsklar	8
ventetidSluttDato	8
ventetidSluttKode	8
vurdDato	8
;
%mend;

%macro infile_format;
format
	
Aktivitetskategori3	BEST1.
aar	BEST4.
aktivitetskategori	BEST1.
alderIdager	BEST4.
ansiendato	YYMMDD10.
antallGangerAvmeldt	BEST1.
atc_1	$CHAR8.
atc_2	$CHAR8.
atc_3	$CHAR8.
atc_4	$CHAR8.
atc_5	$CHAR8.
behandlingsstedISFRefusjon	BEST1.
behandlingsstedKode	BEST10.
behandlingsstedLokal	$CHAR50.
behandlingsstedReshID	BEST9.
bydel2	BEST2.
cyto_1	BEST4.
cyto_2	$CHAR1.
cyto_3	$CHAR1.
cyto_4	$CHAR1.
cyto_5	$CHAR1.
dag_kir	$CHAR1.
debitor	BEST2.
dodDato	YYMMDD10.
drg	$CHAR4.
drg_type	$CHAR1.
drgreturKode	BEST1.
epikriseSamtykke	BEST1.
epikrisedato	YYMMDD10.
episodeFag	$CHAR3.
episode_Lnr	BEST8.
fagenhetISFRefusjon	BEST1.
fagenhetKode	BEST12.
fagenhetLokal	$CHAR50.
fagenhetReshID	BEST9.
fagomrade	$CHAR3.
fbvTjenesteEpisode	$CHAR4.
fbvTjenesteHenvisning	$CHAR4.
fodselsar	BEST4.
fodselsvekt	BEST4.
fraInstitusjonID	BEST9.
fraSted	BEST2.
fristStartBehandling	YYMMDD10.
g_omsorgsniva	BEST1.
hdg	BEST2.
henvFraInstitusjonID	BEST10.
henvFraTjeneste	BEST2.
henvTilInstitusjonID	BEST9.
henvTilTjeneste	BEST2.
henvType	BEST2.
henvVurd	BEST1.
henvisning_Lnr	BEST8.
hf	BEST9.
individuellplan	BEST3.
individuellplanDato	YYMMDD10.
initiativtaker	$CHAR1.
innDato	YYMMDD10.
innTid	TIME8.
innmateHast	BEST1.
innmnd	TIME8.
inntilstand	BEST1.
institusjonID	BEST9.
kjonn	BEST1.
koblet	BEST1.
komnrhjem2	BEST4.
komp_drg	$CHAR1.
kontakttype	BEST2.
liggetid	BEST4.
lopenr	BEST10.
mottaksDato	YYMMDD10.
ncmp_1	$CHAR6.
ncmp_2	$CHAR6.
ncmp_3	$CHAR6.
ncmp_4	$CHAR6.
ncmp_5	$CHAR6.
ncmp_6	$CHAR6.
ncmp_7	$CHAR6.
ncmp_8	$CHAR6.
ncmp_9	$CHAR6.
ncmp_10	$CHAR6.
ncmp_11	$CHAR6.
ncmp_12	$CHAR6.
ncmp_13	$CHAR6.
ncmp_14	$CHAR6.
ncmp_15	$CHAR6.
ncmp_16	$CHAR6.
ncmp_17	$CHAR6.
ncmp_18	$CHAR6.
ncmp_19	$CHAR6.
ncmp_20	$CHAR6.
ncrp_1	$CHAR6.
ncrp_2	$CHAR6.
ncrp_3	$CHAR6.
ncrp_4	$CHAR6.
ncrp_5	$CHAR6.
ncrp_6	$CHAR6.
ncrp_7	$CHAR6.
ncrp_8	$CHAR6.
ncrp_9	$CHAR6.
ncrp_10	$CHAR6.
ncrp_11	$CHAR6.
ncrp_12	$CHAR6.
ncrp_13	$CHAR6.
ncrp_14	$CHAR6.
ncrp_15	$CHAR6.
ncrp_16	$CHAR6.
ncrp_17	$CHAR6.
ncrp_18	$CHAR6.
ncrp_19	$CHAR6.
ncrp_20	$CHAR6.
ncsp_1	$CHAR6.
ncsp_2	$CHAR6.
ncsp_3	$CHAR6.
ncsp_4	$CHAR6.
ncsp_5	$CHAR6.
ncsp_6	$CHAR6.
ncsp_7	$CHAR6.
ncsp_8	$CHAR6.
ncsp_9	$CHAR6.
ncsp_10	$CHAR6.
ncsp_11	$CHAR6.
ncsp_12	$CHAR6.
ncsp_13	$CHAR6.
ncsp_14	$CHAR6.
ncsp_15	$CHAR6.
ncsp_16	$CHAR6.
ncsp_17	$CHAR6.
ncsp_18	$CHAR6.
ncsp_19	$CHAR6.
ncsp_20	$CHAR6.
niva	$CHAR1.
npkOpphold_DRGBasispoeng	BEST6.
npkOpphold_ErTellendeISFOppholdO	BEST1.
npkOpphold_ISFPoeng	BEST6.
npkopphold_poengsum	BEST6.
nyTilstand	BEST1.
omsnivaHenv	BEST1.
omsorgsniva	BEST1.
oppholdstype	$CHAR1.
pas_reg2	BEST1.
pasfylke2	BEST2.
permisjonsdogn	BEST3.
polIndir	BEST2.
polUtforende_1	BEST2.
polUtforende_2	BEST1.
polUtforende_3	BEST2.
rehabType	BEST1.
rettTilHelsehjelp	BEST1.
rolle_1	BEST1.
rolle_2	BEST1.
rolle_3	$CHAR1.
sektor	BEST1.
sh_reg	BEST1.
shfylke	BEST2.
sluttdato	YYMMDD10.
spes_drg	$CHAR1.
spesialist_1	BEST1.
spesialist_2	BEST1.
spesialist_3	$CHAR1.
stedaktivitet	BEST1.
takst_1	$CHAR5.
takst_2	$CHAR5.
takst_3	$CHAR5.
takst_4	$CHAR5.
takst_5	$CHAR5.
takst_6	$CHAR5.
takst_7	$CHAR5.
takst_8	$CHAR5.
takst_9	$CHAR5.
takst_10	$CHAR4.
takst_11	$CHAR4.
takst_12	$CHAR4.
takst_13	$CHAR4.
takst_14	$CHAR4.
takst_15	$CHAR4.
tidspunkt_1	YYMMDD10.
tidspunkt_2	YYMMDD10.
tidspunkt_3	YYMMDD10.
tidspunkt_4	YYMMDD10.
tidspunkt_5	YYMMDD10.
tilInstitusjonID	BEST9.
tilSted	BEST2.
tildeltDato	YYMMDD10.
tilstand_10_1	$CHAR5.
tilstand_11_1	$CHAR5.
tilstand_12_1	$CHAR5.
tilstand_13_1	$CHAR5.
tilstand_14_1	$CHAR5.
tilstand_15_1	$CHAR5.
tilstand_16_1	$CHAR5.
tilstand_17_1	$CHAR5.
tilstand_18_1	$CHAR5.
tilstand_19_1	$CHAR5.
tilstand_1_1	$CHAR6.
tilstand_1_2	$CHAR5.
tilstand_20_1	$CHAR5.
tilstand_2_1	$CHAR6.
tilstand_3_1	$CHAR6.
tilstand_4_1	$CHAR6.
tilstand_5_1	$CHAR6.
tilstand_6_1	$CHAR6.
tilstand_7_1	$CHAR6.
tilstand_8_1	$CHAR5.
tilstand_9_1	$CHAR5.
tjenesteenhetISFRefusjon	BEST1.
tjenesteenhetKode	BEST9.
tjenesteenhetLokal	$CHAR102.
tjenesteenhetReshID	BEST9.
trimpkt	BEST3.
trygdenasjon	$CHAR2.
typeTidspunkt_1	BEST2.
typeTidspunkt_2	BEST2.
typeTidspunkt_3	BEST2.
typeTidspunkt_4	BEST2.
typeTidspunkt_5	BEST2.
ukpDager	BEST3.
utDato	YYMMDD10.
utTid	TIME8.
utTilstand	BEST1.
utforendeHelseperson	BEST2.
utmnd	TIME8.
utsettKode1	BEST1.
utsettKode2	BEST1.
utsettKode3	BEST1.
utsettKode4	BEST1.
utsettKode5	BEST1.
utsettKode21	BEST1.
utsettKode22	BEST1.
utskrKlarDato	YYMMDD10.
utskrivingsklar	BEST1.
ventetidSluttDato	YYMMDD10.
ventetidSluttKode	BEST1.
vurdDato	YYMMDD10.
;
%mend;

%macro infile_informat;
informat 
	
Aktivitetskategori3	BEST1.
aar	BEST4.
aktivitetskategori	BEST1.
alderIdager	BEST4.
ansiendato	YYMMDD10.
antallGangerAvmeldt	BEST1.
atc_1	$CHAR8.
atc_2	$CHAR8.
atc_3	$CHAR8.
atc_4	$CHAR8.
atc_5	$CHAR8.
behandlingsstedISFRefusjon	BEST1.
behandlingsstedKode	BEST10.
behandlingsstedLokal	$CHAR50.
behandlingsstedReshID	BEST9.
bydel2	BEST2.
cyto_1	BEST4.
cyto_2	$CHAR1.
cyto_3	$CHAR1.
cyto_4	$CHAR1.
cyto_5	$CHAR1.
dag_kir	$CHAR1.
debitor	BEST2.
dodDato	YYMMDD10.
drg	$CHAR4.
drg_type	$CHAR1.
drgreturKode	BEST1.
epikriseSamtykke	BEST1.
epikrisedato	YYMMDD10.
episodeFag	$CHAR3.
episode_Lnr	BEST8.
fagenhetISFRefusjon	BEST1.
fagenhetKode	BEST12.
fagenhetLokal	$CHAR50.
fagenhetReshID	BEST9.
fagomrade	$CHAR3.
fbvTjenesteEpisode	$CHAR4.
fbvTjenesteHenvisning	$CHAR4.
fodselsar	BEST4.
fodselsvekt	BEST4.
fraInstitusjonID	BEST9.
fraSted	BEST2.
fristStartBehandling	YYMMDD10.
g_omsorgsniva	BEST1.
hdg	BEST2.
henvFraInstitusjonID	BEST10.
henvFraTjeneste	BEST2.
henvTilInstitusjonID	BEST9.
henvTilTjeneste	BEST2.
henvType	BEST2.
henvVurd	BEST1.
henvisning_Lnr	BEST8.
hf	BEST9.
individuellplan	BEST3.
individuellplanDato	YYMMDD10.
initiativtaker	$CHAR1.
innDato	YYMMDD10.
innTid	TIME11.
innmateHast	BEST1.
innmnd	TIME11.
inntilstand	BEST1.
institusjonID	BEST9.
kjonn	BEST1.
koblet	BEST1.
komnrhjem2	BEST4.
komp_drg	$CHAR1.
kontakttype	BEST2.
liggetid	BEST4.
lopenr	BEST10.
mottaksDato	YYMMDD10.
ncmp_1	$CHAR6.
ncmp_2	$CHAR6.
ncmp_3	$CHAR6.
ncmp_4	$CHAR6.
ncmp_5	$CHAR6.
ncmp_6	$CHAR6.
ncmp_7	$CHAR6.
ncmp_8	$CHAR6.
ncmp_9	$CHAR6.
ncmp_10	$CHAR6.
ncmp_11	$CHAR6.
ncmp_12	$CHAR6.
ncmp_13	$CHAR6.
ncmp_14	$CHAR6.
ncmp_15	$CHAR6.
ncmp_16	$CHAR6.
ncmp_17	$CHAR6.
ncmp_18	$CHAR6.
ncmp_19	$CHAR6.
ncmp_20	$CHAR6.
ncrp_1	$CHAR6.
ncrp_2	$CHAR6.
ncrp_3	$CHAR6.
ncrp_4	$CHAR6.
ncrp_5	$CHAR6.
ncrp_6	$CHAR6.
ncrp_7	$CHAR6.
ncrp_8	$CHAR6.
ncrp_9	$CHAR6.
ncrp_10	$CHAR6.
ncrp_11	$CHAR6.
ncrp_12	$CHAR6.
ncrp_13	$CHAR6.
ncrp_14	$CHAR6.
ncrp_15	$CHAR6.
ncrp_16	$CHAR6.
ncrp_17	$CHAR6.
ncrp_18	$CHAR6.
ncrp_19	$CHAR6.
ncrp_20	$CHAR6.
ncsp_1	$CHAR6.
ncsp_2	$CHAR6.
ncsp_3	$CHAR6.
ncsp_4	$CHAR6.
ncsp_5	$CHAR6.
ncsp_6	$CHAR6.
ncsp_7	$CHAR6.
ncsp_8	$CHAR6.
ncsp_9	$CHAR6.
ncsp_10	$CHAR6.
ncsp_11	$CHAR6.
ncsp_12	$CHAR6.
ncsp_13	$CHAR6.
ncsp_14	$CHAR6.
ncsp_15	$CHAR6.
ncsp_16	$CHAR6.
ncsp_17	$CHAR6.
ncsp_18	$CHAR6.
ncsp_19	$CHAR6.
ncsp_20	$CHAR6.
niva	$CHAR1.
npkOpphold_DRGBasispoeng	BEST6.
npkOpphold_ErTellendeISFOppholdO	BEST1.
npkOpphold_ISFPoeng	BEST6.
npkopphold_poengsum	BEST6.
nyTilstand	BEST1.
omsnivaHenv	BEST1.
omsorgsniva	BEST1.
oppholdstype	$CHAR1.
pas_reg2	BEST1.
pasfylke2	BEST2.
permisjonsdogn	BEST3.
polIndir	BEST2.
polUtforende_1	BEST2.
polUtforende_2	BEST1.
polUtforende_3	BEST2.
rehabType	BEST1.
rettTilHelsehjelp	BEST1.
rolle_1	BEST1.
rolle_2	BEST1.
rolle_3	$CHAR1.
sektor	BEST1.
sh_reg	BEST1.
shfylke	BEST2.
sluttdato	YYMMDD10.
spes_drg	$CHAR1.
spesialist_1	BEST1.
spesialist_2	BEST1.
spesialist_3	$CHAR1.
stedaktivitet	BEST1.
takst_1	$CHAR5.
takst_2	$CHAR5.
takst_3	$CHAR5.
takst_4	$CHAR5.
takst_5	$CHAR5.
takst_6	$CHAR5.
takst_7	$CHAR5.
takst_8	$CHAR5.
takst_9	$CHAR5.
takst_10	$CHAR4.
takst_11	$CHAR4.
takst_12	$CHAR4.
takst_13	$CHAR4.
takst_14	$CHAR4.
takst_15	$CHAR4.
tidspunkt_1	YYMMDD10.
tidspunkt_2	YYMMDD10.
tidspunkt_3	YYMMDD10.
tidspunkt_4	YYMMDD10.
tidspunkt_5	YYMMDD10.
tilInstitusjonID	BEST9.
tilSted	BEST2.
tildeltDato	YYMMDD10.
tilstand_10_1	$CHAR5.
tilstand_11_1	$CHAR5.
tilstand_12_1	$CHAR5.
tilstand_13_1	$CHAR5.
tilstand_14_1	$CHAR5.
tilstand_15_1	$CHAR5.
tilstand_16_1	$CHAR5.
tilstand_17_1	$CHAR5.
tilstand_18_1	$CHAR5.
tilstand_19_1	$CHAR5.
tilstand_1_1	$CHAR6.
tilstand_1_2	$CHAR5.
tilstand_20_1	$CHAR5.
tilstand_2_1	$CHAR6.
tilstand_3_1	$CHAR6.
tilstand_4_1	$CHAR6.
tilstand_5_1	$CHAR6.
tilstand_6_1	$CHAR6.
tilstand_7_1	$CHAR6.
tilstand_8_1	$CHAR5.
tilstand_9_1	$CHAR5.
tjenesteenhetISFRefusjon	BEST1.
tjenesteenhetKode	BEST9.
tjenesteenhetLokal	$CHAR102.
tjenesteenhetReshID	BEST9.
trimpkt	BEST3.
trygdenasjon	$CHAR2.
typeTidspunkt_1	BEST2.
typeTidspunkt_2	BEST2.
typeTidspunkt_3	BEST2.
typeTidspunkt_4	BEST2.
typeTidspunkt_5	BEST2.
ukpDager	BEST3.
utDato	YYMMDD10.
utTid	TIME11.
utTilstand	BEST1.
utforendeHelseperson	BEST2.
utmnd	TIME11.
utsettKode1	BEST1.
utsettKode2	BEST1.
utsettKode3	BEST1.
utsettKode4	BEST1.
utsettKode5	BEST1.
utsettKode21	BEST1.
utsettKode22	BEST1.
utskrKlarDato	YYMMDD10.
utskrivingsklar	BEST1.
ventetidSluttDato	YYMMDD10.
ventetidSluttKode	BEST1.
vurdDato	YYMMDD10.
;
%mend;