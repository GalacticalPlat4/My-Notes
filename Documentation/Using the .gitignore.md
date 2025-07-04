When filling the document with folder you would want to ignore you first need to remove said folder or file from Git's index.
When a folder or file is in Git's index it's considered tracked and cannot be ignored.
By running git rm -r --cached "Enter folder or file name here" this will remove