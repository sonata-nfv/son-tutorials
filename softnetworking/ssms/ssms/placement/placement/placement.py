"""
Copyright (c) 2015 SONATA-NFV
ALL RIGHTS RESERVED.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Neither the name of the SONATA-NFV [, ANY ADDITIONAL AFFILIATION]
nor the names of its contributors may be used to endorse or promote
products derived from this software without specific prior written
permission.

This work has been performed in the framework of the SONATA project,
funded by the European Commission under Grant number 671517 through
the Horizon 2020 and 5G-PPP programmes. The authors would like to
acknowledge the contributions of their colleagues of the SONATA
partner consortium (www.sonata-nfv.eu).
"""

import logging
import yaml
from sonsmbase.smbase import sonSMbase

logging.basicConfig(level=logging.INFO)
LOG = logging.getLogger("ssm-placement-1")
LOG.setLevel(logging.DEBUG)
logging.getLogger("son-mano-base:messaging").setLevel(logging.DEBUG)


class PlacementSSM(sonSMbase):
    def __init__(self):

        self.smtype = 'ssm'
        self.sfname = 'default'
        self.name = 'placement'
        self.id = '1'
        self.version = 'v0.1'
        self.description = 'Placement SSM'

        super(self.__class__, self).__init__(smtype= self.smtype,
                                             sfname= self.sfname,
                                             name= self.name,
                                             id = self.id,
                                             version= self.version,
                                             description= self.description)

    def on_registration_ok(self):
        LOG.debug("Received registration ok event.")

        # Register to task topic and to place topic
        topic = 'placement.ssm' + self.uuid

        self.manoconn.subscribe(self.on_place,topic= topic)

        LOG.info("Subscribed to " + str(topic))

    def on_place(self, ch, method, properties, payload):
        """
        This method organises the placement calculation, and
        provides the response for the SLM.
        """

        LOG.info("Placement started")
        message = yaml.load(payload)
        topology = message['topology']
        nsd = message['nsd']
        functions = message['vnfds']

        mapping = self.placement_alg(nsd, functions, topology)

        if mapping is None:
            LOG.info("The mapping calculation has failed.")
            message = {}
            message['error'] = 'Unable to perform placement.'
            message['status'] = 'ERROR'
            
        else:
            LOG.info("The mapping calculation has succeeded.")
            message = {}
            message['error'] = None
            message['status'] = "COMPLETED"
            message['mapping'] = mapping

        is_dict = isinstance(message, dict)
        LOG.info("Type Dict: " + str(is_dict))

        payload = yaml.dump(message)
        self.manoconn.notify('placement.ssm' + self.uuid,
                             payload,
                             correlation_id=properties.correlation_id)

        return

    def placement_alg(self, nsd, functions, topology):
        """
        This is the default placement algorithm that is used if the SLM
        is responsible to perform the placement
        """
        LOG.info("Mapping algorithm started.")
        mapping = {}

        for vnfd in functions:
            needed_cpu = vnfd['virtual_deployment_units'][0]['resource_requirements']['cpu']['vcpus']
            needed_mem = vnfd['virtual_deployment_units'][0]['resource_requirements']['memory']['size']
            needed_sto = vnfd['virtual_deployment_units'][0]['resource_requirements']['storage']['size']

            for vim in topology:
                cpu_req = needed_cpu <= (vim['core_total'] - vim['core_used'])
                mem_req = needed_mem <= (vim['memory_total'] - vim['memory_used'])

                if cpu_req and mem_req:
                    print('VNF ' + vnfd['instance_uuid'] + ' mapped on VIM ' + vim['vim_uuid'])
                    mapping[vnfd['instance_uuid']] = {}
                    mapping[vnfd['instance_uuid']]['vim'] = vim['vim_uuid']
                    vim['core_used'] = vim['core_used'] + needed_cpu
                    vim['memory_used'] = vim['memory_used'] + needed_mem
                    break
        
        # Check if all VNFs have been mapped
        if len(mapping.keys()) == len(functions):
            LOG.info("Mapping succeeded: " + str(mapping))
            return mapping
        else:
            return None

def main():
    PlacementSSM()

if __name__ == '__main__':
    main()
