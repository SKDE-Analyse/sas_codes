/************************************************************************************
Lage annoteringsdatasett for logo og kildehenvisning
************************************************************************************/
data anno2;
retain drawspace "graphpercent" widthunit "percent" heightunit "percent"
linethickness 1 /*textsize 8*/;
length function $ 9 anchor $ 13;
input function $ x1 y1 width height /*x2 y2 textsize*/ anchor $ /*label $ 44-66*/
display $ 41-44 fillcolor $ 45-50;
cards;
Rectangle 58.8 31.5 6.2 9.0 bottomright fill white
;
run;

data Anno1;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 Label $ 25;
retain function "Image"; 
	x1space="graphpercent"; 
	y1space="graphpercent";
	anchor = "bottomright";
	x1 = 98;
	y1 = 2;
	width=12;
	image = "&filbane\Stiler\logo\skde.png";
output; /*Logo*/
	function = "text";
	anchor = "bottomleft";
	x1 = 8;
	width=150;
	textsize = 8;
	label = "Kilde: NPR/SSB";
output;/*Kilde*/
	function = "text";
	anchor = "bottomleft";
	x1 = 26;
	y1= 96.5;
	width=150;
	textsize = 11;
	label = "Alle tjenester";
output;
	function = "text";
	anchor = "bottomleft";
	x1 = 66;
	y1= 96.5;
	width=150;
	textsize = 11;
	label = "Akutte innleggelser";
output;
run;


data anno3;
set anno2 anno1;
run;