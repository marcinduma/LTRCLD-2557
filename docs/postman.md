# Install and Operate Postman

Postman is an API platform for building and using APIs. Postman simplifies each step of the API lifecycle and streamlines collaboration so you can create better APIs—faster.

## 1. Install Postman in your workstation

First step to do in our dCloud lab is download and install of Postman. Login to your dCloud workstation and from the Chrome connect to:

	https://www.postman.com/downloads/

Select Windows 64-bit to download the installation file.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-download.PNG" width = 800>

Download the file to local folder of your choice.
Start installation - it will automatically install and open application.

!!! Note
	You installed and run Postman in *Scratch Pad* version. If you would like to use workspace version, it is required to setup Free account. It will keep your Postman Collections in cloud, helps to collaborate and backup work you do.

## 2 Initial setup of Postman

Once the Postman is up and running you should create few things. First, setup your **Environment** data. Environment definition can be reused later, it is also good way to keep secured sensitive data like credentials. Second, create your **Request Collection** or import one from .json file.

#### 2.1 Create Environment for our dCloud lab

Environment definition is a place where you can store information about IP address of APIC and credentials. Once you run your restAPI queries, Postman will automatically use variables defined here.
Lets do it then for our scenario.

Navigate to Environment section in Postman Dashboard as marked on figure below.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-env-1.png" width = 800>

In this place you can select existing Environment, edit/delete it or create new one. To review existing Environment use icon most on right in red marked section on Figure above. It will open section shown at next figure. Click **Add** to create new entry.


<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-env-2.png" width = 800>

*Add* button will move you to new Postman Tab

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-env-3.png" width = 800>

1. Change name of your Environment to:

		ACI-dcloud

2. Configure VARIABLES:

		apic, user, password

3. INITIAL VALUES:

		198.18.133.200, admin, C1sco12345

4. Change Type of data for password to **secret**

5. Save it.

Now you have ready Environment you can choice from drop-down menu.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-env-4.png" width = 800>

You will use it for rest of **Day1** exercises.

### 2.2 Create New Collection

Click on Link **Create Collection** indicated in the figure below:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-1.png" width = 800>

Name your New Collection 

		ACI dCloud

Set Authorization type to *Basic Auth*. Once done, use **Ctrl+S** or Save button on dashboard - Floppy Disk icon.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-2.png" width = 800>

Do not type anything to "Username" and "Password". Those data will be pulled from your Environment - created in previous task.

Now you have Environment and Collection ready. We can start working with our restAPI requests.

