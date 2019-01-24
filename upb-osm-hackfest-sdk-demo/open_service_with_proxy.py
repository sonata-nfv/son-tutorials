#!/usr/bin/python
#
# Opens chromium with correct proxy setting
# e.g. chromium-browser --proxy-server="172.17.0.5:3128" 20.0.0.2:8899
#
# This is needed because we cannot fix the IPs of the docker interfaces.
# copy from: https://github.com/sonata-nfv/son-tutorials/blob/master/upb-emulator-mano-integration-demo/scripts/open_service_with_proxy.py

import docker
import subprocess

PROXY_CONTAINER_NAME = ["/mn.proxy", "/mn.t1.vnf2.a", "/mn.squid.1", "/mn.vnf_proxy"]


def main():
    print("Searching proxy IP...")
    client = docker.APIClient(base_url='unix://var/run/docker.sock')
    PROXY_IP = None
    # find proxy container and its IP
    for c in client.containers():
        name = c.get("Names")[0]
        if name in PROXY_CONTAINER_NAME:
            try:
                PROXY_IP = c.get("NetworkSettings").get("Networks").get("bridge").get("IPAddress")
            except:
                print("Error parsing IP address from Docker API")
            print("Found proxy container: '{}' with IP '{}'".format(name, PROXY_IP))
            break
    # quit if no IP was found
    if PROXY_IP is None:
        print("Could not determine proxy IP. Exit.")
        exit(1)
    # try to open chromium with proxy setting if we have the IP
    subprocess.call("chromium-browser --proxy-server='{}:3128' 20.0.0.2:8899".format(PROXY_IP), shell=True)
            

if __name__ == "__main__":
    main()
