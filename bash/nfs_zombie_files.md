# Demonstration for creating and removing .nfsxxxx files

- From the NFS client, create a file in the mounted NFS share and open it with the tail command. Suspend the process with ctrl-z or open a new terminal to complete the rest of the demonstration.

```bash
# echo test > foo
# tail -f foo
test
^Z
[1]+ Stopped tail -f foo
``` 
- Remove the file foo to make the NFS client create the .nfsxxxx file.
```bash
# rm foo
# ls -A .nfs*
.nfs000000000021f8e8000009a2
```  
-  it is impossible to remove that file
```bash
# rm .nfs000000000021f8e8000009a2
rm: impossible de supprimer « .nfs000000000021f8e8000009a2 »: Périphérique ou ressource occupé

``` 
- Locate the process that has the file open using fuser.

```bash
$ fuser ./.nfs000000000021f8e8000009a2
/home/fuentes/.nfs000000000021f8e8000009a2: 304548
```
- Finally, terminate the process holding the file open and observe that the .nfsxxx file is now removed.
```bash
$ kill -9 304548
```
- Observe that the file is not there anymore
```bash
$ ls ./.nfs000000000021f8e8000009a2
ls: impossible d'accéder à ./.nfs000000000021f8e8000009a2: Aucun fichier ou dossier de ce type
```
