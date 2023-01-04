# Use-case 03 - Inter-Tenant routing

In this section of the lab we will expolore possibilites of Inter-tenant traffic flows. It's a very common scenarios where multiple accounts/tenants in Public Cloud need to communicate with one central one where common service are located. 

## Tenant creation 

One additional Tenant needs to be created for this ucs-case configuration. Azure only tenant will be created, to avoid another trust configuration. 

On the Left navigation page click **"Application Management" -> "Tenant"** and then **"Add Tenant"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image50.png" width = 800>

Fill in Tenant details for name and description 

 - Display Name: **Tenant-Azure-02**
 - Descrption: **CL23 Tenant-02 Azure**

Associate Tenant to Azure CNC-Azure-01 Sites by checking the checkbox next to it. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image200.png" width = 800>

!!! Note 
    Similar as for first Tenant, we are not able to **Save** this configuration with red marking Site. Click the **Pencil** button at the end of each site line to complete configuration. 

    Additional setting are needed for CNC, so it knows which subscribtion. 

**CNC-Azure-01 site configuration**

For Azure site, we will be using the same **Subscription** as previously - select **Mode** as **"Select Shared"** and use existing subscription from drop-down. Leave security domains empty. Hit **Save**. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image52.png" width = 800>


As configuration will be done for new Tenant, new Schema, Template, VRF and all other logical objects have to be created. 

## Schema, Template configuration 

### 1. Schema creation 

Navigate to **Dashboard -> Application Management -> Schemas**, then hit **"Add Schema"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image201.png" width = 800>

Add Schema name and Description and hit **"Add"** button

- Name: **Schema-T02-Azure** 
- Description: **Schema for Tenant-Azure-02**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image202.png" width = 400>

Let's now create template inside this schema. 

### 2. Template creation 

Under the Schema-T02-Azure, let's create first Template with **"Add New Template"** button

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image203.png" width = 800>

For a Template type select **"ACI Multi-Cloud"** and hit **"Add"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image72.png" width = 800>

On the right side of the template screen, we can customize the Tempalte Display Name, and also select Tenant. Add Display Name and Select a Tenant. 

- Display Name: **temp-Azure-01**
- Tenant setting: **Tenant-02-Azure**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image204.png" width = 800>

### 3. Template to site association

For configuration in template to be deployed, appropriate sites need to be added. Sites added will decide to which fabric configuration will be pushed. 

For **temp-Azure-01**, we want to add both Azure site only. 

To do it under the **Template Properties** locate the **Actions** button and hit **Sites Associations**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image205.png" width = 800>

Select **CNC-Azure-01** site and hit **Ok**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image206.png" width = 800>

## VRF, EPG, selectors deployment  

### 1. VRF Configuration

Inside **Schema-T02-Azure**, inside **temp-Azure-01** add the VRF with **"Add VRF"** button under **VRFs** box

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image207.png" width = 800>

Add VRF Common Properties 

- Display Name: **T2-VRF-02** 
- Description: **CL2023 VRF-02**

Leave other as default. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image208.png" width = 800>

As Tempalte was assocaited to Azure site, we need to update details for it, to do so under **temp-stretch-01** expand **"Template Properties"** and go to **"CNC-Azure-01"** 


Under **temp-Azure-01** expand **"Tempalate Properties"** and go to **"CNC-Azure-01"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image209.png" width = 800>

Click on the **"T2-VRF-02"** which opens **Site specific properties** for this **CNC-Azure-01 Site**

Under the **"Tempalate Properties"** hit **"Add Region"** button and select **Region** from the list and then hit  **"Add CIDRs"** button 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image210.png" width = 800>

 - **Region:** francecentral

 Now we need to specify what subnet we would like to use in AWS cloud for that VPC.

- CIDR: **10.200.0.0/23** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image211.png" width = 800>

Like previously we need to add subnet, which is whole CIDR. When done, hit **"Save"** button to save subnet configuration. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image212.png" width = 800>

For traffic to flow between the Tenants, **"VNET Peering"** feature with **"Default" Hub Network** needs to be selected as well.

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image213.png" width = 800>

Hit ok to finish configuration for **CNC-Azure-01** fabric.

Under **temp-Azure-01** expand **"Template Properties"** and go to **"Template Properties"** main settings. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image214.png" width = 800>

When done **"Deploy to sites"** button will become active (blue) - click to deploy VRF to respective sites. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image215.png" width = 800>

