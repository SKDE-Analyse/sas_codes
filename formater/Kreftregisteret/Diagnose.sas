/* Opprettet 27.11.2019 - Frank Olsen
Hentet fra Beate Hauglann*/

Proc format;
value $ICD10_gr_fmt
'C00–96'='All sites'
'C00–14'='Mouth, pharynx'
'C00'='Lip'
'C01-02'='Tongue'
'C03-06'='Mouth, other'
'C07-08'='Salivary glands'
'C09-14'='Pharynx'
'C15-26'='Digestive organs'
'C15'='Oesophagus'
'C16'='Stomach'
'C17'='Small intestine'
'C18'='Colon'
'C19-20'='Rectum, rectosigmoid'
'C21'='Anus'
'C22'='Liver'
'C23-24'='Gallbladder, bile ducts'
'C25'='Pancreas'
'C26'='Other digestive organs'
'C30-34, C38'='Respiratory organs'
'C30-31'='Nose, sinuses'
'C32'='Larynx, epiglottis'
'C33-34'='Lung, trachea'
'C38'='Heart, mediastinum and pleura'
'C40-41'='Bone'
'C43'='Melanoma of the skin'
'C44'='Skin, non-melanoma'
'C45'='Mesothelioma'
'C47'='Autonomic nervous system'
'C48-49'='Soft tissues'
'C50'='Breast'
'C51-58'='Female genital organs'
'C51-52, C57.7-57.9'='Other female genital'
'C53'='Cervix uteri'
'C54'='Corpus uteri'
'C55'='Uterus, other'
'C56, C57.0-57.4'='Ovary etc.'
'C58'='Placenta'
'C60-63'='Male genital organs'
'C61'='Prostate'
'C62'='Testis'
'C60, C63'='Other male genital'
'C64–68'='Urinary organs'
'C64'='Kidney(excl. renal pelvis)'
'C65-68'='Urinary tract'
'C69'='Eye'
'C70-72, D42-43'='Central nervous system'
'C73'='Thyroid gland'
'C37, C74-75'='Other endocrine glands'
'C39, C76, C80'='Other or unspecified'
'C81–96'='Lymphoid/haematopoietic tissue'
'C81'='Hodgkin lymphoma'
'C82-86, C96'='Non-Hodgkin lymphoma'
'C88'='Immunoproliferative disease'
'C90'='Multiple myeloma'
'C91-95, D45-47'='Leukaemia';
run;


Proc format;
value ICD10_gr_omk
0='All sites'
1='Mouth, pharynx'
2='Lip'
3='Tongue'
4='Mouth, other'
7='Salivary glands'
9='Pharynx'
14='Digestive organs'
15='Oesophagus'
16='Stomach'
17='Small intestine'
18='Colon'
20='Rectum, rectosigmoid'
21='Anus'
22='Liver'
23='Gallbladder, bile ducts'
25='Pancreas'
26='Other digestive organs'
30='Respiratory organs'
31='Nose, sinuses'
32='Larynx, epiglottis'
33='Lung, trachea'
38='Heart, mediastinum and pleura'
40='Bone'
43='Melanoma of the skin'
44='Skin, non-melanoma'
45='Mesothelioma'
47='Autonomic nervous system'
48='Soft tissues'
50='Breast'
51='Female genital organs'
52='Other female genital'
53='Cervix uteri'
54='Corpus uteri'
55='Uterus, other'
56='Ovary etc.'
58='Placenta'
60='Male genital organs'
61='Prostate'
62='Testis'
63='Other male genital'
66='Urinary organs'
64='Kidney(excl. renal pelvis)'
65='Urinary tract'
69='Eye'
70='Central nervous system'
73='Thyroid gland'
74='Other endocrine glands'
76='Other or unspecified'
84='Lymphoid/haematopoietic tissue'
81='Hodgkin lymphoma'
82='Non-Hodgkin lymphoma'
88='Immunoproliferative disease'
90='Multiple myeloma'
91='Leukaemia';
run;


proc format;
value LOK_ICD7_omk
/*Lok. Ca. labii (leppestift-området)*/
1400 = 'Overleppe (Lok. Ca. labii)'
1401 = 'Underleppe (Lok. Ca. labii)'
1402 = 'Begge lepper (Lok. Ca. labii)'
1407 = 'Kommissurer (Lok. Ca. labii)' /*før 1983*/
1408 = 'Andre spesifiserte lokal. bl.a. kommissurer (Lok. Ca. labii)'
1409 = 'Leppe i.n.s (Lok. Ca. labii)'

/*Lok. Ca. linguae*/
1410 = 'Tungebasis, tungerot, tungemandel (tonsilla lingualis) (Lok. Ca. linguae)'
1411 = 'Tungens overside (Lok. Ca. linguae)'
1412 = 'Tungespiss eller tungerand (Lok. Ca. linguae)'
1413 = 'Tungens underside (Lok. Ca. linguae)'
1418 = 'Omfatter store tumores med utbredelse over flere lok (Lok. Ca. linguae)'
1419 = 'Tunge, i.n.s. (Lok. Ca. linguae)'
/*Gamle koder*/
/*- Tungens høyre/venstre side ble tidligere kodet både på 141.9*/
/*(før 1983) og på 141.8 (fom. 1983 tom. 1985).*/
/*- Tungemandel ble tidligere (før 1986) kodet 145.0.*/

