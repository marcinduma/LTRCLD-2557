# Terraform Language

As you can see in the previous lab, manually specifying each resource and its values is very time consuming. In this lab you will learn how to use variables and functions to simplify the work

## 1. Variable file

Variable declarations can appear anywhere in your configuration files. However, it is recommended putting them into a separate file called variables.tf to make it easier for users to understand how the configuration is meant to be customized.

To parameterize an argument with an input variable, you will first define the variable in `variables.tf`, then replace the hardcoded value with a reference to that variable in your configuration.

Variable blocks have three optional arguments.

- **Description**: A short description to document the purpose of the variable.
- **Type**: The type of data contained in the variable.
- **Default**: The default value.

If you do not set a default value for a variable, you must assign a value before Terraform can apply the configuration. Terraform does not support unassigned variables.

When variables are declared in the root folder of your configuration, they can be set in a number of ways:

- In a Terraform Cloud workspace.
- Individually, with the -var command line option.
- In variable definitions (.tfvars) files, either specified on the command line or automatically loaded.
- As environment variables.

### 1.1 Variables definition

Let's create in our folder new file called `variables.tf`. In this file let's define several variables that we will use to deploy new tenant.

Following variables will be used as a name for new tenant, VRF and bridge domain. Those variables have only a default value defined which will be used if no other value is specified for execution.

```
variable "tenant_name" {
  default = "dcloud-tenant-2"
}

variable "vrf_name" {
  default = "vrf2-1"
}

variable "bd_name" {
  default = "bd2-1"
}
```

The next variable is used for specifying the ARP flooding behaviour of a bridge domain. Here you can see that we are using all possible options:

- description of variable
- default value to be used if no other is specfied
- validation mechanism with:

    - condition - variable can be set to either "yes" or "no" value
    - error message to be displayed if specified value doesn't pass the validation test

```
variable "bd_arp_flood" {
  description = "Specify whether ARP flooding is enabled. If flooding is disabled, unicast routing will be performed on the target IP address."
  default = "yes"
  validation {
    condition = (var.bd_arp_flood == "yes") || (var.bd_arp_flood == "no")
    error_message = "Allowed values are \"yes\" and \"no\"."
  }
}
```

The last two variables will be specifying bridge domain behaviour for unicast routing and unknown unicast flooding:

```
variable "bd_unicast_routing" {
  default = "yes"
}

variable "bd_unk_ucast" {
  default = "proxy"
}
```

### 1.2 Variable usage in config

Now let's use the variables we defined to create new tenant. For this task please create new config file called `dcloud-tenant-2.tf`. We will use it to deploy new tenant called *dcloud-tenant-2* with one VRF and bridge domain.

The way we make references to our variables is by using *var.<variable name>* inside our config file. the *var.* part of this syntax indicates that we are using variables.

```
resource "aci_tenant" "dcloud-tenant-2" {
  name        = var.tenant_name
  description = "This is a new tenant created from Terraform"
}

resource "aci_vrf" "vrf2-1" {
  tenant_dn              = aci_tenant.dcloud-tenant-2.id
  name                   = var.vrf_name
}

resource "aci_bridge_domain" "bd_192_168_1_0" {
  tenant_dn                   = aci_tenant.dcloud-tenant-2.id
  name                        = var.bd_name
  arp_flood                   = var.bd_arp_flood
  unicast_route               = var.bd_unicast_routing
  unk_mac_ucast_act           = var.bd_unk_ucast
  unk_mcast_act               = "flood"
  relation_fv_rs_ctx          = aci_vrf.vrf2-1.id
}
```

In our `variables.tf` all our variables have default value assigned, which means we should be able to apply this configuration and deploy new tenant.
Let's run `terraform apply` and verify on APIC that all the objects have been deployed according to the specified variables.

