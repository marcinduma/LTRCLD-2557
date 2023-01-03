# Infrastructure configuration - MultiSite configuration

In this lab section we will use Nexus Dashboard Orchestrator(NDO) to connect 2 Cloud Fabrics together. 

## Nexus Dashboard Orchestrator(NDO) 

**Cisco Nexus Dashboard Orchestrator (NDO)** provides consistent network and policy orchestration, scalability, and disaster recovery across multiple data centers through a single pane of glass while allowing the data center to go wherever the data is.

NDO allows you to interconnect separate Cisco® Application Centric Infrastructure (Cisco ACI®) sites, Cisco Cloud ACI sites, and Cisco Nexus Dashboard Fabric Controller (NDFC) sites, each managed by its own controller (APIC cluster, NDFC cluster, or Cloud APIC instances in a public cloud). The on-premises sites (ACI or NDFC in the future) can be extended to different public clouds for hybrid-cloud deployments while cloud-first installations can be extended to multi-cloud deployments without on-premises sites. 

The single-pane network interconnect policy management and the consistent network workload and segmentation policy provided by NDO allows monitoring the health of the interconnected fabrics, enforcement of segmentation and security policies, and performance of all tasks required to define tenant intersite policies in APIC, NDFC, and cAPIC sites. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image23a.png" width = 800>

● Key features and benefits

-     Single pane of glass for administration and orchestration of multiple networking fabrics for both Cisco ACI and NDFC

-     Automation of the configuration and management of intersite network interconnects across an IP backbone for both Cisco ACI and NDFC

-     Consistent multitenant policy across multiple sites, which allows IP mobility, disaster recovery, and active/active use cases for data centers

-     Capability to map tenants, applications, and associated networks to specific availability domains within the Cisco Multi-Site architecture for both Cisco ACI and NDFC

-     Hybrid cloud and multi-cloud orchestration supporting on-premises Cisco ACI sites and public cloud sites (AWS and Azure)

-     Capability to have multi-cloud ACI deployments without on-premises sites

-     Scale out sites and leaf switches based on resource growth

●Use cases

There are several uses of Cisco Nexus Dashboard Orchestrator. Some of the main use cases include:

-     Large scale data center deployment

-     Data center interconnectivity

-     Cisco NDO multi-domain integrations

-     Hybrid cloud and multi-cloud

-     Service provider – 5G telco

**Let's now explore possibilites of Cisco Nexus Dashboard Orchestrator!**

### 1. NDO Service Introduction

In the navigation menu on the left go to **"Admin Console"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image24.png" width = 400>

You will be moved to **Admin Console** page, where you can see **Health** of your Nexus Dashboard and status of sites and services. 

Navigate to **"Sites"** tab and verify if **"Connectivity Status"** of you sites is **"Up"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image26.png" width = 800>

Navigate to **"Sevices"** tab to see what applications are installed on this Nexus Dashboard

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image25.png" width = 400>

**Nexus Dashboard Orchestrator** is already installed and enabled under **"Service Catalog"** inside **"Installed Service"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image27.png" width = 800>

Hit **"Open"** button in order to login 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image28.png" width = 400>

You will be now redirected to **Nexus Dashboard Orchestrator** Dashboard. 

### 2. NDO Sites Onboarding

In order to configure AWS and Azure sites from NDO, added previously on **Nexus Dashboard**, sites have to be **Maneged** and have **Site ID** assigned. 

Navigate to **Sites**: 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image30.png" width = 800>

Click on **"Unmanaged"** box under **State** Column for each site and assign **Site ID**, confirming with **"Add"** button. 

    For AWS Site - set ID **10**

    For Azure Site - set ID **20**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image31.png" width = 800>

After this operation - both sites should be visible as **Managed**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image32.png" width = 800>

### 3. Site Connectivity Configuration 

In Next Step we would configure Infrastructure to connect 2 Cloud ACI Sites togehter.

Navigate to **Infrastructure** -> **Site Connectivity** -> **Configure** button

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image33.png" width = 800>

On the **General Settings** Page, scroll down to OSPF Configuration and fill in OSPF Area ID to value **0.0.0.0**, leave other setting as default. OSPF Protocol will be configured over IPSec tunnel and allows for prefixes exchange to bring BGP Neighbourship. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image34.png" width = 800>

Go to tab **"IPSec Tunnel Subnet Pools"**, click **Add IP address** button and add subnet

    Subnet: 192.168.255.0/24

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image40.png" width = 800>

Confirm with **checkbox** button.

You may notice that there is already one subnet 169.254.0.0/16 configured, which is used for Tunnel addresing between Cloud Routers and Cloud Load Balancers(Azure)/Transit Gateways(AWS). Those tunnles are used to forward traffic from Cloud instances to Cloud Routers and further to another sites. 

In the left navigation bar, under the Sites bar, click on first site **CNC-AWS-01**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image35.png" width = 200>

Enable the site for MultiSite by checking the checkbox **"ACI Multisite"** also enable **"Contract Based Routing"**
    
    Settings:
    - ACI Multisite - checked 
    - Contract Based Routing - checked

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image36.png" width = 800>

