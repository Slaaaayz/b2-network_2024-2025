from scapy.all import *

ping = ICMP(type=8)
packet = IP(src="10.33.73.81", dst="1.1.1.1")
frame = Ether(src="b0:dc:ef:bb:ff:9e", dst="7c:5a:1c:d3:d8:76")
final_frame = frame/packet/ping
answers, unanswered_packets = srp(final_frame, timeout=10)
print(f"Pong reçu : {answers[0]}")
