# Terraform State

### 1. View Terraform State

Let's focus now on the state of our deployments. By now you should have three folders with different Terraform configuration.
Please change to `ACI` folder in terraform terminal and run `terraform state list` command. The output should list all the objects that were deployed by Terraform modules and will look similar to this:

```
juchowan@JUCHOWAN-M-D2P2 ACI % terraform state list
aci_aaep_to_domain.AEP_L2_to_PHYSDOM_1
aci_access_port_block.leaf-101-102-eth-1-block
aci_access_port_block.leaf-101-102-eth-2-block
aci_access_port_selector.leaf-101-102-eth-1
aci_access_port_selector.leaf-101-102-eth-2
aci_application_epg.epg1
aci_application_profile.ap1
aci_attachable_access_entity_profile.AEP_L2
aci_attachable_access_entity_profile.AEP_L3
aci_bridge_domain.bd-network-1
aci_bridge_domain.bd_192_168_1_0
aci_bridge_domain.bd_192_168_2_0
aci_epg_to_domain.epg1-to-physdom_1
aci_epg_to_static_path.static-binding-1
aci_external_network_instance_profile.extepg
aci_fabric_if_pol.LINK_10G
aci_fabric_node_member.Leaf-101
aci_fabric_node_member.Leaf-102
aci_fabric_node_member.Spine-103
aci_fabric_node_member.Spine-104
aci_l3_domain_profile.EXTRTDOM_1
aci_l3_ext_subnet.extepg-subnet
aci_l3_outside.l3out-1
aci_l3out_path_attachment.l3ip-path
aci_lacp_policy.LACP_ACTIVE
aci_leaf_access_bundle_policy_group.IntPolGrp_Router1
aci_leaf_access_bundle_policy_group.IntPolGrp_VPC_server1
aci_leaf_interface_profile.IntProf-101-102
aci_leaf_profile.SwProf-101-102
aci_leaf_selector.Sel-101-102
aci_lldp_interface_policy.LLDP_ON
aci_logical_interface_profile.ip-101-102
aci_logical_node_profile.np-101-102
aci_logical_node_to_fabric_node.np-101-102-to-node-101
aci_logical_node_to_fabric_node.np-101-102-to-node-102
aci_node_block.Sel-101-102-Block
aci_physical_domain.PHYSDOM_1
aci_ranges.RANGE_100-200
aci_ranges.RANGE_201-300
aci_subnet.subnet-1
aci_tenant.dcloud-tenant-1
aci_tenant.dcloud-tenant-2
aci_vlan_pool.VLAN_POOL_L2
aci_vlan_pool.VLAN_POOL_L3
aci_vrf.vrf1
aci_vrf.vrf2-1
```

You can see every object/resource we deployed in the previous labs. To see detailed configuration of each object run `terraform state show <object name>`, for example

    `terraform state show aci_bridge_domain.bd-network-1`

You will get output similar to this:

```
juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform state show aci_bridge_domain.bd-network-1
# aci_bridge_domain.bd-network-1:
resource "aci_bridge_domain" "bd-network-1" {
    annotation                  = "orchestrator:terraform"
    arp_flood                   = "no"
    bridge_domain_type          = "regular"
    ep_clear                    = "no"
    ep_move_detect_mode         = "disable"
    host_based_routing          = "no"
    id                          = "uni/tn-dcloud-tenant-1/BD-bd-network-1"
    intersite_bum_traffic_allow = "no"
    intersite_l2_stretch        = "no"
    ip_learning                 = "yes"
    ipv6_mcast_allow            = "no"
    limit_ip_learn_to_subnets   = "yes"
    ll_addr                     = "::"
    mac                         = "00:22:BD:F8:19:FF"
    mcast_allow                 = "no"
    multi_dst_pkt_act           = "bd-flood"
    name                        = "bd-network-1"
    optimize_wan_bandwidth      = "no"
    relation_fv_rs_ctx          = "uni/tn-dcloud-tenant-1/ctx-vrf1"
    tenant_dn                   = "uni/tn-dcloud-tenant-1"
    unicast_route               = "yes"
    unk_mac_ucast_act           = "proxy"
    unk_mcast_act               = "flood"
    v6unk_mcast_act             = "flood"
    vmac                        = "not-applicable"
}
```

