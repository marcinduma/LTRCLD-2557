resource "aci_tenant" "dcloud-tenant-1" {
  name             = "dcloud-tenant-1"
}

resource "aci_vrf" "vrf1" {
  tenant_dn         = aci_tenant.dcloud-tenant-1.id
  name              = "vrf1"
}

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
