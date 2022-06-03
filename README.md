# dmf_dev_setup

Contains common development configuration

## installPowershellModules.ps1

This is a script that will install the PowerShell module defined in PruneLocal.psm1.  It will handle installing the modules both in Windows and Linux (assuming you have powershell core installed).  In Linux it will also add a ~/.devrc file (copied from devrc.sh) which creates bash aliases to the powershell module functions so that they can be invoked directly from a bash shell.

## PruneLocal.psm1

This powershell module file contains functions we want automatically available via powershell -
- PruneLocal
- PruneLocalHard
