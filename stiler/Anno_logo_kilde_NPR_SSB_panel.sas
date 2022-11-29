data anno1;
retain drawspace "graphpercent" widthunit "percent" heightunit "percent"
linethickness 1 /*textsize 8*/;
length function $ 9 anchor $ 13;
input function $ x1 y1 width height /*x2 y2 textsize*/ anchor $ /*label $ 44-66*/
display $ 44-48 fillcolor $ 49-54;
cards;
Rectangle 98.4 12.33 30.2 21.1 bottomright fill white
;
run;

data Anno2;
length x1space $ 13 y1space $ 13 anchor $ 11 textweight $ 16 textcolor $ 16 Label $ 25 Layer $ 16;
retain
     function "Image";    
     x1space = "graphpercent"; 
     anchor = "bottomright";
     x1 = 97;  y1 = 11;  width=12;
     image = "&filbane/Stiler/logo\skde.png";
output; /*Logo*/
     function="text";
     anchor = "bottomleft";
     x1=70; y1=13; width=150; textsize = 8;
     textcolor="Black"; Textweight="Normal";
     label = "Kilde: NPR/SSB";
output;/*Kilde*/
     function = "text";
     anchor = "bottomleft";
     x1=70;  y1=22; width=50;
     layer="Front"; textsize=10; Textweight="Normal";
     textcolor="grey";
     label = "----";
Output;/*Stiplet linje*/

     function="text";
     anchor = "bottomleft";
     x1 = 74;  y1=22; width=50;
     layer="Front";  textsize = 9;
     textcolor="Black";     Textweight="Normal";
     label = "Norge";
output;/*Forklaring*/

run;

data anno;
set anno1 anno2;
run;