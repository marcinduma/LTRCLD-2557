# Use-case 01 - Stretched VRF

**Previous tasks were focusing on infrastructure configuration, from now on infrastructure is ready and will be working on logical topology.**

First use-case task will focus on:

- Configuration of stretch VRF inside Tenant-01
- VPC CIDR, VNET configuration in respective clouds
- EPG configuration in both clouds 
- EC2/Virutal Machine creation for communication testing 
- Contract configuration to allow traffic flow 
- Communication testing 

## Schema, Template configuration 

All logical polices and configuration is done in Nexus Dashboard via Schemas and Templates. Each Schema can have multiple Templates, but Template can belong to only one Schema. Each Template is also assocaited to one and only one Tenant. Template to site assoction will also define to which fabric (on prem or cloud) configration will be pushed, therefore is the smallest logical unit we can decide where changes are deployed. 

### 1. Schema creation 

Navigate to **Dashboard -> Application Management -> Schemas**, then hit **"Add Schema"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image70.png" width = 800>

Add Schema name and Description and hit **"Add"** button

- Name: **Schema-T01** 
- Description: **Schema for Tenant-01**

### 2. Template creation 

Under the Schema-T01, let's create first Template with **"Add New Template"** button

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image71.png" width = 800>

For a Template type select **"ACI Multi-Cloud"** and hit **"Add"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image72.png" width = 800>

On the right side of the template screen, we can customize the Tempalte Display Name, and also select Tenant. Add Display Name and Select a Tenant. 

- Display Name: **temp-stretch-01**
- Tenant setting: **Tenant-01**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image73.png" width = 800>

### 3. Template to site association

For configuration in template to be deployed, appropriate sites need to be added. Sites added will decide to which fabric configuration will be pushed. 

For **temp-stretch-01**, we want to add both Azure and AWS sites. 

To do it under the **Template Properties** locate the **Actions** button and hit **Sites Associations**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image76.png" width = 800>

Select both site **CNC-AWS-01** and **CNC-Azure-01** and hit **Ok**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image77.png" width = 800>

## VRF, EPG, selectors deployment  

### 1. VRF Configuration

Inside **Schema-T01**, inside **temp-stretch-01** add the VRF with **"Add VRF"** button under **VRFs** box

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image74.png" width = 800>

Add VRF Common Properties 

- Display Name: **VRF-01** 
- Description: **CL2023 Stretch VRF**

Leave other as default. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image75.png" width = 800>

As Tempalte was assocaited to both sites, we need to update details for each cloud, to do so under **temp-stretch-01** expand **"Template Properties"** and go to **"CNC-AWS-01"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image78.png" width = 800>

Click on the **"VRF-01"** which opens **Site specific properties** for this **CNC-AWS-01 Site**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image79.png" width = 800>

Under the **"Template Properties"** hit **"Add Region"** button and select **Region** from the list and then hit  **"Add CIDRs"** button 

 - **Region:** eu-central-1

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image80.png" width = 800>

Now we need to specify what subnet we would like to use in AWS cloud for that VPC. This subnet will be configure as VPC CIDR on AWS cloud and will be used for VM and endpoint addressing. 

- CIDR: **10.0.0.0/23** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image81.png" width = 800>

Our CIDR also needs to be divided into subnets for respective **Availability Zones (AZ)** - hit **"Add Subnet"** to configure it. 

We need to add subnet for a,b,c (number of AZ depends on the region), each subet needs to be confirmed with click on **checkbox** button.

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image82.png" width = 800>

Create subnet for all 3 AZ in our Region, use non-virutal zone. 

 - **Subnet:** 10.0.0.0/25      **Name:** az-1a-subnet **AZ:** eu-central-1a
 - **Subnet:** 10.0.0.128/25    **Name:** az-1b-subnet **AZ:** eu-central-1b
 - **Subnet:** 10.0.1.0/25      **Name:** az-1c-subnet **AZ:** eu-central-1c


<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image83.png" width = 800>

When done, hit **"Save"** button to save subnet configuration. 

