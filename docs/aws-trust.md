# Nexus Dasboard Orchestrator Tenant AWS Trust Configuration

In previus step we select Tenant configuration as Trusted, trust need to be made to allow for configuration. 

## AWS Cloud Network Controller Login 

Using the IP found during site onboarding (can be also found in POD guide), connect via browser to CNC GUI for AWS instance. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image60.png" width = 300>

Provide Credentials and hit **Login**

- Username: admin 
- Password: CiscoLive2023! 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image61.png" width = 800>

Hit **"Get started"** to view Cloud Network Controller Dashboard. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image62.png" width = 800>

Look on the **Dashboard -> System -> Fault Summary** We can see Major Fault higher that **"0"** Click on **Major** button to view details. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image63.png" width = 800>

List of all Major faults will pop-up. 

One particular fault, with Code **F3526** is related to AccessDenied for User Account configuration. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image64.png" width = 800>

Double-Click on any column for that fault to open details. Inside **Fault Description** there is information about **CFT Script** which has to be executed on **User Tenant in AWS** for Trust configuration. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image65.png" width = 800>

Extract the CFT URL link for that message - it will be different that one in the screenshot as ID is generated dynamically. 
   
    https://capic-common-XXXXXXXXXX-data.s3.amazonaws.com/tenant-cft.json

Note it down, will be used in a moment. 

## AWS User Account Login 

Each User POD has two(2) AWS Accounts. 

- 1st for Infrastrucre Configuration 
- 2nd for Tenant Configuration 

### 1. Open AWS console via browser 

!!! Note 
    As you are already logged into AWS for Infrastructure Account, you can logout or user Incognito Mode, or different browser. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image3.png" width = 400>

### 2. Select IAM user, provide Account ID and hit "Next" 

!!! Note 
    For this login please use AWS User Account ID 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image4.png" width = 300>

### 3. Provide Username and password and hit "Sign In" 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image5.png" width = 300>

### 3. Trust script execution 

In the same browser you logged into User Account, open New Tab and paste CFT link collected above. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image66.png" width = 300>

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image67.png" width = 300>