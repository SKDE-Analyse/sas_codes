proc sgplot data=&RV_Poli noborder noautolegend sganno=ANNOARSVAR pad=(Bottom=5%) ;
     highlow y=&bo low=numlow high=numhigh / type=bar name="hl1" lineattrs=(color=CX00509E);
          styleattrs datacolors=(CX95BDE6);
     Refline Norge / axis=x lineattrs=(Thickness=.5 color=Black pattern=2) name="Ref1";
	 *Refline Universitet / axis=x lineattrs=(Thickness=.5 color=Black pattern=1) name="Ref2";
	 scatter y=&Bo x=rate2011 / markerattrs=(symbol=squarefilled size=5 color=Black) name="sc3";
	 scatter y=&Bo x=rate2012 / markerattrs=(symbol=diamondfilled size=5 color=Black) name="sc4";
     scatter y=&Bo x=rate2013 / markerattrs=(symbol=circlefilled size=5 color=Black) name="sc5";
     scatter y=&Bo x=rate2014 / markerattrs=(symbol=Trianglefilled size=5 color=Black) name="sc6";
     Highlow Y=&bo low=Min high=Max / type=line name="hl2" lineattrs=(color=black thickness=1 pattern=1);
     Yaxistable Innbyggere Opphold  /Label location=inside position=right valueattrs=(size=7 family=arial) 
          labelattrs=(size=7);
     yaxis display=(noticks noline) label='Hospital referral area' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis display=(nolabel) offsetmin=0.02 values=&skala_poli min=0  valuesformat=COMMA8.0 valueattrs=(size=7);
     inset ("(*ESC*){unicode'25a0'x}" = "   2011" 
			"(*ESC*){unicode'2666'x}" = "   2012" 
			"(*ESC*){unicode'25cf'x}" = "   2013" 
			"(*ESC*){unicode'25b2'x}" = "   2014" 
            "(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}" = " Norge"  
			/*"(*ESC*){unicode'2500'x}(*ESC*){unicode'2500'x}" = " Ref.omr"*/) 
			/ position=bottomright textattrs=(size=7);
     format Innbyggere Opphold comma10.0;
run;Title; ods graphics off;