We also want to connect our subnets to Catalys8000V routers, this is done via Hub Network (Transit Gateway in AWS) - check the checkbox for **"Hub Network"**, select **Hub Network** and also all **Subnets** added. 

 - Hub Network: **TGW-HUB**
 - Subnets: **10.0.0.0/2, 10.0.0.128/25, 10.0.1.0/25** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image84.png" width = 800>

Hit ok to finish configuration for **CNC-AWS-01** fabric.

Similar configuration has to be done for **CNC-Azure-01**.

Under **temp-stretch-01** expand **"Tempalate Properties"** and go to **"CNC-Azure-01"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image85.png" width = 800>

Click on the **"VRF-01"** which opens **Site specific properties** for this **CNC-Azure-01 Site**

Under the **"Tempalate Properties"** hit **"Add Region"** button and select **Region** from the list and then hit  **"Add CIDRs"** button 

 - **Region:** francecentral

 Now we need to specify what subnet we would like to use in AWS cloud for that VPC.

- CIDR: **10.0.0.0/23** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image86.png" width = 800>

Similar like for AWS we also needs to add subnet, but in case of Azure we don't need to select **Availability Zones.** We can add whole CIDR as subnet. When done, hit **"Save"** button to save subnet configuration. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image87.png" width = 800>

In case of Azure cloud, connection to CNC VNET is done via **"VNET Peering"** feature - enable it and select **"Default" Hub Network**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image88.png" width = 800>

Hit ok to finish configuration for **CNC-Azure-01** fabric.

Under **temp-stretch-01** expand **"Template Properties"** and go to **"Template Properties"** main settings. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image89.png" width = 800>

When done **"Deploy to sites"** button will become active (blue) - click to deploy VRF to respective sites. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image90.png" width = 800>

Nexus Dashboard will also show you what changes are to be made. Review those and hit **Deploy** button to push configuration. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image91.png" width = 800>

If all goes well, confirmation pop-up will get displayed on the screen. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image92.png" width = 800>

At this point in both Azure and AWS cloud, there will be VNET/VPC (respectively) created with defined addressing. 

### 2. VRF verification 

In the browser, open AWS console page. From the Region list, make sure that you have Frankfurt (eu-central-1) region selected. If not, switch to it. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image94.png" width = 800>

Search for **"VPC"** resource in Search tool and open it. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image93.png" width = 800>

You should have 2 VPCs created. 

- context-[VRF-01]-addr-[10.0.0.0/23] - coresponding to NDO created VRF 
- Default, without name, created automaticaly by AWS

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image95.png" width = 800>

Let's check the same in Azure Cloud. Open the Azure Portal and login if needed. 

Search for **Virtual Networks"** in search bar

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image96.png" width = 800>

As we are using shared subscribtion in this lab, there will be 2 **Virtual Networks** 

- VRF-01 - corresponding to our VRF 
- overlay-1 - infrastructure VRF in which CNC and Cloud Routers are connected 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image97.png" width = 800>

### 3. Additional Template creation 

As per our topology diagram, EPGs in each Cloud are separate. As current **temp-stretch-01** is associated with both sites, we need to create 2 new templates in the **Schema-T01** schema,  to Azure and AWS cloud sites respectively. 

Use the "Add new Template" and create 2 new templates with following names. Similar to first template form **Actions** mennu associate to respective sites. 

**AWS Template:**

- Template name: **temp-AWS-01**
- Template type: **ACI Multi-Cloud**
- Template Tenant: **Tenant-01**
- Site associated: **CNC-AWS-01**

Hit **Save** button to save the template. 

**Azure Template:**

- Template name: **temp-Azure-01**
- Template type: **ACI Multi-Cloud** 
- Template Tenant: **Tenant-01**
- Site associated: **CNC-Azure-01**

Hit **Save** button to save the template. 

### 4. Application Profile and EPG Configuration for AWS 

ACI in Cloud doesn't use the concept of **Bridge Domain**, they don't have any representation in Cloud, that's why IP ranges were defined as part of VRF configuration. 

**EPGs** can be now created and attached to VRF directly. 

Navigate to **temp-AWS-01** template using **View** dropdown menu. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image100.png" width = 800>

Add **Application Profile** using **Add Application Profile** button. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image101.png" width = 800>

