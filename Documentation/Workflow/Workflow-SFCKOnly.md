# Workflow - SFCK Only

This part can be completed using any git client but the instructions are for fork

## Initial Setup

None really for this workflow

## Reoccurring Setup  

If you have been working with another mod for example, MCS/StarSim/Core/Junk Recycler. 

- You will need to clean out the old files first as the SFCK requires a pristine environment. 
  - Delete any non Starfield ESM/ESL/ESP files from the Game Data directory
  - Delete any namespace folders in the Scripts subdirectory of the Game Data Folder
  - Delete any namespace folders in the Scripts/Source subdirectory of the Game Data Folder
- Open CreationKitPrefs.ini and find the [Papyrus] section
  - Set SDefaultNamespace, SMRUNamespace1, and SMRUNamespace2 to the correct values for this mod (see Tools/sharedConfig.ps1) for example MCS is QOG:MCS and StarSim is QOG:StarSim
    - Not sure of the purpose of SMRUNamespace1 and SMRUNamespace2


## Instructions

- Open your git client of choice (GitHub Desktop, Fork, VSCode, Visual Studio), Due to file locking these instructions will use fork.
- In the toolbar click the Fetch button to query the remote repository for any updates you are missing.
- In the toolbar click the pull button to pull the missing update to your local instance.
- If editing game data files (ESM/ESP/ESL) or model files (NIF), please follow the instruction below in "Instructions to lock a file".
  - Currently we are not supporting this due to problems with the read-only flag the system uses when the file is unlocked
- Open Visual Studio Code.
- Choose Terminal > Run Task and find "Update SFCK (DataDir)" in the list, this script copies the repository versions of the papyrus scripts and game database files to SFCK so it can consume them.
- Do your needed work in SFCK or VSCode for papyrus work.
  - If making papyrus changes and need to sync the updated scripts and code again; Choose Terminal > Run Task and find "Compile Papyrus Scripts (DataDir)" in the list.
- When ready to commit files you need to pull in the changes from the SFCK; Choose Terminal > Run Task and find "Update Repository (DataDir)" in the list.
- Stage and commit the files providing a description of what you changed
- If you locked any game data files (ESM/ESP/ESL) or model files (NIF), please follow the instruction below in "Instructions to unlock a file".
  - Currently we are not supporting this due to problems with the read-only flag the system uses when the file is unlocked