```
juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform apply

<omitted>

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aci_bridge_domain.bd_192_168_1_0 will be created
  + resource "aci_bridge_domain" "bd_192_168_1_0" {
      + annotation                  = "orchestrator:terraform"
      + arp_flood                   = "yes"
      + bridge_domain_type          = (known after apply)
      + description                 = (known after apply)
      + ep_clear                    = (known after apply)
      + ep_move_detect_mode         = (known after apply)
      + host_based_routing          = (known after apply)
      + id                          = (known after apply)
      + intersite_bum_traffic_allow = (known after apply)
      + intersite_l2_stretch        = (known after apply)
      + ip_learning                 = (known after apply)
      + ipv6_mcast_allow            = (known after apply)
      + limit_ip_learn_to_subnets   = (known after apply)
      + ll_addr                     = (known after apply)
      + mac                         = (known after apply)
      + mcast_allow                 = (known after apply)
      + multi_dst_pkt_act           = (known after apply)
      + name                        = "bd2-1"
      + name_alias                  = (known after apply)
      + optimize_wan_bandwidth      = (known after apply)
      + relation_fv_rs_bd_to_ep_ret = (known after apply)
      + relation_fv_rs_bd_to_nd_p   = (known after apply)
      + relation_fv_rs_ctx          = (known after apply)
      + relation_fv_rs_igmpsn       = (known after apply)
      + relation_fv_rs_mldsn        = (known after apply)
      + tenant_dn                   = (known after apply)
      + unicast_route               = "yes"
      + unk_mac_ucast_act           = "proxy"
      + unk_mcast_act               = "flood"
      + v6unk_mcast_act             = (known after apply)
      + vmac                        = (known after apply)
    }

  # aci_tenant.dcloud-tenant-2 will be created
  + resource "aci_tenant" "dcloud-tenant-2" {
      + annotation                    = "orchestrator:terraform"
      + description                   = "This is a new tenant created from Terraform"
      + id                            = (known after apply)
      + name                          = "dcloud-tenant-2"
      + name_alias                    = (known after apply)
      + relation_fv_rs_tenant_mon_pol = (known after apply)
    }

  # aci_vrf.vrf2-1 will be created
  + resource "aci_vrf" "vrf2-1" {
      + annotation                              = "orchestrator:terraform"
      + bd_enforced_enable                      = (known after apply)
      + description                             = (known after apply)
      + id                                      = (known after apply)
      + ip_data_plane_learning                  = (known after apply)
      + knw_mcast_act                           = (known after apply)
      + name                                    = "vrf2-1"
      + name_alias                              = (known after apply)
      + pc_enf_dir                              = (known after apply)
      + pc_enf_pref                             = (known after apply)
      + relation_fv_rs_bgp_ctx_pol              = (known after apply)
      + relation_fv_rs_ctx_to_ep_ret            = (known after apply)
      + relation_fv_rs_ctx_to_ext_route_tag_pol = (known after apply)
      + relation_fv_rs_ospf_ctx_pol             = (known after apply)
      + relation_fv_rs_vrf_validation_pol       = (known after apply)
      + tenant_dn                               = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aci_tenant.dcloud-tenant-2: Creating...
aci_tenant.dcloud-tenant-2: Creation complete after 1s [id=uni/tn-dcloud-tenant-2]
aci_vrf.vrf2-1: Creating...
aci_vrf.vrf2-1: Creation complete after 1s [id=uni/tn-dcloud-tenant-2/ctx-vrf2-1]
aci_bridge_domain.bd_192_168_1_0: Creating...
aci_bridge_domain.bd_192_168_1_0: Creation complete after 2s [id=uni/tn-dcloud-tenant-2/BD-bd2-1]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

### 1.3 Provide variable value

#### 1.3.1 Manual variable values

Now let's see how else we can provide variable values. In this case first let's modify our `variables.tf` file and add new variable called `bd_name_2` which will have no default value and new variable `bd_arp_flood_2` which will also have no default value.
This way with no default value, Terraform will be forced to ask user to specify it manually during execution:

!!!Note
    We are not removing default value from existing `bd_name` or `bd_arp_flood` variables, as it would force terraform to change it on the existing bridge domain. We are adding new variables to show the difference between them

```
variable "bd_arp_flood_2" {
  description = "Specify whether ARP flooding is enabled. If flooding is disabled, unicast routing will be performed on the target IP address."
  validation {
    condition = (var.bd_arp_flood_2 == "yes") || (var.bd_arp_flood_2 == "no")
    error_message = "Allowed values are \"yes\" and \"no\"."
  }
}