- Display Name: **AppProf-AWS-01**
- Description: **Application Profile CL 2023 AWS**

Hit **Save**

Under created **Application Profile** add **EPG**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image102.png" width = 800>

- Display Name: **EPG-AWS-01**
- Description: **EPG AWS CL 2023** 
- EPG Type: **Application** 

Skip the **"On-Premises Properties"** and click on **"Cloud Properties"** and select **"Virtual Routing & Forwarding"** as **"VRF-01"**. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image103.png" width = 500>

We also need to add **Selector**. Selectors are used in Public Cloud to assign Virtual Machines and Endpoints to correct EPG represented by a Security Group. Selector should be added Under **Site Specific** configuration for each EPG. 

Thare can be different type of selectores: 

- IP based 
- TAG based
- Region Based 
- Custom 

In our case we will use **IP based** selectors. 

Under **Template Properties** swtich to **CNC-AWS-01** Site, click on **EPG-AWS-01** and hit **"Add Selector"** button under the EPG Cloud Properties. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image104.png" width = 800>

Selector details: 

- Endpoint Selector Name: **AWS-sel**
- Expression: 
    
    - Type: **IP address**
    - Operator: **Equals**
    - Value: **10.0.0.0/23**

Hit checkbox sign to save expression and then **Ok** to finish. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image105.png" width = 500>

Under **Template Properties** swtich back to **Template Properties** and hit **"Deploy to sites"** and **"Deploy"**. 

Once done confirmation will pop up on the screen. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image106.png" width = 500>


### 5. Application Profile and EPG Configuration for Azure

Navigate to **temp-Azure-01** template using **View** dropdown menu. 

Add **Application Profile** using **Add Application Profile** button. 

- Display Name: **AppProf-Azure-01**
- Description: **Application Profile CL 2023 AWS**

Hit **Save**

Under created **Application Profile** add **EPG**

- Display Name: **EPG-AWS-01**
- Description: **EPG AWS CL 2023** 
- EPG Type: **Application** 

Skip the **"On-Premises Properties"** and click on **"Cloud Properties"** and select **"Virtual Routing & Forwarding"** as **"VRF-01"**. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image110.png" width = 800>

We also need to add **Selector**. Selectors are used in Public Cloud to assign Virtual Machines and Endpoints to correct EPG represented by a Security Group. Selector should be added Under **Site Specific** configuration for each EPG. 

Under **Template Properties** swtich to **CNC-Azure-01** Site, click on **EPG-Azure-01** and hit **"Add Selector"** button under the EPG Cloud Properties. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image111.png" width = 800>

Selector details: 

- Endpoint Selector Name: **Azure-sel**
- Expression: 
    
    - Type: **IP address**
    - Operator: **Equals**
    - Value: **10.100.0.0/23**

Hit checkbox sign to save expression and then **Ok** to finish. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image112.png" width = 500>

Under **Template Properties** swtich back to **Template Properties** and hit **"Deploy to sites"** and **"Deploy"**. 

Once done confirmation will pop up on the screen. 


## EC2/VM creation and verification  

Next step is creation of Vritual Machine/EC2 Instance in respective clouds for traffic veryfication. 

### 1. AWS EC2 creation 

Login to AWS user tenant via https://console.aws.amazon.com and make sure that you have **Frankfurt/eu-central-1** region selected 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image115.png" width = 300>

To be able to launch and login to VM we need to have SSH key-pair created. 

In seach bar type **"key pairs"** and select Key Pairs from Features list. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image118.png" width = 600>

Hit **"Create key pair"** in top right corner and provide following settings: 

- Name: **AWS-key-pair**
- Key pair type: **RSA**
- Private key file format: **.pem**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image119.png" width = 600>

Hit "Create key pair" to finish. Once you do it key will be downloaded to your desktop, so you can use for connection to VMs. Make sure to store it in know place on your desktop. 

In seach bar type **"EC2"** and select EC2 from Service list. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image116.png" width = 600>

On the EC2 Dashboard locate **"Launch instance"** and hit Launch instance option. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image117.png" width = 600>

Instance details:

