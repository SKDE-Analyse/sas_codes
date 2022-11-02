proc sgplot data=Figurgrunnlag noborder noautolegend sganno=AnnoArsvar pad=(Bottom=5%) ;
     highlow y=&bo low=numlow high=numhigh / /*highlabel=totalrate*/ labelattrs=(Color=Black) group=Type type=bar name="hl";
     Refline NorgeTot / axis=x lineattrs=(Thickness=.5 color=Black pattern=2) name="Ref";
     scatter y=&bo x=labelpos / datalabel=labelValue datalabelpos=center markerattrs=(size=0) name="sc" 
          datalabelattrs=(color=white weight=bold size=6);
     Yaxistable &Yaxistable /Label location=inside position=right valueattrs=(size=7 family=arial) 
          labelattrs=(size=7);
     keylegend "hl" / location=outside position=topleft noborder titleattrs=(size=6);
     yaxis display=(noticks noline) label='Boområde / opptaksområde' labelattrs=(size=7 weight=bold) type=discrete discreteorder=data valueattrs=(size=7);
     xaxis offsetmin=0.02 display=(nolabel) values=&skala_forbruk valuesformat=NLNUM8.0 valueattrs=(size=7);
     inset  ("(*ESC*){unicode'2212'x}(*ESC*){unicode'2212'x}"=" Norge") / position=bottomright textattrs=(size=7);
  run;Title;
ods graphics off;