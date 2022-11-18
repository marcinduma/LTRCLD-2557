# Description  

  
  
*Parameters are enclosed in double curly brackets*

Prepend the query URLs with the following if perform the query via https  
https://{{APIC_IP_ADDR}}

## URLs for REST API

**Collect the configuration of fabric, infra and tenants**
```
/api/mo/uni/fabric.xml?rsp-subtree=full&rsp-prop-include=config-only
/api/mo/uni/infra.xml?rsp-subtree=full&rsp-prop-include=config-only
/api/class/fvTenant.xml?rsp-subtree=full&rsp-prop-include=config-only

/api/mo/uni/fabric.json?rsp-subtree=full&rsp-prop-include=config-only
/api/mo/uni/infra.json?rsp-subtree=full&rsp-prop-include=config-only
/api/class/fvTenant.json?rsp-subtree=full&rsp-prop-include=config-only
```

**Collect the configuration of a particular tenant**
```
/api/class/fvTenant.xml?rsp-subtree=full&rsp-prop-include=config-only&query-target=subtree&query-target-filter=eq(fvTenant.name, "{{Tenant_name}}")
/api/class/fvTenant.json?rsp-subtree=full&rsp-prop-include=config-only&query-target=subtree&query-target-filter=eq(fvTenant.name, "{{Tenant_name}}")
```

**Collect the list of Access (non port-channel or vPC) Leaf interface policy groups**
```
/api/node/class/infraAccPortGrp.xml
/api/node/class/infraAccPortGrp.json
```

**Collect the list of Bundle (port-channel or vPC) Leaf interface policy groups**
```
/api/node/class/infraAccBndlGrp.xml
/api/node/class/infraAccBndlGrp.json
```

**Collect the list of Leaf interface profiles**
```
/api/node/mo/uni/infra.xml?query-target=subtree&target-subtree-class=infraAccPortP&query-target=subtree
/api/node/mo/uni/infra.json?query-target=subtree&target-subtree-class=infraAccPortP&query-target=subtree
```

**Collect the list of Leaf interface profiles associated with a particular port interface policy group**
```
/api/node/class/infraAccPortGrp.xml?query-target=subtree&query-target-filter=eq(infraAccPortGrp.name, "{{IPG_name}}")&rsp-subtree=children&rsp-subtree-class=infraRtAccBaseGrp
/api/node/class/infraAccPortGrp.json?query-target=subtree&query-target-filter=eq(infraAccPortGrp.name, "{{IPG_name}}")&rsp-subtree=children&rsp-subtree-class=infraRtAccBaseGrp
```

**Collect the list of Leaf interface profiles associated with a particular bundle interface policy group**
```
/api/node/class/infraAccBndlGrp.xml?query-target=subtree&query-target-filter=eq(infraAccBndlGrp.name, "{{IPG_name}}")&rsp-subtree=children&rsp-subtree-class=infraRtAccBaseGrp
/api/node/class/infraAccBndlGrp.json?query-target=subtree&query-target-filter=eq(infraAccBndlGrp.name, "{{IPG_name}}")&rsp-subtree=children&rsp-subtree-class=infraRtAccBaseGrp
```

**Collect the list of switch node IDs where a particular interface profile is applied**
```
/api/node/mo/uni/infra/accportprof-{{Intf_profile_name}}.xml?query-target=subtree&target-subtree-class=infraRtAccPortP
/api/node/mo/uni/infra/accportprof-{{Intf_profile_name}}.json?query-target=subtree&target-subtree-class=infraRtAccPortP
```

**Collect the range of switch node IDs associated with a particular switch profile**
```
/api/node/mo/uni/infra/nprof-{{Switch_profile_name}}.xml?query-target=subtree&target-subtree-class=infraNodeBlk
/api/node/mo/uni/infra/nprof-{{Switch_profile_name}}.json?query-target=subtree&target-subtree-class=infraNodeBlk
```

