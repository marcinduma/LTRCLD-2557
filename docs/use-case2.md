# Use-case 02 - Internet Gateway

**In this task we will configure Internet Gateway in AWS cloud, so Virtual Machines and Endpoints are able to reach the Internet.**

Instances in AWS can access Internet in AWS cloud with help of Internet Gateway. An internet gateway is a horizontally scaled, redundant, and highly available VPC component that allows communication between VPC and the internet.

An internet gateway provides a target VPC route tables for internet-routable traffic. For communication using IPv4, the internet gateway also performs network address translation (NAT).

## Internet Gateway as External EPG

As all VPC aspects and routing are controller by Cloud Network Controller, also Internet Gateway(IGW) is configured with it's help. Internet Gateway is represented by well know ACI object - External EPG. 

### External EPG configuration 

Open Nexus Dashboard Orchestrator GUI then go to **Application Management -> Schemas -> "Schema-T01"** -> open 

Under View select **"temp-AWS-01"** and hit **"Add External EPGs"** under **External EPGs** section. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image172.png" width = 800>

- Display Name: **ExtEPG-IGW**
- Description: **Ext EPG for Internet Gateway AWS** 
- Virutal Routing & Forwarding: **VRF-01** 
- Select Site Type: **CLOUD** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image174.png" width = 800>   

- Cloud Properties: 

    - Application Profile: **AppProf-AWS-01**
    - Add Selector: 

        - Endpoint Selector Name: **Internet**
        - Expression Type: **IP Address**
        - Expression Operator: **Equal**
        - Expression Value: **0.0.0.0/0**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image173.png" width = 800>   

Hit **Save** to finish. 

!!! Info 
    Adding the "0.0.0.0/0" subnet will add additional route to this prefix, pointing to internet gateway object create in AWS. In case only specyfic prefixes should be rechable, you can use differnt subnet that 0.0.0.0/0. 

### Contract configuration

As External EPG is functioning as any other EPG, contract configuration from EPG to External EPG is mandatory for traffic to be allowed. 

#### 1. Filter creation

Open Nexus Dashboard Orchestrator GUI then go to **Application Management -> Schemas -> "Schema-T01"** -> open 

Under View select **"temp-AWS-01""** and **"Add filter"** under **Filter** section. 

 - Display Name: **permit-any-aws** 

Then click **"Add entry"** to define protocols and ports. 

 - Name: **permit-any** 
 
 Leave rest setting as default - this will allow for all protocols and ports. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image144.png" width = 600>

Hit **Ok** to save it. 

#### 2. Contract configuration

As contracts will be used to connect AWS EPG to ExtEPG of AWS, contract should be created in AWS template 

Under View select **"temp-AWS-01"** and **"Add contract"** under **Contract** section. 

Create two(2) contracts with following details: 

- Contract **con-AWS-01-to-IGW** 

    - Display Name: **con-AWS-01-to-IGW** 
    - Scope: **VRF**
    - Apply both direction: **yes**
    - Add Filter: **permit-any-AWS**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image176.png" width = 800>

Hit **Save** to finish contract configuration. 

- Contract **con-IGW-to-AWS-01** 

    - Display Name: **con-IGW-to-AWS-01** 
    - Scope: **VRF**
    - Apply both direction: **yes**
    - Add Filter: **permit-any-AWS**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image175.png" width = 800>

Hit **Save** to finish contract configuration. 

Hit **Deploy to sites** for contracts to be pushed. 

!!! Info 
    Having contract only in one direction where Internet Gateway is a provider will be enough for EC2 instances to reach Internet, however contract in opposite direction is needed in case you want to connect to EC2 instances Public IPv4 Addresses from Internet. 

#### 3. Contract assigment to EPGs 

Under View select **"temp-AWS-01"** click on the **EPG-AWS-01** and under EPG specific setting locate **Contract** section

Hit **"Add Contract"** button and add the following

Contract 1: 

 - EPG: **EPG-AWS01**
 - Contract: **con-AWS-01-to-IGW***
 - Type: **provider** 

Contract 2: 

 - EPG: **EPG-AWS-01**
 - Contract: **con-IGW-to-AWS-01**
 - Type: **consumer** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image177.png" width = 800>

Under View select **"temp-AWS-01"** click on the **ExtEPG-IGW** and under **Common Properties** locate **Contract** section

Hit **"Add Contract"** button and add the following

Contract 1: 

 - EPG: **ExtEPG-IGW**
 - Contract: **con-IGW-to-AWS-01**
 - Type: **provider** 

Contract 2: 

 - EPG: **ExtEPG-IGW**
 - Contract: **con-AWS-01-to-IGW**
 - Type: **consumer** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image178.png" width = 800>

Hit **Deploy to sites** to create IGW and deploy contracts associations. 

## Veryfication 

Let's check if AWS EC2 instance is now reachable from internet. 

### 1. Open AWS console via browser 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image3.png" width = 400>

### 2. Select IAM user,  provide Account ID for User tenant and hit "Next" 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image4.png" width = 300>

### 3. Provide Username and password and hit "Sign In" 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image5.png" width = 300>

### 4. In AWS Search Bar type "EC2" and Select "EC2" Services Tab

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image6.png" width = 800>

### 5. From "Resources" select "Instances (Running)"

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image7.png" width = 800>

Locate Public IPv4 Address of EC2 instance, either on the EC2 instance list or under Details section

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image179.png" width = 800>

From workstation open command line interface by hitting **"Start"** and typing **"cmd"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image180.png" width = 800>

Execute command 

    ping <Public IPv4 address of EC2>

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image181.png" width = 800>

Communication is successfull now, EC2 instance has access to Internet via AWS Internet Gateway. 

At this point we completed that part of our topology configuration. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image185.png" width = 800>

In Next Section we will configure additional Tenant and try inter-tenant leaking. 