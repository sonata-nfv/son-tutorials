#!/usr/bin/env python

from prometheus_client import start_http_server, Summary, Histogram, Gauge, Counter, REGISTRY, CollectorRegistry, \
    pushadd_to_gateway, push_to_gateway, delete_from_gateway
from subprocess import Popen, PIPE, STDOUT
import threading, queue
from time import sleep
import pty
import os
import re
import sys
from math import isnan
import requests
import time
import signal

import logging
logging.basicConfig(level=logging.INFO)

MAX_READ = 1024

# vnf configuration parameters
vnf_name = os.environ.get('VNF_NAME')
#pushgateway = 'localhost:9091'
pushgateway = '172.17.0.1:9091'

class web_client(threading.Thread):
    def __init__(self, url, result_q, cache=True, id=0, prom_metric=None, count_metric=None):
        super(web_client, self).__init__()
        self.result_q = result_q
        self.url = url
        self.cache=cache
        self.stoprequest = threading.Event()
        self.id = id
        #self.prom_metric_speed = prom_metric_speed
        #self.prom_metric_total = prom_metric_total
        self.prom_metric = prom_metric
        self.counter = count_metric


    # continuously repeat the download cyle
    def run(self):
        headers = None
        if not self.cache:
            headers = {'Cache-Control': 'no-cache'}

        while not self.stoprequest.isSet():
            start = time.time()
            self.counter.labels(vnf_name=vnf_name).inc()
            r = requests.get(self.url, headers=headers)
            self.counter.labels(vnf_name=vnf_name).dec()

            status_code = r.status_code
            r.raise_for_status()

            total_length = int(r.headers.get('content-length'))
            total_time = (time.time() - start)
            total_speed = total_length // (total_time)
            cache_dict = {'True':'cached', 'False':'non-cached'}
            sys.stdout.write("%s %s: [%s bytes, %s sec] %s Bps \n" % (cache_dict[str(self.cache)], self.id, total_length, total_time, total_speed))
            #self.prom_metric_speed.labels(vnf_name=vnf_name).inc(total_speed)
            #self.prom_metric_total.labels(vnf_name=vnf_name).inc()
            self.prom_metric.labels(vnf_name=vnf_name).observe(total_speed)
            self.result_q.put(total_speed)

class squid_testclient():
    def __init__(self, cached_workers=0, non_cached_workers=0, url=None):
        self.cached_workers = cached_workers
        self.non_cached_workers = non_cached_workers
        self.result_q = queue.Queue()
        self.url = url

        # Prometheus export data
        # helper variables to calculate the metrics
        self.registry = CollectorRegistry()

        self.speed_metric = Counter('squid_cached_download_speed_sum', 'sum of download speed (bytes_per_sec)',
                               ['vnf_name'], registry=self.registry)
        self.count_metric = Counter('squid_cached_downloads_total', 'total number of downloads',
                                 ['vnf_name'], registry=self.registry)

        self.cached_requests = Gauge('cached_reqs_count', 'number of ongoing cached requests',
                                     ['vnf_name'], registry=self.registry)
        self.non_cached_requests = Gauge('non_cached_reqs_count', 'number of ongoing non-cached requests',
                                     ['vnf_name'], registry=self.registry)


        self.cached_metric = Summary('squid_cached_download', 'cached download speed',
                               ['vnf_name'], registry=self.registry)
        self.non_cached_metric = Summary('squid_non_cached_downloads', 'non-cached download speed',
                                    ['vnf_name'], registry=self.registry)

        #start_http_server(8000)

        export_thread = threading.Thread(target=self.export_metrics)
        export_thread.start()


    def start_workers(self):
        for i in range(0, self.cached_workers):
            url = 'http://download.thinkbroadband.com/10MB.zip'
            url = 'http://localhost:8888/file/10'
            url = self.url
            t = web_client(url, self.result_q, id=i, prom_metric=self.cached_metric, count_metric=self.cached_requests)
            t.start()

        for i in range(0, self.non_cached_workers):
            url = 'http://download.thinkbroadband.com/10MB.zip'
            url = 'http://localhost:8888/file/10'
            url = self.url
            t = web_client(url, self.result_q, cache=False, id=i, prom_metric=self.non_cached_metric, count_metric=self.non_cached_requests)
            t.start()

    def export_metrics(self):
        while True:
            # push metrics to gateway
            pushadd_to_gateway(pushgateway, job='squid_client', registry=self.registry)
            sleep(1)