/*Lok. Ca. glandula salivariae*/
1420 = 'Glandula parotis. (Lok. Ca. glandula salivariae)'
1421 = 'Glandula submandibularis.(Lok. Ca. glandula salivariae)'
1422 = 'Glandula sublingualis.(Lok. Ca. glandula salivariae)'
1427 = 'Samlekode for Glandula submandibularis (Lok. Ca. glandula salivariae)' /*før 1983*/
1429 = 'Stor spyttkjertel i.n.s. (Lok. Ca. glandula salivariae)'

/*Lok. Ca. baseos oris*/
1430 = 'Gingiva inferior (nedre). (Lok. Ca. baseos oris)' /*Tannkjøttet i underkjeven. Gumme. Slimhinnen svarende til processus alveolaris inferior.*/
1431 = 'Regio sublingualis. (Lok. Ca. baseos oris)' /*Ikke på tungens underside, men munngulvet
under tungen.*/
1438 = 'Svulster over flere sublokalisasjoner. (Lok. Ca. baseos oris)'
1439 = 'Munngulv i.n.s. (Lok. Ca. baseos oris)'

/*Lok. Ca. cavum oris*/
1440 = 'Bløte/harde gane (palatum molle/durum). Drøvelen (uvula). (Lok. Ca. cavum oris)'
1441 = 'Gingiva superior (øvre). Tannkjøttet i overkjeven.
Slimhinnen svarende til processus alveolaris superior. (Lok. Ca. cavum oris)'
1442 = 'Bucca. Kinnslimhinne. Omfatter også slimhinnesiden av leppene. (Lok. Ca. cavum oris)'
1448 = 'Andre spesifiserte lokalisasjoner i munnhulen. (Lok. Ca. cavum oris)'
1449 = 'Munnhule i.n.s. Gingiva i.n.s. (Lok. Ca. cavum oris)'

/*Lok. Ca. mesopharyngis (oropharyngis)*/
1450 = 'Tonsille, halsmandel (tonsilla palatina) (Lok. Ca. mesopharyngis (oropharyngis)).'
1451 = 'Vallecula epiglottica. (Lok. Ca. mesopharyngis (oropharyngis))'
1452 = 'Overside av epiglottis. (Lok. Ca. mesopharyngis (oropharyngis))'
1457 = 'Mesopharynx , andre lokalisasjoner. (Lok. Ca. mesopharyngis (oropharyngis))Ble kodet som 145.8 før 1983'
1458 = 'Mesopharynx i.n.s., før 1983 (Lok. Ca. mesopharyngis (oropharyngis))'
1459 = 'Mesopharynx i.n.s (Lok. Ca. mesopharyngis (oropharyngis))'
/*Gamle koder:*/
/*- Tungemandel (tonsilla lingualis, tidligere 145.0) kodes til 141.0.*/
/*- Falsk mandel (tonsilla pharyngea, tidligere 145.0) kodes til 146.0.*/

/*Lok. Ca. epipharyngis*/
1460 = 'Epipharynx = nasopharynx = rhinopharynx,
tonsilla pharyngea (falsk mandel).'
/*Gamle koder*/
/*146.0 Falsk mandel (tonsilla pharyngea) ble før 1986 kodet 145.0.*/

/*Lok. Ca. hypopharyngis*/
1470 = 'Hypopharynx, nederste del av svelget.
Hypopharynx i.n.s. og epiglottis i.n.s.'
/*Omfatter bl.a. plica pharyngo-epiglottica, den frie øvre rand*/
/*av epiglottis, plica aryepiglottica, tuberculum cuneiforme,*/
/*tuberculum corniculatum, incisura inter-arytenoidea, regio*/
/*retroarytenoidea, recessus piriformis, regio retro-cricoidea,*/

/*Lok. Ca. pharyngis i.n.s*/
1480 = 'Svelg i.n.s.'
1481 = 'Bronchiogen halscyste'

/*Lok. Ca. oesophagi*/
1500 = 'Oesophagus, spiserør, 15-23 cm fra tannrekken,
øvre (proximale) 1/3. Overgang hypopharynx - oesophagus.'
1501 = 'Oesophagus, spiserør, 24-32 cm fra tannrekken, midtre 1/3.'
1502 = 'Oesophagus, spiserør, 33-44 cm fra tannrekken, nedre (distale) 1/3.'
1508 = 'Oesophagus, spiserør, Utbredt over flere sub-lokalisajoner.'
1509 = 'Oesophagus i.n.s.'

