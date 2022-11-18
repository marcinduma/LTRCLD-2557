# Cisco ACI rest API

In this lab section you will create and execute list of API calls to configure ACI managed objects as well as read data from existing polices and devices. After this section you should feel comfortable with running simple automation tasks and build your own tasks for further customizations. You will be familiar with Postman dashboard and general idea of running request individually or as a collection defined.

## 1 Define restAPI calls under Collection

Now is a time to work with our requests to GET or POST restAPI. You will define couple of them during the LAB. Figure below shows where to navigate to create new request in your collection.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-request-1.png" width = 800>

Every API command have predefined structure. Administrator needs to specify URI for correct object are you going to work with. Everything is described in details under the following link:
[Cisco ACI API Configuration guide](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/2-x/rest_cfg/2_1_x/b_Cisco_APIC_REST_API_Configuration_Guide/b_Cisco_APIC_REST_API_Configuration_Guide_chapter_01.html){target=_blank}.

The figure below shows structure of every API call:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/349945.png" width = 800>



### 1.1 Create ACI login request

First request when working with ACI must be authentication. Without having your session authenticated, no API calls can be successfully executed. Information about Authentication request structure can be found here:

[Cisco ACI Authentication API](https://www.cisco.com/c/en/us/td/docs/switches/datacenter/aci/apic/sw/2-x/rest_cfg/2_1_x/b_Cisco_APIC_REST_API_Configuration_Guide/b_Cisco_APIC_REST_API_Configuration_Guide_chapter_01.html#concept_D16AC6DC9CCD4351A4A40287487F061A){target=_blank}.

Define it in Postman:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-aaalogin-1.png" width = 800>

In New Request section specify:

1) Name of Request

		ACI Login

2) Select Method to be **POST**

3) Enter request URL

		https://{{apic}}/api/aaaLogin.json

!!!Note
	Please notice that it's first place you use your Environment Variable = apic. In JSON definition every variable is closed by **{{ }}**.

4) Move to **Body** section for further work with your request


Once you open Body section, you need to select type of data to be **raw** and coding to **JSON**.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-aaalogin-2.png" width = 800>

Now you can copy code defined below to body section of your request.

```json title="aaaLogin" hl_lines="4 5"
{
  "aaaUser" : {
    "attributes" : {
      "name" : "{{user}}",
      "pwd" : "{{password}}"
    }
  }
}
```

**==Yellow==** highlighted text in the json code above will use variables you defined in **Environment** at the beginning of the Lab.

Now your Request should looks like on the figure below.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-aaalogin-3.png" width = 800>

<span style="color:blue">**It's time to TEST it!**</span>.


<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-aaalogin-4.png" width = 800>

Click on **Send** button. Make sure your environment **ACI-dcloud** is selected - above the Send button.

When works as expected you will be authenticated to APIC. Responce from the APIC is visible in the section at your screen.
Let's go together across results you see on the screen. First is a Status ** 200 OK ** - means APIC server accepted your request, execute it and responce with data. In the REPLY Body you see JSON structure data. You can see **token** which is your authentication token. **RefreshTimeoutSeconds** set to 600 seconds = 10 minutes. Token is valid for 10 minutes and after that period will expire.

Please scroll down across the response body yourself.  Look for such information:

- userName
- sessionId
- aaaWriteRoles

Write them down to notepad.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-aaalogin-5.png" width = 800>


### Register your ACI Fabric Switches in APIC

Lab is clear and leaf/spines requires registration. You can automate it using Postman.

Configure new Postman POST Request with code **[downloaded from here](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/fabricinfra.json){target=_blank}**

use URI:

		https://{{apic}}/api/node/class/fabricNode.json

Contact Instructor in case of issues.


### 1.2 Get Information About a Node

POST is not only one request type. You can configure your ACI fabric, but you can use restAPI to pull data you are interest to analyse. This excercise is about writing a **GET** Request under already created ACI collection. As an example you will pull information about Leaf node-101 system in *json*.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-get-node101-1.PNG" width = 800>

Name your new Request

		Node-101-topsystem check

Copy the URI to GET request:

		https://{{apic}}/api/mo/topology/pod-1/node-101/sys.json


Save new Request and Click **Send** .

!!! Note
	It may happen that your API Token expired - remember its valid only 10 minutes. If you experience it, go to *ACI Login* Request and Send it again to re-authenticate.



