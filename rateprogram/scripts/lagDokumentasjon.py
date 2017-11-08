#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import codecs
import warnings
import errno


def extractDoc(filename):

   # Extract text in file that are
   # between /*! and */
   
    macroFile = codecs.open(filename, "r", "latin-1")
    macroFileContent = macroFile.readlines()
    macroFile.close()

    doc = ""
    extract = False
    for i in macroFileContent:
        if len(i.split()) == 2:
            if i.split()[0] == "%macro":
                print(i)
                doc += '''
## Makro {0}

'''.format(i.split()[1])
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

folder = "./"
listofMacros = findSASfiles(folder)
print(listofMacros)

docFolder = "./docs/"

try:
    os.makedirs(docFolder)
except OSError as e:
    if e.errno != errno.EEXIST:
        raise

index = ""
for i in listofMacros:
   heading = '''[Ta meg tilbake.](./)

# Oversikt over innholdet i filen `{0}`
'''.format(i)

   heading += '''
{: .no_toc}

## Innholdsfortegnelse
{: .no_toc}

* auto-gen TOC:
{:toc}
'''

   doc = extractDoc(folder + i)
   
   if doc != "":
      index += "- [{0}]({1})\n".format(i,i.split(".")[0])
      docFile = codecs.open(docFolder+i.split(".")[0]+".md", "w", "utf-8")
      docFile.write(heading + doc)
      docFile.close()
   else:
      warnings.warn("ADVARSEL: Filen {0} er ikke dokumentert!".format(i))
      index += "- Filen {} er ikke dokumentert.".format(i)
      
indexHeading = ""
for i in open("./docs/indexHead.md","r").readlines():
   indexHeading += i

indexFile = open(docFolder+"index.md", "w")
indexFile.write(indexHeading+index)
indexFile.close()


