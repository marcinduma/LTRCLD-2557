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

resource "aci_physical_domain" "PHYSDOM_1" {
  name        = "PHYSDOM_1"
  relation_infra_rs_vlan_ns = aci_vlan_pool.VLAN_POOL_L2.id
}

resource "aci_l3_domain_profile" "EXTRTDOM_1" {
  name  = "EXTRTDOM_1"
  relation_infra_rs_vlan_ns = aci_vlan_pool.VLAN_POOL_L3.id
}

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