**Collect the port channel information per Pod and Node**
```
/api/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys.xml?query-target=subtree&target-subtree-class=pcAggrIf&rsp-subtree=children&rsp-subtree-class=pcRsMbrIfs
/api/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys.json?query-target=subtree&target-subtree-class=pcAggrIf&rsp-subtree=children&rsp-subtree-class=pcRsMbrIfs
```

**Collect the list of interfaces dynamically added to EPG due to VMM integration**
```
/api/node/mo/uni/epp/fv-[uni/tn-{{Tenant_name}}/ap-{{APP_name}}/epg-{{EPG_name}}].xml?query-target=subtree&target-subtree-class=fvIfConn
/api/node/mo/uni/epp/fv-[uni/tn-{{Tenant_name}}/ap-{{APP_name}}/epg-{{EPG_name}}].json?query-target=subtree&target-subtree-class=fvIfConn
```

**Collect the interface RX traffic statistics**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/HDeqptIngrTotal15min-0.xml
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/HDeqptIngrTotal15min-0.json
```

**Collect the interface TX traffic statistics**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/HDeqptEgrTotal15min-0.xml
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/HDeqptEgrTotal15min-0.json
```

**Collect the CDP neighbor for an interface**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/cdp/inst/if-[{{Intf_id}}].xml?query-target=children&target-subtree-class=cdpAdjEp&query-target=subtree
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/cdp/inst/if-[{{Intf_id}}].json?query-target=children&target-subtree-class=cdpAdjEp&query-target=subtree
```

**Collect the LLDP neighbor for an interface**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/lldp/inst/if-[{{Intf_id}}].xml?query-target=children&target-subtree-class=lldpAdjEp&query-target=subtree
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/lldp/inst/if-[{{Intf_id}}].json?query-target=children&target-subtree-class=lldpAdjEp&query-target=subtree
```

**Collect the interface RX counters**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/dbgIfIn.xml
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/dbgIfIn.json
```

**Collect the interface TX counters**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/dbgIfOut.xml
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/dbgIfOut.json
```

**Collect the interface statistics**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/dbgEtherStats.xml
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/dbgEtherStats.json
```

**Collect the interface SFP information**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/phys.xml?query-target=children&target-subtree-class=ethpmFcot
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}]/phys.json?query-target=children&target-subtree-class=ethpmFcot
```

**Collect the information on interfaces dedicated for FEX uplinks on a node**
```
/api/node/class/topology/pod-{{Pod_id}}/node-{{Node_id}}/l2ExtIf.xml
/api/node/class/topology/pod-{{Pod_id}}/node-{{Node_id}}/l2ExtIf.json
```

**Collect the information on interfaces dedicated for FEX uplinks on a node per FEX**
```
/api/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}.xml?query-target=subtree&target-subtree-class=satmFabP&query-target-filter=eq(satmFabP.extChId,"{{Fex_id}}")
/api/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}.json?query-target=subtree&target-subtree-class=satmFabP&query-target-filter=eq(satmFabP.extChId,"{{Fex_id}}")
```

**Collect the FEX information**
```
/api/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}.xml?query-target=subtree&target-subtree-class=satmDExtCh&query-target-filter=eq(satmDExtCh.id, "{{Fex_id}}")
/api/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}.json?query-target=subtree&target-subtree-class=satmDExtCh&query-target-filter=eq(satmDExtCh.id, "{{Fex_id}}")
```

**Collect the FEX inventory per switch node**
```
/api/node/class/topology/pod-{{Pod_id}}/node-{{Node_id}}/eqptExtCh.xml
/api/node/class/topology/pod-{{Pod_id}}/node-{{Node_id}}/eqptExtCh.json
```

**Collect the supervisor inventory of a node**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.xml?query-target=subtree&target-subtree-class=eqptSupC
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.json?query-target=subtree&target-subtree-class=eqptSupC
```

**Collect the linecard inventory of a node**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.xml?query-target=subtree&target-subtree-class=eqptLC
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.json?query-target=subtree&target-subtree-class=eqptLC
```

**Collect the power supply inventory of a node**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.xml?query-target=subtree&target-subtree-class=eqptPsu
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.json?query-target=subtree&target-subtree-class=eqptPsu
```

**Collect the fan tray inventory of a node**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.xml?query-target=subtree&target-subtree-class=eqptFt
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.json?query-target=subtree&target-subtree-class=eqptFt
```