/*Lok. Ca. ventriculi*/
1510 = 'Pars pylorica, canalis, angulus, antrum. (Lok. Ca. ventriculi)'
1511 = 'Corpus. (Lok. Ca. ventriculi)'
1512 = 'Cardia, fundus, øvre del av ventrikkel. (Lok. Ca. ventriculi)'
/*1513 = 'Utbredt ventrikkelcancer. Utgått.'*/
1514 = 'Tidligere ventrikkel-recessert pga. godartet sår
i ventrikkel/duodenum. (Lok. Ca. ventriculi)'
1515 = 'Curvatura minor (Lok. Ca. ventriculi)' /*(fom. 01.01.83).*/
1516 = 'Curvatura major (Lok. Ca. ventriculi)' /*(fom. 01.01.83).*/
1518 = 'Utbredt over flere sub-lokalisasjoner. (Lok. Ca. ventriculi)'
1519 = 'Ventrikkel i.n.s. (Lok. Ca. ventriculi)'

/*Lok. Ca. duodeni, jejuni, ilei*/
1520 = 'Duodenum. (Lok. Ca. duodeni, jejuni, ilei)'
1521 = 'Jejunum. (Lok. Ca. duodeni, jejuni, ilei)'
1522 = 'Ileum. (Lok. Ca. duodeni, jejuni, ilei)'
1523 = 'Meckels divertikkel. (Lok. Ca. duodeni, jejuni, ilei)'
1527 = 'Jejunum og ileum, før 1983 (Lok. Ca. duodeni, jejuni, ilei)'
1528 = 'Utbredt over flere sub-lokalisasjoner. (Lok. Ca. duodeni, jejuni, ilei)'
1529 = 'Tynntarm i.n.s. (Lok. Ca. duodeni, jejuni, ilei)'

/*Lok. Ca. coli*/
1530 = 'Caecum, colon ascendens, iloecaecal-overgangen. (Lok. Ca. coli)'
1531 = 'Colon transversum med flexura hepatica og lienalis
(høyre og venstre flexur). (Lok. Ca. coli)'
1532 = 'Colon descendens. (Lok. Ca. coli)'
1533 = 'Colon-sigmoideum (evt. 21cm eller mer fra analåpningen). (Lok. Ca. coli)'
1534 = 'Recto-sigmoideum (20 cm fra analåpningen). (Lok. Ca. coli)'
1535 = 'Polypper. (Lok. Ca. coli)'
1536 = 'Appendix. (Lok. Ca. coli)'
1539 = 'Colon i.n.s, eksklusive rectum i.n.s. (Lok. Ca. coli)'
/*Gamle koder*/
/*153.6 ble 01.01.83 konvertert til 153.9: Colon, eksklsuve rectum i.n.s.*/
/*153.8 ble 01.01.83 konvertert til 159.0: Tarm i.n.s.*/
/*Fra 01.01.83 ble 153.8 brukt for "andre spesifiserte lokalisasjoner*/
/*i colon". Utgår f.o.m 01.01.86.*/

/*Lok. Ca. recti, ani*/
1540 = 'Rectum, ampullen, rectum i.n.s (Lok. Ca. recti, ani).
tarmavsnittet 5-19 cm fra anal-åpningen. (Lok. Ca. recti, ani)'
1541 = 'Analkanal, endetarm (Lok. Ca. recti, ani);
tarmavsnittet 0-4 cm fra anal-åpningen. (Lok. Ca. recti, ani)'
1545 = 'Polypper. (Lok. Ca. recti, ani)'

/*Lok. Ca. hepatis*/
1550 = 'Leverparenchym.'
1551 = 'Intrahepatiske galleganger.'
1557 = 'Galleveier i.n.s., før 1983.'
1559 = 'Lever i.n.s.'

/*Lok. Ca. vesica felleae*/
1560 = 'Galleblære'
1561 = 'Ekstrahepatiske galleganger (ductus hepaticus, ductus cysticus,
ductus choledochus).'
1562 = 'Papilla Vateri.'
1568 = 'Utbredt over flere sub-lokalisasjoner. (Lok. Ca. vesica felleae)'
1569 = 'Ekstrahepatiske galleveier i.n.s.'
/*Gamle koder*/
/*156 før 1983:*/
/*Metastaser og uspesifiserte maligne svulster i lever og*/
/*galleveier.*/
/*Fra 1970 bare brukt på dødsattester, men etterhvert gikk man over*/
/*til lok. 199 for alle meldinger med følgende informasjon:*/
/*"Tumor i lever, ins. om primær eller sekundær".*/
/*Fra 01.01.86 vil disse bli kodet til 159.2 (lever/pancreas/*/
/*galle-veier, -ganger i.n.s.).*/
/*Konverteringer 01.01.83:*/
/*156 konvertert til 199.9 (Helt uten opplysning om lokalisasjon).*/
/*155.1 konvertert til 156.0 (Galleblære).*/
/*155.2 konvertert til 156.1 (Ekstrahepatiske galleganger).*/
/*155.3 konvertert til 156.2 (Papilla Vateri).*/

/*Lok. Ca. pancreatis*/
1570 = 'Caput. (Lok. Ca. pancreatis)'
1571 = 'Corpus. (Lok. Ca. pancreatis)'
1572 = 'Cauda. (Lok. Ca. pancreatis)'
1573 = 'Svulster utgående fra de Langerhanske øyer (endocrine svulster) (Lok. Ca. pancreatis)'
1577 = 'Andre spesifiserte lokalisasjoner i pancreas, før 1983 (Lok. Ca. pancreatis)'
1578 = 'Utbredt over flere sub-lokalisasjoner. (Lok. Ca. pancreatis)'
1579 = 'Pancreas i.n.s. (Lok. Ca. pancreatis)'

