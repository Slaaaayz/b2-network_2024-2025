from scapy.all import *

def requete_dns(packet):
        dns_request = IP(dst="1.1.1.1")/UDP(dport=53)/DNS(rd=1,qd=DNSQR(qname="ynov.com"))
        response = sr1(dns_request)
        print(response.getlayer(DNS).an.rdata)

sniff(filter="port 53", prn=requete_dns, count=1)
