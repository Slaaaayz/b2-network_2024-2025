# TP7 SECU : Accès réseau sécurisé

## I. VPN

**🌞 Monter un serveur VPN Wireguard sur vpn.tp7.secu**

```
[slayz@vpn ~]$ sudo modprobe wireguard
[sudo] password for slayz: 
[slayz@vpn ~]$ echo wireguard | sudo tee /etc/modules-load.d//wireguard.conf
wireguard
[slayz@vpn ~]$ sudo sysctl -p
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
[slayz@vpn ~]$ sudo dnf install wireguard-tools -y
[slayz@vpn ~]$ wg genkey | sudo tee /etc/wireguard/server.key
kLIuWSXAJ9VUjd3hdhk0bHdHVu8rTJ644A4jvpVhXEc=
[slayz@vpn ~]$ sudo chmod 0400 /etc/wireguard/server.key
[slayz@vpn ~]$ sudo cat /etc/wireguard/server.key | wg pubkey | sudo tee /etc/wireguard/server.pub
zFvhh+eW4myExW7Dd9dMmMCwuMBXwtodd6oBvEruu2A=
[slayz@vpn ~]$ sudo chmod 0400 /etc/wireguard/clients/martine.key
[slayz@vpn ~]$ sudo mkdir -p /etc/wireguard/clients
[slayz@vpn ~]$ wg genkey | sudo tee /etc/wireguard/clients/martine.key
aGO4xOWx1cVhV4BdDMk1xqT1cV8igMUm2CN/7Az6mEQ=
[slayz@vpn ~]$ sudo cat /etc/wireguard/clients/martine.key | wg pubkey | sudo tee /etc/wireguard/clients/martine.pub
YjOj0wNR/kO7qm0NCuccFzovYc8oC00cezvvQmEAvUU=
[slayz@vpn ~]$ sudo cat /etc/wireguard/wg0.conf
[Interface]
Address = 10.7.2.1/24
SaveConfig = false
PostUp = firewall-cmd --zone=public --add-masquerade
PostUp = firewall-cmd --add-interface=wg0 --zone=public
PostDown = firewall-cmd --zone=public --remove-masquerade
PostDown = firewall-cmd --remove-interface=wg0 --zone=public
ListenPort = 13337
PrivateKey = kLIuWSXAJ9VUjd3hdhk0bHdHVu8rTJ644A4jvpVhXEc= 

[Peer]
PublicKey = YjOj0wNR/kO7qm0NCuccFzovYc8oC00cezvvQmEAvUU=
AllowedIPs = 10.7.2.11/32 

[slayz@vpn ~]$ sudo systemctl start wg-quick@wg0.service
[slayz@vpn ~]$ sudo systemctl status wg-quick@wg0.service
● wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0
     Loaded: loaded (/usr/lib/systemd/system/wg-quick@.service; disabled; preset: disabled)
     Active: active (exited) since Thu 2024-11-21 10:08:01 CET; 4s ago
       Docs: man:wg-quick(8)
             man:wg(8)
             https://www.wireguard.com/
             https://www.wireguard.com/quickstart/
             https://git.zx2c4.com/wireguard-tools/about/src/man/wg-quick.8
             https://git.zx2c4.com/wireguard-tools/about/src/man/wg.8
    Process: 11852 ExecStart=/usr/bin/wg-quick up wg0 (code=exited, status=0/SUCCESS)
   Main PID: 11852 (code=exited, status=0/SUCCESS)
        CPU: 245ms

Nov 21 10:08:01 vpn.tp7.secu systemd[1]: Starting WireGuard via wg-quick(8) for wg0...
Nov 21 10:08:01 vpn.tp7.secu wg-quick[11852]: [#] ip link add wg0 type wireguard
Nov 21 10:08:01 vpn.tp7.secu wg-quick[11852]: [#] wg setconf wg0 /dev/fd/63
Nov 21 10:08:01 vpn.tp7.secu wg-quick[11852]: [#] ip -4 address add 10.7.2.0/24 dev wg0
Nov 21 10:08:01 vpn.tp7.secu wg-quick[11852]: [#] ip link set mtu 1420 up dev wg0
Nov 21 10:08:01 vpn.tp7.secu wg-quick[11852]: [#] firewall-cmd --zone=public --add-masquerade
Nov 21 10:08:01 vpn.tp7.secu wg-quick[11884]: success
Nov 21 10:08:01 vpn.tp7.secu wg-quick[11852]: [#] firewall-cmd --add-interface=wg0 --zone=public
Nov 21 10:08:01 vpn.tp7.secu wg-quick[11899]: success
Nov 21 10:08:01 vpn.tp7.secu systemd[1]: Finished WireGuard via wg-quick(8) for wg0.
[slayz@vpn ~]$ sudo nano /etc/wireguard/wg0.conf
[slayz@vpn ~]$ sudo systemctl start wg-quick@wg0.service
[slayz@vpn ~]$ sudo ss -alntpu
Netid           State            Recv-Q           Send-Q                     Local Address:Port                       Peer Address:Port           Process                                     
udp             UNCONN           0                0                                0.0.0.0:13337                           0.0.0.0:*                                                          
udp             UNCONN           0                0                              127.0.0.1:323                             0.0.0.0:*               users:(("chronyd",pid=702,fd=5))           
udp             UNCONN           0                0                                   [::]:13337                              [::]:*                                                          
udp             UNCONN           0                0                                  [::1]:323                                [::]:*               users:(("chronyd",pid=702,fd=6))           
tcp             LISTEN           0                128                              0.0.0.0:22                              0.0.0.0:*               users:(("sshd",pid=730,fd=3))              
tcp             LISTEN           0                128                                 [::]:22                                 [::]:*               users:(("sshd",pid=730,fd=4))              
[slayz@vpn ~]$ sudo firewall-cmd --add-port=13337/udp --permanent
success
[slayz@vpn ~]$ sudo firewall-cmd --reload
success
[slayz@vpn ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:82:e6:70 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 84833sec preferred_lft 84833sec
    inet6 fd00::a00:27ff:fe82:e670/64 scope global dynamic noprefixroute 
       valid_lft 86088sec preferred_lft 14088sec
    inet6 fe80::a00:27ff:fe82:e670/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:b5:30:77 brd ff:ff:ff:ff:ff:ff
    inet 10.7.1.100/24 brd 10.7.1.255 scope global noprefixroute enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feb5:3077/64 scope link 
       valid_lft forever preferred_lft forever
6: wg0: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
    link/none 
    inet 10.7.2.0/24 scope global wg0
       valid_lft forever preferred_lft forever

```