/*Lok. Ca. peritonei, omenti, mesenterii*/
1580 = 'Peritoneum, bukhinnen.'
1581 = 'Retroperitoneum. Bak bukhinnen. På bakre bukvegg.'
1588 = 'Andre spesifiserte lokalisasjoner, f.eks. oment, krøs.'
1589 = 'Peritoneum/retroperitoneum i.n.s.'

/*Lok.*/
1590 = 'Tarm i.n.s. (uvisst om tykk- eller tynntarm).'
1591 = 'Milt'
1592 = 'Lever/pancreas/galle-veier, -ganger i.n.s.'
/*Gamle koder*/
/*01.01.83 ble 153.8 overført til 159.0*/
/*01.01.86 159.2 (ny). Tidligere 156 og 199.*/

/*Lok. Ca. cavi nasi, sinuum nasi, auris mediae, tubae Eustachii.*/
1600 = 'Nesehule, ikke ytre hud.'
1601 = 'Sinus maxillaris.'
1602 = 'Sinus ethmoidalis, sphenoidalis, frontalis.'
1603 = 'Bihuler i.n.s.'
1604 = 'Tubae Eustachii, mellomøret, indre øre.'
1608 = 'Utbredt over to eller flere sub-lokalisasjoner. (Lok. Ca. cavi nasi, sinuum nasi, auris mediae, tubae Eustachii)'
1609 = 'i.n.s. lokalisasjon i nese/bihule-systemet.'

/*Lok. Ca. laryngis.*/
1610 = 'Supraglottisk' /*(strupesiden: baksiden av epiglottis),
strupelokket, plicae ventricularis, de falske stemmebånd,
arytenoidebrusken, cuneiform-bruskene, corniculat-bruskene,
ventriculus laryngis, vestibulum laryngis med sinus Morgagni.*/
1611 = 'Glottisk inkl. de ekte stemmebånd (plicae vocalis).'
1612 = 'Subglottisk, cricoidbrusken.'
1613 = 'Utbredt cancer i larynx, før 1983'
1618 = 'Utbredt over flere sublokalisasjoner. (Lok. Ca. laryngis)'
1619 = 'Larynx i.n.s.; omfatter brusk i larynx.'

/*Lok. Ca. tracheae, bronci, pulmonis.*/
1620 = 'Trachea, luftrør.'
1621 = 'Bronchier, lunger.'
1623 = 'Før 1983: Multiple lokalisasjoner.'
1627 = 'Før 1983: "Neopl.mal. bronchi, pulmonis et pleurae primarium
sive secundarium non descriptum." Før 1983: 163.x.'
1629 = 'Nedre luftveier i.n.s.'

/*Lok. Ca. pleurae.*/
1630 = 'Brysthinne, pleura.'
/*Gamle koder/konverteringer.*/
/*Tidligere 163.0: Sekundære eller i.n.s. svulster i i bronchier, lunger*/
/*og brysthinne; nå lokalisasjon 199.*/

/*Lok. Ca. mediastini, thymi, cordis.*/
1640 = 'Mediastinum.'
1641 = 'Hjerte, cor.'
1642 = 'Hjerteposen, pericard.'
1643 = 'Brissel, thymus.'
/*Gamle koder/konverteringer:*/
/*164.3: ble tidligere kodet på 195.x.*/

/*Lok. Ca. mammae.*/
1700 = 'Vesentlig medialt beliggende. (Lok. Ca. mammae)'
1701 = 'Vesentlig lateralt beliggende. (Lok. Ca. mammae)'
1702 = 'Vesentlig sentralt beliggende. (Lok. Ca. mammae)'
1703 = 'Utbredt tumor som inntar det meste av eller hele mamma.'
/*170.0-170.3: se nedenfor*/
1704 = 'Utbredt tumor som inntar det meste av eller hele mamma. Samtidig tumor i begge mamma, før 1983'
1705 = 'Mamma, brystkjertel, inkl. papillen.'
1708 = 'Andre spesifikke lokalisasjoner i mamma, aberrant mamma.'
1709 = 'Mamma i.n.s. Før 1986.'
/*Kommentar*/
/*170.0-170.3 kodes kun på meldinger fra DNR.*/
/*170.0 Vesentlig medialt beliggende.*/
/*170.1 Vesentlig lateralt beliggende.*/
/*170.2 Vesentlig sentralt beliggende.*/
/*170.3 Utbredt tumor som inntar det meste av eller hele mamma.*/

/*Lok. Ca. cervicis uteri.*/
1710 = 'Livmorhalsen, cervix'

/*Lok. Ca. corporis uteri.*/
1720 = 'Livmorlegemet, corpus uteri.'
1721 = 'Malign tumor oppstått i endometriosefocus.'

/*Lok. Placenta.*/
1730 = 'Placenta, morkake.'

/*Lok. Ca. uteri i.n.s.*/
1740 = 'Ca. cervicis et corporis uteri'
1749 = 'Uterus/cervix i.n.s.'