**Collect the fabric card inventory of a node**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.xml?query-target=subtree&target-subtree-class=eqptFC
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.json?query-target=subtree&target-subtree-class=eqptFC
```

**Collect the system controller inventory of a node**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.xml?query-target=subtree&target-subtree-class=eqptSysC
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/ch.json?query-target=subtree&target-subtree-class=eqptSysC
```

**Collect the APIC time zone**
```
/api/node/mo/uni/fabric/format-default.xml
/api/node/mo/uni/fabric/format-default.json
```

**Collect the NTP provider and status of a switch node**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/time.json?rsp-subtree=children
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/time.json?rsp-subtree=children
```

**Collect the NTP provider and status of an APIC node**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys.json?query-target=subtree&target-subtree-class=datetimeNtpq
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys.json?query-target=subtree&target-subtree-class=datetimeNtpq
```

**Collect the list of allowed VLANs on interface**
```
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}].xml?query-target=children&target-subtree-class=ethpmPhysIf
/api/node/mo/topology/pod-{{Pod_id}}/node-{{Node_id}}/sys/phys-[{{Intf_id}}].json?query-target=children&target-subtree-class=ethpmPhysIf
```

**Collect Leaf Switch profile info**
```
/api/node/mo/uni/infra/nprof-{{Profile_name}}.xml?query-target=subtree&target-subtree-class=infraNodeBlk
/api/node/mo/uni/infra/nprof-{{Profile_name}}.json?query-target=subtree&target-subtree-class=infraNodeBlk
```

**Collect Spine Switch profile info**
```
/api/node/mo/uni/infra/spprof-{{Profile_name}}.xml?query-target=subtree&target-subtree-class=infraNodeBlk
/api/node/mo/uni/infra/spprof-{{Profile_name}}.json?query-target=subtree&target-subtree-class=infraNodeBlk
```

**Collect vPC domain info**
```
/api/node/mo/uni/fabric/protpol/expgep-{{vPC_domain}}.xml?query-target=subtree&target-subtree-class=fabricNodePEp
/api/node/mo/uni/fabric/protpol/expgep-{{vPC_domain}}.json?query-target=subtree&target-subtree-class=fabricNodePEp
```

**Collect static VLAN pool info**
```
/api/node/mo/uni/infra/vlanns-[{{VLANpool_name}}]-static.xml?query-target=subtree
/api/node/mo/uni/infra/vlanns-[{{VLANpool_name}}]-static.json?query-target=subtree
```

**Collect dynamic VLAN pool info**
```
/api/node/mo/uni/infra/vlanns-[{{VLANpool_name}}]-dynamic.xml?query-target=subtree
/api/node/mo/uni/infra/vlanns-[{{VLANpool_name}}]-dynamic.json?query-target=subtree
```

**Collect physical domain info**
```
/api/node/mo/uni/phys-{{Domain_name}}.xml?query-target=subtree
/api/node/mo/uni/phys-{{Domain_name}}.json?query-target=subtree
```

**Collect physical domain VLAN pool name**
```
/api/node/mo/uni/phys-{{Domain_name}}/rsvlanNs.xml
/api/node/mo/uni/phys-{{Domain_name}}/rsvlanNs.json
```

**Collect L3 domain info**
```
/api/node/mo/uni/l3dom-{{Domain_name}}.xml?query-target=subtree
/api/node/mo/uni/l3dom-{{Domain_name}}.json?query-target=subtree
```

**Collect L3 domain VLAN pool name**
```
/api/node/mo/uni/l3dom-{{Domain_name}}/rsvlanNs.xml
/api/node/mo/uni/l3dom-{{Domain_name}}/rsvlanNs.json
```

**Collect L2 domain info**
```
/api/node/mo/uni/l2dom-{{Domain_name}}.xml?query-target=subtree
/api/node/mo/uni/l2dom-{{Domain_name}}.json?query-target=subtree
```

