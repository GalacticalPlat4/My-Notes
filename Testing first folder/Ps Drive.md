# This is creating a new PowerShell drive that only exist in PowerShell Example: folder called PSforWork lives in the Demo folder in Root.
new-psdrive -name PSforWork -Description "This is a test location for my PS scripts for work" -PSProvider FileSystem -Root C:\Demo

# First go to Root
cd c:\

# Then type the PSDrive (PowerShell drive)
cd psforwork: