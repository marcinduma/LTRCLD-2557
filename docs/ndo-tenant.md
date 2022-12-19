# Nexus Dasboard Orchestrator Tenant configuration 

In this section we will configure our first Tenant, streteched between Azure and AWS. As Cloud Network Controller will be used for configuration, we need to make sure that CNC has privillages to do so. Will learn how to do it. 

## Tenant Creation on NDO 

On the Left navigation page click **"Application Management" -> "Tenant"** and then **"Add Tenant"**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image50.png" width = 800>

Fill in Tenant details for name and description 

 - Display Name: Tenant-01
 - Descrption: Cisco Live 2023 AMS Tenant

Associate Tenant to both Site by checking the checkbox next to it. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image51.png" width = 800>

!!! Note 
    For now you are not able to **Save** this configuration with red marking on both Sites. Click the **Pencil** button at the end of each site line to finish configuration. 

    Additional setting are needed for CNC, so it knows which subscribtion to use on Azure and which Tenant ID on AWS. 

**CNC-Azure-01 site configuration**

For Azure site, we will be using the same **Subscription** as the one used for CNC deployment - select **Mode** as **"Select Shared"** and use existing subscription from drop-down. Leave security domains empty. Hit **Save**. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image52.png" width = 800>

**CNC-AWS-01 site configuration**

For AWS site we have 2 options - **Untrusted** with Cloud Access key and Secret or **Trusted**. In our case we would be using Trusted configuration. 

Each Tenant create on NDO with AWS Site association required sepearete Account ID on AWS site. You can find your in POD Details. 

Fill in with your POD ** AWS User-Account ID** and select **Access Type** as **Trusted**, hit **Save**. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image53.png" width = 800>

Now configuration can be saved, leave assocaited user list empty as there are no additional users and hit **Save**.

On the Tenant list you should see **Tenant-01** created an assigned to 2 Sites. 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image54.png" width = 800>