- Name: **VM-AWS-01**
- Application and OS Images: **Amazon Linux**
- Architecture: **64-bit** 
- Instance type: **t2.micro** 
- Key pair(login): **AWS-key-pair** 
- Network settings (hit Edit to change):

    - VPC: **context-[VRF-01]-addr[10.0.0.0/23]**
    - subnet: **subnet-[10.0.0.0/25]**
    - Auto-assign public IP: **Enable**
    - Firewall (security groups): **leave default**

- Other setting leave default 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image120.png" width = 800>

Review summary and hit **"Launch instance"** to create Virtual Machine

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image121.png" width = 400>

It may take 3-5 minutes for instance to be ready - you may jump to next step and deploy instance in Azure, then come back here for veryfication. 


### 2. AWS EC2 veryfication 

Go back to EC2 -> Instances and locate your EC2 machine. Click on Instance-ID of you machine to open it. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image122.png" width = 800>

 - Verify that VPC ID is correct 
 - Verify that subnet is correct 
 - Verify that instance has correct **Private IPv4 addressess"** 

 Note down IP address of EC2 instance, we will need it for veryfication. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image123.png" width = 800>

 Go to Security settings of VM and check that **Security groups** for you instance is the one related to **EPG-AWS-01** 

 <img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image124.png" width = 800>

 This security group was pushed when EPG was deployed towards AWS site. Instance interfaces was assigned to this EPG/Security Group based on the IP based Selector configured for this EPG. Cloud Network Controller is monitoring resources created in managed Tenants and it's automatically assigning Security groupes based on selectors. 

### 3. Azure Virutal Machine creation 

Login to Azure portal  via https://portal.azure.com with your account 

Search for **Virtual machine** in search bar and open from Services list 

 <img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image130.png" width = 800>

Under **Create** button select **"Azure virtual machine"**

 <img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image131.png" width = 800>

 Virutal Machine details: 

 !!!Note
    If setting is not listed, leave default.

 - Subscription: **leave selected** 
 - Resource Group: **create new "RG-CL23"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image132.png" width = 400>

 - Virtual Machine name: **VM-AZ-01**
 - Region: **(Europe) France Central** 
 - Authentication type: **Password**  
 
    - username: **student** 
    - password: **CiscoLive2023!**

Hit **"Next: Disks >"** and accept all default values, hit **"Next: Networking >"** and configure: 

 - Virtual Network: **VRF-01**
 - Subnet: **az-subnet (10.100.0.0/23)**
 - Public IP: **leave default**

Hit directly **"Review + Create"** and all other setting will stat default. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image133.png" width = 500>

Hit directly **"Create"** to deploy Virutal Machine. 

It may take 3-5 minutes for instance to be ready. Portal will notify you when done. 

### 4. Azure Virutal Machine veryfication 

Go back to **Services -> Virutal machines** and locate your Virutal Machine. Click on the name to open it. 

Under the **"Settings"**, go to **"Networking"** and then **"Application Security groups (ASG)"** and notice that our Virutal Machine is assigned to **"EPG-Azure-01_cloudapp-AppProf-Azure-01"** securty group. Similarly like for AWS, this ASG was assigned due to Selector configuration for EPG. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image134.png" width = 800>

## Cross Cloud traffic verification 

Let's check if our Virutal Machines are able to communicate. For now we have configured that part of our infrastructure. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image140.png" width = 800>

On the Azure Virtual Machine, scroll down to **"Help"** Section and select **"Serial Console"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image141.png" width = 800>

Hit enter and provide VM login credentials:

- username: **student** 
- password: **CiscoLive2023!**

Inside the console try to reach via ping to AWS EC2 IP address we noted earlier. 

    student@VM-AZ-01:~$ ping 10.0.0.106
    PING 10.0.0.106 (10.0.0.106) 56(84) bytes of data.

    --- 10.0.0.106 ping statistics ---
    7 packets transmitted, 0 received, 100% packet loss, time 6134ms
    student@VM-AZ-01:~$

It doesnt work, what is expected as we didn't connect our two EPGs via contract. So even they are part of the same VRF, they are not able to communicate, as exactly same principles as on ACI applies. 

## Contract configuration 

