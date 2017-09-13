# 5. Start using SONATA

## 5.1 General workflow

## 5.2 Creating a network service with the SDK (Luis)

The recommended workflow when developing a SONATA network service consists on using the CLI tools to create a workspace, create a project to hold the descriptors of the service, validate the components and finally, create a bundled service package. The required steps are as follows:

-   Step 1: Create Workspace

```
son-workspace --init
````

-   Step 2: Create Project

```
son-workspace --project project_dir
```

After this step, a sample Network Service Descriptor (NSD) and several Virtual Network Function Descriptors (VNFDs) are available at `<project_dir/sources>` directory.

-   Step 3: Edit NSD and VNFDs to compose the service

Use a text editor of choice to edit the descriptors.

-   Step 4: Validate the syntax, integrity and topology of the project

```
son-validate --project project_dir
```

-   Step 5: Create a SONATA service package

```
son-package --project project_dir -n service_package
```

After this step, if everything is correct, a package file named `service_package.son` will be created.

-   Step 6: Onboard the package into the SONATA Service Platform or Emulator

```
son-access push --upload service_package.son
```

These are the most basic steps to develop a network service, however additional features may be used and configuration procedures may take place, when required. For instance, to compose a NSDs and VNFDs, the son-editor GUI may be used. Likewise, the son-validator GUI can also be used to trigger validations and visualize the resulting errors, the service network topology, the forwarding graphs, etc. Regarding configuration procedures, before step 6 takes place (onboard a network service to the service platform) the service platform URL and user credentials must be configured in the workspace. To learn more about the additional features and configuration requirements please consult the wiki \[documentation\](https://github.com/sonata-nfv/son-cli/wiki) of son-cli repository.

## 5.3 Testing a network service with the EMULATOR

To deploy and test a network service on the emulation platform you can use the son-cli tools just like you would do when pushing a service to the service platform. You can find an example service package and a detailed description of the workflow [online]. The main steps are as follows:

-   Step 1: Start the emulator
    -   `sudo python ~/demo/topologies/son-emu_example3.py`
-   Step 2: Create a SONATA service package using son-cli
    -   `son-package --project demo/sonata-demo-service -n sonata-demo-service`
-   Step 3: Deploy the created service package on the emulator
    -   `son-access push --upload sonata-demo-service.son`
-   Step 4: Instantiate the service
    -   `son-access push --deploy `<insert service uuid from last step here>
-   Step 5: Check the running SONATA service
    -   `son-emu-cli compute list`

The output will show you the running VNFs of the service and the emulated datacenters:

```
+--------------+-------------+--------------------------------+-------------------+-------------------------------------+
| Datacenter   | Container   | Image                          | Interface list    | Datacenter interfaces               |
+==============+=============+================================+===================+=====================================+
| dc2          | snort_vnf   | sonatanfv/sonata-snort-ids-vnf | mgmt,input,output | dc2.s1-eth2,dc2.s1-eth3,dc2.s1-eth4 |
+--------------+-------------+--------------------------------+-------------------+-------------------------------------+
| dc1          | client      | sonatanfv/sonata-iperf3-vnf    | client-eth0       | dc1.s1-eth2                         |
+--------------+-------------+--------------------------------+-------------------+-------------------------------------+
| dc1          | server      | sonatanfv/sonata-iperf3-vnf    | server-eth0       | dc1.s1-eth3                         |
+--------------+-------------+--------------------------------+-------------------+-------------------------------------+
```

  [online]: https://github.com/sonata-nfv/son-tutorials/tree/master/upb-containernet-emulator-summerschool-demo