/*Lok. Ca. ovarii, tubae, ligamenti.*/
1750 = 'Ovarium, eggstokk.'
1751 = 'Bilateral, før 1983.'
1752 = 'Tube, eggleder.'
1753 = 'Ekstragonadal germinalcellesvulst.'
1758 = 'Andre spesifiserte lokalisasjoner i adnex, f.eks.
parametriet/ligamenter.'
1759 = 'Ovarium, tube, adnexstruktur i.n.s.'

/*Lok. Ca. vulvae, vaginae.*/
1760 = 'Vulva, ytre genitalia, inkluderer clitoris,
gl. Bartholini, labium majus og minus.'
1761 = 'Vagina, skjede.'
1762 = 'Uterus og ovarium samtidig (før 1983).'
1768 = 'Utbredt i ytre genitalia eller vagina.'
1769 = 'Kvinnelige genitalia i.n.s. (ytre og indre)'

/*Lok. Ca. prostata.*/
1770 = 'Prostata, blærehalskjertel.'
1771 = 'Vesiculae seminales.'
1779 = '177.0 (alle før 1980)'

/*Lok. Ca. testis.*/
1780 = 'Testis (inkluderer tubuli seminiferis og rete testis).'
1781 = 'Ektopisk testis. Retinert testis. Både operert og ikke operert.'
1782 = 'Epididymis.'
1783 = 'Ductus deferens, funiculus spermaticus.'
1784 = 'Ekstragonadal germinalcellesvulst.'

/*Lok. Ca. penis.*/
1790 = 'Glans penis, inkl. sulcus coronarius.'
1791 = 'Preputium, forhud.'
1792 = 'Scrotum.'
1793 = 'Corpus penis.'
1794 = 'Penis uspesifisert.'
1798 = 'Utbredt over flere sublokalisasjoner. (Lok. Ca. penis)'
1799 = 'Mannlige genitalia i.n.s.'
/*Kommentar*/
/*Malignt melanom på scrotum kodes på 190.6.*/

/*Lok. Ca. renis.*/
1800 = 'Nyre.'
1801 = 'Nyrebekken, pelvis.'
1802 = 'Ureter, urinleder.'
1808 = 'Utbredt over flere sublokalisasjoner. (Lok. Ca. renis)' /*Ved tvil spør lege.*/
1809 = 'Øvre urinveier i.n.s.'

/*Lok. Ca. vesicae urinariae.*/
1810 = 'Blære.'
1811 = 'Urethra.'
1813 = 'Paraurethrale kjertler (brukes ved tvil om prostata eller blære).'
1814 = 'Urachus rest.'
1818 = 'Utbredt over flere sublokalisasjoner. (Lok. Ca. vesicae urinariae)' /* Ved tvil spør lege.*/
1819 = 'Nedre urinveier i.n.s.'

/*Lok. Ca. cutis - basalcellecarcinom.*/
1890 = 'Hud, ytre øre. Lok. Ca. cutis - basalcellecarcinom'
1891 = 'Øyelokk med øyenvinkel, unntatt conjunctiva oculi. Lok. Ca. cutis - basalcellecarcinom'
1892 = 'Ansiktet og hodet forøvrig, inkl. hodebunn, orbitalregionen,
hake, kinn. Lok. Ca. cutis - basalcellecarcinom'
1893 = 'Hals, kropp, nakke, skulder, lyske, axiller, nates, hofte
unntatt genitalhud (lok. 176/179). Lok. Ca. cutis - basalcellecarcinom'
1894 = 'Perianalt, perineum. Lok. Ca. cutis - basalcellecarcinom'
1895 = 'Overekstremiteter. Lok. Ca. cutis - basalcellecarcinom'
1896 = 'Underekstremiteter. Lok. Ca. cutis - basalcellecarcinom'
1898 = 'Multiple lokalisasjoner, se kommentar. (Lok. Ca. cutis - basalcellecarcinom)'
1899 = 'Hud i.n.s. Lok. Ca. cutis - basalcellecarcinom'
/*Kommentar:*/
/*Denne lokalisasjon taes i bruk fom. 01.01.86.*/
/*189.8 brukes ved 2. gangs opptreden av ny hudtumor efter 4 måneder.*/
/*Personen får da en ny akkumulert record med 189.8 mens den første blir*/
/*stående med spesifikk lokalisasjon. Ved ny hudtumor innen 4 måneder*/
/*skal det være kun en akkumulert record, men lokalisasjonen skal endres*/
/*til 189.8. (fom. 01.01.86). Denne lokalisasjonen er fjernet fra standarduttrekk, jf. Cancer in Norway.*/