### 1. Filter creation

In order to create Contract, we need to have a filter which defines what type of traffis is allowed or denied under specyfic contract. 

Open Nexus Dashboard Orchestrator GUI then go to **Application Management -> Schemas -> "Schema-T01"** -> open 

Under View select **"temp-stretch-01"** and **"Add filter"** under **Filter** section. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image143.png" width = 800>

 - Display Name: **permit-any** 

Then click **"Add entry"** to define protocols and ports. 

 - Name: **permit-any** 
 
 Leave rest setting as default - this will allow for all protocols and ports. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image144.png" width = 600>

Hit **Ok** to save it. 

### 2. Contract configuration

As contracts will be used to connect AWS EPG to Azure EPG, contract should be created in stretched templates so it's deployed in both sites. 

Under View select **"temp-stretch-01"** and **"Add contract"** under **Contract** section. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image142.png" width = 800>

Create two(2) contracts with following details: 

- Contract **con-AWS-01-to-Azure-01** 

    - Display Name: **con-AWS-01-to-Azure-01** 
    - Scope: **VRF**
    - Apply both direction: **yes**
    - Add Filter: **permit-any**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image145.png" width = 800>

Hit **Save** to finish contract configuration. 

- Contract **con-Azure-01-to-AWS-01** 

    - Display Name: **con-Azure-01-to-AWS-01** 
    - Scope: **VRF**
    - Apply both direction: **yes**
    - Add Filter: **permit-any**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image146.png" width = 800>

Hit **Save** to finish contract configuration. 

Hit **Deploy to sites** for contracts to be pushed. 

### 2. Contract assigment to EPGs 

Just creation of contract doesn't have any impact on the traffic. Contract needs to have at least on Provider EPG and one Consumer EPG to allow communication between them. 

Under View select **"temp-AWS-01"** click on the **EPG-AWS-01** and under EPG specific setting locate **Contract** section

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image150.png" width = 800>

Hit **"Add Contract"** button and add the following

Contract 1: 

 - EPG: **EPG-AWS-01**
 - Contract: **152**
 - Type: **provider** 

Contract 2: 

 - EPG: **EPG-AWS-01**
 - Contract: **con-Azure-01-to-AWS-01**
 - Type: **consumer** 

 Hit **Deploy to sites** for contracts to be applied to EPGs. 

Under View select **"temp-Azure-01"** click on the **EPG-Azure-01** and under EPG specific setting locate **Contract** section

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image151.png" width = 800>

Hit **"Add Contract"** button and add the following

Contract 1: 

 - EPG: **EPG-Azure-01**
 - Contract: **con-Azure-01-to-AWS-01**
 - Type: **provider** 

Contract 2: 

 - EPG: **EPG-Azure-01**
 - Contract: **con-AWS-01-to-Azure-01**
 - Type: **consumer** 

Hit **Deploy to sites** for contracts to be applied to EPGs. 

## Cross Cloud traffic verification attempt 2 

Let's check now if our Virutal Machine are able to communicate. For now we have configured that part of our infrastructure. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image152.png" width = 800>

On the Azure Virtual Machine, scroll down to **"Help"** Section and select **"Serial Console"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image141.png" width = 800>

Hit enter and provide VM login credentials:

- username: **student** 
- password: **CiscoLive2023!**

Once in the console try to reach via ping to AWS EC2 IP address we noted earlier. 

    student@VM-AZ-01:~$ ping 10.0.0.106
    PING 10.0.0.106 (10.0.0.106) 56(84) bytes of data.
    64 bytes from 10.0.0.106: icmp_seq=1 ttl=252 time=14.7 ms
    64 bytes from 10.0.0.106: icmp_seq=2 ttl=252 time=12.1 ms
    64 bytes from 10.0.0.106: icmp_seq=3 ttl=252 time=12.2 ms
    64 bytes from 10.0.0.106: icmp_seq=4 ttl=252 time=11.9 ms
    64 bytes from 10.0.0.106: icmp_seq=5 ttl=252 time=12.1 ms
    ^C
    --- 10.0.0.106 ping statistics ---
    5 packets transmitted, 5 received, 0% packet loss, time 4007ms
    rtt min/avg/max/mdev = 11.893/12.598/14.707/1.060 ms
    student@VM-AZ-01:~$

