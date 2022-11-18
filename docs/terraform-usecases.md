# Basic use-cases with Terraform

In this lab the focus will be on using Terraform as a way to provide operational rigor to your network device configurations. You will learn how to install and use Terraform on Cisco network solutions like ACI.

## 1. Install Visual Studio Code

Terraform uses structured files that require editing. To assist you in this process the best tool is some editor that understands the Terraform semantics. For this lab you will be using a web based integrated development environment that uses the code that is inside Microsofts Visual Studio Code. When Microsoft wrote Visual Studio Code it built the IDE on top of a platform called electron. This allowed for cross platform development and is based on javascript.

Visual Studio Code can be installed on variety of operating systems, please download the package suitable for your environment and follow the installation process in the wizard:

    https://code.visualstudio.com/

Visual Studio Code has three panes that you will be using:
- The left pane with the files
- The right pane with the file contents
- The bottom pane will be leveraging the Terminal to issue commands

### 1.1 Open a new terminal in the IDE

To get started, first you have to open a terminal windows in the IDE to access the underlying operating system and work the lab. On the menu bar click the *Terminal* tab to open *New Terminal*

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/visual-terminal.png" width = 800>

Terminal will open at the bottom of the screen. This will be the area that you will execute all the terraform commands after making changes to terraform files.

## 2 Create the working directory

Terraform uses directory structures as a way to organize its automation structure. This is due to the fact that Terraform treats everything in a directory as a unit and reads all the `.tf` files before execution.
The first step is to create a directory called *ACI* for the terraform files. Using the IDE you can create folders. This directory will live under the ACI folder. There are various ways to create these in visual studio code: using the contextual menu (1a and 1b) or using the icons (2):

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/visual-new-folder.png" width = 800>
<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/visual-new-folder2.png" width = 800>

In that directory create the first terraform file called `main.tf` using the icon:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/visual-new-file.png" width = 800>

## 3. Configure ACI Provider

One of the first things we should do before writing configuration for ACI is to add the Terraform Provider for ACI. The definition will be placed in the `main.tf` file and we will use the username/password construct. It is also possible and recommended to use certificates based authentication, but for this lab we are using the simpler method.

ACI Provider documentation can be found on the official Terraform Registry website: https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs
In also includes instruction on how to use this provider. After clicking on "Use provider" small section with code will appear.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/terraform-aci-provider.png" width = 800>

The code that we will use in this lab contains IP address of APIC in the lab and default admin user/password. It should be copied to the `main.tf` file:

```
terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "2.5.2"
    }
  }
}

provider "aci" {
  # Cisco ACI user name
  username    = "admin"
  password    = "C1sco12345"
  url         = "https://198.18.133.200"
  insecure    = true
}
```

### 3.1 Run Terraform Init

Once the provider is configured and our APIC IP and credentials are present in the file, we can proceed with the first step of Terraform workflow and initialize the directory to include proper terraform provider modules needed for execution. In the terminal window on the bottom pane of Visual Studio make sure you are in the correct directory (your ACI folder) and then execute `terraform init`. The output should show that the provider plugin hsa been downlaoded:

```

juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform init

Initializing the backend...

Initializing provider plugins...
- Finding ciscodevnet/aci versions matching "2.5.2"...
- Installing ciscodevnet/aci v2.5.2...
- Installed ciscodevnet/aci v2.5.2 (signed by a HashiCorp partner, key ID 433649E2C56309DE)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Next you can try running `terraform plan`, but since our `main.tf` file has no resource confguration, you will see that there is no change needed:

```
juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform plan

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```


### 3.2 (Optional) Switch registration

At this point leaf and spine switches should be registered in the lab using Postman the day before.
Registration of switch is possible to be done using resource *aci_fabric_node_member*. Documentation of this resource is present in the official [Terraform Registry documentation](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/fabric_node_member){target=_blank}.
- In the Example Usage section you can find example code to register new node
- In the Argument Reference you will see possible arguments/parameters that can be used for switch registration with indication if argument is required or optional and additional information about it
- In the Attribute Reference you will see what is the attribute that this resource exports, and in case of ACI resources it will be always `id` set to the DN of the VLAN Pool.
- Importing describes how to import existing object to the terraform resource

For reference the following resource configuration in Terraform would register new switch.
If the switches are already registered, this task can be skipped

```
resource "aci_fabric_node_member" "Leaf-101" {
  name        = "Leaf-101"
  serial      = "TEP-1-101"
  node_id     = "101"
  pod_id      = "1"
  role        = "leaf"
}

