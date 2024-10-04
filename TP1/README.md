# TP1 : Maîtrise réseau du votre poste
## I. Basics

**☀️ Carte réseau WiFi**
``` 
PS C:\Users\melb3> ipconfig /all
Adresse physique . . . . . . . . . . . : B0-DC-EF-BB-FF-9E
Adresse IPv4. . . . . . . . . . . . . .: 10.33.73.81(préféré)
Masque de sous-réseau. . . . . . . . . : 255.255.240.0
Ou 
Masque de sous-reseau en CIDR : /20
```

**☀️ Déso pas déso**

```
Adresse de broadcast : 10.33.79.255
Adresse de réseau du LAN : 10.33.73.1
4094 IP sont disponibles sur le réseau
```

**☀️ Hostname**
    
```
PS C:\Users\melb3> hostname
Maxime
```

**☀️ Passerelle du réseau**
```
PS C:\Users\melb3> ipconfig /all
Passerelle par défaut. . . . . . . . . : 10.33.79.254
PS C:\Users\melb3> arp -a
10.33.79.254          7c-5a-1c-d3-d8-76     dynamique
```

**☀️ Serveur DHCP et DNS**
```
PS C:\Users\melb3> ipconfig /all
Serveur DHCP . . . . . . . . . . . . . : 10.33.79.254
Serveurs DNS. . .  . . . . . . . . . . : 1.1.1.1
```

**☀️ Table de routage**
```
PS C:\Users\melb3> route print -4
0.0.0.0          0.0.0.0     10.33.79.254      10.33.73.81     35
```

## II. Go further

**☀️ Hosts ?**
```
PS C:\Users\melb3> ping b2.hello.vous

Envoi d’une requête 'ping' sur b2.hello.vous [1.1.1.1] avec 32 octets de données :
Réponse de 1.1.1.1 : octets=32 temps=61 ms TTL=55
Réponse de 1.1.1.1 : octets=32 temps=15 ms TTL=55
Réponse de 1.1.1.1 : octets=32 temps=16 ms TTL=55
Réponse de 1.1.1.1 : octets=32 temps=16 ms TTL=55

Statistiques Ping pour 1.1.1.1:
    Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 15ms, Maximum = 61ms, Moyenne = 27ms
```

**☀️ Go mater une vidéo youtube et déterminer, pendant qu'elle tourne...**

```    
PS C:\Windows\system32> netstat -n -a -b | Select-String chrome -Context 1,0
UDP    0.0.0.0:61588          91.68.245.140:443
>  [chrome.exe]

Port serveur : 443
Port client : 61588
```

**☀️ Requêtes DNS**
```
PS C:\Users\melb3> nslookup www.thinkerview.com
Addresses:
          188.114.96.6
          188.114.97.6
PS C:\Users\melb3> nslookup 143.90.88.12
Nom :    EAOcf-140p12.ppp15.odn.ne.jp
Address:  143.90.88.12
```
**☀️ Hop hop hop**
```
PS C:\Users\melb3> tracert -d www.ynov.com

Détermination de l’itinéraire vers www.ynov.com [104.26.11.233]
avec un maximum de 30 sauts :

  1     2 ms     2 ms     1 ms  10.33.79.254
  2     3 ms     2 ms     2 ms  195.7.117.145
  3     3 ms     3 ms     5 ms  86.79.195.237
  4     5 ms     6 ms     5 ms  86.65.224.196
  5    12 ms    56 ms    14 ms  194.6.147.164
  6    27 ms     *        *     162.158.20.24
  7    62 ms    16 ms    16 ms  162.158.20.31
  8    16 ms    63 ms    16 ms  104.26.11.233

Itinéraire déterminé.

Il passe par 8 machines avant d'arriver à la destination
```
**☀️ IP publique**
```
PS C:\Users\melb3> curl ifconfig.me
Content           : 195.7.117.146
```

## III. Le requin

**☀️ Capture ARP**  

[Lien vers capture ARP](./arp.pcapng)

**☀️ Capture DNS**

[Lien vers capture DNS](./dns.pcapng)

**☀️ Capture TCP**

[Lien vers capture TCP](./tcp.pcapng)

