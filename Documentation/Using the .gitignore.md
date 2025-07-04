When filling the document with folder names you would want to ignore you first need to remove said folder or file from Git's index.
When a folder or file is in Git's index it's considered *tracked* and cannot be ignored.
By running `git rm -r --cached "Enter folder or file name here"` this will remove the copy of the file from Git's index, but leaves the folder or file alone in your file system. This would now be considered *untracked*.

For more detail explanation here is [Torek's](https://stackoverflow.com/questions/66716064/file-is-not-ignored-despite-adding-it-to-gitignore) explanation that I used to resolve my issue.