/*Lok. Ca. cutis - melanoma malignum.*/
1900 = 'Ansikt inkl. øyelokk, hals, nakke, hodebunn,
ytre øre og øregang. (Lok. Ca. cutis - melanoma malignum)'
1901 = 'Kropp, skulder, hofte, lyske, axiller, nates. (Lok. Ca. cutis - melanoma malignum)'
1902 = 'Overekstremiteter. (Lok. Ca. cutis - melanoma malignum)'
1903 = 'Føtter, nedenfor ankel.(Lok. Ca. cutis - melanoma malignum)'
1904 = 'Underekstremiteter over eller på ankel. (Lok. Ca. cutis - melanoma malignum)'
1905 = 'Perianalt. (Lok. Ca. cutis - melanoma malignum)'
1906 = 'Scrotum. (Lok. Ca. cutis - melanoma malignum)'
1907 = 'Mamma (begge kjønn). For menn: kun pigmentert område. (Lok. Ca. cutis - melanoma malignum)'
1908 = 'Andre spesifiserte lokalisasjoner / sub-unguinalt. (Lok. Ca. cutis - melanoma malignum)'
1909 = 'Hud i.n.s. (Lok. Ca. cutis - melanoma malignum)'

/*Lok. Ca. cutis - (ekskl. melanom, basalcellecarcinom).*/
1910 = 'Hud, ytre øre. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
1911 = 'Øyelokk med øyenvinkel, unntatt conjunctiva oculi. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
1912 = 'Ansiktet og hodet forøvrig, inkl. hodebunn, orbitalregionen,
hake, kinn. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
1913 = 'Hals, kropp, nakke, skulder, lyske, axiller, nates, hofte unntatt
genitalhud (lok. 176/179) samt Pagets sykdom i papilla mammae. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
1914 = 'Perianalt, perineum. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
1915 = 'Overekstremiteter. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
1916 = 'Underekstremiteter. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
1918 = 'Multiple lokalisasjoner, se kommentar. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
1919 = 'Hud i.n.s. (Lok. Ca. cutis - ekskl. melanom, basalcellecarcinom)'
/*Kommentar:*/
/*191.8 brukes ved 2. gangs opptreden av ny hudtumor etter 4 måneder.*/
/*Personen får da en ny akkumulert record med 191.8 mens den første blir*/
/*stående med spesifikk lokalisasjon. Ved ny hudtumor innen 4 måneder*/
/*skal det være kun en akkumulert record, men lokalisasjonen skal endres*/
/*til 191.8. Gjelder også Kaposis sarcom.*/

/*Lok. Ca. oculi.*/
1920 = 'Øyet, bulbus oculi, unntatt øyelokk. (Lok. Ca. oculi).'
1921 = 'Orbita; dvs. bløtdeler. (Lok. Ca. oculi)'
1922 = 'Tårekjertler, tåresekk. (Lok. Ca. oculi)'
1923 = 'Tårekanal. (Lok. Ca. oculi)'
1924 = 'Conjunctiva (øyets bindehinne, øyelokkets innside). (Lok. Ca. oculi)'
1925 = 'Andre spesifiserte lokalisasjoner i øyet. (Lok. Ca. oculi)'
1927 = 'Øye og orbita (ekskl. øyelokk), før 1983 (Lok. Ca. oculi)'
1928 = 'Utbredt over flere sublokalisasjoner. (Lok. Ca. oculi)'
1929 = 'Øye i.n.s. (Lok. Ca. oculi)'

/*Lok. Ca. cerebri, medullae, meningum, systematis nervosi.*/
1930 = 'Hjerne og medulla oblongata (forlengede marg).'
/*/*Omfatter ikke hypofyse og corpus pineale; -*/*/
/*/*bruk underlokalisasjon 393.x (Se kommentar).*/*/
1931 = 'Hjernenerver, intrakranielt forløp.'
1932 = 'Hjernehinner, meninger.'
1933 = 'Medulla spinalis, ryggmargen.'
1934 = 'Ryggmargens hinner.'
1935 = 'Perifere nerver, også hjernenerver når de går ekstrakranielt.'
1936 = 'Sympatiske nervesystem.'
1937 = 'Andre spesifiserte lokalisasjoner i CNS og PNS.'
1938 = 'Utbredt over flere sublokalisasjoner. (Lok. Ca. cerebri, medullae, meningum, systematis nervosi)'
1939 = 'Nervesystem i.n.s.'

/*Lok. Ca. thyreoideae.*/
1940 = 'Skjoldbruskkjertelen. Glandula thyreoidea.'
1941 = 'Ektopisk skjoldbruskkjertel.'

/*Lok. Ca. glandulae endocrinae.*/
1950 = 'Binyre. Glandulae suprarenalis.'
1951 = 'Parathyreiodae, biskjoldbruskkjertelen.'
1953 = 'Hypofyse. Lok. Ca. thyreoideae'
1954 = 'Corpus pineale. Lok. Ca. thyreoideae'
1955 = 'Cranieopharyngealkanal.'
1956 = 'Andre spesifiserte lokalisasjoner i endokrine organer
(glomus jugulare, glomus caroticus, autonome ganglier). Lok. Ca. thyreoideae'
1958 = 'Andre, før 1986. Lok. Ca. thyreoideae'
1959 = 'Endokrine organ i.n.s. Lok. Ca. thyreoideae'

