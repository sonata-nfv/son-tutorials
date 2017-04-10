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
LOG = logging.getLogger("ssm-configuration-1")
LOG.setLevel(logging.DEBUG)
logging.getLogger("son-mano-base:messaging").setLevel(logging.DEBUG)


class ConfigurationSSM(sonSMbase):
    def __init__(self):

        self.smtype = 'ssm'
        self.sfname = 'default'
        self.name = 'configuration'
        self.id = '1'
        self.version = 'v0.1'
        self.description = 'configuration SSM'

        super(self.__class__, self).__init__(smtype= self.smtype,
                                             sfname= self.sfname,
                                             name= self.name,
                                             id = self.id,
                                             version= self.version,
                                             description= self.description)

    def on_registration_ok(self):
        LOG.debug("Received registration ok event.")

        # Register to task topic and to place topic
        topic = 'configure.ssm' + self.uuid

        self.manoconn.subscribe(self.on_configure,topic= topic)

        LOG.info("Subscribed to " + str(topic))

    def on_configure(self, ch, method, properties, payload):
        """
        This method organises the placement calculation, and
        provides the response for the SLM.
        """

        if properties.app_id != self.name:
            LOG.info("Configuration started.")
            content = yaml.load(payload)
            LOG.info("Payload keys: " + str(content.keys()))

            # TODO: Add functionality of the SSM

            # Once finished, reply to the SLM to indicate that
            # the SSM is done.
            response = {'status': "completed",
                        'error': None}
            payload = yaml.dump(response)
            self.manoconn.notify('configure.ssm' + self.uuid,
                                 payload,
                                 correlation_id=properties.correlation_id)

        return


def main():
    ConfigurationSSM()

if __name__ == '__main__':
    main()