In the Body responce you can verify topsystem information about Leaf in your Fabric.
You can pull data about AccessPolices, Interfaces as well as Logical construct - Tenant, EPGs, VRFs etc. The idea is always same - specify correct URL. Another test will be quering information about APIC node and current firmware version running on it.


Please Create another Request under your Collection with following setup:

Name of Request:

		Get Running Firmware

GET request URI:

		https://{{apic}}/api/mo/topology/pod-1/node-1/sys/ctrlrfwstatuscont.json?query-target=subtree&target-subtree-class=firmwareCtrlrRunning

Please observe that current query is composed with parameters. Before we pulled data directly from top-system of our ACI Leaf. Now you are narrowing the output to only sub-class you are intrested about.
Try to delete part of URI ==**?query-target=subtree&target-subtree-class=firmwareCtrlrRunning**== and do Send again.



## 2  ACI Access Polices

Every ACI Fabric configuration starts with Access Polices. You need to define ACI objects which represent single physical port configurations. To remind relationships between objects, please check following figure.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/access-polices.png" width = 800>

Usually Interface Polices are configured once and re-used like LLDP, LACP, CDP, etc. However our LAB is empty and you need to start from zero. Following sections will help you to prepare your API requests.

### 2.1 Interface Policies

You will configure LACP Policy, LLDP_ON, LINK-10G. Copy each of the Policy json definition to individual POST requests under your ACI Collection in Postman.

Use URI to POST:

		https://{{apic}}/api/node/mo/uni.json

```json title="LACP_ACTIVE"
{
  "lacpLagPol": {
    "attributes": {
      "dn": "uni/infra/lacplagp-LACP_ACTIVE",
      "ctrl": "fast-sel-hot-stdby,graceful-conv,susp-individual",
      "name": "LACP_ACTIVE",
      "mode": "active",
      "rn": "lacplagp-LACP_ACTIVE",
      "status": "created"
    },
    "children": []
  }
}
```

```json title="LLDP_ON"
{
  "lldpIfPol": {
    "attributes": {
      "dn": "uni/infra/lldpIfP-LLDP_ON",
      "name": "LLDP_ON",
      "rn": "lldpIfP-LLDP_ON",
      "status": "created"
    },
    "children": []
  }
}
```

```json title="LINK-10G"
{
	"fabricHIfPol": {
		"attributes": {
			"dn": "uni/infra/hintfpol-LINK-10G",
			"name": "LINK-10G",
			"speed": "10G",
			"rn": "hintfpol-LINK-10G",
			"status": "created"
		},
		"children": []
	}
}
```

### 2.2 VLANs, Domains and AAEPs

Create VLAN pool with vlan-range, associate it with Physical Domain and AAEP.
Now you will change an approach. Your task is to create VLAN Pool with APIC GUI and capture json code from **API Inspector**.

Connect to your APIC using bookmark in dCloud workstation Chrome. Navigate to Access Polices -> Pools -> VLAN. When you are there, Click on *Help and Tools* menu in APIC Dashboard

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/apic-api-inspector.png" width = 800>

and Click on **Show API Inspector**. In new window you will open API Inspector, where you can capture every API call send to the APIC server.

Now you can start ADD VLAN-pool in APIC GUI.

VLAN POOL NAME:

		vlan-pool

**Allocation Mode:** Static

**Encap Blocks**: 100-200, Inherit Allocation mode from parent, **Role:** External or On the wire encapsulations

SUBMIT and open API Inspector in the another Chrome Window.

Search for ==**POST**== method.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/api-inspector-vlanpool.png" width = 800>


COPY now ALL POST URI from API Inspector to Postman request Body.

You should capture data as shown in code below.

```json
https://apic1.dcloud.cisco.com/api/node/mo/uni/infra/vlanns-[vlan-pool]-static.json
payload
{
	"fvnsVlanInstP": {
		"attributes": {
			"dn": "uni/infra/vlanns-[vlan-pool]-static",
			"name": "vlan-pool",
			"allocMode": "static",
			"rn": "vlanns-[vlan-pool]-static",
			"status": "created"
		},
		"children": [
			{
				"fvnsEncapBlk": {
					"attributes": {
						"dn": "uni/infra/vlanns-[vlan-pool]-static/from-[vlan-100]-to-[vlan-200]",
						"from": "vlan-100",
						"to": "vlan-200",
						"rn": "from-[vlan-100]-to-[vlan-200]",
						"status": "created"
					},
					"children": []
				}
			}
		]
	}
}
```


