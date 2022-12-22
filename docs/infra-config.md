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

### 6. On the Instances List scroll to the right and note down "Public IPv4 address" 

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

### 6. On the Virtual Machines list scroll to the right and note down "Public IP address" 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image19.png" width = 800>



## Nexus Dashboard site onboarding

### 1. Login to Nexus Dasboard using IP collected above and login with provided credentials 

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
  - Hostname/IP Address: **"Public IP of Cloud Network Controller for AWS collected above"**
  - Username: **admin**
  - Password: **CiscoLive2023!**
  - Login Domain: empty

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image13.png" width = 800>

### 6. Hit **"Save"**  

**"AWS site should be added now, stay on the same page! "**

### 7. Hit "Add site button one more time to add Azure site 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image20.png" width = 800>

### 8. Add Azure site details 

  - Site Type: **"Cloud Network Controller"**
  - Name: **"CNC-Azure-01"**
  - Hostname/IP Address: **"Public IP of Cloud Network Controller from Azure collected above"**
  - Username: **admin**
  - Password: **CiscoLive2023!**
  - Login Domain: empty

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image21.png" width = 800>

### 6. Hit **"Save"**  

## Check the site list 

You should see both sites added under the site list. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image22.png" width = 800>
