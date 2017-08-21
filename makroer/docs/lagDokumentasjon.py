#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import codecs

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

indexFile = open("index.md", "w")
indexFile.write(index)
indexFile.close()


