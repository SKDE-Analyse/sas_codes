/************************************************************************************
Lage annoteringsdatasett for logo og kildehenvisning
************************************************************************************/
Options locale=NB_no;
data Anno;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 Label $ 90;
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomright";
	x1 = 98;
	y1 = 2;
	width=12;
	image = "&filbane/stiler/logo/SKDE_figur.jpg";
output; /*Logo*/
function = "text";
	anchor = "bottomleft";
	x1 = 2;
	y1=4;
	width=150;
	textsize = 8;
	label = "Source: NNK";
output;/*Kilde*/
function="text";
	anchor="bottomleft";
	x1=2;
	y1=1;
	width=500;
	textsize = 7;
	Label= "%sysfunc(byte(185)) Data for Vestfold 2009-2011 is estimated from average for 2012-2014.";
output;/*Forklaring*/
run;
data AnnoRHF;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 Label $ 90;
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomright";
	x1 = 98;
	y1 = 2;
	width=12;
	image = "&filbane/stiler/logo/SKDE_figur.jpg";
output; /*Logo*/
function = "text";
	anchor = "bottomleft";
	x1 = 2;
	y1=4;
	width=150;
	textsize = 8;
	label = "Kilde: NNK";
output;/*Kilde*/
function="text";
	anchor="bottomleft";
	x1=2;
	y1=1;
	width=300;
	textsize = 7;
	Label= "%sysfunc(byte(185)) Data for Vestfold 2009-2011 is estimated from average for 2012-2014.";
output;/*Forklaring*/
run;