# Terraform modules

As you can see deploying objects like L3out require a lot of repeatable configuration. Such configs can be simplified by using Terraform modules. In such module we can write source configuration and re-use it multiple times, with standardized configuration.

In this lab we will use existing module for L3out configuration.
This module consists of three files:

- main.tf with the resource configuration
- variables.tf with th variables definition
- outputs.tf with the output ID value that this module would return

Each three files should be placed under *modules/aci_l3out/* folder structure.

Apart from those files, we still require our own configuration, so again we will create `main.tf`, `variables.tf` and `terraform.tfvars` under main folder. The whole structure should look like this:

- ACI-4/

    - main.tf
    - variables.tf
    - terraform.tfvars
    - modules/

        - aci_l3out/

            - main.tf
            - variables.tf
            - outputs.tf

The complete folder can be downloaded: **[here](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/modules-demo.zip){target=_blank}**

We will walk over the config files.

**Module files**

Inside the module folder we have three files.

In the *variables.tf* we define every variable that we will be using. In case of this module those variables don't have any default values assigned, they mostly specify the type of parameters to be used in maps.

In the *main.tf* file we create our complex l3out configuration and relations between multiple objects. This configuration looks similar to your manual L3out configuration, but this time it is reusable and you wouldn't have to write it multiple times for multiple L3outs.
We have set of resources like `aci_l3out`, `aci_logical_node_profile`, `aci_logical_interface_profile` etc. This module adds also BGP peer connectivity which is something we haven't done yet in the previous labs.

The new thing you can spot in this module is the initial part with the `locals` block. This block defined a local value. Local value is a temporary variable that is constructed with an expression on other variables. If you run expressions on variables, for example loops, you would always get some temporary variable that you can use. However, what a local value does, is that it assigns a name to that expression and you will be able to reuse it multiple times within your module, instead of repeating the expression. You can treat it similarly to a function in programming which returns some value.
In case of local value `external_epg_subnets` it is performing `flatten` function. (Flatten function)[https://developer.hashicorp.com/terraform/language/functions/flatten] is useful for us when we want to run loops inside a map of map. The result of this flatten function would be a list of all subnets that need to be configured under external EPG with their parameters.

```
locals {
  external_epg_subnets = flatten([
    for l3epg_key, l3epg in var.external_epgs : [
      for subnet_key, subnet in l3epg.subnets : {
        external_epg_key = l3epg_key
        external_epg_name = l3epg.name
        subnet_key = subnet_key
        subnet_ip = subnet.ip
        subnet_scope = subnet.scope
      }
    ]
  ])
}
```

Later in the code we can see that this is used with `for` function in `aci_l3_ext_subnet` resource:

```

resource "aci_l3_ext_subnet" "l3instp_subnet" {
  for_each       = {
    for subnet in local.external_epg_subnets : "${subnet.external_epg_key}.${subnet.subnet_key}" => subnet
  }

  external_network_instance_profile_dn  = aci_external_network_instance_profile.l3instp[each.value.external_epg_key].id
  ip                                    = each.value.subnet_ip
  scope                                 = each.value.subnet_scope
}
```

In the *value.tf* file we specify the output value for this module. Output values are similar to return values in programming languages. In this case they will return ID of L3out we created, and that ID in ACI will be the path of this object.
As you may remember, our standard resources from official ACI provider also return ID value of this resource in ACI, and it is always the path to the object.

**Main folder files**

In the main folder the files use same configuration as in previous labs, so you should be already familiar with the way we configure objects using variables and how we configure  bridge domains with conditionals and for_each loop. The new part is the way we configure L3Out using module.

As first part you can see that we are using data source to import existing configuration of Routed Domain. It would have to be used for configuration of L3out, so we need to have a way to reference it in our files.

Next we have our block for configuring the L3out itself. The highlithed lines show how we can write configuration and reference the module. Instead of a `resource` block, we are using `module` block and then in second line we have to reference the source path where this module is located `./modules/aci_l3out`.

```json hl_lines="1 2"
module "l3out_core" {
    source = "./modules/aci_l3out"

    tenant_id = aci_tenant.tenant.id
    name = "core_l3out"
    vrf_id = aci_vrf.main.id
    l3_ext_domain_id = data.aci_l3_domain_profile.EXTRTDOM_1.id
    nodes = {
        101 = {
            pod_id = "1"
            node_id = "101"
            rtr_id = "51.1.1.1"
            rtr_id_loopback = "no"
        }
    }
    paths = {
        "101.1.10" = {
            pod_id = "1"
            node_id = "101"
            port_id = "eth1/10"
            ip_addr  = "5.5.1.2/24"
            mode = "regular"
            mtu = "inherit"
        }
    }
    bgp_peers = {
        asa = {
            peer_addr = "5.5.1.1"
            peer_asn = "65099"
            local_asn = "65001"
        }
    }
    external_epgs = {
        default = {
            name = "default_l3epg"
            prefGrp = "exclude"
            provided_contracts = ["default"]
            consumed_contracts = []
            subnets = {
              "0.0.0.0" = {
                ip = "0.0.0.0/0"
                scope = ["import-security"]
              }
            }
        }
    }
}
```

The remaining part is the actual config parameters that we want to use for our L3out. Each of the parameters that we are assigning is defined in the module itself. In this file we simply assign values to them, either manually by typing it (i.e. name = "core_l3out") or by referencing other variables and objects (i.e tenant_id = aci_tenant.tenant.id).


### Lab

Customer creates Custom2 tenant with dedicated VRF, bridge domains, EPGs, domain associations and static-bindings for particular departaments. There are also two L3outs for MPLS and Internet connectivity. Use existing PHYSDOM_1 physcial domain and existing EXTRTDOM_1 routed domain. Use following static bindings:

WAN Router:

- node 101, interface eth1/10, routed interface

INTERNET Router:

- node 102, interface eth1/11, routed interface

UCS/vmware server:

- topology/pod-1/protpaths-101-102/pathep-[IntPolGrp_VPC_server1]
- EPG_UC - vlan 160
- EPG_DMZ - vlan 161

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/terraform-usecase-module.png" width = 400>
