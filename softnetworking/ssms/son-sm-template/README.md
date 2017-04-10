
# SSM/FSM Template
The templates is responsible for SSM/FSM registration in SONATA'S service platform plugin, Specific Manager Registry (SMR).

More details about FSM/SSM template are available on the following link:
* [Updated Requirements and Architecture Design Deliverable 2.3](http://sonata-nfv.eu/content/d23-updated-requirements-and-architecture-design)


## Implementation
* implemented in Python 3.4
* dependecies: amqp-storm
* The main implementation can be found in: `son-sm-template/sonsmbase/smbase`

## Unit tests

* To run the unit tests of the SLM individually, run the following from the root of the repo:
 * ./test/test_son-sm-template.sh