Nexus Dashboard will also show what changes are to be made. Review those and hit **Deploy** button to push configuration. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image216.png" width = 800>

If all goes well, confirmation pop-up will get displayed on the screen. 

### 2. Application Profile and EPG Configuration for Azure

Navigate to **temp-Azure-01** template using **View** dropdown menu. 

Add **Application Profile** using **Add Application Profile** button. 

- Display Name: **AppProf-Azure-T2-01**
- Description: **Application Profile CL 2023 Azure T02**

Hit **Save**

Under created **Application Profile** add **EPG**

- Display Name: **EPG-Azure-02**
- Description: **EPG Azure CL 2023 T02** 
- EPG Type: **Application** 

Skip the **"On-Premises Properties"** and click on **"Cloud Properties"** and select **"Virtual Routing & Forwarding"** as **"T2-VRF-02"**. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image220.png" width = 800>

We also need to add **Selector** for this EPG. Selector should be added Under **Site Specific** configuration for each EPG. 

Under **Template Properties** swtich to **CNC-Azure-01** Site, click on **EPG-Azure-02** and hit **"Add Selector"** button under the EPG Cloud Properties. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image221.png" width = 800>

Selector details: 

- Endpoint Selector Name: **Azure-sel-02**
- Expression: 
    
    - Type: **IP address**
    - Operator: **Equals**
    - Value: **10.200.0.0/23**

Hit checkbox sign to save expression and then **Ok** to finish. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image222.png" width = 500>

Under **Template Properties** swtich back to **Template Properties** and hit **"Deploy to sites"** and **"Deploy"**. 

Once done confirmation will pop up on the screen. 

**At this point we have created Tenant, VRF, EPGs and selectors for our second Tenant - let's now add Virtual Machines instance.**

## VM creation 

Creation of VM for Tenant-Azure-02 in Azure. 

Login to Azure portal via https://portal.azure.com with your account details

Search for **Virtual machine** in search bar and open from Services list 

 <img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image130.png" width = 800>

Under **Create** button select **"Azure virtual machine"**

 <img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image131.png" width = 800>

 Virtual Machine details: 

!!! Note
    If setting is not listed, leave default.

 - Subscription: **leave selected** 
 - Resource Group: **hit create new and add with name "RG-CL23-T02, then hit OK"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image230.png" width = 400>

 - Virtual Machine name: **VM-AZ-02**
 - Region: **(Europe) France Central** 
 - Authentication type: **Password**  
 
    - username: **student** 
    - password: **CiscoLive2023!**

Hit **"Next: Disks >"** and accept all default values, hit **"Next: Networking >"** and configure: 

 - Virtual Network: **T2-VRF-02**
 - Subnet: **az-subnet (10.200.0.0/23)**
 - Public IP: **leave default**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image231.png" width = 400>

Hit directly **"Review + Create"** and leave all other setting as default. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image232.png" width = 500>

Hit directly **"Create"** to deploy Virtual Machine. 

It may take 3-5 minutes for instance to be ready. Portal will notify you when done. 

**Let's add contract to allow communication.**

## Contract configuration 

### 1. Filter creation

In order to create Contract, we need to have a filter in this template also

Open Nexus Dashboard Orchestrator GUI then go to **Application Management -> Schemas -> "Schema-T02-Azure"** -> open 

Under View select **"temp-Azure-01"** and **"Add filter"** under **Filter** section. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image233.png" width = 800>

 - Display Name: **permit-any** 

Then click **"Add entry"** to define protocols and ports. 

 - Name: **permit-any** 
 
 Leave rest setting as default - this will allow for all protocols and ports, but we could limit traffic to very specific conditions. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image144.png" width = 600>

Hit **Ok** to save it. 

### 2. Contracts configuration

!!! Info 
    Contract can have a different scope (Application Profile, VRF, Tenant, Global). Depneds on the use case, where are the providers and consumers located we should choose appropriate scope. In first two use-case providers and consumer were located in the same VRF, hence default **VRF** Scope was enough to cover provider and consumer. 

In this Use-case, idea is to connect EPGs from different Tenants, hence scope for contract needs to be set to **"Global"**, as this is the only one which covers EPGs from different tenants. Also placement of contract is imporant.

!!! Important
    If contract is to be used for connection of EPGs from different Tenants/VRFs, contract needs to be deployed in the Tenant were Provider of this contract is configured. 

In our case contract where **EPG-Azure-02** from **Tenant-Azure-02** is to be a **Provider** will be created in **"Schema-T02-Azure"** and Tempalte **"temp-Azure-01"**. 

