# Infrastructure configuration - Multi-Site configuration

In this lab section we wil Use Nexus Dashboard orchestrator to connect 2 ACI Fabrics together. 

## Nexus Dashboard Orchestrator(NDO) login

### 1.  

On the Site list hit "Continue" and then "Done" button to finish Initial Setup. 

Hit **"Go To Dashboard"** in bottom right corner - you should be moved to ND Dashboard with Site Map

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image23.png" width = 800>

In the navigation menu on the left  go to **"Admin Console"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image24.png" width = 400>

You will be moved to **Admin Console** page, where you can see **Health** of your Nexus Dashboard and status of sites and services. 

Navigate to **"Sites"** tab and verify if **"Connectivity Status"** of you sites is **"Up"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image26.png" width = 800>

Navigate to **"Sevices"** tab to see what applicationa are installed on this Nexus Dashboard

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image25.png" width = 400>

**Nexus Dashboard Orchestrator** is already installed and enabled under **"Service Catalog"** inside **"Installed Service"** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image27.png" width = 800>

Hit **"Open"** button in order to login 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image28.png" width = 400>

You will be now redirected to **Nexus Dashboard Orchestrator** Dashboard. 

### 2. NDO Infrastrucure Configuration

To be able to used AWS and Azure sited we added on **Nexus Dashboard** we need to make them **Maneged** and assign **Site ID** 

Navigate to **Sites** 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image30.png" width = 800>

Click on **"Unmanaged"** box under **State** Column for each site and assign **Site ID**

For AWS Site - set ID **10**

For Azure Site - set ID **20**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image31.png" width = 800>

After this operation - both sites should be visable as **Managed**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image32.png" width = 800>
