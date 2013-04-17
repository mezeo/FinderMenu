#!/usr/bin/env python
## Copies the branding data into application bundle
import os
import re

def replaceDefineInFile(key, value, define, filew_brand, file_string, header_file):
    filew_brand.write(key + "=" + value + "\n\n")

    pattern = "#define\s+%s\s+.*\n?" % define.replace('"', '')
    subst = "#define	%s	\"" % define.replace('"', '') + value + "\"\n"

    # If '#define <define> ' pattern exists in file_string, substitute that line only
    regex = re.compile(pattern)
    if regex.findall(file_string):
        file_string = re.sub(pattern, subst, file_string)
        fh = open(header_file, 'w')
        fh.write(file_string)
        fh.close()
    else:
        # Append that line to end of .h file
        fh = open(header_file, 'a')
        fh.write("\n\n")
        fh.write(subst)
        fh.close()


entries = ["FINDER_SECURE_SHARE", "FINDER_PUBLIC_SHARE",
           "FINDER_FILE_VERSIONS", "FINDER_COMMENTS", "FINDER_VIEW_WEB_HOME",
           "FINDER_VIEW_FILE_WEB"]

finder_defines = ["FINDER_SECURE_SHARE", "FINDER_PUBLIC_SHARE",
                  "FINDER_FILE_VERSIONS", "FINDER_COMMENTS", "FINDER_VIEW_WEB_HOME",
                  "FINDER_VIEW_FILE_WEB"]

# Import the branding info into this namespace
branding_info = {}
execfile("%s/branding/branding.py" % (os.environ['PROJECT_DIR']), {}, branding_info)

# Finder file to temporarily write to
finder_branding_file = '%s/FinderMenu/branding.txt' % (os.environ['PROJECT_DIR'])
filew_brand = open(finder_branding_file, 'w')

# Finder header file to transfer values to
header_file = '%s/FinderMenu/FinderExt/FinderExt.h' % (os.environ['PROJECT_DIR'])
fh = open(header_file, 'r')
file_string = fh.read()
fh.close()

key = "SYNC_FOLDER_NAME"
value = branding_info[key]
replaceDefineInFile(key, value, "BRAND", filew_brand, file_string, header_file)

localized_strings = branding_info['LocalizedStrings']

for entry, define in zip(entries, finder_defines):
    fh = open(header_file, 'r')
    file_string = fh.read()
    fh.close()

    key = entry
    value = localized_strings[entry]
    replaceDefineInFile(key, value, define, filew_brand, file_string, header_file)

filew_brand.close()
