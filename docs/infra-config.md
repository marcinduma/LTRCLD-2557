# Infrastructure configuration - Site onboarding 

## Public IP Address of Nexus Dashboard and Cisco Cloud Network Controller in AWS 

### 1. Open AWS console via browser 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image3.png" width = 400>

### 2. Select IAM user,  provide Account ID and hit "Next" 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image4.png" width = 300>

### 3. Provide Username and password and hit "Sign In" 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image5.png" width = 300>

### 4. In AWS Search Bar type "EC2" and Select "EC2" Services Tab

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image6.png" width = 800>

### 5. From "Resources" select "Instances (Running)"

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image7.png" width = 800>

### 6. On the Instances List scroll to the right and note down "Public IPv4 address" for: 

- **"ND1-Master"**

- **"Cisco Cloud Network Controller"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image8.png" width = 800>


## Public IP Address of Cisco Cloud Network Controller in Azure

### 1. Open Azure portal via browser

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image14.png" width = 400>

### 2. Enter your username along with domain and hit "Next"

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image15.png" width = 400>

### 3. Provide password and hit "Sign In"

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image16.png" width = 400>

### 4. Use "Skip for now" option for Account Protection

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image17.png" width = 800>

### 5. In Search bar look for "virtual machines" and select from services

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image18.png" width = 800>

### 6. On the Virtual Machines list scroll to the right and note down "Public IP address" for: 

- **"CloudNetworkController"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image19.png" width = 800>



## Nexus Dashboard site onboarding

**Cisco Nexus Dashboard** is a single launch point to monitor and scale across different sites, whether it is Cisco Application Centric Infrastructure™ (Cisco ACI®) fabric controllers, the Cisco® Application Policy Infrastructure Controller (APIC), Cisco Nexus Dashboard Fabric Controller (NDFC), or a Cloud APIC running in a public cloud provider environment.

Cisco Nexus Dashboard provides a single focal point to unite the disparate views of hybrid-cloud data-center operations, application deployment, and performance.

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image9a.png" width = 800>

**Benefits**

●Easy to use

-      Customizable role-based UI view to provide a focused view on network operator use cases

-      Single Sign-On (SSO) for seamless user experience across operation services

-      Single console for health monitoring and quick service turn-up

●Easy to scale

-      Ensure high availability, scale-out operations from a single dashboard

-      Scale use cases leveraging flexible deployment options

-      Operations that span across on-premises, multicloud, and edge networks

●Easy to maintain

-     Seamless integration and lifecycle management of operational services

-      Onboard and manage operational services across on-premises, cloud, or hybrid environments

-      Single integration point for critical third-party applications and tools

●Flexible deployment options

-      On premises: Run Cisco Nexus Dashboard on the Cisco Nexus Dashboard platform

-      Hybrid: Run Cisco Nexus Dashboard on premises and in the cloud

-      Virtual: Run Cisco Nexus Dashboard on any local compute

-      Cloud: Run Cisco Nexus Dashboard on public cloud of choice

-      SaaS: Deploy, maintain, and support your infrastructure from anywhere*

**Let's now login and start using it! **

### 1. Login to Nexus Dasboard using **"ND1-Master"** Public IPv4 Address

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image9.png" width = 800>

### 2. Hit "Get started" and Setup screen will pop-up

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image10.png" width = 800>

### 3. On the "Add Sites" section hit "Begin" 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image11.png" width = 800>

### 4. Hit "Add Site" button

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image12.png" width = 800>

### 5. Add AWS Cloud Network Controller 
  - Site Type: **"Cloud Network Controller"**
  - Name: **"CNC-AWS-01"**
  - Hostname/IP Address: **"Public IPv4 Address of AWS Cisco Cloud Network Controller"**
  - Username: **admin**
  - Password: **CiscoLive2023!**
  - Login Domain: empty

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image13.png" width = 800>

### 6. Hit **"Save"**  

**"AWS site should be added now, stay on the same page! "**

### 7. Hit "Add site" button one more time to add Azure site 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image20.png" width = 800>

### 8. Add Azure site details 

  - Site Type: **"Cloud Network Controller"**
  - Name: **"CNC-Azure-01"**
  - Hostname/IP Address: **"Public IP Address of Azure CloudNetworkController"**
  - Username: **admin**
  - Password: **CiscoLive2023!**
  - Login Domain: empty

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image21.png" width = 800>

### 6. Hit **"Save"**  

## Check the site list 

You should see both sites added under the site list. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image22.png" width = 800>

On the Site list hit "Continue" and then "Done" button to finish Initial Setup.

Navigate to **"Go To Dashboard"** in bottom right corner - you should be moved to ND Dashboard with Site Map. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image23.png" width = 800>

In this section **Azure** and **AWS Cloud Network Controllers** were added to **Network Dashboard**. We will now proceed to **Multisite** configuration, and start managing those sites from **Nexus Dashboard Orchestrator**. We will also build an IPSec tunnels between them, so they can securly exchange traffic. 