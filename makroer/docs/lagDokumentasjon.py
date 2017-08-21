#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import codecs

def extractDoc(filename):

   # Extract text in file that are
   # between /*! and */
   
   macroFile = open(filename, "r")
   macroFileContent = macroFile.readlines()
   macroFile.close()

   doc = ""
   extract = False
   for i in macroFileContent:
      if extract and "*/" in i:
         extract = False
      if extract:
         doc += i
      if "/*!" in i:
         extract = True
   return(doc)

def findSASfiles(folder):
   SASfiles = []
   for fn in os.listdir(folder):
      readFile = False
      try:
         if fn.endswith(".sas"):
            readFile = True
         else:
            readFile = False
      except:
         readFile = False

      if readFile:
         SASfiles.append(fn)

   return(SASfiles)

def deleteMD(folder):
   for fn in os.listdir(folder):
      if fn.endswith(".md"):
         os.remove(fn)

folder = "../"   
listofMacros = findSASfiles(folder)

deleteMD(".")

index = ""
for i in listofMacros:
   heading = '''[Ta meg tilbake.](./)

# {0}

'''.format(i.split(".")[0])

   doc = extractDoc(folder + i)
   
   if doc != "":
      index += "- [{0}]({0})\n".format(i.split(".")[0])
      docFile = codecs.open(i.split(".")[0]+".md", "w", "utf-8")
      docFile.write(heading + doc)
      docFile.close()

      
indexHeading="""
Dokumentasjon av SAS-makroene.

Makroene ligger her:
```
\\tos-sas-skde-01\SKDE_SAS\Makroer\master
```
For å bruke de i din egen SAS-kode, legges følgende inn i koden:
```
%let filbane=\\tos-sas-skde-01\SKDE_SAS\;
options sasautos=("&filbane.Makroer\master" SASAUTOS);
```

Hvis man vil lage en ny makro, lager man en sas-fil som heter det samme som makroen. Makroene dokumenteres direkte i koden. Eksempel på makro, som legges i en fil som heter `minNyeMakro.sas`:
```
%macro minNyeMakro(variabel1 = );

/*!
Min dokumentasjon av makroen minNyeMakro
*/

sas-kode...

%mend;
```



Alt som ligger mellom `/*!` og `*/` vil legges inn i `docs/minNyeMakro.md` av scriptet `lagDokumentasjon.py` i mappen `docs`. Ved å kjøre dette scriptet og så dytte opp til *github*, vil dokumentasjon legges på nett.

## Linker til dokumentasjon av de ulike makroene

"""

indexFile = open("index.md", "w")
indexFile.write(indexHeading+index)
indexFile.close()


