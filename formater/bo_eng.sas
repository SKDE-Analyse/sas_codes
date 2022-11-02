Proc format;


Value BoHF
	1='Finnmark Hospital Trust - residence'
	2='University Hospital of Northern Norway - residence'
	3='Nordland Hospital Trust- residence'
	4='Helgeland Hospital Trust - residence'
	6='Nord-Trøndelag Hospital Trust - residence'
	7="St. Olavs Hospital Trust - residence"
	8='Møre og Romsdal Hospital Trust - residence'
	9='Haraldsplass Diakonale Sykehus - residence'
	10='Førde Health Trust - residence'
	11='Bergen Health Trust - residence'
	12='Fonna Health Trust - residence'
	13='Stavanger Health Trust - residence'
	14='Østfold Hospital Trust - residence'
	15='Akershus University Hospital Trust - residence'
	16='Oslo University Hospital Trust - residence'
	17='Lovisenberg Diakonale Sykehus - residence'
	18='Diakonhjemmet sykehus - residence'
	19='Innlandet Hospital Trust - residence'
	20='Vestre Viken Hospital Trust - residence'
	21='Vestfold Hospital Trust - residence'
	22='Telemark Hospital Trust - residence'
	23='Sørlandet Hospital Trust - residence'
	24='Abroad/Svalbard - residence'
	30='Oslo - residence'
	31='Inner Oslo - residence'
	8888='Norway'
	99='Unknown/invalid municipal nr';
 
Value BoHF_kort
	1='Finnmark'
	2='UNN'
	3='Nordland'
	4='Helgeland '
	6='Nord-Trøndelag'
	7="St. Olav"
	8='Møre og Romsdal'
	9='Haraldsplass'
	10='Førde'
	11='Bergen'
	12='Fonna'
	13='Stavanger'
	14='Østfold'
	15='Akershus'
	16='OUS'
	17='Lovisenberg'
	18='Diakonhjemmet'
	19='Innlandet'
	20='Vestre Viken'
	21='Vestfold'
	22='Telemark'
	23='Sørlandet'
	24='Abroad/Svalbard'
	30='Oslo'
	31='Inner Oslo'
	8888='Norway'
	99='Unknown/invalid municipal nr';
	 
Value Bydel
	30101 = 'Gamle Oslo'
	30102 = 'Grünerløkka'
	30103 = 'Sagene'
	30104 = 'St. Hanshaugen'
	30105 = 'Frogner'
	30106 = 'Ullern'
	30107 = 'Vestre Aker'
	30108 = 'Nordre Aker'
	30109 = 'Bjerke'
	30110 = 'Grorud'
	30111 = 'Stovner'
	30112 = 'Alna'
	30113 = 'Østensjø'
	30114 = 'Nordstrand'
	30115 = 'Søndre Nordstrand'
	30116 = 'Sentrum'
	30117 = 'Marka'
 	30199 = 'Unknown district Oslo'
	110301 = 'Hundvåg'
	110302 = "Tasta"
	110303 = "Eiganes/Våland"
	110304 = "Madla"
	110305 = "Storhaug"
	110306 = "Hillevåg"
	110307 = "Hinna"
	110399 = "Unknown district Stavanger"
	120101 = "Arna"
	120102 = "Bergenhus"
	120103 = "Fana"
	120104 = "Fyllingsdalen"
	120105 = "Laksevåg"
	120106 = "Ytrebygda"
	120107 = "Årstad"
	120108 = "Åsane"
	120199 = "Unknown district Bergen"
	160101 = "Midtbyen"
	160102 = "Østbyen"
	160103 = "Lerkendal"
	160104 = "Heimdal"
	160199 = "Unknown district Trondheim";

Value Bydel_Oslo
0='Not resident in Oslo'
01='Gamle Oslo'
02='Grünerløkka'
03='Sagene'
04='St. Hanshaugen'
05='Frogner'
06='Ullern'
07='Vestre Aker'
08='Nordre Aker'
09='Bjerke'
10='Grorud'
11='Stovner'
12='Alna'
13='Østensjø'
14='Nordstrand'
15='Søndre Nordstrand'
16='Sentrum'
17='Marka'
99='Unknown district Oslo';

value bydel_Stavanger
0="Not resident in Stavanger"
01 = "Hundvåg"
02 = "Tasta"
03 = "Eiganes/Våland"
04 = "Madla"
05 = "Storhaug"
06 = "Hillevåg"
07 = "Hinna"
99 = "Unknown district Stavanger";

