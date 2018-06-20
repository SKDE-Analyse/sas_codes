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
	y1 = 2;
	width=12;
	image = "\\tos-sas-skde-01\SKDE_SAS\Stiler\logo\skde.png";
output; /*Logo*/
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomleft";
	x1 = 2;
	y1 = 2;
	width=40;
	image = "\\tos-sas-skde-01\SKDE_Felles\RightCare\Bilder\SKDE_logo\NNK.jpg";
output; /*Logo NNK*/
	function = "text";
	anchor = "bottomleft";
	x1 = 2;
	y1 = 6;
	width=150;
	textsize = 9;
	label = "Source: NNK/MFR";
output;/*Kilde*/

run;