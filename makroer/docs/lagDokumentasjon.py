#!/usr/bin/env python
# -*- coding: utf-8 -*-




import sys
import os

def extractDoc(filename):
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


folder = "../"   
listofMacros = findSASfiles(folder)

for i in listofMacros:
   doc = '''[Ta meg tilbake.](./)

# {0}

'''.format(i.split(".")[0])

   doc += extractDoc(folder + i)
   
   docFile = open(i.split(".")[0]+".md", "w")
   docFile.write(doc)
   docFile.close()


   

#print(extractDoc("../Episode_of_care.sas"))

