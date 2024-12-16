%include "&filbane/stiler/anno_logo_kilde_npr_ssb_dark.sas";
proc template;
   define style dark_mode_stil;
      parent=styles.htmlblue;
      style GraphAxisLines / contrastcolor=white color=white; /* farge på x- og y akse-linje */
      style GraphValueText / color=white; /* Farge på verdiene på x- og y-aksene */
      style GraphLabelText / color=white; /* Farge på x- og y-akse labels */
      style GraphLegendText / color=white; /* Farge på Legend-text */
      style GraphBackground / color=CX00233F; /* Bakgrundsfarge - ytre */
      style GraphWalls / color=CX00233F; /* Bakgrundsfarge - indre */
   end;
run;