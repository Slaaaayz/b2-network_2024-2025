# TP4 SECU : Exfiltration

## I. Getting started Scapy

**🌞 ping.py**

```bash
slayyzer@Slayz:~/Ynov/b2-network-2024$ sudo /bin/python3 ping.py 
Begin emission:
Finished sending 1 packets.
*
Received 1 packets, got 1 answers, remaining 0 packets
Pong reçu : QueryAnswer(query=<Ether  dst=7c:5a:1c:d3:d8:76 src=b0:dc:ef:bb:ff:9e type=IPv4 |<IP  frag=0 proto=icmp src=10.33.73.81 dst=1.1.1.1 |<ICMP  type=echo-request |>>>, answer=<Ether  dst=b0:dc:ef:bb:ff:9e src=7c:5a:1c:d3:d8:76 type=IPv4 |<IP  version=4 ihl=5 tos=0x0 len=28 id=36798 flags= frag=0 ttl=55 proto=icmp chksum=0x9eaf src=1.1.1.1 dst=10.33.73.81 |<ICMP  type=echo-reply code=0 chksum=0x0 id=0x0 seq=0x0 unused=b'' |<Padding  load=b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' |>>>>)
```

**🌞 tcp_cap.py**

```bash
slayyzer@Slayz:~/Ynov/b2-network-2024/TP4$ sudo /bin/python3 tcp_cap.py
TCP SYN ACK reçu !
- Adresse IP src : 1.1.1.1
- Adresse IP dst : 10.33.73.81
- Port TCP src : 80
- Port TCP dst : 55592
```

**🌞 dns_cap.py**

```bash
slayyzer@Slayz:~/Ynov/b2-network-2024/TP4$ sudo /bin/python3 dns_cap.py 
Begin emission:
Finished sending 1 packets.
...*
Received 4 packets, got 1 answers, remaining 0 packets
104.26.10.233
```

**🌞 dns_lookup.py**
```bash
slayyzer@Slayz:~/Ynov/b2-network-2024/TP4$ sudo /bin/python3 dns_lookup.py 
Begin emission:
Finished sending 1 packets.
.*
Received 2 packets, got 1 answers, remaining 0 packets
104.26.10.233
Begin emission:
Finished sending 1 packets.
*
Received 1 packets, got 1 answers, remaining 0 packets
142.250.200.206
Begin emission:
Finished sending 1 packets.
*
Received 1 packets, got 1 answers, remaining 0 packets
140.82.121.3
Begin emission:
Finished sending 1 packets.
*
Received 1 packets, got 1 answers, remaining 0 packets
82.67.64.82
```

## II. ARP Poisoning

```bash
[slayz@localhost ~]$ ip n s
**192.168.56.148 dev enp0s3 lladdr b0:dc:ef:bb:ff:9e STALE**
192.168.56.102 dev enp0s3 lladdr 08:00:27:f8:a8:b0 STALE 
192.168.56.1 dev enp0s3 lladdr 0a:00:27:00:00:00 REACHABLE 
```

## III. Exfiltration ICMP
**🌞 icmp_exf_send.py**