You can see the current state of this bridge domain and configuration of many parameters, even the ones we did not specify in the configuration. The reason we have these parameters here, is that they took the default value for bridge domain. The `id` element is the path of the bridge domain that was returned to us from ACI after we created this bridge domain.
You can in the same way check the state of other objects that we deployed.

Terraform stores information about our infrastructure in a state file. This state file keeps track of resources created by our configuration and maps them to real-world resources. The state file by default is located in the main directory of our workspace and is called `terraform.tfstate`. If you list all the contents of our workspace folder you will see that this file exists, and is created after we apply our config:

```
juchowan@JUCHOWAN-M-D2P2 ACI-simulator % ls | grep tfstate
terraform.tfstate
terraform.tfstate.backup
```

There is also a backup file created of our state.
Those files should not be changed manually to avoid drift between our Terraform configuration, state and infrastructure.
Open `terraform.tfstate` file in a file editor. You will see that this file is in the JSON format. The first stanza contains information about our Terraform application

```
{
  "version": 4,
  "terraform_version": "1.3.2",
  "serial": 577,
  "lineage": "8c71daed-6a43-a3c1-3981-9ce1f9789eb6",
  "outputs": {},
  "resources": [
```

Below that is the `resources` section of the state file, and it contains the schema for any resource that was created in Terraform. Example resource from the state file:

```
{
  "mode": "managed",
  "type": "aci_aaep_to_domain",
  "name": "AEP_L2_to_PHYSDOM_1",
  "provider": "provider[\"registry.terraform.io/ciscodevnet/aci\"]",
  "instances": [
    {
      "schema_version": 1,
      "attributes": {
        "annotation": "orchestrator:terraform",
        "attachable_access_entity_profile_dn": "uni/infra/attentp-AEP_L2",
        "description": null,
        "domain_dn": "uni/phys-PHYSDOM_1",
        "id": "uni/infra/attentp-AEP_L2/rsdomP-[uni/phys-PHYSDOM_1]"
      },
      "sensitive_attributes": [],
      "private": "eyJzY2hlbWFfdmVyc2lvbiI6IjEifQ==",
      "dependencies": [
        "aci_attachable_access_entity_profile.AEP_L2",
        "aci_physical_domain.PHYSDOM_1",
        "aci_vlan_pool.VLAN_POOL_L2"
      ]
    }
  ]
},
```

The first key is `mode`. Mode refers to the type of resource Terraform creates - either a resource (`managed`) or a data source (`data`). Tye `type` key refers to the resource type, in this case `aci_aaep_to_domain` is a resource available in the `aci` provider. The name of our resrouce is also stated here.
Below in the `instances` section, we have `attributes` of our resource: annotaion, attachable_access_entity_profile_dn, description, domain_dn and id. All those parameters apart from id can be set in our resource configuration, the ID parameter is returned from APIC after resource creation.
If you now run `terraform state show aci_aaep_to_domain.AEP_L2_to_PHYSDOM_1` you would see the same parameters displayed in the CLI version.

Terraform also marks dependencies between resources in state with the built-in dependency logic. In case of our aci_aaep_to_domain resoucre we have three dependencies to AEP, physical domain and vlan pool. Those dependencies are created based on `depends_on` attribute or by Terraform automatically.

## 2. Config drift

Terraform usually only updates infrastructure if it does not match the coniguration.

Let's see what happens when there is a manual change done on an existing object that was created by Terraform. We will work on the `bd-network-1` resource that was created in the `dcloud-tenant-1`. This resource was declared following:

```
resource "aci_bridge_domain" "bd-network-1" {
    tenant_dn             = aci_tenant.dcloud-tenant-1.id
    relation_fv_rs_ctx    = aci_vrf.vrf1.id
    name                  = "bd-network-1"
}
```