Now it's time to build a request from data captured. You will use that request in the future for adding more vlan pools.

First, copy URL and place it in Postman URL. Replace apic1.dcloud.cisco.com with our variable {{apic}}. Next replace vlanpool name in [ ] brakets.
New URI looks like that:

		https://{{apic}}/api/node/mo/uni/infra/vlanns-[{{vlanpoolname}}]-static.json

```json title="VLAN POOL"
{
	"fvnsVlanInstP": {
		"attributes": {
			"dn": "uni/infra/vlanns-[{{vlanpoolname}}]-static",
			"name": "{{vlanpoolname}}",
			"allocMode": "static",
			"rn": "vlanns-[{{vlanpoolname}}]-static",
			"status": "created"
		},
		"children": [
			{
				"fvnsEncapBlk": {
					"attributes": {
						"dn": "uni/infra/vlanns-[{{vlanpoolname}}]-static/from-[vlan-{{vlanstart}}]-to-[vlan-{{vlanend}}]",
						"from": "vlan-{{vlanstart}}",
						"to": "vlan-{{vlanend}}",
						"rn": "from-[vlan-{{vlanstart}}]-to-[vlan-{{vlanend}]",
						"status": "created"
					},
					"children": []
				}
			}
		]
	}
}
```
Variables *{{vlanpoolname}}, {{vlanstart}}, {{vlanend}}* you can replace by hardcoded values in your code, or define values in Environment. Later today you will see the powerfull of variables using csv file for input data.

Same approach please use in Domain and AAEP creation - Go to GUI, do Domain - PHY-DOM, associate with **vlan-pool** and AAEP - dcloud-AAEP. Observe API Inspector, capture the code and build those two requests in Postman.

URI for AAEP Function:

		https://{{apic}}/api/node/mo/uni/infra.json

```json title="AAEP"
{
	"infraInfra": {
		"attributes": {
			"dn": "uni/infra",
			"status": "modified"
		},
		"children": [
			{
				"infraAttEntityP": {
					"attributes": {
						"dn": "uni/infra/attentp-{{aaep}}",
						"name": "{{aaep}}",
						"rn": "attentp-{{aaep}}",
						"status": "created"
					},
					"children": []
				}
			},
			{
				"infraFuncP": {
					"attributes": {
						"dn": "uni/infra/funcprof",
						"status": "modified"
					},
					"children": []
				}
			}
		]
	}
}
```

Last one is Domain. Create Physical domain PHY-DOM with vlan pool associated *vlan-pool* and AAEP *dcloud-AAEP*.

		https://{{apic}}/api/node/mo/uni/phys-{{domain}}.json

```json title="Domain"
{
	"physDomP": {
		"attributes": {
			"dn": "uni/phys-{{domain}}",
			"name": "{{domain}}",
			"rn": "phys-{{domain}}",
			"status": "created"
		},
		"children": [
			{
				"infraRsVlanNs": {
					"attributes": {
						"tDn": "uni/infra/vlanns-[{{vlanpoolname}}]-static",
						"status": "created"
					},
					"children": []
				}
			}
		]
	}
}
```
Interesting fact about domain to AAEP association. Domain is sub-object to AAEP, you will not see AAEP under Domain definition, even you specify it in APIC GUI. In API you need to add it under AAEP.

	https://{{apic}}/api/node/mo/uni/infra.json

```json title="Domain to AAEP association"
{
	"infraAttEntityP": {
		"attributes": {
			"annotation": "",
			"descr": "",
			"dn": "uni/infra/attentp-{{aaep}}",
			"name": "{{aaep}}",
			"nameAlias": "",
			"ownerKey": "",
			"ownerTag": "",
			"userdom": ":all:"
		},
		"children": [
			{
				"infraRsDomP": {
					"attributes": {
						"annotation": "",
						"tDn": "uni/phys-{{domain}}",
						"userdom": ":all:"
					}
				}
			}
		]
	}
}
```

### 2.3 Interface Policy Group

Lets now create one of the Interface policy group and use all created policy.

