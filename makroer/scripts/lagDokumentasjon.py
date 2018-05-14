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

def main():
  
    folder = "./"
    listofMacros = findSASfiles(folder)

    docFolder = "./docs/"
    try:
        os.makedirs(docFolder)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

    index = ""
    
    # Make a separate web page for each macro
    for i in listofMacros:
        tail = '''

[Ta meg tilbake.](./)

'''
        heading = '''
# {0}

'''.format(i.split(".")[0])

        # Extract documentation from sas-file i
        doc = extractDoc(folder + i)
   
        if doc != "":
            # Add link in index file
            index += "- [{0}]({0})\n".format(i.split(".")[0])
            docFile = codecs.open(docFolder+i.split(".")[0]+".md", "w", "utf-8")
            docFile.write(heading + doc + tail)
            docFile.close()
        else:
            warnings.warn("WARNING: File {0} is not documented!".format(i))
    
    # Start the index page from the README file
    indexHeading = ""
    for i in open("./README.md","r").readlines():
        indexHeading += i
    
    indexHeading += '''

## Linker til dokumentasjon av de ulike makroene

'''

    indexFile = open(docFolder+"index.md", "w")
    indexFile.write(indexHeading+index)
    indexFile.close()

if __name__ == "__main__":
    main()