/*Lok. Ca. ossis/cartilaginis.*/
1960 = 'Hode, unntatt underkjeve. (Lok. Ca. ossis/cartilaginis)'
1961 = 'Underkjeve (mandibula). (Lok. Ca. ossis/cartilaginis)'
1962 = 'Ryggrad (columna). (Lok. Ca. ossis/cartilaginis)'
1963 = 'Ribben (costa), brystben (sternum), kraveben (clavicula). (Lok. Ca. ossis/cartilaginis)'
1964 = 'Skulderblad (scapula), over- og underarm. (Lok. Ca. ossis/cartilaginis)'
1965 = 'Hånd, fingre, fot, tær. (Lok. Ca. ossis/cartilaginis)'
1966 = 'Bekkenben (pelvis) ): os coecygis, sacrum, ischii, ilii. (Lok. Ca. ossis/cartilaginis)'
1967 = 'Lår, legg over ankelen. (Lok. Ca. ossis/cartilaginis)'
1968 = 'Andre spesifiserte lokalisasjoner inklusive multiple
lokalisasjoner. (Lok. Ca. ossis/cartilaginis)'
1969 = 'Knokler i.n.s. (Lok. Ca. ossis/cartilaginis)'

/*Lok. Bløtdeltumores.*/
1970 = 'Hode, ansikt, hals. Lok. Bløtdeltumores'
1971 = ' Kropp, inkl. nates, axille, lyske. Lok. Bløtdeltumores'
1972 = 'Skulder, overekstremitet. Lok. Bløtdeltumores'
1973 = 'Hofte, underekstremitet. Lok. Bløtdeltumores'
1977 = 'Multiple svulster i bløtvev, før 1983. Lok. Bløtdeltumores'
1978 = 'Andre spesifiserte lokalisasjoner i bløtdeler. Lok. Bløtdeltumores'
1979 = 'Bløtdeler i.n.s. Lok. Bløtdeltumores'
/*Kommentar*/
/*Bløtdelssvulster i ledd, leddbånd, leddkapsel, sene, seneskjede,*/
/*muskulatur, fettvev, bindevev når den er lokalisert utenom spesifikke*/
/*organer med eget lokalisasjonsnummer.*/

/*Lok. Andre og uspesifiserte organer.*/
1990 = 'Ukjent, før 1993'
1991 = 'Utilstrekkelig spesifiserte lokalisasjoner i hode/hals/ansikt.'
1992 = 'Utilstrekkelig spesifiserte lokalisasjoner i thorax.'
1993 = 'Utilstrekkelig spesifiserte lokalisasjoner i abdomen.'
1994 = 'Utilstrekkelig spesifiserte lokalisasjoner i pelvis.'
1995 = 'Utilstrekkelig spesifiserte lokalisasjoner i ekstremiteter.'
1996 = 'Generalisert carcinomatose.'
1998 = 'Utilstrekkelig spesifiserte lokalisasjoner andre steder.'
1999 = ' Helt uten opplysninger om lokalisasjon.'

/*Lok. Ca. lymphonodorum.*/
2060 = 'Hals, inklusive fossa supraclavicularis, pre- og
retroauricularius, samt suboccipitale lymfeknuter. Lok. Ca. lymphonodorum'
2061 = 'Intrathoracalt.Lok. Ca. lymphonodorum'
2062 = ' Intraabdominalt. Lok. Ca. lymphonodorum'
2063 = 'Axiller, andre lymfeknuter på overekstremiteter. Lok. Ca. lymphonodorum'
2064 = 'Lysker, andre lymfeknuter på underekstremiteter. Lok. Ca. lymphonodorum'
2065 = 'ved underlok. Lok. Ca. lymphonodorum'
2066 = 'Hud (mycosis fungoides), før 1986. Lok. Ca. lymphonodorum '
2068 = 'Multiple lokalisasjoner", "Generell glandelsvulst, før 1993. Lok. Ca. lymphonodorum'
2069 = 'Lymfeknuter i.n.s. Lok. Ca. lymphonodorum'
/*Kommentar:*/
/*Ved malignt lymfom i andre organer brukes 206.5 med spesifikk under-*/
/*lokalisasjon. Gjelder også hud.*/
/*Benmargsaffeksjon betyr stadium IV, og skal ha lokalisasjon 206.9.*/

/*Lok. Benmarg*/
2070 = 'Benmarg';
/*Ved dobbeltmelding leukemi/lymfom skal lokalisasjon 206.5 med underlok*/
/*207.4 brukes.*/
run;