class iperf():
    def __init__(self, option_string=''):

        self.read_loop = True
        options = option_string.split(' ')
        cmd = ['iperf'] + options
        cmd_str = 'iperf '+ option_string
        master, slave = pty.openpty()
        self.process = Popen(cmd, stdout=slave, stderr=slave, close_fds=False)
        self.stdout = os.fdopen( master, 'r', 10000 )

        # buffer which holds the iperf process output to read from
        self.readbuf = ''
        self.test_str = ''

        self.test_end = False

        # Prometheus export data
        # helper variables to calculate the metrics
        self.registry = CollectorRegistry()

        #buckets = (0.1, 0.2, 0.5, 1, 2, 5, 7, 10, 20, 50, 70, 90, float("inf"))
        self.prom_loss = Gauge('sonemu_packet_loss_percent', 'iperf packet loss (percent)',
                                          ['vnf_name'], registry=self.registry)

        self.prom_packets_loss = Gauge('sonemu_packets_loss_count', 'iperf packets lost (count)',
                                         ['vnf_name'], registry=self.registry)

        self.prom_packets_total = Gauge('sonemu_packets_total_count', 'iperf packets total (count)',
                                           ['vnf_name'], registry=self.registry)

        #buckets = (1, 9, 10, 11, 90, 100, 110, 900, 1000, 1100, float("inf"))
        self.prom_bandwith = Gauge('sonemu_bandwith_Mbitspersec', 'iperf bandwith (Mbits/sec)',
                                            ['vnf_name'], registry=self.registry)

        #buckets = (0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 5, 10, float("inf"))
        self.prom_jitter = Gauge('sonemu_jitter_ms', 'iperf jitter (ms)',
                                       ['vnf_name'], registry=self.registry)


        self.prom_bandwith.labels(vnf_name=vnf_name).set(float('nan'))
        self.prom_loss.labels(vnf_name=vnf_name).set(float('nan'))
        self.prom_packets_total.labels(vnf_name=vnf_name).set(float('nan'))
        self.prom_packets_loss.labels(vnf_name=vnf_name).set(float('nan'))
        self.prom_jitter.labels(vnf_name=vnf_name).set(float('nan'))

        while True:
            data = self.readline()
            if data :
                logging.info('stdout: {0}'.format(data))
                self.parse_beginning_of_test(data)
                self.parse_end_of_test(data)
                if not self.test_end:

                    bw = self.parse_bandwith(data)

                    if not isnan(bw):
                        self.prom_bandwith.labels(vnf_name=vnf_name).set(bw)
                    else:
                        self.prom_bandwith.labels(vnf_name=vnf_name).set(bw)
                        # end of iperf test, no real measurement
                        continue

                    loss = self.parse_loss(data)
                    self.prom_loss.labels(vnf_name=vnf_name).set(loss)

                    lost, total = self.parse_packets(data)
                    if lost and total:
                        self.prom_packets_total.labels(vnf_name=vnf_name).set(total)
                        self.prom_packets_loss.labels(vnf_name=vnf_name).set(lost)

                    jitter = self.parse_jitter(data)
                    self.prom_jitter.labels(vnf_name=vnf_name).set(jitter)
            else:
                self.prom_loss.labels(vnf_name=vnf_name).set(float('nan'))
                self.prom_jitter.labels(vnf_name=vnf_name).set(float('nan'))

            pushadd_to_gateway(pushgateway, job='sonemu-profile_sink', registry=self.registry)


    def read( self, maxbytes=MAX_READ ):
        """Buffered read from node, potentially blocking.
           maxbytes: maximum number of bytes to return"""
        count = len( self.readbuf )
        if count < maxbytes:
            data = os.read( self.stdout.fileno(), maxbytes - count )
            self.readbuf += data.decode("utf-8") # need to decode bytes to string
        if maxbytes >= len( self.readbuf ):
            result = self.readbuf
            self.readbuf = ''
        else:
            result = self.readbuf[ :maxbytes ]
            self.readbuf = self.readbuf[ maxbytes: ]
        return result

    def readline(self):
        """Buffered readline from node, potentially blocking.
           returns: line (minus newline) or None"""

        pos = self.readbuf.find('\n')
        if pos >=0:
            line = self.readbuf[0: pos]
            # logging.info('stdout: {0}'.format(line))
            # self.parse_loss(line)
            self.readbuf = self.readbuf[(pos + 1):]
            return line
        else:
            test_str = self.read(MAX_READ) # get MAX_READ bytes of the buffer
            self.readbuf = self.readbuf + test_str
            return None



    def parse_loss(self,iperf_line):
        loss = re.search('(\()((\d+\.)?\d+)(\%\))', iperf_line)
        if loss:
            logging.info('loss: {0} percent'.format(loss.group(2)))
            return float(loss.group(2))
        else:
            logging.info('no loss found')
            return float('nan')

    def parse_bandwith(self, iperf_line):
        bw = re.search('(\d+\.?\d+)(\sMbits\/sec)', iperf_line)
        if bw:
            logging.info('bw: {0} Mbits/sec'.format(bw.group(1)))
            return float(bw.group(1))
        else:
            return float('nan')

    def parse_packets(self, iperf_line):
        match = re.search('(\d+)\/\s*(\d+)\s*\(', iperf_line)
        if match:
            lost = match.group(1)
            total = match.group(2)
            logging.info('packets lost: {0} total: {1}'.format(lost, total))

            return int(lost), int(total)
        else:
            return None, None

    def parse_jitter(self, iperf_line):
        match = re.search('(\d+\.\d+)\sms', iperf_line)
        if match:
            logging.info('jitter: {0} ms'.format(match.group(1)))
            return float(match.group(1))
        else:
            logging.info('no jitter found')
            return float('nan')

    def parse_end_of_test(self, iperf_line):
        match = re.search('(-\s-\s)+', iperf_line)
        if match:
            logging.info('end: {0} '.format(match.group(1)))
            self.test_end = True
            return match

    def parse_beginning_of_test(self, iperf_line):
        match = re.search('(--)+', iperf_line)
        if match:
            logging.info('begin: {0} '.format(match.group(1)))
            self.test_end = False
            return match

    def read_stdout(self):
        while self.read_loop:
            print('read')

            self.process.stdout.flush()
            output = self.process.stdout.readline()
            if output == '' and self.process.poll() is not None:
                break
            if output:
                logging.info('stdout: {0}'.format(output))