Contract configuration makes communication possible. 

## Cross Cloud traffic infrastructure check  

Let's now check what was confiugure on the infrastructure that traffic can now flow. 

### Azure Cloud veryfication

Go back to **Services -> Virutal machines** and locate your Virutal Machine. Click on the name to open it. 

Under the **"Settings"**, go to **"Networking"** and then take a look in **Inbound port rules** and **Outband port rules**. 

Our contract configuration added one more rule to the port rules which allows for communication with CIDR of AWS Cloud. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image153.png" width = 800>

Under the **"Settings"**, go to **"Networking"** locate the **"Network Interface"** and click on it's ID. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image154.png" width = 800>

Under the **Network Interface** locate the **Help Section** in left navigation menu and select **"Effective Routes"** tab 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image155.png" width = 800>

It may take couple of second to load, once loaded scroll down to the end of the list and notice one **User** Route added. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image156.png" width = 800>

You can see that subnet representing **AWS CIDR space - 10.0.0.0/23** is routed to **Virtual Appliance** which is an **Internal Load Balancer** balancing the traffic between 2 Cloud Routers. 

With that configuration, traffic is send to **Azure Cloud Routers** from which via **IPSec tunnels** is send to **AWS Cloud Routers** and towards destination AWS VPC. 

### AWS Cloud veryfication

Login to AWS user tenant via https://console.aws.amazon.com and make sure that you have **Frankfurt/eu-central-1** region selected 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image115.png" width = 300>

In seach bar type **"Subnet"** and select **Subnet (VPC feature)** from Features list. 

Locate you subnet **subnet-[10.0.0.0/25]** and click on **Subnet ID** assocaited to open that subnet. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image160.png" width = 800>

On the subnet details page, scroll down and locate **"Route Table"** tab, click on it 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image161.png" width = 800>

Notice that there was route added for **Azure VNET space - 10.100.0.0/23** towards **"tgw-*"** which is our Transit Gateway used to communicated with **AWS Cloud Routers**, so traffic can be send to Azure. 

### Cloud Routers Veryfication 

Open Putty client from desktop and put IP address of Cloud router from Azure - you can login to any of 4 routers. 

!!! Note 
    Cloud Routers IP address are avaibale in POD details IP address schema, or you can find them in Azure/AWS console directly. 

Login with username **"csradmin"** and password **"CiscoLive2023!"**

Execute command **"show vrf | inc VRF-01**
    
    show vrf | inc VRF-01

Expected output: 

    ct-routerp-francecentral-0-0#show vrf | inc VRF-01
        Tenant-01:VRF-01                 10.20.0.52:7          ipv4        BD7
    ct-routerp-francecentral-0-0#

Check the routing table for that VRF 

Execute command **"show ip route vrf Tenant-01:VRF-01**

    show ip route vrf Tenant-01:VRF-01

Expected output: 

    ct-routerp-francecentral-0-0#show ip route vrf Tenant-01:VRF-01

    Routing Table: Tenant-01:VRF-01
    [output truncated]
    Gateway of last resort is not set

        10.0.0.0/23 is subnetted, 2 subnets
    B        10.0.0.0 [20/0] via binding label: 0x3000001, 1d21h
                      [20/0] via binding label: 0x3000002, 1d21h
    S        10.100.0.0 [1/0] via 10.20.0.1, GigabitEthernet2
          192.168.100.0/24 is variably subnetted, 2 subnets, 2 masks
    C        192.168.100.0/24 is directly connected, BDI7
    L        192.168.100.100/32 is directly connected, BDI7
    ct-routerp-francecentral-0-0#

Output shows routing table from perspective of Azure Cloud Router, hence:

- Azure subnet **10.100.0.0/23** is available via **Static route** towards interfaces **GigabitEthernet2**, which is interfaces conencted to inside of Azure. 
- AWS subnet 10.0.0.0/23 is available from BGP protocol, from two (2) Cloud Router located in AWS Cloud 

In that way cloud routers know how to route traffic towards respective clouds. 
