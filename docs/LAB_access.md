# Connectivity Check


## 1. Lab access general description

The lab is based on dCloud session *Started with Cisco ACI 5.2 v1*:

You will have access to Cisco dCloud User Interface, where you will be able to login to necessary resources. Each dCloud session contain Windows Workstation, Centos server tool and ACI Simulator. You will work on your dedicated session - details will be provided by instructor.
During the training you will use only dCloud resources, no need to install additional applications at your PC.

## 2. Cisco dCloud dashboard

The entire lab for the session is built using Cisco dCloud environment.
Access to the Session will be provided by the proctor assigned to you.

You will get credentials for your individual session provided by teacher.

### Access session with webRDP

Once logged to the dCloud session, you will see dashboard like on the following picture:


<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/dCloud-dashboard.PNG" width = 800>


To open **webRDP* follow the procedure from the figures:

1) Click on the blue triangle highlighted on figure below

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/dCloud-rdp-1.PNG" width = 800>

2) Follow to "Remote Desktop" by using link in red frame on the figure:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/dCloud-rdp-2.PNG" width = 800>


When you click on "Remote Desktop" link, your web browser will open new TAB with access to Windows desktop. The webRDP has installed basic tools to operate with the LAB. Rest of them you will install yourself for better undestanding of prerequisites for Automation.

!!! info
	Please do not use "Remote Desktop" for other devices from the list at **Network** tab. ONLY win-workstation can be accessed that way.

!!! tip
	When you use webRDP you are still able to copy/paste between your 'main PC' and webRDP interface. You can use *Guacamole interface* - explained in Appendix: Guacamole.


## 3. Accessing Linux Machine

Open PuTTY client on webRDP taskbar.

PuTTY has predefined session called **tool1** for centos-terminal. Open SSH session by selecting it and click Open button.

Username:
	
	root

User password:
	
	C1sco12345


## 4. Accessing ACI simulator

The LAB is based on ACI simulator installed for you. To login, please use CHROME at webRDP workstation. Once you click at Chrome icon in taskbar, you get APIC gui open. Login using credentials below

URL:
	
	https://apic1.dcloud.cisco.com/

Username:
	
	admin

User password:
	
	C1sco12345


!!! warning
	Do not delete any configuration already present at ANY device within the LAB topology.

