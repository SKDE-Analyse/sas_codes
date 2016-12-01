%macro reinnleggelser_hjelp;

%put ================================================================================;
%put Reinnleggelser-makro - opprettet av Arnfinn 1. des. 2016 ;
%put Makro for å markere EoC som er en reinnleggelse ;
%put Makroen Episode_of_care må være kjørt før reinnleggelse-makroen;
%put NOTE: reinnleggelser(dsn=, ReInn_Tid = 30, eks_diag=1);
%put 1. dsn: datasett man utfører analysen på;
%put 2. ReInn_Tid (=30): tidskrav i dager mellom primæropphold og et eventuelt reinnleggelsesopphold;
%put 3. eks_diag (=1): Hvis ulik 0, innleggelser som inneholder hoved- eller bi-diagnoser, som brukt av kunnskapssenteret, er ikke en reinnl.;
%put Alle avdelingsopphold i en EoC som er en reinnleggelse blir markert som det (EoC_reinnleggelse = 1);
%put ================================================================================;

%mend;
