/************************************************************************************
Lage annoteringsdatasett for logo og kildehenvisning
************************************************************************************/
Options locale=NB_no;
data Anno;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 Label $ 25;
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomright";
	x1 = 98;
	y1 = 7;
	width=12;
	image = "&filbane/stiler/logo/skde.png";
output; /*Logo*/

run;