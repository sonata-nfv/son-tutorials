# 5GTANGO SDK Tutorial

This tutorial shows the 5GTANGO SDK, including the full workflow of descriptor generation, project management, validation, packaging, and on-boarding and instantiation on the *vim-emu* emulator.

This tutorial is based on a [demo previously presented at IEEE NFV-SDN 2018](https://github.com/CN-UPB/demo-multi-platform-nfv-sdk).

**Contact information:** [Stefan Schneider](https://github.com/stefanbschneider), Paderborn University

![architecture](docs/architecture.png)

## Setup

To run the full demo, including instantiation of the service on the emulator, you should use Ubuntu 16.04. All previous steps of the demo also work on other operating systems (eg, Windows and Mac OS).

See the [getting started guide](https://sonata-nfv.github.io/sdk-installation) to install the project management, validation, and packaging tool in a Python 3.5+ virtual environment:

```bash
# install
pip install git+https://github.com/sonata-nfv/tng-sdk-project.git
pip3 install git+https://github.com/sonata-nfv/tng-sdk-validation.git
pip3 install git+https://github.com/sonata-nfv/tng-sdk-package

# test
tng-project -h
tng-validate -h
tng-package -h
```

## Tutorial walkthrough

### Descriptor generation

To use the graphical descriptor generation, navigate to https://sonata-nfv.github.io/tng-sdk-descriptorgen/ and default values for author, service, and description (keep in mind that vendor and service need to be lowercase strings without spaces).

Finally add VNFs with the following Docker images (in this order!):

* `proxy-squid-img`
* `l4fw-socat-img`
* `http-apache-img`

![descriptorgen](docs/descriptorgen.png)

Click "generate" to generate the descriptors. After a moment, you'll see the generated NSD and VNFDs for our demo service. Our SDK is has multi-platform support and also generates OSM descriptors.

After reviewing (and potentially adjusting) the generated descriptors, download them by clicking "download all".

*Note:* The descriptor generator is also available as CLI tool for advanced users.

### Project management

Extract the downloaded `descriptors.zip` (or take the `descriptors` directory from this repo) and activate your Python virtual environment in which you installed `tng-sdk-project`.

#### Workspace

If you haven't done so before, create a new workspace (containing some configuration files) by typing `tng-wks` in the terminal with the activated virtual environment.

#### Project status

Now, let's have a look at the generated descriptors and downloaded project, using the project management tool:

```bash
$ tng-project -p descriptors --status
2019-01-23 15:16:46 nb-stschn tngsdk.project.project[220] INFO Loading project 'descriptors/project.yml'
Project: generated-project
Vendor: eu.5gtango
Version: 0.1
UUID: baaf9c9b-523a-44b9-8493-b868c4e67e33
Demo service for hackfest
+-------------------------------+------------+
| MIME type                     |   Quantity |
+===============================+============+
| application/vnd.5gtango.nsd   |          1 |
+-------------------------------+------------+
| application/vnd.5gtango.vnfd  |          3 |
+-------------------------------+------------+
| application/vnd.etsi.osm.nsd  |          1 |
+-------------------------------+------------+
| application/vnd.etsi.osm.vnfd |          3 |
+-------------------------------+------------+
```

Using the `tng-project --status` command, you'll get an overview of the involved files: 1 NSD and 3 VNFDs for both 5GTANGO and OSM.

#### Adding a file

Now, let's create add a file to our project. For example, a dummy license file:

```bash
touch descriptors/License.txt
```

To include this file in our project, use the `tng-project --add` command (similar to `git add`):

```bash
$ tng-project -p descriptors --add descriptors/License.txt
2019-01-23 15:22:08 nb-stschn tngsdk.project.project[14016] INFO Loading project 'descriptors\project.yml'
2019-01-23 15:22:08 nb-stschn tngsdk.project.project[14016] INFO Added descriptors/License.txt to project.yml
```

If you run the `status` command again, you'll see that the license file is now part of your project (listed as `text/plain` file).

### Validation

The next step in the SDK workflow is descriptor and project validation to ensure all descriptors are correct. Currently, the validator only works on Linux (not Windows).

#### Validate our project

Validate our project by using the following command:

```bash
$ tng-validate --project descriptors/
CLI input arguments: ['--project', 'descriptors/']
Printing all the arguments: Namespace(api=False, cfile=None, custom=False, dext=None, dpath=None, integrity=False, mode='stateless', nsd=None, package_file=None, project_path='descriptors/', service_address='127.0.0.1', service_port=5001, syntax=False, topology=False, verbose=False, vnfd=None, workspace_path=None)
Project validation
2019-01-23 15:41:54 [INFO] [tngsdk.project.project] Loading project 'descriptors/project.yml'
2019-01-23 15:41:54 [INFO] [tngsdk.validation.validator] Validating project 'descriptors/'
...
2019-01-23 15:41:55 [INFO] [tngsdk.validation.validator] Validating topology of service 'eu.5gtango.demo-service.0.9'
No errors found in project validation
```

Great, it seems like our descriptors are error-free!

#### Introducing and fixing a bug

Feel free to further test the tool by introducing a bug and using the validator to find and fix it again. For example, you can rename one of the connection points of the vLinks in `descriptors/tango_demo-service.yml`:

```yaml
- id: input-2-vnf0
    connectivity_type: E-Line
    connection_points_reference:
      - input
      - 'vnf5:input'	# bug: vnf5 is not defined
```

When running the validation again, it should warn you about the error:

```bash
2019-01-23 15:58:26 [ERROR] [validator.events] Undefined connection point
2019-01-23 15:58:26 [ERROR] [validator.events] Function (VNF) of vnf_id='vnf5' declared in connection point 'vnf5' in virtual link 'input' is not defined
```

Now it is easy to identify and fix the error again.

### Packaging

Next, you'll package the created and validated project (without bugs!) into a single package file. Thanks to its generic, standard-conformant design, this package file can then be on-boarded to the 5GTANGO service platform or OSM (possibly also to ONAP in future versions).

Call the packager using the following command inside your virtualenv:

```bash
$ tng-pkg -p descriptors/
2019-01-23 17:05:02 nb-stschn tango.tngsdk.package.packager:l240 INFO Packager created: TangoPackager(7e4c9fd4-b68d-428b-adc2-4939ad904986)
2019-01-23 17:05:02 nb-stschn tango.tngsdk.package.packager:l897 INFO Creating 5GTANGO package using project: 'descriptors/'
Printing all the arguments: Namespace(api=False, cfile=None, custom=False, dext=None, dpath=None, integrity=False, mode='stateless', nsd=None, package_file=None, project_path='descriptors/', service_address='127.0.0.1', service_port=5001, syntax=True, topology=False, verbose=False, vnfd=None, workspace_path='C:\\Users\\Stefan\\.tng-workspace')
Project validation
Syntax validation
2019-01-23 17:05:03 nb-stschn tngsdk.project.project[13976] INFO Loading project 'descriptors/project.yml'
2019-01-23 17:05:03 nb-stschn tngsdk.validation.validator[13976] INFO Validating project 'descriptors/'
2019-01-23 17:05:03 nb-stschn tngsdk.validation.validator[13976] INFO ... syntax: True, integrity: False, topology: False
2019-01-23 17:05:03 nb-stschn tngsdk.validation.validator[13976] INFO Validating service 'descriptors/tango_demo-service.yml'
2019-01-23 17:05:03 nb-stschn tngsdk.validation.validator[13976] INFO ... syntax: True, integrity: False, topology: False
2019-01-23 17:05:03 nb-stschn tngsdk.validation.validator[13976] INFO Validating syntax of service 'eu.5gtango.demo-service.0.9'
No errors found in project validation
2019-01-23 17:05:03 nb-stschn tango.tngsdk.package.packager:l939 INFO Package created: 'eu.5gtango.generated-project.0.1.tgo'
2019-01-23 17:05:03 nb-stschn tango.tngsdk.package.packager:l300 INFO Packager done (1.0069s): TangoPackager(7e4c9fd4-b68d-428b-adc2-4939ad904986)
===============================================================================
P A C K A G I N G   R E P O R T
===============================================================================
Packaged:    descriptors/
Project:     eu.5gtango.generated-project.0.1
Artifacts:   9
Output:      eu.5gtango.generated-project.0.1.tgo
Error:       None
Result:      Success.
===============================================================================

```

As you can see, the packager automatically validates the project again to make sure there are no errors (if the validator is installed) before creating the package `eu.5gtango.generated-project.0.1.tgo` (also available in the repo). This package is now ready to be on-boarded to the service platform.

**Congratulations, you successfully completed the 5GTANGO SDK tutorial!**



## Extra: Instantiation on emulator

Since the installation and usage of the emulator is a bit more complex and time-consuming than the other SDK tools, it's not part of the tutorial. If you're still interested, you can of course try to use it. Have fun!

### Setup

For the last part of the demo, you will also need the *vim-emu* prototyping platform. You should install it using Python 2, installing it globally (with `sudo`). Follow the install instructions for the [bare-metal installation](https://osm.etsi.org/wikipub/index.php/VIM_emulator#Option_1:_Bare-metal_installation):

```bash
# package requirements
sudo apt-get install ansible git aptitude

# containernet
git clone https://github.com/containernet/containernet.git
cd ~/containernet/ansible
sudo ansible-playbook -i "localhost," -c local install.yml

# vim-emu
git clone https://osm.etsi.org/gerrit/osm/vim-emu.git
cd ~/vim-emu/ansible
sudo ansible-playbook -i "localhost," -c local install.yml
```

#### Build VNFs

On the machine, where you installed vim-emu, build the VNFs that we use in our service. For this, copy the VNFs from the `vnfs` folder of this repo and execute the following command (from within the `vnfs` folder) to build the three Docker images of the VNFs:

```bash
sudo ./build.sh
```

Depending on your connection, this will take a while.

### Emulator tutorial

Now, it's time to on-board and instantiate our developed service.

#### Start vim-emu

On the machine, where `vim-emu` is installed, navigate to the cloned `vim-emu` repository and start the emulator using the following command:

```bash
sudo python examples/tango_default_cli_topology_2_pop.py
```

This will start a dummy topology with two emulated PoPs. Keep this terminal window (let's call it `containernet` terminal) open and continue the tutorial in a *new* terminal.

#### Package on-boarding

On-board the packaged service using the provided script in the repo:

```bash
./onboard.sh
```

You should see some updates on the `containernet` terminal and receive a positive response similar to this one (with different UUID etc of course):

```
HTTP/1.0 201 CREATED
Content-Type: application/json
Content-Length: 159
Server: Werkzeug/0.14.1 Python/2.7.12
Date: Wed, 23 Jan 2019 16:27:05 GMT

{
    "error": null,
    "service_uuid": "f2fd806f-9002-494e-830c-32109efce048",
    "sha1": "01433c28329786fc76d8bab250bd3ba16a70f799",
    "size": 6207
}
```

*Note:* This will only work if you are running vim-emu locally and if you didn't change the package name. Otherwise, you'll have to use `curl`  (possibly in combination with a VPN if you're trying to reach a remote host):

```bash
curl -i -X POST -F package=@<package-name> <remote-emulator-host>:5000/packages
```

#### Instantiation

After on-boarding, you can now instantiate the service. But first, let's check that it is not yet running. On the vim-emu machine, call:

```bash
vim-emu compute list
```

This should show an empty table with now VNFs/containers running. Now call the provided script to instantiate the service:

```bash
./instantiate.sh
```

As before, you may also use `curl` instead:

```bash
curl -X POST <remote-host>:5000/instantiations -d '{"service_name": "demo-service"}'
```

This should start the services and return the `service_instance_uuid` of the started service. Call `vim-emu compute list` again, and you'll see the three containers of our three VNFs started.

#### Termination

To stop the vim-emu emulator, type `exit` in the `containernet` terminal. You may need to press "Enter" a couple of times before seeing the `containernet>` prompt.