Contract in opposite direction where **EPG-Azure-01** from **Tenant-01** is to be a **Provider** will be created in **"Schema-T01"** and Tempalte **"temp-Azure-01"**. 

**Contracts configuration under Tenant-Azure-02** 

Under Schema **"Schema-T02-Azure"** navigate to **View** select **"temp-Azure-01"** and **"Add contract"** under **Contract** section. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image240.png" width = 800>

Create contracts with following details: 

- Contract **con-Azure-02-to-Azure-01** 

    - Display Name: **con-Azure-02-to-Azure-01** 
    - Scope: **Global**
    - Apply both direction: **yes**
    - Add Filter: **permit-any**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image241.png" width = 800>

Hit **Save** to finish contract configuration. 

Under Schema **"Schema-T02-Azure"** navigate to **View** select **"temp-Azure-01"** and under **EPG-Azure-02** specific setting locate **Contract** section

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image242.png" width = 800>

Hit **"Add Contract"** button and add the following contract: 

 - EPG: **EPG-Azure-02**
 - Contract: **con-Azure-02-to-Azure-01**
 - Type: **provider** 

 Hit **Deploy to sites** for contracts to be applied to EPGs. 

**Let's now create contract in opposite direction.**

Under Schema **"Schema-T01"** navigate to **View** select **"temp-stretch-01"** and **"Add contract"** under **Contract** section. 

Create contracts with following details: 

- Contract **con-Azure-01-to-Azure-02** 

    - Display Name: **con-Azure-01-to-Azure-02** 
    - Scope: **Global**
    - Apply both direction: **yes**
    - Add Filter: **permit-any**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image247.png" width = 800> 

 Under Schema **"Schema-T01"**  navigate to **View** select **"temp-Azure-01"** and under **EPG-Azure-01** specific setting locate **Contract** section

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image248.png" width = 800>

Hit **"Add Contract"** button and add the following contract: 

Contract 1: 

 - EPG: **EPG-Azure-01**
 - Contract: **con-Azure-01-to-Azure-02**
 - Type: **provider** 

Contract 2:

 - EPG: **EPG-Azure-01**
 - Contract: **con-Azure-02-to-Azure-01**
 - Type: **consumer** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image249.png" width = 800>

 Hit **Deploy to sites** for contracts to be applied to EPGs. 

**Let's come back to Tenant-Azure-02 to consume newly created contract.**

Under Schema **"Schema-T02-Azure"** navigate to **View** select **"temp-Azure-01"** and under **EPG-Azure-02** specific setting locate **Contract** section

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image242.png" width = 800>

Hit **"Add Contract"** button and add the following contract: 

 - EPG: **EPG-Azure-02**
 - Contract: **con-Azure-01-to-Azure-02**
 - Type: **consumer** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image250.png" width = 800>

 Hit **Deploy to sites** for contracts to be applied to EPGs. 

 ## Cross-Tenant traffic verification 

 Let's check now if our Virtual Machines are able to communicate. For now we have configured that part of our infrastructure. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image251.png" width = 800>

Login to Azure portal via https://portal.azure.com with your account details

Search for **Virtual machine** in search bar and open from Services list 

 <img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image130.png" width = 800>

On the Azure Virtual Machine **VM-AZ-02**, scroll down to **"Help"** Section and select **"Serial Console"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image252.png" width = 800>

Hit enter and provide VM login credentials:

- username: **student** 
- password: **CiscoLive2023!**

Once in the console try to reach via ping to private IP address of Virutal Machine **VM-AZ-01** 

    student@VM-AZ-02:~$ ping 10.100.0.4
    PING 10.100.0.4 (10.100.0.4) 56(84) bytes of data.
    64 bytes from 10.100.0.4: icmp_seq=1 ttl=63 time=4.48 ms
    64 bytes from 10.100.0.4: icmp_seq=2 ttl=63 time=6.70 ms
    64 bytes from 10.100.0.4: icmp_seq=3 ttl=63 time=3.19 ms
    64 bytes from 10.100.0.4: icmp_seq=4 ttl=63 time=6.22 ms
    ^C
    --- 10.100.0.4 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3005ms
    rtt min/avg/max/mdev = 3.185/5.147/6.699/1.401 ms
    student@VM-AZ-02:~$ 

Communication is successfull! Well done. 

# This test has completed our lab, hope you enjoyed it and learn some new infromations.