proc format;
value basis
00 = 'Klinisk undersoekelse uten tilleggsundersoekelser utenfor sykehus'
10 = 'Klinisk undersoekelse uten tilleggsundersoekelser i sykehus'
20 = 'Bildediagnostikk (roentgen, UL, CT, MR)'
22 = 'Klinisk melding naar det vites at det er gjort cytologisk undersoekelse av primaersvulst eller metastase som bekrefter diagnosen'
23 = 'Sykdomstilfelle generert paa bakgrunn av straaleterapidata og pas.adm.data Sykdomstilfelle generert paa bakgrunn av doedsattest og pas.adm.data '
29 = 'Prostata-spesifikt antigen (PSA) (basis for kreft i blaerehalskjertel)'
30 = 'Biokjemisk undersoekelse, elektroforese'
31 = 'Endoskopisk undersoekelse (uansett organ, inkl. ERCP)'
32 = 'Cytologisk undersoekelse (inkl. celleblokk), punksjonscytologi, Frantzens biopsi fra primaersvulst'
33 = 'Blodutstryk (cytologisk undersoekelse av perifert blod under mikroskop)'
34 = 'Benmargsutstryk (benmargsaspirat, sternalpunksjon, sternalmarg)'
35 = 'Spinalvaeskeundersoekelse'
36 = 'Cytologisk undersoekelse av metastase'
37 = 'Cytologisk undersoekelse av lokalt residiv (tilbakefall av sykdommen i samme kroppsomraade som primaersvulsten satt) '
38 = 'Cytologisk undersoekelse med immunfenotyping, immuncytokjemi eller cytogenetikk'
39 = 'Cytologisk undersoekelse, usikkert om fra primaersvulst eller metastase'
/*(Benyttes selv om cytologiske spesialundersoekelser er utfoert) */
40 = 'Operativt inngrep (eksplorativt eller terapeutisk) uten morfologisk undersoekelse'
41 = 'Obduksjon uten histologisk undersoekelse'
45 = 'Ploiditetsanalyse, flowcytometri eller billedanalyse (uten histologisk undersoekelse besvart paa aktuelle remisse)'
46 = 'Hormonreceptoranalyse'
47 = 'Molekylaergenetisk undersoekelse, PCR'
57 = 'Histologisk undersoekelse av lokalt residiv (tilbakefall av sykdommen i samme kroppsomraade som primaersvulsten satt)'
60 = 'Histologisk undersoekelse av metastase'
/*(68) (kodes ikke paa noen melding) Histologisk undersoekelse av metastase og obduksjon BASIS */
68 = 'Genereres automatisk i SYKDOMSTILFELLE paa grunnlag av BASIS 60 og BASIS 80 eller 82' /*enten disse kodekombinasjoner forekommer paa forskjellige meldinger, mellom SYKDOMSTILFELLE og ny melding eller mellom obduksjons-journalens to basis-koder. Benyttes kun for solide svulster.*/ 
70 = 'Histologisk undersoekelse av primaer solid svulst og alle non-solide svulster som ikke kodes BASIS 74, 75 eller 76. Benyttes ogsaa paa residiv av non-solide svulster'
71 = 'Dersom, etter ordinaer oppdatering av SYKDOMSTILFELLE, DS (5) og BASIS (32, 33, 34, 35, 39, 70, 74, 75, 76), settes automatisk BASIS = 71 i sykdomstilfelle'
72 = 'Klinisk melding naar det vites at det er gjort histologisk undersoekelse av primaersvulst eller metastase som bekrefter diagnosen (uansett om histologi-remissen er registrert eller ikke)'
74 = 'Histologisk undersoekelse med elektronmikroskopi (ultrastrukturell diagnostikk) av non-solid svulst (fra 01.01.93) og solid primaersvulst (fra 01.01.94)' 
75 = 'Histologisk undersoekelse med immunfenotyping (immunhistokjemi, immunfluorescens, vaeskestroemcytometri) av non-solid svulst (fra 01.01.93) og solid primaersvulst (fra 01.01.94)' 
76 = 'Histologisk undersoekelse med cytogenetisk/molekylaergenetisk undersoekelse / billedanalyse (D score, MNA-10, MAI) av non-solid svulst (fra 01.01.93) og solid primaersvulst (fra 01.01.94)' 
/*(78) (kodes ikke paa noen melding) Histologisk undersoekelse av primaersvulst og obduksjon basis */
78 = 'Genereres automatisk i sykdomstilfelle paa grunnlag av basis 70 og basis 68, 80 eller 82' /*enten disse kodekombinasjoner forekommer paa forskjellige meldinger, 
mellom sykdomstilfelle og ny melding eller mellom obduksjons-journalens to basis-koder. Benyttes kun for solide svulster*/ 
79 = 'Histologisk undersoekelse, ukjent om vevsproeven er fra primaersvulst eller metastase' 
80 = 'Obduksjon med histologisk undersoekelse, obduksjon med forutgaaende histologisk undersoekelse'
81 = 'Tilfeldig funn ved obduksjon med histologisk undersoekelse '
82 = 'Partiell obduksjon '
83 = 'Paa klinisk melding anfoeres, i tillegg til ordinaer BASIS naar det vites at det er utfoert obduksjon (uansett obduksjonens omfang, om krefttilfellet er et tilfeldig funn ved obduksjon eller om obduksjons-rapporten er 
registrert eller ikke)' 
/*(84) Historisk, benyttes ikke etter 01.01.93: Obduksjon uten restsvulst */
90 = 'Doedsmelding '
98 = 'Vevsproeve (histologisk eller cytologisk) uten svulstvev '
99 = 'Diagnosebasis ukjent';

/*Prosjekter som mottar data fra Kreftregisteret boer vurdere om krefttilfeller */
/*innmeldt til Kreftregisteret kun ved doedsattest (basis = 90) */
/*og tilfeller tilfeldig oppdaget ved obduksjon (basis = 81) skal fjernes */
/*fra utvalget.Dersom man kun oensker aa beholde krefttilfeller som er histologisk verifisert beholdes alle tilfeller med unntak av de */
/*med basis = 0-20, 23, 29, 31, 40, 81, 90 og 99.*/
/**/
run;