**Collect L2 domain VLAN pool name**
```
/api/node/mo/uni/l2dom-{{Domain_name}}/rsvlanNs.xml
/api/node/mo/uni/l2dom-{{Domain_name}}/rsvlanNs.json
```

**Collect VMWare VMM domain info**
```
/api/node/mo/uni/vmmp-VMware/dom-{{Domain_name}}.xml?query-target=subtree
/api/node/mo/uni/vmmp-VMware/dom-{{Domain_name}}.json?query-target=subtree
```

**Collect VMWare VMM domain VLAN pool name**
```
/api/node/mo/uni/vmmp-VMware/dom-{{Domain_name}}/rsvlanNs.xml
/api/node/mo/uni/vmmp-VMware/dom-{{Domain_name}}/rsvlanNs.json
```

**Collect AAEP info**
```
/api/node/mo/uni/infra/attentp-{{AAEP_name}}.xml?query-target=subtree
/api/node/mo/uni/infra/attentp-{{AAEP_name}}.json?query-target=subtree
```

**Collect Spine Interface Policy Group info**
```
/api/node/mo/uni/infra/funcprof/spaccportgrp-{{IPG_name}}.xml?query-target=subtree
/api/node/mo/uni/infra/funcprof/spaccportgrp-{{IPG_name}}.json?query-target=subtree
```

**Collect Spine Interface Policy Group AAEP name**
```
/api/node/mo/uni/infra/funcprof/spaccportgrp-{{IPG_name}}/rsattEntP.xml
/api/node/mo/uni/infra/funcprof/spaccportgrp-{{IPG_name}}/rsattEntP.json
```

**Collect Leaf Access Interface Policy Group info**
```
/api/node/mo/uni/infra/funcprof/accportgrp-{{IPG_name}}.xml?query-target=subtree
/api/node/mo/uni/infra/funcprof/accportgrp-{{IPG_name}}.json?query-target=subtree
```

**Collect Leaf Access Interface Policy Group AAEP name**
```
/api/node/mo/uni/infra/funcprof/accportgrp-{{IPG_name}}/rsattEntP.xml
/api/node/mo/uni/infra/funcprof/accportgrp-{{IPG_name}}/rsattEntP.json
```

**Collect Leaf PC or vPC Interface Policy Group info**
```
/api/node/mo/uni/infra/funcprof/accbundle-{{IPG_name}}.xml?query-target=subtree
/api/node/mo/uni/infra/funcprof/accbundle-{{IPG_name}}.json?query-target=subtree
```

**Collect Leaf PC or vPC Interface Policy Group AAEP name**
```
/api/node/mo/uni/infra/funcprof/accbundle-{{IPG_name}}/rsattEntP.xml
/api/node/mo/uni/infra/funcprof/accbundle-{{IPG_name}}/rsattEntP.json
```

**Collect Spine Interface Profile info**
```
/api/node/mo/uni/infra/spaccportprof-{{Profile_name}}.xml?query-target=subtree
/api/node/mo/uni/infra/spaccportprof-{{Profile_name}}.json?query-target=subtree
```

**Collect Spine Interface Profile IPG name**
```
/api/node/mo/uni/infra/spaccportprof-{{Profile_name}}.xml?query-target=subtree&target-subtree-class=infraRsSpAccGrp
/api/node/mo/uni/infra/spaccportprof-{{Profile_name}}.json?query-target=subtree&target-subtree-class=infraRsSpAccGrp
```

**Collect Leaf Interface Profile info**
```
/api/node/mo/uni/infra/accportprof-{{Profile_name}}.xml?query-target=subtree
/api/node/mo/uni/infra/accportprof-{{Profile_name}}.json?query-target=subtree
```

**Collect Leaf Interface Profile IPG name**
```
/api/node/mo/uni/infra/accportprof-{{Profile_name}}.xml?query-target=subtree&target-subtree-class=infraRsAccBaseGrp
/api/node/mo/uni/infra/accportprof-{{Profile_name}}.json?query-target=subtree&target-subtree-class=infraRsAccBaseGrp
```

