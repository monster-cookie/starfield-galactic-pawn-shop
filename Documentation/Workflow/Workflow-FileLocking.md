# File Locking

Currently this caused more problems then it solved so we will just have to coordinate exchanging files around the 
problem lies with the read-only flag Git LFS is setting when the file is unlocked. The read only flag causes problems
with the CK and Game.  

## Binary Single Access files

Game data files (ESM/ESP/ESL) and model files (NIF) can only be access and edited by a single author from start to 
finish until BGS restores CK2 version control. 

### Instructions to lock a file

#### Fork

Currently GitHub does not support LFS as it is still a preview feature for them. 

- Open Fork
- Open the relevant repo
- Select from the menu bar Repository > Git LFS
- Select Status (Locks) to verify the file you need isn't locked by someone
  ![Git LFS Menu](./Documentation/images/Fork_GitLFS.png)
- On the main repository display select "All Commits"
- Then in the lower panel choose file tree
- Right click the ESP/ESM/NIF file you want to lock and choose LFS > Lock
  ![Git LFS Lock/Unlock](./Documentation/images/Fork_LockUnlockFile.png)

#### Command Line
- To lock the file to you, execute:
  - git lfs lock [filename]

### Instructions to unlock a file

#### Fork

Currently GitHub does not support LFS as it is still a preview feature for them. 

- Open Fork
- Open the relevant repo
- Select from the menu bar Repository > Git LFS
- Select Status (Locks) to verify the file you need is still locked by you
  ![Git LFS Menu](./Documentation/images/Fork_GitLFS.png)
- On the main repository display select "All Commits"
- Then in the lower panel choose file tree
- Right click the ESP/ESM/NIF file you want to lock and choose LFS > Unlock
  ![Git LFS Lock/Unlock](./Documentation/images/Fork_LockUnlockFile.png)

#### Command Line
- To lock the file to you, execute:
  - git lfs unlock [filename]
