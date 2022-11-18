# Create sample use-cases with terraform

## Use-Case no.1

Customer place SHARED network component in ACI shared tenant *common*. Custom tenants contain dedicated VRF, BDs and EPGs, Domain associations and static-bindings for particular department. L3out configuration for routing with external networks.

Use existing PHYSDOM_1 physical domain and existing EXTRTDOM_1 routed domain (TIP: you can use data sources for this)
Use following static-bindings for devices:

WAN router:

  - node 101, interface eth1/5, vlan 250

INTERNET router:

  - topology/pod-1/protpaths-101-102/pathep-[IntPolGrp_Router1], vlan 251

UCS/vmware server:

  - topology/pod-1/protpaths-101-102/pathep-[IntPolGrp_VPC_server1]
  - EPG_HA - vlan 152
  - EPG_UC - vlan 150
  - EPG_DMZ - vlan 151

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/terraform-usecase.png" width = 800>

Based on experience gained, build yourself a use-case in Terraform. You can specify each resource directly, or you can use variable file.
