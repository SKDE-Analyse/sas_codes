/*
Definere variabler
*/


%macro definerVariabler;


%macro gi_verdi(variabel = , verdi = );
/*%if %sysevalf(%superq(&variabel)=,boolean) %then %do;*/
    %global &variabel;
	/*%if %length(&verdi) ne 0 %then*/ %let &variabel = &verdi;
/*%end;*/
%mend;

    %gi_verdi(variabel = Ratefil, verdi = test.ratetest_11_15;);

    %gi_verdi(variabel = RV_variabelnavn, verdi = poli);
    
    %gi_verdi(variabel = ratevariabel, verdi = Poliklinikk);
    
    %gi_verdi(variabel = forbruksmal, verdi = Konsultasjoner);

    %gi_verdi(variabel = innbyggerfil, verdi = Innbygg.innb_2004_2017_bydel_allebyer);
    
    %gi_verdi(variabel = aarsvarfigur, verdi = );
    
    %gi_verdi(variabel = aarsobs, verdi = );
    
    %gi_verdi(variabel = NorgeSoyle, verdi = 1);

    %gi_verdi(variabel = KIfigur, verdi = );    

    %gi_verdi(variabel = Mine_boomraader, verdi = );

    %gi_verdi(variabel = vis_ekskludering, verdi = );

    %gi_verdi(variabel = kommune, verdi = );

    %gi_verdi(variabel = Fig_AA_kom, verdi = );

    %gi_verdi(variabel = Fig_KI_kom, verdi = );

    %gi_verdi(variabel = kommune_HN, verdi = 1);

    %gi_verdi(variabel = Fig_AA_komHN, verdi = );

    %gi_verdi(variabel = Fig_KI_komHN, verdi = );

    %gi_verdi(variabel = fylke, verdi = 1);

    %gi_verdi(variabel = Fig_AA_fylke, verdi = );

    %gi_verdi(variabel = Fig_KI_fylke, verdi = );

    %gi_verdi(variabel = sykehus_HN, verdi = 1);

    %gi_verdi(variabel = Fig_AA_ShHN, verdi = );

    %gi_verdi(variabel = Fig_KI_ShHN, verdi = );

    %gi_verdi(variabel = HF, verdi = 1);

    %gi_verdi(variabel = Fig_AA_HF, verdi = );

    %gi_verdi(variabel = Fig_KI_HF, verdi = );

    %gi_verdi(variabel = RHF, verdi = 1);

    %gi_verdi(variabel = Fig_AA_RHF, verdi = );

    %gi_verdi(variabel = Fig_KI_RHF, verdi = );

    %gi_verdi(variabel = Oslo, verdi = 1);

    %gi_verdi(variabel = Fig_AA_Oslo, verdi = );

    %gi_verdi(variabel = Fig_KI_Oslo, verdi = );

    %gi_verdi(variabel = Vertskommune_HN, verdi = );

    %gi_verdi(variabel = bildeformat, verdi = png);

    %gi_verdi(variabel = lagring, verdi = "\\hn.helsenord.no\RHF\SKDE\Analyse\Data\SAS\Bildefiler");

    %gi_verdi(variabel = hoyde, verdi = 8.0cm);

    %gi_verdi(variabel = bredde, verdi = 11.0cm);

    %gi_verdi(variabel = skala, verdi = );

    %gi_verdi(variabel = Vis_Tabeller, verdi = 1);

    %gi_verdi(variabel = TallFormat, verdi = NLnum);

    %gi_verdi(variabel = kart, verdi = );

    %gi_verdi(variabel = rateformat, verdi = 2);

    %gi_verdi(variabel = Ut_sett, verdi = );

    %gi_verdi(variabel = StartÅr, verdi = 2011);

    %gi_verdi(variabel = SluttÅr, verdi = 2015);

    %gi_verdi(variabel = aar, verdi = 2014);

    %gi_verdi(variabel = aldersspenn, verdi = in (0:105));

    %gi_verdi(variabel = Alderskategorier, verdi = 30);

    %gi_verdi(variabel = aldjust, verdi = );

    %gi_verdi(variabel = standard, verdi = Kjønns- og aldersstandardiserte);

    %gi_verdi(variabel = kjonn, verdi = (0,1));

    %gi_verdi(variabel = rate_pr, verdi = 1000);

    %gi_verdi(variabel = boomraade, verdi = BoRHF in (1:4));

    %gi_verdi(variabel = boomraadeN, verdi = BoRHF in (1:4));

    %gi_verdi(variabel = SnittOmraade, verdi = Norge);

%mend;
