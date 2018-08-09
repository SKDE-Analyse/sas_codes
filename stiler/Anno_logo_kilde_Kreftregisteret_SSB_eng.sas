/************************************************************************************
Lage annoteringsdatasett for logo og kildehenvisning
************************************************************************************/
data Anno;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 Label $ 40;
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomright";
	x1 = 98;
	y1 = 2;
	width=12;
	image = "\\tos-sas-skde-01\SKDE_SAS\FELLESKODER\MASTER\Stiler\logo\skde.png";
output; /*Logo*/
	function = "text";
	anchor = "bottomleft";
	x1 = 1;
	width=150;
	textsize = 8;
	label = "Source: Cancer Registry of Norway/SSB";
output;/*Kilde*/
run;