# Infrastructure configuration - Multi-Site configuration

In this lab section we wil Use Nexus Dashboard orchestrator to connect 2 ACI Fabrics together. 

## Nexus Dashboard Orchestrator(NDO) login

### 1.  

On the Site list hit "Continue" and then "Done" button to finish Initial Setup. 

Hit **"Go To Dashboard"** in bottom right corner - you should be moved to ND Dashboard with Site Map

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image23.png" width = 800>

In the navigation menu on the left  go to **"Admin Console"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image24.png" width = 400>

You will be moved to **Admin Console** page, where you can see **Health** of your Nexus Dashboard and status of sites and services. 

Navigate to **"Sites"** tab and verify if **"Connectivity Status"** of you sites is **"Up"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image26.png" width = 800>

Navigate to **"Sevices"** tab to see what applicationa are installed on this Nexus Dashboard

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image25.png" width = 400>

**Nexus Dashboard Orchestrator** is already installed and enabled under **"Service Catalog"** inside **"Installed Service"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image27.png" width = 800>

Hit **"Open"** button in order to login 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image28.png" width = 400>

You will be now redirected to **Nexus Dashboard Orchestrator** Dashboard. 

### 2. NDO Sites Onboarding

To be able to used AWS and Azure sited we added on **Nexus Dashboard** we need to make them **Maneged** and assign **Site ID** 

Navigate to **Sites** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image30.png" width = 800>

Click on **"Unmanaged"** box under **State** Column for each site and assign **Site ID**

    For AWS Site - set ID **10**

    For Azure Site - set ID **20**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image31.png" width = 800>

After this operation - both sites should be visable as **Managed**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image32.png" width = 800>

### 2. Site Connectivity Configuration 

In Next Step we would configure Infrastructure to connect 2 Cloud ACI Sites togehter.

Navigate to **Infrastructure** -> **Site Connectivity** -> **Configure** button

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image33.png" width = 800>

On the **General Settings** Page, scroll down to OSPF Configuration and fill in OSPF Area ID to value **0.0.0.0**, leave other setting as default. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image34.png" width = 800>

Go to tab **"IPSec Tunnel Subnet Pools"**, click **Add IP address** button and add subnet

    **Subnet: 192.168.255.0/24**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image40.png" width = 800>

Confirm with checkbox button.

In the left navigation bar, under the Sites bar, click on first site **CNC-AWS-01**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image35.png" width = 800>

Enable the site for MultiSite by checking the checkbox **"ACI Multisite"** 
    
    Settings:
    - ACI Multisite - checked 
    - Contract Based Routing - checked

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image36.png" width = 800>

Click the "Add Site" button to cross-connect 2 sites. Under **Connected to Site** select **Select a Site** 

Select Azure fabric and hit **Select**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image37.png" width = 800>

For the **Connection Type** select **Public Internet** and hit **Ok** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image38.png" width = 800>

Move to CNC-Azure-01 Site and also enable the site for MultiSite by checking the checkbox **"ACI Multisite"** 
    
    Settings:
    - ACI Multisite - checked 
    - Contract Based Routing - checked

Note that second site is already selected for Inter-Site Connectivity

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image39.png" width = 800>

Once this is done, locate the **Deploy** button, click it and Select **"Deploy Only"**, hit **Yes** for confirmation. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image41.png" width = 800>

As you hit **Deploy** button, NDO will now connect to Catalyst-8kV routers over CNC and configure on them:

    - IPSec tunnels, full mesh between all 4 routers (2 per Cloud)
    - OSPF routing 
    - BGP EVPN peering for prefixes exchange

## Veryfication 

**It may take 5-10 minutes for configuration to be pushed and Tunnel to be established.**

At this point we configured this part of our topology diagram: 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image42.png" width = 800>