**🌞 Client Wireguard sur martine.tp7.secu**

```
[slayz@martine wireguard]$ ip route add default via 10.7.2.1
[slayz@martine wireguard]$ sudo cat martine.conf
[Interface]
Address = 10.7.2.11/24
PrivateKey = aGO4xOWx1cVhV4BdDMk1xqT1cV8igMUm2CN/7Az6mEQ=
 
[Peer]
PublicKey = zFvhh+eW4myExW7Dd9dMmMCwuMBXwtodd6oBvEruu2A=
AllowedIPs = 0.0.0.0/0
Endpoint = 10.7.1.100:13337
[slayz@martine wireguard]$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=254 time=20.2 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=254 time=19.1 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=254 time=22.2 ms
^C
--- 1.1.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 19.100/20.507/22.227/1.295 ms

```

**🌞 Client Wireguard sur votre PC**

```
slayz@debian:~$ sudo apt install wireguard
slayz@debian:~$ sudo wg genkey | sudo tee /etc/wireguard/client.key
slayz@debian:~$ sudo chmod 0400 /etc/wireguard/client.key
slayz@debian:~$ sudo cat /etc/wireguard/client.key | wg pubkey | sudo tee /etc/wireguard/client.pub
slayz@debian:~$ sudo cat /etc/wireguard/wg0.conf
[Interface]
PrivateKey = 4BddvRjwYBwQPmZ5PYhGX7LcNfZ7ow2lt3XDTwIqWEU= 
Address = 10.7.2.15/24

[Peer]
PublicKey = zFvhh+eW4myExW7Dd9dMmMCwuMBXwtodd6oBvEruu2A=
AllowedIPs =  0.0.0.0/0
Endpoint = 10.7.1.100:13337

slayz@debian:~$ ping 10.7.2.11
PING 10.7.2.11 (10.7.2.11) 56(84) bytes of data.
64 bytes from 10.7.2.11: icmp_seq=1 ttl=63 time=3.54 ms
64 bytes from 10.7.2.11: icmp_seq=2 ttl=63 time=4.90 ms
^C
--- 10.7.2.11 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 3.537/4.218/4.899/0.681 ms

```

## II. SSH

### 1. Setup

**🌞 Générez des confs Wireguard pour tout le monde**