value bydel_Bergen
0="Not resident in Bergen"
01 = "Arna"
02 = "Bergenhus"
03 = "Fana"
04 = "Fyllingsdalen"
05 = "Laksevåg"
06 = "Ytrebygda"
07 = "Årstad"
08 = "Åsane"
99 = "Unknown district Bergen";

value bydel_Trondheim
0="Not resident in Trondheim"
01 = "Midtbyen"
02 = "Østbyen"
03 = "Lerkendal"
04 = "Heimdal"
99 = "Unknown district Trondheim" ;


value bydel_alle

030101 = "01 Gamle Oslo"
030102 = "02 Grünerløkka"
030103 = "03 Sagene"
030104 = "04 St. Hanshaugen"
030105 = "05 Frogner"
030106 = "06 Ullern"
030107 = "07 Vestre Aker"
030108 = "08 Nordre Aker"
030109 = "09 Bjerke"
030110 = "10 Grorud"
030111 = "11 Stovner"
030112 = "12 Alna"
030113 = "13 Østensjø"
030114 = "14 Nordstrand"
030115 = "15 Søndre Nordstrand"
030116 = "16 Sentrum"
030117 = "17 Marka"
030199 = "Unknown district Oslo"

110301 = "01 Hundvåg"
110302 = "02 Tasta"
110303 = "03 Eiganes/Våland"
110304 = "04 Madla"
110305 = "05 Storhaug"
110306 = "06 Hillevåg"
110307 = "07 Hinna"
110399 = "Unknown district Stavanger"

120101 = "01 Arna"
120102 = "02 Bergenhus"
120103 = "03 Fana"
120104 = "04 Fyllingsdalen"
120105 = "05 Laksevåg"
120106 = "06 Ytrebygda"
120107 = "07 Årstad"
120108 = "08 Åsane"
120199 = "Unknown district Bergen"

160101 = "01 Midtbyen"
160102 = "02 Østbyen"
160103 = "03 Lerkendal"
160104 = "04 Heimdal"
160199 = "Unknown district Trondheim" ;

 
value BoRHF
1='Northern Norway Regional Health Authority - residence' 
2='Central Norway Regional Health Authority - residence' 
3='The Western Norway Regional Health Authority - residence' 
4='South-Eastern Norway Regional Health Authority - residence' 
24='Abroad/Svalbard - residence' 
8888='Norway'
99='Unknown/invalid municipal nr';

value BoRHF_kort
1='Northern Norway RHA' 
2='Central Norway RHA' 
3='Western Norway RHA' 
4='South-Eastern Norway RHA' 
24='Abroad/Svalbard' 
8888='Norway'
99='Unknown/invalid municipal nr';

value BoRHF_kortest
1='North' 
2='Central' 
3='West' 
4='South-East' 
24='Abroad/Svalbard' 
8888='Norway'
99='Unknown/invalid municipal nr';

 
value BoShHN
1='Kirkenes - residence'
2='Hammerfest - residence' 
3='Tromsø - residence'
4='Harstad - residence'
5='Narvik - residence' 
6='Vesterålen - residence'
7='Lofoten - residence' 
8='Bodø - residence' 
9='Rana - residence' 
10='Mosjøen - residence' 
11='Sandnessjøen - residence'
8888='Norway';

value BoShHN_kort
1='Kirkenes'
2='Hammerfest' 
3='Tromsø'
4='Harstad'
5='Narvik' 
6='Vesterålen'
7='Lofoten' 
8='Bodø' 
9='Rana' 
10='Mosjøen' 
11='Sandnessjøen'
8888='Norway';

value fylke
1 ='Østfold'
2 ='Akershus'
3 ='Oslo'
4 ='Hedmark'
5 ='Oppland'
6 ='Buskerud'
7 ='Vestfold'      
8 ='Telemark'
9 ='Aust-Agder'
10='Vest-Agder'
11='Rogaland'
12='Hordaland'
14='Sogn og Fjordane'
15='Møre og Romsdal'
16='Sør-Trøndelag'
17='Nord-Trøndelag'
18='Nordland'
19='Troms Romsa'
20='Finnmark Finnmárku'
24='Abroad/Svalbard - residence'
8888='Norway' 
99='Unknown/invalid municipal nr';
 
value vertskommHN
1='Host municipal '
0='Not host municipal ';


run;
 
