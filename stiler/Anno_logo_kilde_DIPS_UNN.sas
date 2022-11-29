/************************************************************************************
Lage annoteringsdatasett for logo og kildehenvisning
************************************************************************************/
data Anno;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 Label $ 30;
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomright";
	x1 =99.9;
	y1 =0.2;
	/*width=30;*/
	image = "\\hn.helsenord.no\RHF\SKDE\Analyse\Prosjekter\Lise\NarvikHarstad\UNN_logo2.png";
output; /*Logo*/
	function = "text";
	anchor = "bottomleft";
	x1 = 1;
	width=150;
	textsize = 9;
	label = "Kilde: UNNs 0perasjonsdatabase";
output;/*Kilde*/
run;

/************************************************************************************
Lage annoteringsdatasett for logo og kildehenvisning
************************************************************************************/
data Anno2015;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 Label $ 30;
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomright";
	x1 =99.9;
	y1 =0.2;
	/*width=30;*/
	image = "\\hn.helsenord.no\RHF\SKDE\Analyse\Prosjekter\Lise\NarvikHarstad\UNN_logo2.png";
output; /*Logo*/
	function = "text";
	anchor = "bottomleft";
	x1 = 1;
	width=150;
	textsize = 9;
	label = "Kilde: UNNs 0perasjonsdatabase";
output;/*Kilde*/
	function = "text";
	anchor = "bottomleft";
	x1 = 1;
	y1=4;
	width=150;
	textsize = 9;
	label = "%sysfunc(byte(185)) 01.01.2015 - 16.12.2015";
output;/*Fotnote*/
run;