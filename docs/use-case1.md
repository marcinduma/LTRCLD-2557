# Use-case 01 - Stretched VRF

**Previous tasks were focusing on infrastructure configuration, from now on, infrastructure is ready and will be working on logical topology.**

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

## VRF, EPG, contracts deployment  

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

### 2. VRF Veryfication 

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


### 3. Additional Template creation 

As per our topology diagram, EPGs in each Cloud are separate. As current **temp-stretch-01** is associated with both sites, we need to create 2 new templates in the **Schema-T01** schema,  to Azure and AWS cloud sites respectively. 

Use the "Add new Template" and create 2 new templates with following names:

**AWS Template:**

- Template name: **temp-AWS-01**
- Template type: **ACI Multi-Cloud**
- Template Tenant: **Tenant-01**

**Azure Template:**

- Template name: **temp-Azure-01**
- Template type: **ACI Multi-Cloud** 
- Template Tenant: **Tenant-01**



### 4. EPG Configuration 

ACI in Cloud doesn't use the concept of **Bridge Domains**, they don't have any representation in Cloud, that's why IP ranges were defined as part of VRF configuration. 

**EPGs** can be now created and attached to VRF directly, without Bridge Domain. 