```json title="Interface Policy Group VPC"
{
	"infraAccBndlGrp": {
		"attributes": {
			"dn": "uni/infra/funcprof/accbundle-intpolgrp-vpc-server1",
			"lagT": "node",
			"name": "intpolgrp-vpc-server1",
			"rn": "accbundle-intpolgrp-vpc-server1",
			"status": "created"
		},
		"children": [
			{
				"infraRsAttEntP": {
					"attributes": {
						"tDn": "uni/infra/attentp-dcloud-AAEP",
						"status": "created,modified"
					},
					"children": []
				}
			},
			{
				"infraRsHIfPol": {
					"attributes": {
						"tnFabricHIfPolName": "LINK-10G",
						"status": "created,modified"
					},
					"children": []
				}
			},
			{
				"infraRsLldpIfPol": {
					"attributes": {
						"tnLldpIfPolName": "LLDP_ON",
						"status": "created,modified"
					},
					"children": []
				}
			},
			{
				"infraRsLacpPol": {
					"attributes": {
						"tnLacpLagPolName": "LACP_ACTIVE",
						"status": "created,modified"
					},
					"children": []
				}
			}
		]
	}
}
```

Replace **intpolgrp-vpc-server1** with **intpolgrp-vpc-server2** to observe how simple you can add new VPC policy group using Postman.

!!! Warning
	Download three files to your dcloud workstation and using **post** in Postman or in APIC GUI upload it to access-polices. Without them, your VPC won't instanciate and cannot be used in later stage of the lab.
	
	==**[JSON VPC Policy](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/vpc-policy.json){target=_blank}.**==

	==**[JSON interface leaf profile](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/interface-leafprofile.json){target=_blank}.**==

	==**[JSON switch leaf profile](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/switch-leafprofile.json){target=_blank}.**==

	Ask instructor for assistance if not clear.


## 3  ACI Tenant

Upon now you created ACI AccessPolicies for your Tenant. Having JSON code for every object you will be able to unified variables across Postman Collection and then run all together using Variables from *Environment* or much better from CSV file.

Now is time to create your tenant using JSON. It will be simple Tenant definition with one VRF and two bridge domains associated with two EPGs. Every EPG will be associated with created domain and statically binded to both VPC created, with VLAN from VLAN pool done by you perviously.

Figure below shows our Logical Tenant.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/dcloud-tenant-1.PNG" width = 800>

You need to define Tenant, VRF, Bridge-Domains, Application-Profile, EPGs with Domain association and static binding under EPG. Quite many of Requests to do in Postman. You can define all of them under one Request.
Please, download a JSON file from ==**[JSON Tenant Ready](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/tn-dcloud-tenant-1.json){target=_blank}.**==

Once you have it on dcloud workstation, please create new Request under ACI Collection:
NAME:

		CREATE TENANT-1

Method: POST

URL:

		https://{{apic}}/api/node/mo/uni.json

COPY now content from downloaded file to Body of the new request, Save and Send it.

!!! Note
	Please check your authentication token if still valid.

Tenant-1 will be created with all structure shown in figure above.

### 3.1 Tenant components

This section contain JSON codes necessary to create Tenant objects.

#### 3.1.1 Tenant and VRF

Code below can be used to create new Tenant and VRF.

		https://{{apic}}/api/node/mo/uni.json

```json title="Tenant and VRF from CSV"
{
	"fvTenant": {
		"attributes": {
			"annotation": "",
			"descr": "",
			"dn": "uni/tn-{{tenantname}}",
			"name": "{{tenantname}}"
		},
		"children": [
			{
				"fvCtx": {
					"attributes": {
						"name": "{{vrfname}}"
					},
					"children": []
				}
			}
		]
	}
}
```

#### 3.1.2 BD in existing tenant

Code below can be used to create new Bridge-Domain in existing Tenant.

		https://{{apic}}/api/node/mo/uni.json

```json title="Bridge-domain L3 from CSV"
{
	"fvBD": {
		"attributes": {
			"name": "{{bdname}}",
			"dn": "uni/tn-{{tenantname}}/BD-{{bdname}}",
			"rn": "BD-{{bdname}}",
			"type": "regular"
		},
		"children": [
			{
				"fvSubnet": {
					"attributes": {
						"ip": "{{ipaddress}}",
						"ipDPLearning": "enabled",
						"scope": "private"
					}
				}
			},
			{
				"fvRsCtx": {
					"attributes": {
						"tnFvCtxName": "{{vrfname}}"
					}
				}
			}
		]
	}
}
```

In case you need to add BD without IP address and unicast routing disabled, use code below.

		https://{{apic}}/api/node/mo/uni.json

