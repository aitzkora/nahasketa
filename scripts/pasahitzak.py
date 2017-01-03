import subprocess
import re

def getpasswd(account):
    command = ["/usr/bin/gpg2","-dq", "/home/fux/.pasahitzak.gpg"]
    out = subprocess.check_output(command).splitlines()
    out = [line for line in out if account in str(line).rstrip('\n')]
    if len(out) == 0:
        print("erreur : account %s does not exist" % account)
        return ""
    out = str(out[0]).split("=")[1]
    out = re.sub(r"\"", "", out)
    return re.sub(r"'", "" , out)
