#!/usr/bin/env python
# -*- coding: utf-8 -*-


def extractDoc(filename):

    import codecs
    # Extract text in file that are
    # between /*! and */

    macroFile = codecs.open(filename, "r", "latin-1")
    macroFileContent = macroFile.readlines()
    macroFile.close()

    doc = ""
    extract = False

    # Only make macro heading for the first layer of macros,
    # not for macros inside macro
    macroLayer = 0

    for i in macroFileContent:
        if i.startswith("%macro"):
            macroLayer += 1

        if (not extract) and (i.startswith("%macro")) and (macroLayer == 1):
            # Macro heading
            doc += '''
## Makro `{0}`

'''.format(i[7:].split("(")[0])
            insideMacro = True
        if extract and "*/" in i:
            # Stop extracting doc when */ is found in file
            extract = False
        if extract:
            doc += i
        if "/*!" in i:
            # Start extracting doc when /*! is found in file
            extract = True
        if i.startswith("%mend"):
            macroLayer -= 1
    return(doc)


def findSASfiles(folders):
    import os
    SASfiles = []
    for i in folders:
        for fn in os.listdir(i):
            readFile = False
            if fn.endswith(".sas"):
                readFile = True
            else:
                readFile = False

            if readFile:
                SASfiles.append(i + "/" + fn)

    return(SASfiles)


def main():
    import os
    import errno
    import codecs
    import warnings
    import sys

    folders = []
    for i in sys.argv[1:]:
        folders.append(i)
    if len(folders) == 0:
        folders = ["."]

    listofMacros = findSASfiles(folders)

    docFolder = "./docs/"
    try:
        os.makedirs(docFolder)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

    index = ""

    # Make a separate web page for each sas file
    for i in listofMacros:
        tail = '''

[Ta meg tilbake.](./)

'''
        heading = '''
# Dokumentasjon for filen *{0}*

'''.format(i)

        # Extract documentation from sas-file i
        doc = extractDoc(i)

        filename = i.split("/")[-1]
        if doc != "":
            # Add link in index file
            mdfile = filename.split(".")[0] + ".md"
            index += "- [{0}]({1})\n".format(i, mdfile.split(".")[0])
            docFile = codecs.open(docFolder + mdfile, "w", "utf-8")
            docFile.write(heading + doc)
            docFile.close()
        else:
            warnings.warn("ADVARSEL: Filen {0} er ikke dokumentert!".format(filename))
            index += "- Filen {} er ikke dokumentert.\n".format(filename)

    # Start the index page from the docs/preindex.md file
    indexHeading = ""
    for i in open("./docs/preindex.md", "r").readlines():
        indexHeading += i

    indexHeading += '''

## Linker til dokumentasjon av de ulike filene

'''

    indexFile = open(docFolder + "index.md", "w")
    indexFile.write(indexHeading + index)
    indexFile.close()


if __name__ == "__main__":
    main()
