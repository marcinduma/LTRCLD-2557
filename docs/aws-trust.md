# Nexus Dasboard Orchestrator Tenant AWS Trust Configuration

In previus step we have selected Tenant configuration Mode as Trusted, so now trust needs to be made for Cloud Network Controller to have access to AWS Account. 

## AWS User Account Login 

Each User POD has two(2) AWS Accounts. 

- 1st for Infrastrucre Configuration 
- 2nd for Tenant Configuration 

Open AWS console via browser 

!!! Note 
    As you are already logged into AWS for Infrastructure Account, you can logout or use Incognito Mode (preferably), or different browser. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image3.png" width = 400>

Select IAM user, provide Account ID and hit "Next" 

!!! Note 
    For this login please use AWS User Account ID from POD details

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image4.png" width = 300>

Provide Username and password and hit "Sign In" 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image5.png" width = 300>

You will land on the welcome page of AWS cloud console. 

## AWS Cloud Network Controller Login 

Using the IP of AWS Cisco Clout Network Controller (can be found in POD deatils), connect via browser to CNC GUI for AWS instance. Make sure to use the same browser in which you logged in for AWS User Tenant. 

!!!Note 
    The trust configuration CloudFormation script needs to be executed on AWS User Account! 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image60.png" width = 300>

Provide Credentials and hit **Login**

- Username: admin 
- Password: CiscoLive2023! 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image61.png" width = 800>

Hit **"Get started"** to view Cloud Network Controller Dashboard. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image62.png" width = 800>

Look on the **Dashboard -> Application Management -> Tenants**, we can see newly create tenant on the list. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image63.png" width = 800>

Double-click the Tenant name **"Tenant-01"** to open it. 

Under the **AWS Account** section there is warning related to our Trust configuration, along with the **"Run the CloudFormation Template"** hyperlink. 

!!!Note 
    Make sure you have executed CloudFormation link from AWS User Tenant!

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image64.png" width = 800>

Click on the hyperlink to run CloudFormation Script. You will be then redirected to AWS console CloudFormation Stack configuration. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image65.png" width = 800>

All the parameters are already filled in, hit **"Next"** to continue. 

In **Specify stack details** step - fill in stack name and hit **"Next"**

- Stack Name: **CNC-AWS-Trust**
- Parameters: none

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image66.png" width = 800>

In **Configure stack options** step - leave all options as default and hit **"Next"**

In **Review CNC-AWS-Trust** step - leave all options as default, scroll down to **"Capabilities"** section and check the checkbox for resource creation and hit **"Submit"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image67.png" width = 800>

After couple of seconds(use refresh button) - stack will be completed and we are good to go. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image68.png" width = 800>

After AWS trust configuration we have our Infrastruture and first Tenant ready to be used. In next section of the Lab we will procced to Use-Cases configuration. Three(3) use-case we are about to configure are presenting typical real-life scenearios. 