Click the "Add Site" button to cross-connect 2 sites. Under **Connected to Site** select **Select a Site** hyperlink. 

Select Azure fabric and hit **Select**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image37.png" width = 800>

For the **Connection Type** select **Public Internet** and hit **Ok**. Leave rest of the setting as default, you can review them. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image38.png" width = 800>

Move to **CNC-Azure-01** Site and also enable the site for MultiSite by checking the checkbox **"ACI Multisite"** - simiar as in previous point. 
    
    Settings:
    - ACI Multisite - checked 
    - Contract Based Routing - checked

Note that second site is already selected for Inter-Site Connectivity

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image39.png" width = 800>

Once done, locate the **Deploy** button on top the screen, click it and Select **"Deploy Only"**, hit **Yes** for confirmation. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image41.png" width = 800>

As you hit **Deploy** button, NDO will now configure CNC and Cloud Routes (previously deployed and visible in AWS EC2/Azure Virutal Machines pages). Configuration includes:  

    - IPSec tunnels, full mesh between all 4 routers (2 per Cloud)
    - OSPF routing over IPSec Tunnels
    - BGP EVPN peering for prefixes exchange

## Inter-site connectivity veryfication 

**It may take 5-10 minutes for configuration to be pushed and Tunnels to be established.**

At this point we configured this part of our topology diagram: 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image42.png" width = 800>

### 1. Nexush Dashboard view

Nexus Dashboard allows for monitoring of Inter-Site connectivity. 

On the Left navigation page click **"Dashboard"** to go back to main Connectivity View. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image43.png" width = 800>

Take a look into green line between AWS and Azure site(you can use use magnifying tool for better view). Green line indicated that all is fine with connectivity. 

On the Left navigation page click **"Infrastructure"** -> **"Site Connectivity"** and scroll down on a page. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image44.png" width = 300>

Under the site list, locate "Show Connectivity Status" and click on it. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image45.png" width = 800>

Check the connectivity status for both **BGP EVPN** as well as **Tunnel Status.** There should be 4 UP BGP sessions, as well as 4 Tunnels which are **UP** between Sites.

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image46.png" width = 800>

## Inter-site connectivity veryfication  (Cloud Routers)

### 1. IPSec tunnel veryfication

Open Putty client from desktop and put IP address of Cloud router. 

!!! Note
    Cloud Routers IP address are avaibale in POD details IP address schema.

Login with username **"csradmin"** and password **"CiscoLive2023!"**

Execute command **"show ip int brief | include Tunnel"**
    
    show ip int brief | include Tunnel

Expected output: 

    ct_routerp_eu-central-1_0_0#show ip int brief | include Tunnel
    Tunnel0                10.10.0.52      YES unset  up                    up      
    Tunnel1                169.254.112.1   YES NVRAM  up                    up      
    Tunnel6                192.168.255.4   YES NVRAM  up                    up      
    Tunnel7                192.168.255.2   YES NVRAM  up                    up      
    ct_routerp_eu-central-1_0_0#

Verify that all 4 tunnels are up/up. 

Tunnel0 is addressed from TEP pool of our Cloud Contoller Fabric and it's used for communication between CNC and Cloud Router. 

Tunnel1 is a connected to inside of a Cloud. Depends on the provider - it's an Azure Load Balancer or AWS Transit Gateway and routing will be injected to send traffic towards VNETs and VPC CIDRs. 

Tunnel6 and Tunnel7 are configured towards two (2) Catalyst 8000V Routers in another site. Note also that Tunnel6 and Tunnel7 are addressed from IPSec subnet which was specified in the beginning of Multiste Configuration.

### 2. OSPF adjacency veryfication

Execute command **"show ip ospf neighbor"**

    show ip ospf neighbor 

Expected output: 

    ct_routerp_eu-central-1_0_0#show ip ospf neighbor 

    Neighbor ID     Pri   State           Dead Time   Address         Interface
    10.20.0.20        0   FULL/  -        00:00:33    192.168.255.3   Tunnel7
    10.20.0.68        0   FULL/  -        00:00:38    192.168.255.5   Tunnel6
    ct_routerp_eu-central-1_0_0#

Verify that both sessions are in **FULL** State. OSPF Neighbourship allows for prefixes exchange, so BGP session can be build. 

### 2. BGP EVPN veryfication

Execute command **"show bgp l2vpn evpn summary"**

    show bgp l2vpn evpn summary

Expected output: 

    ct_routerp_eu-central-1_0_0#show bgp l2vpn evpn summary 
    BGP router identifier 10.10.0.20, local AS number 65110
    BGP table version is 1, main routing table version 1

    Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
    10.20.0.52      4        65200      96      94        1    0    0 01:22:47        0
    10.20.0.116     4        65200      95      94        1    0    0 01:22:52        0
    ct_routerp_eu-central-1_0_0#

Verify that both sessions are Up (O in "State/PfxRcd" column)

**In Next Section our First Tenant will be configured!**