```json title="Bridge-domain L2 from CSV" hl_lines="15-18"
{
	"fvTenant": {
		"attributes": {
			"dn": "uni/tn-{{tenantname}}",
			"status": "modified"
		},
		"children": [
			{
				"fvBD": {
					"attributes": {
						"dn": "uni/tn-{{tenantname}}/BD-{{bdname}}",
						"mac": "00:22:BD:F8:19:FF",
						"name": "{{bdname}}",
						"rn": "BD-{{bdname}}",
						"arpFlood": "yes",
						"ipLearning": "no",
						"unicastRoute": "no",
						"unkMacUcastAct": "flood",
						"type": "regular",
						"unkMcastAct": "flood",
						"status": "created"
					},
					"children": [
						{
							"fvRsCtx": {
								"attributes": {
									"tnFvCtxName": "{{vrfname}}",
									"status": "created,modified"
								},
								"children": []
							}
						}
					]
				}
			}
		]
	}
}
```
==**Highlighted**== rows are specific for L2 Bridge-Domain.

#### 3.1.3 Application Profile

Component which contain all EPGs in the Tenant.

		https://{{apic}}/api/node/mo/uni.json


```json title="Application Profile from CSV"
{
	"fvAp": {
		"attributes": {
			"dn": "uni/tn-{{tenantname}}/ap-{{ap}}",
			"name": "{{ap}}",
			"rn": "ap-{{ap}}",
			"status": "created"
		}
	}
}
```


#### 3.1.4 EPGs in existing tenant/appprofiles and associated with domain

		https://{{apic}}/api/node/mo/uni.json


```json title="Create EPG under existing application profile from CSV"
{
  "fvAEPg": {
    "attributes": {
      "dn": "uni/tn-{{tenantname}}/ap-{{ap}}/epg-{{epgname}}",
      "name": "{{epgname}}",
      "rn": "epg-{{epgname}}",
      "status": "created"
    },
    "children": [
      {
        "fvRsBd": {
          "attributes": {
            "tnFvBDname": "{{bdname}}",
            "status": "created,modified"
          },
          "children": []
        }
      },
      {
        "fvRsDomAtt": {
          "attributes": {
            "tDn": "uni/phys-{{domain}}",
            "status": "created"
          },
          "children": []
        }
      }
    ]
  }
}
```

## 4 Use CSV file for input data

You are about to re-use work you did during all excercises. Untill now you run every request for static data, only once. Adding 100 Bridge-Domains, by changing "Variables" within the code would be problematic. Postman is giving an option to use external variable file to execute created requests in the collection.

By running five requests from your Collection and using CSV file from location ==**[FILE CSV TO DOWNLOAD](https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/docs/tenant-create.csv){target=_blank}**== you will add new Tenant with one VRF, Applicatioin Profile, 22 Bridge-Domains and 22 EPGs associated to Physical Domain created before. All of this will be done in one Postman collection Run.

## 4.1 Run Collection requests

Follow the instruction from the figure below:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-run-1.png" width = 800>

1)	Click on dots icon at your ACI dCloud collection folder

2)	Select **Run Collection**

You will be moved to new dashboard, where you will select Requests and input file.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-run-2.png" width = 800>

Deselect All, and then Select only needed requests:

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-run-3.png" width = 800>


When you select Requests, go to Data **"Select File"** and choice downloaded CSV file - *tenant-create.csv*.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-run-4.png" width = 800>

Confirm that your file is selected as on the figure above. You can confirm amount of iterations in the top field *Iterations*.

!!! Note
	Do not forget to authenticate your Postman session using ACI Login request. I recommend to do it out of collection Run -- beforehand.

Click ** Run ACI dCloud ** Blue button.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-run-5.png" width = 800>

## 4.2 Verification after runing the collection

When you successfully execute your collection, in Summary at the screen you will see results of every Iteration.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-run-6.png" width = 800>

When Request was accepted by APIC, result will be **200 OK**. Every Iteration contain all five seleceted requests. You probably noticed that one of them is getting **400 Bad Request** - "Bridge Domain L3 from CSV". Reason for that, is missing children attribute **fvSubnet** for all L2 bridge-domain in our CSV file.

Now connect to APIC GUI and verify if tenant exists, check dashboard status.

<img src="https://raw.githubusercontent.com/marcinduma/ACI-Automation/main/images/postman-coll-run-7.png" width = 800>

You successfully Created New Tenant with 22 EPGs and 22 BDs.

Please, edit CSV file in notepad++ editor at your dCloud workstation, replace Tenantname with new and run your Postman Collection once again.

**<p align=center>Do you understand now power of simple automation?</p>**
