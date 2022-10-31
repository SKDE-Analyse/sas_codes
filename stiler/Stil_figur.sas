proc template;
source Styles.HTMLBlue;
define style Styles.Stil_figur;
   parent = styles.HTMLBlue;
   class body, header, footer / Backgroundcolor=white;
   style GraphBox /
   	  capstyle="line"
      linethickness = 1px
      linestyle = 1
      markersize = 0px
      markersymbol = "dot";
      
	style graphdata1 / color=CX00509E;
	Style graphdata2 / color=CX95BDE6;
	Style graphdata3 / color=CX568BBF;
	Style graphdata4 / color=CX969696;
	style graphframe / linethickness=0px;
	style graphxaxislines / linethickness=1px;
	style graphwalls / frameborder=off;
	style graphbackground / color=white;
	replace Table from Output /*Output from Container*/ / 
		 borderwidth=0.2
		 frame = hsides /* outside borders */ 
		 borderwidth=0.2
		 rules = groups /* internal borders */ 
		 cellspacing=0;
end;
run;

   