**Collect Spine Interface profile names associated with Spine Switch profile**
```
/api/node/mo/uni/infra/spprof-{{Switchprofile_name}}.xml?query-target=subtree&target-subtree-class=infraRsSpAccPortP
/api/node/mo/uni/infra/spprof-{{Switchprofile_name}}.json?query-target=subtree&target-subtree-class=infraRsSpAccPortP
```

**Collect Leaf Interface profile names associated with Leaf Switch profile**
```
/api/node/mo/uni/infra/nprof-{{Switchprofile_name}}.xml?query-target=subtree&target-subtree-class=infraRsAccPortP
/api/node/mo/uni/infra/nprof-{{Switchprofile_name}}.json?query-target=subtree&target-subtree-class=infraRsAccPortP
```

**Collect Tenant info**
```
/api/node/mo/uni/tn-{{Tenant_name}}.xml?query-target=subtree
/api/node/mo/uni/tn-{{Tenant_name}}.json?query-target=subtree
```

**Collect VRF info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/ctx-{{VRF_name}}.xml?query-target=subtree
/api/node/mo/uni/tn-{{Tenant_name}}/ctx-{{VRF_name}}.json?query-target=subtree
```

**Collect Bridge Domain info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.xml?query-target=subtree
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.json?query-target=subtree
```

**Collect Bridge Domain VRF name**
```
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.xml?query-target=children&target-subtree-class=fvRsCtx
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.json?query-target=children&target-subtree-class=fvRsCtx
```

**Collect Bridge Domain IP subnet**
```
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.xml?query-target=children&target-subtree-class=fvSubnet
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.json?query-target=children&target-subtree-class=fvSubnet
```

**Collect Bridge Domain L3Out name**
```
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.xml?query-target=children&target-subtree-class=fvRsBDToOut
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.json?query-target=children&target-subtree-class=fvRsBDToOut
```

**Collect Bridge Domain L3Out profile**
```
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.xml?query-target=children&target-subtree-class=fvRsBDToProfile
/api/node/mo/uni/tn-{{Tenant_name}}/BD-{{BD_name}}.json?query-target=children&target-subtree-class=fvRsBDToProfile
```

**Collect Application profile info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/ap-{{APP_name}}.xml?query-target=children
/api/node/mo/uni/tn-{{Tenant_name}}/ap-{{APP_name}}.json?query-target=children
```

**Collect EPG info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/ap-{{APP_name}}/epg-{{EPG_name}}.xml?query-target=children
/api/node/mo/uni/tn-{{Tenant_name}}/ap-{{APP_name}}/epg-{{EPG_name}}.json?query-target=children
```

**Collect EPG BD name**
```
/api/node/mo/uni/tn-{{Tenant_name}}/ap-{{APP_name}}/epg-{{EPG_name}}/rsbd.xml
/api/node/mo/uni/tn-{{Tenant_name}}/ap-{{APP_name}}/epg-{{EPG_name}}/rsbd.json
```

**Collect L3Out info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}.xml?query-target=children
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}.json?query-target=children
```

**Collect L3Out VRF name**
```
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}/rsectx.xml
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}/rsectx.json
```

**Collect L3Out Node Profile info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}/lnodep-{{NP_name}}.xml?query-target=children
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}/lnodep-{{NP_name}}.json?query-target=children
```

**Collect L3Out Interface Profile info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}/lnodep-{{NP_name}}/lifp-{{Intfprof_name}}.xml?query-target=children
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}/lnodep-{{NP_name}}/lifp-{{Intfprof_name}}.json?query-target=children
```

**Collect L3Out Network (External EPG) info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}/instP-{{ExtEPG_name}}.xml?query-target=children
/api/node/mo/uni/tn-{{Tenant_name}}/out-{{L3Out_name}}/instP-{{ExtEPG_name}}.json?query-target=children
```

**Collect Contract info**
```
/api/node/mo/uni/tn-{{Tenant_name}}/brc-{{Contract_name}}.xml?query-target=children
/api/node/mo/uni/tn-{{Tenant_name}}/brc-{{Contract_name}}.json?query-target=children
```
