/************************************************************************************
Lage annoteringsdatasett for logo og kildehenvisning
************************************************************************************/
data Anno;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 Label $ 25;
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomright";
	x1 = 95;
	y1 = 12;
	width=12;
	
output; /*Logo*/
	function = "text";
	anchor = "bottomleft";
	x1 = 85;
	width=150;
	textsize = 8;
	label = "Kilde: NPR/SSB";
output;/*Kilde*/
run;