resource "aci_fabric_node_member" "Leaf-102" {
  name        = "Leaf-102"
  serial      = "TEP-1-102"
  node_id     = "102"
  pod_id      = "1"
  role        = "leaf"
}

resource "aci_fabric_node_member" "Spine-103" {
  name        = "Spine-103"
  serial      = "TEP-1-103"
  node_id     = "103"
  pod_id      = "1"
  role        = "spine"
}

resource "aci_fabric_node_member" "Spine-104" {
  name        = "Spine-104"
  serial      = "TEP-1-104"
  node_id     = "104"
  pod_id      = "1"
  role        = "spine"
}
```


## 4 ACI Access Policies

Every ACI Fabric configuration starts with Access Polices. You need to define ACI objects which represent single physical port configurations. To remind relationships between objects, please check following figure.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/access-polices.png" width = 800>

Usually Interface Polices are configured once and re-used like LLDP, LACP, CDP, etc.
In our LAB some of the policies already exist from the day before and Postman configuration, so different names should be used for Terraform lab to create new objects. Following sections will help you to prepare your API requests.

For reference full configuration of access-policies can be found here: ==**[Terraform Tenant Ready](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/access-policies.tf){target=_blank}.**==

### 4.1 Interface Policies

You will configure LACP Policy, LLDP and speed policies. Let's separate our terraform files and create separate config file for out interface policies. Under your folder in Visual Studio create new file calles `interface-policies.tf`:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/visual-new-file.png" width = 800>

Copy each of the Policy resource definition to the new interface-policies.tf file

```json title="LACP_ACTIVE"
resource "aci_lacp_policy" "LACP_ACTIVE" {
  name        = "LACP_ACTIVE"
  ctrl        = ["susp-individual", "fast-sel-hot-stdby", "graceful-conv"]
  mode        = "active"
}
```

```json title="LLDP_ON"
resource "aci_lldp_interface_policy" "LLDP_ON" {
  name        = "LLDP_ON"
  admin_rx_st = "enabled"
  admin_tx_st = "enabled"
}
```

```json title="LINK-10G"
resource "aci_fabric_if_pol" "LINK-10G" {
  name        = "LINK-10G"
  auto_neg    = "on"
  speed       = "10G"
}
```

The documentation for each of the resources can be found in Terraform Registry:

[aci_lacp_policy resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/lacp_policy){target=_blank}

[aci_lldp_interface_policy resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/lldp_interface_policy){target=_blank}

[aci_fabric_if_pol resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/fabric_if_pol){target=_blank}

### 4.2 Run Terraform Plan & Apply

At this point we have our first three resources in the configuration so it's time to deploy them on our APIC. To do so we will follow the Terraform workload init -> plan -> apply. In previous step, after configuring ACI provider you should have already done `terraform init`, so it is **not** needed to run it again now, as it would not bring any change.

Our first step to deploy config is to run `terraform plan` command in the terminal window. The output will show us what changes Terraform needs to do on the fabric, to bring it to the required configuration. The output should look similar to the following:

```
juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform plan
aci_fabric_node_member.Leaf-102: Refreshing state... [id=uni/controller/nodeidentpol/nodep-TEP-1-102]
aci_fabric_node_member.Leaf-101: Refreshing state... [id=uni/controller/nodeidentpol/nodep-TEP-1-101]
aci_fabric_node_member.Spine-103: Refreshing state... [id=uni/controller/nodeidentpol/nodep-TEP-1-103]
aci_fabric_node_member.Spine-104: Refreshing state... [id=uni/controller/nodeidentpol/nodep-TEP-1-104]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aci_fabric_if_pol.auto-10G will be created
  + resource "aci_fabric_if_pol" "auto-10G" {
      + annotation    = "orchestrator:terraform"
      + auto_neg      = "on"
      + description   = (known after apply)
      + fec_mode      = (known after apply)
      + id            = (known after apply)
      + link_debounce = (known after apply)
      + name          = "LINK-10G"
      + name_alias    = (known after apply)
      + speed         = "10G"
    }

  # aci_lldp_interface_policy.LLDP_ON will be created
  + resource "aci_lldp_interface_policy" "LLDP_ON" {
      + admin_rx_st = "enabled"
      + admin_tx_st = "enabled"
      + annotation  = "orchestrator:terraform"
      + description = (known after apply)
      + id          = (known after apply)
      + name        = "LLDP_ON"
      + name_alias  = (known after apply)
    }

  # aci_lacp_policy.LACP_ACTIVE will be created
  + resource "aci_lacp_policy" "LACP_ACTIVE" {
      + annotation  = "orchestrator:terraform"
      + ctrl        = [
          + "susp-individual",
          + "fast-sel-hot-stdby",
          + "graceful-conv",
        ]
      + description = "done by terraform"
      + id          = (known after apply)
      + max_links   = (known after apply)
      + min_links   = (known after apply)
      + mode        = "active"
      + name        = "LACP_ACTIVE"
      + name_alias  = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

In the plan you can see all the *plus* signs beside the elements that are going to be added to the fabric. Terraform read the fabric state and compared with required configuration, and then decided which elements need to be added. At this point no configuration has been added yet to the fabric, Terraform only lists the changes it is planning to do.
As the Note says at the bottom, this plan was not saved to a file, but only displayed in the console. If you change command to `terraform plan -out interface-policies.plan`  you will see that a file was generated with the contents of the plan.

Now you can perform the `terraform apply` command. This command will run plan again, ask for approval and then it will go into the fabric and perform these actions.

```
<plan omitted>

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aci_lldp_interface_policy.LLDP_ON: Creating...
aci_fabric_if_pol.auto-10G: Creating...
aci_lacp_policy.LACP_ACTIVE: Creating...
aci_lldp_interface_policy.LLDP_ON: Creation complete after 0s [id=uni/infra/lldpIfP-LLDP_ON]
aci_fabric_if_pol.auto-10G: Creation complete after 0s [id=uni/infra/hintfpol-LINK-10G]
aci_lacp_policy.LACP_ACTIVE: Creation complete after 0s [id=uni/infra/lacplagp-LACP_ACTIVE]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

If you run plan command again now, you would see the output is different because now it will only show the changes it plans to do over the previous push. Since there are no changes in the config yet, the plan will not show anything new to be added:

```

juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform plan
aci_fabric_node_member.Spine-103: Refreshing state... [id=uni/controller/nodeidentpol/nodep-TEP-1-103]
aci_fabric_node_member.Leaf-102: Refreshing state... [id=uni/controller/nodeidentpol/nodep-TEP-1-102]
aci_lacp_policy.LACP_ACTIVE: Refreshing state... [id=uni/infra/lacplagp-LACP_ACTIVE]
aci_fabric_if_pol.auto-10G: Refreshing state... [id=uni/infra/hintfpol-LINK-10G]
aci_fabric_node_member.Spine-104: Refreshing state... [id=uni/controller/nodeidentpol/nodep-TEP-1-104]
aci_lldp_interface_policy.LLDP_ON: Refreshing state... [id=uni/infra/lldpIfP-LLDP_ON]
aci_fabric_node_member.Leaf-101: Refreshing state... [id=uni/controller/nodeidentpol/nodep-TEP-1-101]

No changes. Your infrastructure matches the configuration.
```

### 4.3 VLANs, Domains and AAEPs

Create VLAN pool with vlan-range, associate it with Physical Domain and AAEP. Let's put these policies in a separate, new file called `access-policies.tf`
We will create two VLAN pools, one for L2 Physical Domain, and second one for L3 Routed Domain. In the same way we will create two AEP, one for L2 connections and second one for L3 connections. Each AEP will map one domain:
- VLAN_POOL_L2 <-- PHYSDOM_1 <-- AEP_L2
- VLAN_POOL_L3 <-- EXTRTDOM_1 <-- AEP_L3

For VLAN pool there are two resources that need to be created: VLAN Pool and VLAN Range. In this case VLAN Range object is a child of VLAN Pool object, which means that the Range resource needs to have a reference to the VLAN Pool resource. This reference can be done in terraform by using the resource name followed by the attribute, in this case `id`.

```
resource "aci_vlan_pool" "VLAN_POOL_L2" {
  name  = "VLAN_POOL_STATIC"
  alloc_mode  = "static"
}

resource "aci_ranges" "RANGE_100-200" {
  vlan_pool_dn  = aci_vlan_pool.VLAN_POOL_L2.id
  from          = "vlan-100"
  to            = "vlan-200"
  alloc_mode    = "inherit"
}

resource "aci_vlan_pool" "VLAN_POOL_L3" {
  name  = "VLAN_POOL_STATIC"
  alloc_mode  = "static"
}

resource "aci_ranges" "RANGE_201-300" {
  vlan_pool_dn  = aci_vlan_pool.VLAN_POOL_L3.id
  from          = "vlan-201"
  to            = "vlan-300"
  alloc_mode    = "inherit"
}
```

Two domains, physical and routed, will be created as two resources, and each of them needs to have a reference to a VLAN Pool. This reference will be done by special attribute `relation_infra_rs_vlan_ns`, by referencing the resource name and id attribute:

```
resource "aci_physical_domain" "PHYSDOM_1" {
  name        = "PHYSDOM_1"
  relation_infra_rs_vlan_ns = aci_vlan_pool.VLAN_POOL_L2.id
}

resource "aci_l3_domain_profile" "EXTRTDOM_1" {
  name  = "EXTRTDOM_1"
  relation_infra_rs_vlan_ns = aci_vlan_pool.VLAN_POOL_L3.id
}
```

Two AAEP will be created, one for L2 connections and another one for L3 connections.
Between AAEP and Domains there is also relationship. AEP needs to be related to a domain. This relation can be done in two ways:

- separate resource `aci_aaep_to_domain` which is shown in the example below for AEP_L2 and PHYSDOM_1 relation. This resource needs to reference `id` values of both AEP and Physical Domain
- argument within `aci_attachable_access_entity_profile` called `relation_infra_rs_dom_p` which is shown in the example below for AEP_L3 and EXTRTDOM_1 relation. This argument needs to reference `id` values of both AEP and Routed Domain, but needs to be embedded in [] as the documentation says it's *Type -[Set of String]*

```
resource "aci_attachable_access_entity_profile" "AEP_L2" {
  description = "AAEP for L2 connections"
  name        = "AEP_L2"
}

resource "aci_aaep_to_domain" "AEP_L2_to_PHYSDOM_1" {
  attachable_access_entity_profile_dn = aci_attachable_access_entity_profile.AEP_L2.id
  domain_dn                           = aci_physical_domain.PHYSDOM_1.id
}

resource "aci_attachable_access_entity_profile" "AEP_L3" {
  description = "AAEP for L3 connections"
  name        = "AEP_L3"
  relation_infra_rs_dom_p = [aci_l3_domain_profile.EXTRTDOM_1.id]
}
```

Documentation of resources:

[aci_vlan_pool resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vlan_pool){target=_blank}

[aci_ranges resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/ranges){target=_blank}

[aci_physical_domain resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/physical_domain){target=_blank}

[aci_l3_domain_profile resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/l3_domain_profile){target=_blank}

[aci_attachable_access_entity_profile resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/attachable_access_entity_profile){target=_blank}

[aci_aaep_to_domain resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/aaep_to_domain){target=_blank}

### 4.4 Interface Policy group

Let's now create two Interface Policy Groups, one for server (L2) and another one for router (L3) and use all created policies:

- IntPolGrp_VPC_server1 VPC policy with AEP_L2
- IntPolGrp_Router1 access port policy with AEP_L3

Those interface policy groups will have relation to all the access policies we created before by referencing the `id` of those policies:

```
resource "aci_leaf_access_bundle_policy_group" "IntPolGrp_VPC_server1" {
  name        = "IntPolGrp_VPC_server1"
  lag_t       = "node"
  relation_infra_rs_lldp_if_pol = aci_lldp_interface_policy.LLDP_ON.id
  relation_infra_rs_lacp_pol = aci_lacp_policy.LACP_ACTIVE.id
  relation_infra_rs_h_if_pol    = aci_fabric_if_pol.LINK_10G.id
  relation_infra_rs_att_ent_p   = aci_attachable_access_entity_profile.AEP_L2.id
}

resource "aci_leaf_access_bundle_policy_group" "IntPolGrp_Router1" {
    name        = "IntPolGrp_Router1"
    lag_t       = "node"
    relation_infra_rs_lldp_if_pol = aci_lldp_interface_policy.LLDP_ON.id
    relation_infra_rs_lacp_pol = aci_lacp_policy.LACP_ACTIVE.id
    relation_infra_rs_h_if_pol    = aci_fabric_if_pol.LINK_10G.id
    relation_infra_rs_att_ent_p   = aci_attachable_access_entity_profile.AEP_L3.id
}
```

Documentation of resources:

[aci_leaf_access_bundle_policy_group resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_access_bundle_policy_group){target=_blank}

[aci_leaf_access_port_policy_group resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_access_port_policy_group){target=_blank}

### 4.5 Switch & Interface Profiles

Let's assign our created interface policy groups to the newly created switch and interface profiles. We will create:

- switch profile
- interface profile *IntProf-101-102* with two interface selectors
  - eth1/1 connecting server
  - eth1/2 connecting router

First we create interface profile within this profile two interface selectors. Interface selectors need to have reference to the Interface Profile (*IntProf-101-102*) and relation to the interface policy groups created for our end devices:

- *IntPolGrp_VPC_server1*
- *IntPolGrp_Router1*

```
resource "aci_leaf_interface_profile" "IntProf-101-102" {
    name        = "IntProf-101-102"
}

resource "aci_access_port_selector" "leaf-101-102-eth-1" {
    leaf_interface_profile_dn      = aci_leaf_interface_profile.IntProf-101-102.id
    name                           = "leaf-101-102-eth-1"
    access_port_selector_type      = "range"
    relation_infra_rs_acc_base_grp = aci_leaf_access_bundle_policy_group.IntPolGrp_VPC_server1.id
}

resource "aci_access_port_block" "leaf-101-102-eth-1-block" {
    access_port_selector_dn = aci_access_port_selector.leaf-101-102-eth-1.id
    name                    = "leaf-101-102-eth-1-block"
    from_card               = "1"
    from_port               = "1"
    to_card                 = "1"
    to_port                 = "1"
}

resource "aci_access_port_selector" "leaf-101-102-eth-2" {
    leaf_interface_profile_dn      = aci_leaf_interface_profile.IntProf-101-102.id
    name                           = "leaf-101-102-eth-2"
    access_port_selector_type      = "range"
    relation_infra_rs_acc_base_grp = aci_leaf_access_bundle_policy_group.IntPolGrp_Router1.id
}

resource "aci_access_port_block" "leaf-101-102-eth-2-block" {
    access_port_selector_dn = aci_access_port_selector.leaf-101-102-eth-2.id
    name                    = "leaf-101-102-eth-2-block"
    from_card               = "1"
    from_port               = "2"
    to_card                 = "1"
    to_port                 = "2"
}
```

Next we have our switch profile configuration which needs to have a reference to the leaf interface profile (*IntProf-101-102*) as well as mark the nodes which will be used in this switch profile (nodes 101 & 102)
```
resource "aci_leaf_profile" "SwProf-101-102" {
    name                         = "SwProf-101-102"
    relation_infra_rs_acc_port_p = [aci_leaf_interface_profile.IntProf-101-102.id]
}

resource "aci_leaf_selector" "Sel-101-102" {
    leaf_profile_dn         = aci_leaf_profile.SwProf-101-102.id
    name                    = "Sel-101-102"
    switch_association_type = "range"
}

resource "aci_node_block" "Sel-101-102-Block" {
    switch_association_dn = aci_leaf_selector.Sel-101-102.id
    name                  = "Sel-101-102-Block"
    from_                 = "101"
    to_                   = "102"
}
```

## 5 ACI Tenant

Upon now you created ACI AccessPolicies for your Tenant.
Now is time to create your tenant using Terraform. It will be simple Tenant definition with one VRF, one bridge domains associated with one EPG and one L3out. EPG will be associated with L2 domain and statically binded to VPC created, with VLAN from L2 VLAN pool done by you perviously. The L3out will be associated to L3 domain and router interface, with VLAN from L3 VLAN pool.

Figure below shows our Logical Tenant.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/terraform-tenant-dcloud-1.png" width = 800>

You need to define Tenant, VRF, Bridge-Domain, Application-Profile, EPG with Domain association, static binding under EPG and L3out. Quite many of resources to do in Terraform. We will define all of them in a single, new config file called dcloud-tenant-1.tf
Please, download a terraform file from ==**[Terraform Tenant Ready](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/dcloud-tenant-1.tf){target=_blank}.**==

### 5.1 Tenant components

This section contains Terraform codes necessary to create Tenant objects

### 5.1.1 Tenant and VRF

Following code can be used to create new Tenant and VRFs. The VRF resource needs to reference its parent object - tenant id.

```
resource "aci_tenant" "dcloud-tenant-1" {
  name             = "dcloud-tenant-1"
}

resource "aci_vrf" "vrf1" {
  tenant_dn         = aci_tenant.dcloud-tenant-1.id
  name              = "vrf1"
}
```

### 5.1.2 BD in existing tenant

Following code can be used to create new Bridge Domain in existing Tenant. Bridge Domain needs to have a reference to parent objects: tenant ID and VRF ID. There is also a child object of bridge domain which is a Subnet with reference to bridge domain ID.

```

resource "aci_bridge_domain" "bd-network-1" {
    tenant_dn             = aci_tenant.dcloud-tenant-1.id
    relation_fv_rs_ctx    = aci_vrf.vrf1.id
    name                  = "bd-network-1"
}

resource "aci_subnet" "subnet-1" {
    parent_dn            = aci_bridge_domain.bd-network-1.id
    ip                   = "10.0.0.1/24"
    scope                = ["public"]
}
```


### 5.1.3 Application Profile with EPG and static bindings

Following code can be used to create new Application Profile with EPG. Application Profile needs a reference to parent object tenant ID, while EPG needs reference to AP ID ad Bridge Domain ID. The next two resources reflect the physical domain PHYSDOM_1 attached to that EPG, and one static binding towards our server1 with encapsulation of vlan 100.

```

resource "aci_application_profile" "ap1" {
  tenant_dn  = aci_tenant.dcloud-tenant-1.id
  name       = "ap1"
}

resource "aci_application_epg" "epg1" {
    application_profile_dn  = aci_application_profile.ap1.id
    name                    = "epg1"
    relation_fv_rs_bd       = aci_bridge_domain.bd-network-1.id
}

resource "aci_epg_to_domain" "epg1-to-physdom_1" {
    application_epg_dn = aci_application_epg.epg1.id
    tdn = aci_physical_domain.PHYSDOM_1.id
    }

resource "aci_epg_to_static_path" "static-binding-1" {
  application_epg_dn  = aci_application_epg.epg1.id
  tdn  = "topology/pod-1/protpaths-101-102/pathep-[IntPolGrp_VPC_server1]"
  encap  = "vlan-100"
  mode  = "regular"
}
```

### 5.1.4 L3Out

Following code can be used to create new L3out. As you can see there are plenty of resources which reflect node profile and node mapping, interface profile and path used for it, external EPG with subnet.

```

resource "aci_l3_outside" "l3out-1" {
        tenant_dn      = aci_tenant.dcloud-tenant-1.id
        name           = "l3out-1"
        relation_l3ext_rs_l3_dom_att = aci_l3_domain_profile.EXTRTDOM_1.id
        relation_l3ext_rs_ectx = aci_vrf.vrf1.id
    }

resource "aci_logical_node_profile" "np-101-102" {
        l3_outside_dn = aci_l3_outside.l3out-1.id
        name          = "np-101-102"
      }

resource "aci_logical_node_to_fabric_node" "np-101-102-to-node-101" {
  logical_node_profile_dn  = aci_logical_node_profile.np-101-102.id
  tdn               = "topology/pod-1/node-101"
  rtr_id            = "1.1.1.1"
}

resource "aci_logical_node_to_fabric_node" "np-101-102-to-node-102" {
  logical_node_profile_dn  = aci_logical_node_profile.np-101-102.id
  tdn               = "topology/pod-1/node-102"
  rtr_id            = "1.1.1.2"
}

resource "aci_logical_interface_profile" "ip-101-102" {
        logical_node_profile_dn = aci_logical_node_profile.np-101-102.id
        name                    = "ip-101-102"
  }

resource "aci_l3out_path_attachment" "l3ip-path" {
  logical_interface_profile_dn  = aci_logical_interface_profile.ip-101-102.id
  target_dn  = "topology/pod-1/protpaths-101-102/pathep-[IntPolGrp_Router1]"
  if_inst_t = "ext-svi"
  addr  = "10.1.1.1/24"
  encap  = "vlan-201"
  encap_scope = "ctx"
  mode = "regular"
  mtu = "inherit"
}

resource "aci_external_network_instance_profile" "extepg" {
  l3_outside_dn  = aci_l3_outside.l3out-1.id
  name           = "extepg"
}

resource "aci_l3_ext_subnet" "extepg-subnet" {
  external_network_instance_profile_dn  = aci_external_network_instance_profile.extepg.id
  ip                                    = "0.0.0.0/0"
  scope                                 = ["import-security","export-rtctrl"]
}
```


Documentation of resources:

[aci_tenant resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tenant){target=_blank}

[aci_bridge_domain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/bridge_domain){target=_blank}

[aci_subnet resource](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/subnet){target=_blank}

[aci_application_profile](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/application_profile){target=_blank}

[aci_application_epg](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/application_epg){target=_blank}

[aci_epg_to_domain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/epg_to_domain){target=_blank}

[aci_l3_outside](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/l3_outside){target=_blank}