def reload_proxy(signum, frame):
    logging.info("Received Signal: {} at frame: {}".format(signum, frame))
    file = open('/http_proxy_setting', "r")
    http_proxy = file.read()
    file.close()
    logging.info("http_proxy={}".format(http_proxy))
    os.environ["http_proxy"] = http_proxy

if __name__ == "__main__":

    #min is 12bytes
    #iperf_server = iperf('-s -u -l18 -i -fm')
    #iperf_cmd = sys.argv[1]
    #iperf_server = iperf(iperf_cmd)
    #iperf_server = iperf('-s -u -i -fm')
    #iperf_client = iperf('-c localhost -u -i1')

    #result_q = queue.Queue()
    #squid_thread = web_client('http://download.thinkbroadband.com/50MB.zip', result_q)
    #squid_thread.start()
    #squid_thread.join()

    cached_downloads = int(sys.argv[1])
    non_cached_downloads = int(sys.argv[2])
    url = sys.argv[3]

    # Register reload_libs to be called on restart
    signal.signal(signal.SIGHUP, reload_proxy)

    try:
        http_proxy = ''
        if len(sys.argv) > 4:
            http_proxy = sys.argv[4]
            os.environ["http_proxy"] = http_proxy
        else:
            file = open('/http_proxy_setting', "r")
            http_proxy = file.read()
            file.close()
            os.environ["http_proxy"] = http_proxy
            
        logging.info("http_proxy={}".format(http_proxy))
    except:
        logging.info("Could not set http_proxy")

    test = squid_testclient(cached_downloads, non_cached_downloads, url=url)
    test.start_workers()