Please login to APIC and go to Tenants -> dcloud-tenant-1 -> Networking -> Bridge Domains -> bd-network-1 and open the Policy tab.
Change the L2 Unkown Unicast setting from Hardware Proxy to Flood and Submit changes:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/terraform-config-drift-1.png" width = 800>

If you run `terraform plan` now you will see that no changes to the infrastructure are required. If display state of this object, you will see that it still has "proxy" value assigned:

```

juchowan@JUCHOWAN-M-D2P2 ACI % terraform state show aci_bridge_domain.bd-network-1
# aci_bridge_domain.bd-network-1:
resource "aci_bridge_domain" "bd-network-1" {

<omitted>

    unk_mac_ucast_act           = "proxy"
    unk_mcast_act               = "flood"
    v6unk_mcast_act             = "flood"
    vmac                        = "not-applicable"
}
```
 The reason for that is that the attribute that was changed - `unk_mac_ucast_act` - was not set in Terraform configuration. Terraform will detect the config drift but it will not revert it. If we now run `apply` we will see that the parameter has been updated in the Terraform state:

```
juchowan@JUCHOWAN-M-D2P2 ACI % terraform apply

<omitted>

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

juchowan@JUCHOWAN-M-D2P2 ACI-simulator % terraform state show aci_bridge_domain.bd-network-1
# aci_bridge_domain.bd-network-1:
resource "aci_bridge_domain" "bd-network-1" {

<omitted>

    unk_mac_ucast_act           = "flood"
    unk_mcast_act               = "flood"
    v6unk_mcast_act             = "flood"
    vmac                        = "not-applicable"
}
```

If we would like to see those config drifts in the output of our `plan` and `apply` command, we would need to use the `-refresh-only` flag.

```
juchowan@JUCHOWAN-M-D2P2 ACI % terraform plan -refresh-only

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply" which may have affected this plan:

  # aci_bridge_domain.bd-network-1 has changed
  ~ resource "aci_bridge_domain" "bd-network-1" {
        id                          = "uni/tn-dcloud-tenant-1/BD-bd-network-1"
        name                        = "bd-network-1"
      ~ unk_mac_ucast_act           = "proxy" -> "flood"
        # (22 unchanged attributes hidden)
    }


This is a refresh-only plan, so Terraform will not take any actions to undo these. If you were expecting these changes then you can apply this plan to record the updated
values in the Terraform state without changing any remote objects.
```

Let's now see what will happen if we explicitly set this parameter in the Terraform configuration.
The current state is that our bridge domain has manually set "flood" option, and our state is in line with this. Let's add a new line to our bridge domain configuration. This config was done in the `dcloud-tenant-1.tf` file. Please add the line:

```json hl_lines="5"
resource "aci_bridge_domain" "bd-network-1" {
    tenant_dn             = aci_tenant.dcloud-tenant-1.id
    relation_fv_rs_ctx    = aci_vrf.vrf1.id
    name                  = "bd-network-1"
    unk_mac_ucast_act     = "proxy"
}
```

If you run `plan` and `apply` now, you will see the change needs to be done. Please apply that change and verify in APIC that L2 unknown unicast is changed to "proxy".

At this point our state shows "proxy" for this bridge domain settings. Let's change back to flood on the APIC GUI:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/terraform-config-drift-1.png" width = 800>

If we were to run `plan` now we will start seeing the change required:

```
juchowan@JUCHOWAN-M-D2P2 ACI % terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aci_bridge_domain.bd-network-1 will be updated in-place
  ~ resource "aci_bridge_domain" "bd-network-1" {
        id                          = "uni/tn-dcloud-tenant-1/BD-bd-network-1"
        name                        = "bd-network-1"
      ~ unk_mac_ucast_act           = "flood" -> "proxy"
        # (22 unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

This is because attribute has been set in Terraform, so Terraform detects this drift and tries to revert it its expected condition.

If we would like now to not revert it, but update Terraform state to reflect this change to "flood", we would require to change Terraform config to "flood" under resource block, and run `terraform apply -refresh-only`.
