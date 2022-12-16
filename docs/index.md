# Welcome to CiscoLive 2023 - Instructor Lab about ACI Multicloud

Speakers:

*Karol Okraska*, CX Delivery Architect, Cisco Systems, Inc.

*Marcin Duma*, CX Delivery Architect, Cisco Systems, Inc.

## Cisco ACI support of Public Cloud infrastructure
Cisco Cloud Network Controller (formerly Cloud APIC) provides enterprises with networking tools necessary to accelerate their hybrid-cloud and/or multicloud journey.

Utilizing cloud-native constructs, the solution enables automation that accelerates infrastructure deployment and governance and simplifies management to easily connect workloads across multicloud environments. The Cisco Cloud Network Controller vision is to support enhanced observability, operations, and troubleshooting across the entire environment.

Cisco Cloud Network Controller enables:

●      Seamless connectivity for any workload at scale across any location

●      Operational simplicity and visibility across a vast multisite, multicloud

●      data-center network

●      Easy L4-7 services integration

●      Consistent security and segmentation

●      Business continuity and disaster recovery

## Cloud Network Controller components: 

Cisco Cloud Network Controller is the main architectural component of this multicloud solution. It is the unified point of automation and management for the solution fabric including network and security policy, health monitoring, and optimizes performance and agility. The complete solution includes:

●      Cisco Cloud Network Controller(deployed in each Public Cloud which is to be managed) 

●      Cisco Nexus Dashboard (in our lab deployed in AWS Cloud) - Multicloud networking orchestration and policy management, disaster recovery, and high availability, as well as provisioning and health monitoring.

●      Cisco Catalyst® 8000V - deployed in Public Clouds, allowing for communication with other Clouds or on-premises datacenter. Responsible for traffic secuirty and end to end policy enforcement. 

## Topology

In this lab we will be using two(2) Public Cloud Provders: 

●      Microsoft Azure

●      Amazon AWS 

However Cloud Network Controller (CNC) is also supported on Google Cloud. 

In both Public Enviroments CNC will be deployed. Nexus Dashboard orchestrator will be run on Nexus Dashboard appliance deployed in AWS cloud. 

Due to time concern of this lab, Cloud Network Controller and Nexus Dasboard along with Nexus Dashboard Orchestrator Application will be pre-installed for you and ready for configuration. 

**Intial lab diagram:**

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image1a.png" width = 800>

## **Lab agenda**

### 1. Infrastructure veryfication - login and access 
### 2. Site onboarding in Nexus Dashboard   
### 3. Multisite infrastructure configuration
### 4. Multisite configuration check 
### 5. Tenant creation and Public Cloud Trust configuration 
### 6. Three(3) common use-cases configuration and veryfcation
####  - Stretched VRF across Public Clouds with Cloud-local EPGs 
####  - Internet Gateway configuration in AWS 
####  - Inter-Tenant routing 

Step by step configuration will guide you towards final topology as indicated in the picture below: 

<img src="https://raw.githubusercontent.com/marcinduma/LTRCLD-2557/master/images/image2.png" width = 800>

**<p style="text-align: center;">Enjoy!</p>**