[Voici le script pour generer des confs Wireguard](client.sh)

```
[slayz@bastion ~]$ sudo bash client.sh 

  ____               _____   _                       
 |  _ \             / ____| | |                      
 | |_) |  _   _    | (___   | |   __ _   _   _   ____
 |  _ <  | | | |    \___ \  | |  / _` | | | | | |_  /
 | |_) | | |_| |    ____) | | | | (_| | | |_| |  / / 
 |____/   \__, |   |_____/  |_|  \__,_|  \__, | /___|
           __/ |                          __/ |      
          |___/                          |___/       

-------------------------------------------------
La clé publique du client est :
PDAnMEjp81R+adprfIHEInVuNE+4UYAnKDfCgudL1GQ=
-------------------------------------------------
Ajoutez cette clé publique au serveur WireGuard avec l'adresse IP : 10.7.2.189/32
Voici le contenu du [peer] à ajouter au serveur :
-------------------------------------------------
[Peer]
PublicKey = PDAnMEjp81R+adprfIHEInVuNE+4UYAnKDfCgudL1GQ=
AllowedIPs = 10.7.2.189/32
-------------------------------------------------
Creation des alias pour les interfaces...
Alias crée : vpn-up et vpn-down
Activation de l'interface WireGuard...
[#] ip link add client type wireguard
[#] wg setconf client /dev/fd/63
[#] ip -4 address add 10.7.2.189/24 dev client
[#] ip link set mtu 1420 up dev client
[#] wg set client fwmark 51820
[#] ip -4 route add 0.0.0.0/0 dev client table 51820
[#] ip -4 rule add not fwmark 51820 table 51820
[#] ip -4 rule add table main suppress_prefixlength 0
[#] sysctl -q net.ipv4.conf.all.src_valid_mark=1
[#] nft -f /dev/fd/63
Ajout de la route par défaut via le VPN...
Configuration du client WireGuard terminée. Le fichier de configuration est situé dans /etc/wireguard/client.conf.
[slayz@bastion ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:82:14:49 brd ff:ff:ff:ff:ff:ff
    inet 10.7.1.12/24 brd 10.7.1.255 scope global noprefixroute enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe82:1449/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:d6:11:fb brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s8
       valid_lft 86138sec preferred_lft 86138sec
    inet6 fd00::c1f3:e01c:700b:26fc/64 scope global dynamic noprefixroute 
       valid_lft 86295sec preferred_lft 14295sec
    inet6 fe80::6d02:6cce:e88b:b4d7/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: client: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
    link/none 
    inet 10.7.2.189/24 scope global client
       valid_lft forever preferred_lft forever
         
[slayz@bastion ~]$ ping -I client 1.1.1.1
PING 1.1.1.1 (1.1.1.1) from 10.7.2.189 client: 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=254 time=19.5 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=254 time=19.7 ms
^C
--- 1.1.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1003ms
rtt min/avg/max/mdev = 19.486/19.573/19.660/0.087 ms
```

### 2. Bastion

**🌞 Empêcher la connexion SSH directe sur web.tp7.secu**

```
[slayz@web ~]$ sudo cat iptables.sh 
#!/bin/bash

iptables -F ; iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

iptables -A INPUT -p udp --sport 13337 -j ACCEPT
iptables -A OUTPUT -p udp --dport 13337 -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

iptables -A INPUT --src 10.7.2.1 -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT


[slayz@bastion ~]$ ssh 10.7.2.114
slayz@10.7.2.114's password: 

```
**🌞 Connectez-vous avec un jump SSH**

```
[slayz@bastion ~]$ ssh -J 10.7.2.189 10.7.2.114
slayz@10.7.2.189's password: 
slayz@10.7.2.114's password: 
Last login: Sun Nov 24 11:15:12 2024 from 10.7.2.1
[slayz@web ~]$ 
```

### 3. Connexion par clé
**🌞 Générez une nouvelle paire de clés pour ce TP**

```
slayz@debian:~$ ssh-keygen -o -a 100 -t ed25519
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/slayz/.ssh/id_ed25519): 
/home/slayz/.ssh/id_ed25519 already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/slayz/.ssh/id_ed25519
Your public key has been saved in /home/slayz/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:QmzE91M0Uat4PeZ7odQz1uJJwmLVnAKgBy5FcvzFSx0 slayz@debian
The key's randomart image is:
+--[ED25519 256]--+
|    .+* .o oE+.  |
|     Boo. = o. . |
|    . *o.+ + o.. |
|     + .. +.oo+  |
|      . S .+o.= .|
|       .  o.o+oB.|
|         . ..++o+|
|             .o..|
|              .. |
+----[SHA256]-----+
slayz@debian:~$ ssh-copy-id -i ~/.ssh/id_ed25519.pub slayz@10.7.2.114
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/slayz/.ssh/id_ed25519.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
slayz@10.7.2.114's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'slayz@10.7.2.114'"
and check to make sure that only the key(s) you wanted were added.
```

### 4. Conf serveur SSH

**🌞 Changez l'adresse IP d'écoute**

```
[slayz@web ~]$ sudo cat /etc/ssh/sshd_config | grep Listen
ListenAddress 10.7.2.1
[slayz@web ~]$ sudo systemctl restart sshd
slayz@debian:~$ ssh slayz@10.7.1.13
ssh: connect to host 10.7.1.13 port 22: Connection timed out
```

**🌞 Améliorer le niveau de sécurité du serveur**


Pour obliger l’utilisation de clés SSH, dans /etc/ssh/sshd_config :

```
PasswordAuthentication no
```
Permettre uniquement à certains utilisateurs de se connecter via SSH :

```
AllowUsers slayz
```

Remplacez le port SSH par un port non standard pour éviter les scans automatisés (bien que cela ne soit pas une sécurité absolue) :

```
Port 2222
```


## III. HTTP

### 1. Initial setup

**🌞 Monter un bête serveur HTTP sur web.tp7.secu**

```
sudo dnf install nginx 
sudo cat /etc/nginx/conf.d/web.conf
server {
    server_name web.tp7.secu;

    listen 10.7.2.1:80;

    root /var/www/site_nul;
}
sudo systemctl start nginx
sudo systemctl enable nginx
```

**🌞 Site web joignable qu'au sein du réseau VPN**

```
[slayz@web ~]$ sudo cat iptables.sh 
#!/bin/bash

iptables -F ; iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

iptables -A INPUT -p udp --sport 13337 -j ACCEPT
iptables -A OUTPUT -p udp --dport 13337 -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

iptables -A INPUT --src 10.7.2.1 -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

iptables -A INPUT -i client -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT

iptables -L -v -n
```

```
[slayz@web ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:e3:bb:58 brd ff:ff:ff:ff:ff:ff
    inet 10.7.1.13/24 brd 10.7.1.255 scope global noprefixroute enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fee3:bb58/64 scope link 
       valid_lft forever preferred_lft forever
3: client: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
    link/none 
    inet 10.7.2.114/24 scope global client
       valid_lft forever preferred_lft forever
[slayz@web ~]$ curl 10.7.1.13
curl: (28) Failed to connect to 10.7.1.13 port 80: Connection timed out
```

**🌞 Accéder au site web**

```
slayz@debian:~$ curl 10.7.2.114
<h1>toto</h1>
```

### 2. Génération de certificat et HTTPS

## A. Préparation de la CA

**🌞 Générer une clé et un certificat de CA**

```
[slayz@web ~]$ openssl genrsa -des3 -out CA.key 4096
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
[slayz@web ~]$ openssl req -x509 -new -nodes -key CA.key -sha256 -days 1024  -out CA.pem
Enter pass phrase for CA.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:fr
State or Province Name (full name) []:france
Locality Name (eg, city) [Default City]:bordeaux
Organization Name (eg, company) [Default Company Ltd]:slayz
Organizational Unit Name (eg, section) []:slayz
Common Name (eg, your name or your server's hostname) []:slayz
Email Address []:slayz@slayz.com
[slayz@web ~]$ ls
CA.key  CA.pem  client.sh  index.html  iptables.sh
```

## B. Génération du certificat pour le serveur web

**🌞 Générer une clé et une demande de signature de certificat pour notre serveur web**

```
[slayz@web ~]$ openssl req -new -nodes -out web.tp7.secu.csr -newkey rsa:4096 -keyout web.tp7.secu.key
......+.....+......+.+......+..+.+......+...+..+.+..+.......+.........+..+...+....+..+...+...+.......+...........+.........+.+..+.......+..+...+..........+......+.....+......+.+.........+........+.......+.....+......+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*..+...........+......+.......+..+...+.+.....+.+.........+...........................+..+.......+...+..+...+......+.+...+......+..+.......+..+......+....+...+......+.....+.+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*......+.........+.........+.....+.+..............+.+..............+.+..+...+.......+....................+.............+...............+......+........+......+....+.....+.............+...+............+..+............+.+.....+............+...+......................+........+..........+........+...................+..+......+.......+..+..................+............+....+......+......+.....+.......+...+...+......+.....+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
...+....+.....+.+.....+.+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*..+..+.....................+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*.....................+...........+..........+...........+.........+....+...+...+..........................+.........+....+.................+.............+........+....+...+........+.............+..+....+...+......+............+..............+.+.........+..............+.........+............+.........+.+..............+....+..+.+..+.............+.........+...............+......+...+.....+....+...+....................+...+.......+..+.......+.........+..........................+.+.....+...+.+.........+..+.........+...+...+....+...+........+.......+......+..+...+.+...+...+..+.......+.....+......+...+.+........+.............+...+...........+............................+.....+...+...+.........+..................+....+...........+..........+..............+......+...............+....+......+............+...+..............+....+..+....+......+..............+....+...........+...+.+......+...+......+......+......+...............+........+..........+.....+.+...+..................+.................+...............+.+......+......+.......................+...............+......+.+..+.......+......+............+...+............+..+...+...+...................+.......................+............+......+...+.......+.....+.........+....+........................+.....+.+.....+........................+..........+.....+.....................+......+....+..+.........+....+.....+....+......+.....+.+........+.+............+...+..+.......+..+.........+...............+...................+......+..+....+........+...+...+.......+...+.....+............+.......+..+.........+......+......+...+.......+...+...............+.....+.........+.+............+...+.....+.......+........+...................+...+.....+..........+...+..............+......+.........+......+................+.....+...+...+....+...+...+..+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:fr
State or Province Name (full name) []:france  
Locality Name (eg, city) [Default City]:bordeaux
Organization Name (eg, company) [Default Company Ltd]:slayz
Organizational Unit Name (eg, section) []:slayz
Common Name (eg, your name or your server's hostname) []:slayz
Email Address []:slayz@slayz.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:root
An optional company name []:slayz
```

**🌞 Faire signer notre certificat par la clé de la CA**

```
[slayz@web ~]$ cat v3.ext 
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = web.tp7.secu
DNS.2 = www.tp7.secu

[slayz@web ~]$ openssl x509 -req -in web.tp7.secu.csr -CA CA.pem -CAkey CA.key -CAcreateserial -out web.tp7.secu.crt -days 500 -sha256 -extfile v3.ext
Certificate request self-signature ok
subject=C = fr, ST = france, L = bordeaux, O = slayz, OU = slayz, CN = slayz, emailAddress = slayz@slayz.com
Enter pass phrase for CA.key:
```

## C. Bonnes pratiques RedHat

**🌞 Déplacer les clés et les certificats dans l'emplacement réservé**

```
[slayz@web ~]$ sudo mv CA.key CA.pem web.tp7.secu.key /etc/pki/tls/private/
[slayz@web ~]$ sudo mv CA.srl web.tp7.secu.crt web.tp7.secu.csr /etc/pki/tls/certs/
```

## D. Config serveur Web

**🌞 Ajustez la configuration NGINX**

```
[slayz@web ~]$ sudo cat /etc/nginx/conf.d/web.conf 
server {
    server_name web.tp7.secu;

    listen 10.7.2.114:443 ssl;

    ssl_certificate /etc/pki/tls/certs/web.tp7.secu.crt;
    ssl_certificate_key /etc/pki/tls/private/web.tp7.secu.key;

    root /var/www/site_nul;

    location / {
        index index.html index.htm;
    }
}
```

**🌞 Prouvez avec un curl que vous accédez au site web**

```
slayz@debian:~$ curl -k https://10.7.2.114
<h1>toto</h1>
```

**🌞 Ajouter le certificat de la CA dans votre navigateur**

```
slayz@debian:~$ sudo cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	debian

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

10.10.11.20 editorial.htb
10.10.11.32 sightless.htb
10.10.11.32 sqlpad.sightless.htb


10.7.2.114 web.tp7.b2
```

```
Sous Firefox :

Ouvrez Firefox et allez dans Paramètres > Vie privée et sécurité.
Faites défiler jusqu'à Certificats et cliquez sur Afficher les certificats.
Dans l'onglet Autorités, cliquez sur Importer.
Sélectionnez le fichier.
Cochez "Faire confiance à cette CA pour identifier des sites web", puis validez.
```