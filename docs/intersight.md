# Explore Cisco Intersight Dashboard

## 1. Accessing Cisco Intersight Platform

Cisco Intersight Platform manages Kuberenetes clusters in the private infrasturcture. You will have access to dedicated instance of Cisco Intersight, from which you will manage your own Kuberenetes Clusters used later on to deploy application.

Please find login credentials and URL to your IKS instance below:

URL:
	
	https://intersight.com/
User name:
	
	holcld2611+pod'X'@gmail.com

Where X will be provided by proctor	

User password:
	
	CiscoLive!2022

!!! warning
	You can explore Cisco Intersight through the GUI, but please do not delete content already created.

### Access Intersight using following steps:

Open WebBrowser (Chrome) and connect to https://intersight.com 
Select *Sign In with Cisco ID* option on the first screen - as shown on figure below.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-access.png" width = 800>

Enter e-mail provided by proctor to your POD:

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-e-mail.png" width = 800>

Click next and fill password.

!!! tip
	Credentials for the session can be found in WIL Assistant portal. In case of issues, ask proctor for help.
	
## 2. Intersigh Dashboard Target

While you are logged to Cisco Intersight, first page you see is *Monitor* section.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-monitor.png" width = 1500>

Navigate to *Admin* section in the bottom of Navigation Pane on Left. Click on *Target*

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-nav-target.png" width = 1500>

Target section shows already Claimed services - in our case it is Cisco Intersight Assist installed "on-prem" together with vCenter.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-target.png" width = 1500>

You can see status of claim, date and who executed it.
Click on our Intersight Assist - iva.dcloud.cisco.com to see details of the Target.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-target-details.png" width = 1500>

## 3. Intersight Dashboard Operate

Most information from claimed targets are visible under *Operate* section. The section is divided to two sub categories: Virtualization and Kuberenetes.

### Virtualization

When exloring first of them, you will see information about all VMs managed by vCenter claimed in *Target* section.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-virtualization.png" width = 1500>

By using three dots button on right column, you are able to manage each of VM:

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-virtualization-menu.png" width = 1500>

Option when open the *Menu*:

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-virtualization-menu-open.png" width = 1500>


On the other Tabs, you can verify details of Hosts, Storage, etc. Please explore yourself rest of the tab when interested.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-virtualization-tabs.png" width = 1500>

### Kuberenetes

Second section contain informations about deployed Intersight Kuberenetes Clusters (IKS).

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-k8s.png" width = 1500>

You will see one IKS cluster, which is deployed on-prem. On main screen you see general information about its status - numbers of control plane nodes, workers, associated profile.
Using three dots button on most right column you open menu where you are able to download kubeconfig, undeploy Cluster or Open TAC case.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-k8s-menu.png" width = 1500>

### Explore deployed IKS cluster

Please, click at name of deployed IKS cluster.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-k8s-iks.png" width = 1500>

Now you are inside the selected cluster, where you find more details about deployment.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-k8s-clus.png" width = 1500>

Dashboard shows information about cluster condition, version of the K8s installed, CNI and more.
By selecting *Operate* Tab, you find more information about profile and policy usage.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-k8s-clus-oper.png" width = 1500>

Please explore rest of the *Sections* to see information under them.

## 4. Intersight Dashboard Configure

Another section in Navigation pane is "Configure". Under "Configure > Profiles" you find definition of IKS profile used for CLUS-IKS-1 K8s deployment you just explored.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-profiles.png" width = 1500>

### IKS Profile wizzard

When you open existing profile, you will be able to see progress wizzard.


!!! tip
	In new deployment you need to create all Pools and Polices for IKS beforehand. In the wizzard below, you will see already selected polices. It is explained in next section.

!!! warning
	PLEASE, DO NOT EDIT ANY OF THE POLICES UNDER THE PROFILE - IT MAY CAUSE DESTROY OF YOUR IKS CLUSTER.
	Explore it only and CLOSE in the END - DON'T DEPLOY CHANGES.

First page of the wizzard is asking Name of the Cluster

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-prof-wizzard-1.png" width = 1500>

Second page contains information about cluster in general. You find there IP Pool, LoadBalancer IP counts, DNS/NTP policy, etc.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-prof-wizzard-2.png" width = 1500>

Next one, its K8s Control Plane node definition. It is possible to configure desired state of CP nodes, minumum/maximum, K8s version, IP pools. It is first place where user must specify VM infra policy which contain vCenter information (basically definition where to deploy CP nodes). VM Machine policy contain information about VM size (RAM, CPU, disk size).

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-prof-wizzard-3.png" width = 1500>

Fourth page its definition of worker nodes. Similar to control-plane node definition, its possible to configure size of cluster, VM polices, IP pools, K8s version.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-prof-wizzard-4.png" width = 1500>

Next section contain ADD-Ons definition. Cisco Intersight give you an option to install K8s add-ons automatically during IKS cluster deployments. One of the ADD-on installed is Kuberenetes Dashboard.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-prof-wizzard-5.png" width = 1500>

Final page is summary of the entire profile, where is "DEPLOY" button.

DO NOT DEPLOY PROFILE, BUT CLOSE IT.

### IKS Configure Polices

Important section when working with Cisco Intersight is *Polices*. Here user needs to configure parameters of deployments before start doing profiles. 
In the LAB we use seven polices as shown on the figure below.

<img src="https://raw.githubusercontent.com/marcinduma/WILCLD-2611/master/images/intersight-polices.png" width = 1500>

Table gives general information about Names and Policy Types, time of creation/update. By clicking on the policy name, its possible to check details and edit it.