variable "bd_name_2" {
}

```

Let's also add another bridge domain resource where we will verify our manual values. Add following block to the *dcloud-tenant-2.tf* file. Here we are only giving new name to the resource so that Terraform is aware that this is a new resource to be deployed.

```
resource "aci_bridge_domain" "bd_192_168_2_0" {
  tenant_dn                   = aci_tenant.dcloud-tenant-2.id
  name                        = var.bd_name_2
  arp_flood                   = var.bd_arp_flood_2
  unicast_route               = var.bd_unicast_routing
  unk_mac_ucast_act           = var.bd_unk_ucast
  unk_mcast_act               = "flood"
  relation_fv_rs_ctx          = aci_vrf.vrf2-1.id
}
```

Now if we run `terraform plan` we will be asked to specify both values that don't have a default value in the variables file. Let's specify them, but at the same time test if our validation rule works. Please specify *bd2* as `bd_name_2` and *enable* as `bd_arp_flood_2`

```
juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform plan
var.bd_arp_flood_2
  Specify whether ARP flooding is enabled. If flooding is disabled, unicast routing will be performed on the target IP address.

  Enter a value: enable

var.bd_name_2
  Enter a value: bd2

<omitted>


│ Error: Invalid value for variable
│
│   on variables.tf line 31:
│   31: variable "bd_arp_flood_2" {
│     ├────────────────
│     │ var.bd_arp_flood_2 is "enable"
│
│ Allowed values are "yes" and "no".
│
│ This was checked by the validation rule at variables.tf:33,3-13.
╵
```

In this case Terraform will stop the plan and report incorrect value provided for *bd_arp_flood_2*

If we then specify `yes` to *bd_arp_flood* and `bd2` for *bd_name* we will see that the plan generated output showing us what would be deployed in the APIC:

```
juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform plan
var.bd_arp_flood_2
  Specify whether ARP flooding is enabled. If flooding is disabled, unicast routing will be performed on the target IP address.

  Enter a value: yes

var.bd_name_2
  Enter a value: bd2
```

```

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aci_bridge_domain.bd_192_168_2_0 will be created
  + resource "aci_bridge_domain" "bd_192_168_2_0" {
      + annotation                  = "orchestrator:terraform"
      + arp_flood                   = "yes"
      + bridge_domain_type          = (known after apply)
      + description                 = (known after apply)
      + ep_clear                    = (known after apply)
      + ep_move_detect_mode         = (known after apply)
      + host_based_routing          = (known after apply)
      + id                          = (known after apply)
      + intersite_bum_traffic_allow = (known after apply)
      + intersite_l2_stretch        = (known after apply)
      + ip_learning                 = (known after apply)
      + ipv6_mcast_allow            = (known after apply)
      + limit_ip_learn_to_subnets   = (known after apply)
      + ll_addr                     = (known after apply)
      + mac                         = (known after apply)
      + mcast_allow                 = (known after apply)
      + multi_dst_pkt_act           = (known after apply)
      + name                        = "bd2"
      + name_alias                  = (known after apply)
      + optimize_wan_bandwidth      = (known after apply)
      + relation_fv_rs_bd_to_ep_ret = (known after apply)
      + relation_fv_rs_bd_to_nd_p   = (known after apply)
      + relation_fv_rs_ctx          = "uni/tn-dcloud-tenant-2/ctx-vrf2-1"
      + relation_fv_rs_igmpsn       = (known after apply)
      + relation_fv_rs_mldsn        = (known after apply)
      + tenant_dn                   = "uni/tn-dcloud-tenant-2"
      + unicast_route               = "yes"
      + unk_mac_ucast_act           = "proxy"
      + unk_mcast_act               = "flood"
      + v6unk_mcast_act             = (known after apply)
      + vmac                        = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

Let's run `terraform apply` to see that this bridge domain would be deployed.

#### 1.3.2. The .tfvars file

Manual method of providing values for our variables can be quite absorbing and prone to humar errors. Another, preferred way would be to include all our variable values into separate file called *.tfvars. Please create new file calle `terraform.tfvars`. Variable values in such file can be defined in a simple way:

```
tenant_name = "dcloud-tenant-2"
vrf_name = "vrf2-1"
bd_name_2 = "bd2"
bd_arp_flood_2 = "no"
bd_unicast_routing = "no"
bd_unk_ucast = "proxy"
```

To each variable name we assign our preferred value. If you take a look closely you will see that for `bd_arp_flood_2` and `bd_unicast_routing` we specify different values that we did for our `bd2` bridge domain. If we run our `terraform apply` command now, we will see that terraform wants to do changes on our resource:

```
<omitted>

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aci_bridge_domain.bd_192_168_1_0 will be updated in-place
  ~ resource "aci_bridge_domain" "bd_192_168_1_0" {
        id                          = "uni/tn-dcloud-tenant-2/BD-bd2-1"
        name                        = "bd2-1"
      ~ unicast_route               = "yes" -> "no"
        # (22 unchanged attributes hidden)
    }

  # aci_bridge_domain.bd_192_168_2_0 will be updated in-place
  ~ resource "aci_bridge_domain" "bd_192_168_2_0" {
      ~ arp_flood                   = "yes" -> "no"
        id                          = "uni/tn-dcloud-tenant-2/BD-bd2"
        name                        = "bd2"
      ~ unicast_route               = "yes" -> "no"
        # (21 unchanged attributes hidden)
    }

Plan: 0 to add, 2 to change, 0 to destroy.
```

If we execute our command, Terraform will change the configuration on the APIC. Please verify in the GUI that these changes really reflect the configuration.

## 2. For_each loop

This way of specifying variables and creating configuration is good if we want to deploy single object, however in case we have multiple bridge domains to deploy it may not be the most efficient way.
By default a resource block configures one real infrastructure object. However, sometimes you want to manage several similar obejcts (like several bridge domains) without writing separate block for each one. Terraform has two ways to do this:

- count
- for_each

The `count` argument takes a value of a whole number and Terraform will simply create that many instances of an object. This will not help us much with ACI, as every of these objects would have the same configuration. We want to have option to create multiple bridge domains, which may have different config options.

The `for_each` argument can be included in a resource block, and its value is a map or set of strings. Terraform will create one instance for each member of that map or set. For this exercise we will work with maps that will include our bridge domains configuration.

The map has an index value for each object instance. This index is used by terraform to reference resources and to get values we need from it to create objects.

In our example let's create new folder for our workspace and call it `ACI-2`. Inside this folder create three files that we will use:

- main.tf - which will hold our provider configuration and resource that will be deployed (tenant, vrf, bridge domains and subents)
- variables.tf - which will have definition of variables we will use, including their types and default values
- terraform.tfvars - which we will use to specify our desired values and confiuration of bridge domains

Inside `variables.tf` file paste the following content:

```

variable "tenant_name" {
  default = "demo_tn"
}

variable "vrf_name" {
  default = "vrf1"
}

variable "bridge_domains" {
  type = map(object({
    name = string
    arp_flood = string
    unicast_routing = string
    unk_ucast = string
    subnet = string
    subnet_scope = list(string)
  }))
  default = {
    default_bd = {
      name = "default"
      arp_flood = "yes"
      unicast_routing = "yes"
      unk_ucast = "proxy"
      subnet = "10.10.10.1/24"
      subnet_scope = ["private"]
    }
  }
}
```

In this file we can see that we are defining three variables: tenant_name, vrf_name and bridge_domains. The bridge_domains variable is the interesting one, and it has type map of objects. One object will represent single bridge domain and its configuration. As part of this object we have our standard values to configure a BD like name, ARP flooding, unicast routing and unknown unicast flooding behaviour, but also subnet and subnet scope. Inside this variable first we define for those arguments what type they should take (string value for most of them and list of strings for subnet_scope). Then we specify default value that our map would take, in case we don't provide any values ourselves (inside `terraform.tfvars` file).

Now we want to provide the values we want to use in the `terraform.tffvars` file, please paste following content:

```
tenant_name = "dcloud-tenant-3"
vrf_name = "vrf1"
bridge_domains = {
    bd01 = {
        name = "192.168.1.0_24_bd"
        arp_flood = "no"
        unicast_routing = "yes"
        unk_ucast = "proxy"
        subnet = "192.168.1.1/24"
        subnet_scope = ["private"]
    },
    bd02 = {
        name = "192.168.2.0_24_bd"
        arp_flood = "yes"
        unicast_routing = "yes"
        unk_ucast = "proxy"
        subnet = "192.168.2.1/24"
        subnet_scope = ["private","shared"]
    }
}
```

Inside this file we specify our tenant and vrf name we want to use, and then we specify bridge domains map, which includes two bridge domains:

- bd01 of name 192.168.1.0_24_bd
- bd02 of name 192.168.2.0_24_bd

That means our map has two objects. Each object is a key and value pair, where:

- first object key is `bd01` and value is all the arguments we specify for it, including name, arp_flood, subnet etc
- second object key is `bd02` and value is all the arguments we specify for it, including name, arp_flood, subnet etc

You can see that our bridge domains differ in configuration of parameters. We have different names, arp flooding and subnet with scope.

Now, since we are doing this demo in separate folder `ACI-2`, we will have to initialize Terraform again and treat it as a separate deployment. For this reason inside the `main.tf` file we have to paste first our ACI provider configuration:

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

!!!Note
    Please remmeber in the terminal to change path to the right folder with `cd` command.

Below that we will start describing our resources. We want to create four resources: tenant, vrf, bridge domain and subnet.

```

resource "aci_tenant" "dcloud-tenant-3" {
  name        = "${var.tenant_name}"
  description = "This is a demo tenant created from Terraform"
}

resource "aci_vrf" "main" {
  tenant_dn              = aci_tenant.dcloud-tenant-3.id
  name                   = var.vrf_name
}

resource "aci_bridge_domain" "bd" {
  for_each = var.bridge_domains

  tenant_dn                   = aci_tenant.dcloud-tenant-3.id
  name                        = each.value.name
  arp_flood                   = each.value.arp_flood
  unicast_route               = each.value.unicast_routing
  unk_mac_ucast_act           = each.value.unk_ucast
  unk_mcast_act               = "flood"
  relation_fv_rs_ctx          = aci_vrf.main.id
}

resource "aci_subnet" "subnets" {
    for_each             = var.bridge_domains

    parent_dn            = aci_bridge_domain.bd[each.key].id
    ip                   = each.value.subnet
    scope                = each.value.subnet_scope
}
```

The tenant and VRF resources are configured in a similar way as in previous demo, so they don't need description. They use standard references to variables we provided in the file.
The interesting part is with the bridge_domain and subnet. In here we can see that each of these resources start with a special line

    for_each = var.bridge_domains

This indicates that we want to create this resource once for every object in our variable called `bridge_domains`. In our `terraform.tfvars` we declared this variable to include two different bridge_domains, so we expect that this resource will be created twice. Each resource will be unique by the map key.
In resource blocks where `for_each` is set, an additional `each` object is available in expressions, so you can modify the configuration of each instance. This object has two attributes:

- `each.key` - the map key corresponding to this instance
- `each.value` - the map value corresponding to this instance.

In our resource block for bridge domain and subnet we can see that we are referring to arguments with `each.value.<argumnet>` or `each.key`, as an example:

    name = each.value.name

We can also see that for the relation that needs to happen between bd and subnet we specify parent_dn with following expression using `each.key`:

    parent_dn = aci_bridge_domain.bd[each.key].id

If we now run `terraform plan` and `apply` we will see that two bridge domains have been created according to our settings.

Let's expand our tenant configuration by adding several EPGs, which we will create in the same way using `for_each` expression.
First we need to define new variable corresponding to an EPG, it will take values of *name* and *bridge domain*:

```
variable "end_point_groups" {
  type = map(object({
    name = string
    bd = string
  }))
}
```

Next we specify desired configuration of our EPGs in `terraform.tfvars` file:

```
end_point_groups = {
    epg1 = {
        name = "epg1",
        bd   = "bd01"
    },
    epg2 = {
        name = "epg2",
        bd   = "bd02"
    }
}
```

Finally we add resource configuration in `main.tf` file:

```
resource "aci_application_profile" "ap1" {
  tenant_dn  = aci_tenant.dcloud-tenant-3.id
  name       = "ap1"
}

resource "aci_application_epg" "epg" {
    for_each                = var.end_point_groups

    application_profile_dn  = aci_application_profile.ap1.id
    name                    = each.value.name
    relation_fv_rs_bd       = aci_bridge_domain.bd[each.value.bd].id
}
```

You can see that endpoint groups also use the `for_each` function and create relation to a bridge domain that we specified.
If you run `apply` now you will see additional AP and 2xEPG created. You can try adding new EPGs to the `terraform.tfvars` map of endpoint groups, to see that now it is easier to add new EPGs.

## 3. Conditionals and for expression

A conditional expression uses the value of a boolean expression to select one of two values.
The condition can be any expression that resolves to a boolean value. This will usually be an expression that uses the equality, comparison, or logical operators.

In our case we will use it to configure several parameters only *under condition* that other parameters are configured to a sprecific value. As an example let's take bridge domain configuration. On a high level there are two types of bridge domains we configure in ACI: L2 and L3. For L3 bridge domain we need to set unicast routing option to true, flooding arguments need to be adjusted, and subnet IP should be configured. For L2 bridge domains those parameters are not needed and BD should work in a flooding mode with no IP address.
To specify that kind of configuration we can use conditionals in Terraform resource block.

Please create new folder `ACI-3` that we will use for this test, and under this folder three files:

- `main.tf` and paste the ACI provider configuration
- `variables.tf` which we will use to define variables type
- `terraform.tfvars` which we will use to specify our desired configuration

Our `variables.tf` file will include following variabels:

```

variable "tenant_name" {
  default = "dcloud-tenant-4"
}

variable "vrf_name" {
  default = "vrf1"
}

variable "bridge_domains" {
  type = map(object({
    name = string
    arp_flood = string
    type = string
    gateway = string
    scope = list(string)
  }))
  default = {
    default_bd = {
      name = "default"
      arp_flood = "yes"
      type = "L3"
      gateway = "192.168.1.1/24"
      scope = ["private"]
    }
  }
}
```

In this example our bridge domains are configured with type (L2 or L3), name, ARP flooding mechanism, gateway (IP address) and its scope. We no longer define unicast routing and unknown unicast flooding mechanism. We want to set them based on the type of bridge domain we specify.

Our `terraform.tfvar` file will have our desired config of bridge domains:

```
bridge_domains = {
    bd01 = {
        name = "192.168.1.0_24_bd"
        arp_flood = "yes"
        type = "L3"
        gateway = "192.168.1.1/24"
        scope = ["private"]
    },
    bd02 = {
        name = "192.168.2.0_24_bd"
        arp_flood = "yes"
        type = "L2"
        gateway = null
        scope = null
    }
}
```

One of the bridge domains is L3 and has IP address, while the second one is L2 and has no IP address.
Inside `main.tf` we specify our resources configuration:

```
resource "aci_tenant" "tenant" {
  name        = "${var.tenant_name}"
}

resource "aci_vrf" "vrf" {
  tenant_dn              = aci_tenant.tenant.id
  name                   = var.vrf_name
}

resource "aci_bridge_domain" "bd" {
  for_each = var.bridge_domains

  tenant_dn                   = aci_tenant.tenant.id
  name                        = each.value.name
  arp_flood                   = each.value.arp_flood
  unicast_route               = each.value.type == "L3" ? "yes" : "no"
  unk_mac_ucast_act           = each.value.type == "L3" ? "proxy" : "flood"
  unk_mcast_act               = "flood"
  relation_fv_rs_ctx          = aci_vrf.vrf.id
}


```

We are again using `for_each` loop to create multiple resources for our bridge domains and we assign values like tenant_dn, name, VRF and ARP_flooding in the same way as before, by refering the `each.value.<argument name>`.
The difference is with assigning values for unicast routing and unknown unicast flooding mechanism. For these values we use conditional expression:

    unicast_route               = each.value.type == "L3" ? "yes" : "no"

This expression takes `each.value.type` of our object and verifies if the content of this type is ``"L3"``. "?" symbol specified that we are checking this condition:

- if condition is `true` the result is that `unicast_route` argument will be assigned `"yes"` value
- if condition is `false` the result is that `unicast_route` argument will be assigned `"no"` value

In the same way we can read the second line for unknown unicast flooding verifying condition that `each.value.type` is ``"L3"``:

- if condition is `true` the result is that `unk_mac_ucast_act` argument will be assigned `"proxy"` value
- if condition is `false` the result is that `unk_mac_ucast_act` argument will be assigned `"flood"` value

If we run our `terraform init`, `plan` and `apply` commands now, you will get two bridge domains configured with different settings based on the conditional expression. You can verify configuration in the APIC GUI.

!!!Note
    Remember to change to the correct folder in the Terminal

Second thing we want to do is to create subnet resource, that will reflect our bridge domain IP address, but we want to do it only for L3 bridge domains. L2 BD doesn't require subnet to be configured and shouldn't have it at all. There would be no reason to deploy subnet resource for L2 bridge domain.
If we simply use the `for_each` expression, we would deploy subnet for all bridge domains we specify in our map, but we want to verify a condition expression here too. This can be done with a `for` expression.

A `for` expression creates a complex type value by transforming another complex type value. Each element in the input value can correspond to either one or zero values in the result, and an arbitrary expression can be used to transform each input element into an output element.
We want to use the `for` expression to modify our `for_each` block:

```

resource "aci_subnet" "net" {
  for_each = { for k, v in var.bridge_domains: k => v if v.type == "L3" }

  parent_dn        = aci_bridge_domain.bd[each.key].id
  ip               = each.value.gateway
  scope            = each.value.scope
}
```

In this example we added the expression to the `for_each` block. This `for` loop is supposed to go iterate over every `k` (key) and `v` (value) pair in our map called `var.bridge_domains` and return those key and value pair only if the condition that "type" is set to "L3" is true. In reality `for` expression is returning (creating) new map variable that will consist only of key and value pairs of elements that pass our condition.
If we wanted to take a look at those values, we would have our bridge_domains map that we declared:

```
bridge_domains = {
    bd01 = {
        name = "192.168.1.0_24_bd"
        arp_flood = "yes"
        type = "L3"
        gateway = "192.168.1.1/24"
        scope = ["private"]
    },
    bd02 = {
        name = "192.168.2.0_24_bd"
        arp_flood = "yes"
        type = "L2"
        gateway = null
        scope = null
    }
}
```

The new map variable created by `for` expression inside resource block would look like this:

```
{
  bd01 = {
      name = "192.168.1.0_24_bd"
      arp_flood = "yes"
      type = "L3"
      gateway = "192.168.1.1/24"
      scope = ["private"]
  }
}
```

The second bd02 is not included in this temporary variable as it does not meet the condition.

The `for_each` loop can now loop over this map, which only contains one object (one key, value pair) and inside the resource we refer to this object in the same way as we would normally use, with `eack.key` and `each.value` arguments:

```
parent_dn        = aci_bridge_domain.bd[each.key].id
ip               = each.value.gateway
scope            = each.value.scope
```

If you run `terraform plan` and `apply` now, you will see that only one `aci_subnet` resource is being created for "bd01".


## 4. Data sources

Terraform data sources let you dynamically fetch data from APIs or other Terraform state backends. This allows to fetch data from APIC that was already created, and this data source is always read-only. We can use it to read objects in ACI that were already created before either manually or by default like a common tenant in ACI. Those data sources can then be used to create relations with different resources that we want to deploy.
Data sources have separate documentation in the Terraform Registry
As an example we will try to deploy new bridge domain with VRF that will be placed in the common tenant. In ACI from day-0 there is *common* tenant deployed with *default* VRF. We will reference it for our new bridge domain. First we have to create two data sources that will reflect our tenant and VRF:

```
data "aci_tenant" "common-tenant" {
    name = "common"
}
data "aci_vrf" "common-vrf" {
    tenant_dn   = data.aci_tenant.common-tenant.id
    name        = "default"
}
```

Then we can start using references inside our new bridge domain:

```
resource "aci_bridge_domain" "bd-common" {
  tenant_dn                   = aci_tenant.tenant.id
  name                        = "bd-common"
  arp_flood                   = "yes"
  unicast_route               = "no"
  unk_mac_ucast_act           = "flood"
  unk_mcast_act               = "flood"
  relation_fv_rs_ctx          = data.aci_vrf.common-vrf.id
}
```

The difference in a way we make references to data sources, instead of normal resource, is by adding `data.` before the data source name.
If we run `terraform plan` and `apply` now, we will see that Terraform tries to create new bridge domain:

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aci_bridge_domain.bd-common will be created
  + resource "aci_bridge_domain" "bd-common" {
      + annotation                  = "orchestrator:terraform"
      + arp_flood                   = "yes"
      + bridge_domain_type          = (known after apply)
      + description                 = (known after apply)
      + ep_clear                    = (known after apply)
      + ep_move_detect_mode         = (known after apply)
      + host_based_routing          = (known after apply)
      + id                          = (known after apply)
      + intersite_bum_traffic_allow = (known after apply)
      + intersite_l2_stretch        = (known after apply)
      + ip_learning                 = (known after apply)
      + ipv6_mcast_allow            = (known after apply)
      + limit_ip_learn_to_subnets   = (known after apply)
      + ll_addr                     = (known after apply)
      + mac                         = (known after apply)
      + mcast_allow                 = (known after apply)
      + multi_dst_pkt_act           = (known after apply)
      + name                        = "bd-common"
      + name_alias                  = (known after apply)
      + optimize_wan_bandwidth      = (known after apply)
      + relation_fv_rs_bd_to_ep_ret = (known after apply)
      + relation_fv_rs_bd_to_nd_p   = (known after apply)
      + relation_fv_rs_ctx          = "uni/tn-common/ctx-default"
      + relation_fv_rs_igmpsn       = (known after apply)
      + relation_fv_rs_mldsn        = (known after apply)
      + tenant_dn                   = "uni/tn-dcloud-tenant-4"
      + unicast_route               = "no"
      + unk_mac_ucast_act           = "flood"
      + unk_mcast_act               = "flood"
      + v6unk_mcast_act             = (known after apply)
      + vmac                        = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```


[aci_tenant data source](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/data-sources/tenant){target=_blank}
[aci_vrf data source](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/data-sources/vrf){target=_blank}
